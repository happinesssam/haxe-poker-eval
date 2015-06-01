/*Copyright (c) 2009 Søren Houen
 
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
	
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.*/
package net.houen.pokerface;
import net.houen.cactuskev.PokerEval;
import net.houen.cactuskev.PokerLib;
import net.houen.cactuskev.PokerVars;
import net.houen.pokerface.Card;

/**
 * A combo of hand5 and hand7 into one class to I can add cards as I go to simulate getting more cards in a texas hold ems game
 * @author Sam Bellman
 */
class Hand implements IHand
{
	private var _cards:Array<Card>;
	private var _strength:Int;
	private var _strengthRank:Int;
	private var _name:String;
	private var _chenScore:Float;
	private var _cardsUsed:Array<Int>;
	
	private var calcFunction:Void->Void;	
	
	public var chenScore(get, null):Float;
	public var strength(get, null):Int;
	public var category(get, null):String;	
	public var numCards(get, null):Int;	
	public var cardsUsed(get, null):Array<Int>;	
	
	public function new(cardReps:Array<Int> ,name:String = "") 
	{		
		_cards = [];
		_name = name;
		
		for(i in 0...cardReps.length) {
			_cards[i] = new Card(cardReps[i] ,name + i);
		}
		
		numCardsChanged();
	}
	
	private function numCardsChanged():Void
	{
		switch(numCards)
		{
			case 2:
				calcFunction = setChenScore;
			case 5:
				calcFunction = calcStrength5;
			case 6:
				calcFunction = calcStrength6;
			case 7:
				calcFunction = calcStrength7;
			default:
				throw "Invalid number of cards";
		}
		_cardsUsed = [];
		recalcStrength();
	}
	
	public function addCards(cardReps:Array<Int>):Void
	{		
		for(i in 0...cardReps.length) {
			_cards.push(new Card(cardReps[i] ,_name + numCards));
		}
		
		numCardsChanged();
	}
	
	/* INTERFACE net.houen.pokerface.IHand */
	
	/**
	 * Get a Card in the hand
	 * @param num The number of card to get. Must be between 0 and 4
	 * @throws Will throw error if invalid number given as parameter
	 * @return Card
	 * @see Card
	 */
	public function getCard(num:Int):Card
	{
		if(num >= _cards.length || num < 0)
			throw "Cannot get card " + num + " from a " + numCards +  " card hand. (Cards are 0-indexed)";
		return _cards[num];
	}
	
	/**
	 * Set a card in the hand. Will recalculate hand strength when set, so use with caution must be and existing card - use addCard to add a card
	 * @param num The number of the card to set
	 * @param card The new Card object to replace card with
	 * @throws Will throw error if invalid number given as parameter
	 * @see Card
	 */
	public function setCard(num:Int, card:Card):Void 
	{
		if(num >= _cards.length || num < 0)
			throw "Cannot set card " + num + " in a 5 card hand. (Cards are 0-indexed)";
		_cards[num] = card;
		_cardsUsed = [];
		recalcStrength();
	}
	
	public function get_strength():Int 
	{
		return _strength;
	}
	
	public function get_category():String 
	{
		return PokerVars.handRank[_strengthRank];
	}	
	
	public function get_numCards():Int 
	{
		return _cards.length;
	}
	
	public function get_cardsUsed():Array<Int> 
	{
		if (_cardsUsed.length != numCards)
		{
			_cardsUsed = PokerEval.getCardsUsed(this);
		}
		return _cardsUsed;
	}
	
	public function toString():String 
	{
		var str:String = this.category + "(" + this.strength + ")" + " (";
		for (card in _cards) {
			str += card.toString() + " ";
		}
		str = str.substr(0,str.length - 1);
		str += ")";
		return str;
	}
	
	public function recalcStrength():Void 
	{
		calcFunction();
	}
	
	private function calcStrength5():Void
	{
		this.setStrength(PokerEval.eval_5hand_fast([this.getCard(0).cardRep, this.getCard(1).cardRep, this.getCard(2).cardRep, this.getCard(3).cardRep, this.getCard(4).cardRep]));
		cardsUsed = [0, 1, 2, 3, 4];
	}
	
	private function calcStrength6():Void
	{
		this.setStrength(PokerEval.eval_6hand([this.getCard(0).cardRep,this.getCard(1).cardRep,this.getCard(2).cardRep,this.getCard(3).cardRep,this.getCard(4).cardRep,this.getCard(5).cardRep]));
	}
	
	private function calcStrength7():Void
	{
		this.setStrength(PokerEval.eval_7hand([this.getCard(0).cardRep,this.getCard(1).cardRep,this.getCard(2).cardRep,this.getCard(3).cardRep,this.getCard(4).cardRep,this.getCard(5).cardRep,this.getCard(6).cardRep]));
	}
	
	/**
	 * Compare two hands to eachother
	 * @param otherHand a Hand5 object representing the hand to be compared to
	 * @return Returns 1 if this hand is greater, -1 if this hand is lesser, 0 if equal
	 */
	public function compare(handOther:IHand):Int
	{
		var thisStren:Int = this.strength;
		var otherStren:Int = handOther.get_strength();
		
		//This hand is strongest
		if(thisStren < otherStren)
			return 1;
		//Other hand is strongest
		else if(thisStren > otherStren)
			return -1;
		//Hands are equal
		return 0;
	}
	
	/**
	 * Set the hands cactuskev strength (unique hand strength for every possible poker hand)
	 */
	private function setStrength(strength:Int):Void
	{
		this._strength = strength;
		this._strengthRank = PokerLib.hand_rank(this.strength); 
	}
	
	public function getCardReps():Array<Int>
	{
		var cardReps:Array<Int> = [];
		for (i in 0..._cards.length)
		{
			cardReps.push(_cards[i].cardRep);
		}
		
		return cardReps;
	}
	
	/**
	 * Set the score for the first two cards in a poker hand using the formula created by Poker champion Bill Chen https://www.google.co.uk/search?q=chen%20poker%20formula
	The score is out of 20
	 */
	private function setChenScore():Void
	{
		var card1:Card = this.getCard(0);
		var card2:Card = this.getCard(1);
		var baseScore:Float = Math.max(cScore(card1), cScore(card2));
		
		if (card1.value == card2.value)
		{
			baseScore = Math.max(5, baseScore * 2);
		}
		
		if (card1.suit == card2.suit) 
		{
			baseScore += 2;
		}
		
		var gap:Float = Math.abs(card1.value - card2.value);
		switch(gap) 
		{
			case 0:
			case 1: baseScore++;
			case 2: baseScore--; 
			case 3: baseScore-= 2; 
			case 4: baseScore-= 4; 
			default: baseScore-= 5;
		}
		_chenScore = baseScore;
	}
	
	private function cScore(card:Card):Float
	{
		switch(card.value)
		{
			case 14: return 10;
			case 13: return 8;
			case 12: return 7;
			case 11: return 6; 
		}
		return card.value / 2;
	}
	
	public function get_chenScore():Float
	{
		return _chenScore;
	}
}