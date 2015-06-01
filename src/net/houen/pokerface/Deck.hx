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
import net.houen.cactuskev.PokerLib;

/**
 * A haxe port of the as3 poker hand evaluator writen by Søren Houen, based on cactuskev's poker evaluator
 */
class Deck
{

	private var _deck:Array<Int>;
		
	/**
	 * Creates the deck unshuffled. This should normally be followed be an immediate shuffle operation
	 */
	public function new()
	{
		this._deck = [];
		this.reset();
	}
	
	/**
	 * Returns the last card from the deck, removing it at the same time
	 * 
	 * @param name A custom id name for the card
	 * @throws net.houen.pokerface.error.DeckError If no cards left in deck
	 * @return A net.houen.pokerface.Card object representing the card pulled
	 * @see net.houen.pokerface.Card
	 * @see net.houen.pokerface.Hand5
	 */
	public function pullCard(name:String = ""):Card
	{
		if(this._deck.length < 1)
			throw"Tried to pull random card, but no cards left in deck";
		var cardRep:Int = this.pullCardRep();
		return new Card(cardRep,name);
	}
	
	/**
	 * Returns the last card from the deck, leaving it in the deck
	 * 
	 * @param num The number in the deck to return, empty for random
	 * @param name A custom id name for the card
	 * @throws net.houen.pokerface.error.DeckError If no cards left in deck
	 * @return A net.houen.pokerface.Card object representing the card pulled
	 * @see net.houen.pokerface.Card
	 */
	public function peekCard(num:Int = -1,name:String = ""):Card
	{
		if(this._deck.length < 1)
			throw "Tried to peek random card, but no cards left in deck";
		if(num > this._deck.length - 1)
			throw "Tried to peek card num " + num + ", but not that many cards left in deck";
		if(num < 0)
			num = 0;
		var card:Int = this._deck[num];
		return new Card(card,name);
	}
	
	/**
	 * Returns a 5 card Hand5 object from the last 5 cards in the deck, removing them at the same time
	 * 
	 * @throws net.houen.pokerface.error.DeckError If less than five cards left in deck
	 * @return A net.houen.pokerface.Hand object representing the hand pulled
	 * @see net.houen.pokerface.Card
	 * @see net.houen.pokerface.Hard5  
	 */
	public function pull5Hand(name:String = ""):Hand
	{
		if(this._deck.length < 5)
			throw "Less than five cards left in deck";
		var hand:Array<Int> = [this.pullCardRep(),this.pullCardRep(),this.pullCardRep(),this.pullCardRep(),this.pullCardRep()];
		return new Hand(hand,name);
	}
	
	/**
	 * Returns a 7 card Hand7 object from the last 7 cards in the deck, removing them at the same time
	 * 
	 * @param card1 A Card object to put as first card in hand (e.g. for Texas Hold'em shared cards
	 * @param card2 A Card object to put as second card in hand
	 * @throws Error If less than five cards left in deck, or only one Card supplied
	 * @return A net.houen.pokerface.Hand object representing the hand pulled
	 * @see net.houen.pokerface.Card
	 * @see net.houen.pokerface.Hand7  
	 */
	public function pull7Hand(card1:Card = null, card2:Card = null,name:String = ""):Hand
	{
		var hand:Array<Int>;
		
		if(this._deck.length < 7)
			throw "Less than seven cards left in deck";
		if((card1 == null && card2 != null) || (card2 == null && card1 != null))
			throw "Only one card was supplied as argument. Pleasy supply either two or none";
		if((card1 != null) && (card2 != null))
			hand = [card1.cardRep,card2.cardRep,this.pullCardRep(),this.pullCardRep(),this.pullCardRep(),this.pullCardRep(),this.pullCardRep()];
		else
			hand = [this.pullCardRep(),this.pullCardRep(),this.pullCardRep(),this.pullCardRep(),this.pullCardRep(),this.pullCardRep(),this.pullCardRep()];
		return new Hand(hand,name);
	}
	
	/**
	 * Returns and an array of 2 ints to represent the 2 player cards in a Texas hold em game. these are removed form the deck
	 * @throws Error If less than two cards left in deck
	 * @return an Int array of the top two cards
	 */
	public function pull2Hand(name:String = ""):Hand
	{
		return return new Hand(pull2Cards(), name);
	}
	
	/**
	 * Returns and an array of 2 ints to represent the 2 player cards in a Texas hold em game. these are removed form the deck
	 * @throws Error If less than two cards left in deck
	 * @return an Int array of the top two cards
	 */
	public function pull2Cards():Array<Int>
	{
		if(this._deck.length < 2) throw "Less than two cards left in deck";
		var cards:Array<Int> = [this.pullCardRep(), this.pullCardRep()];
		return cards;
	}
	
	/**
	 * Combines a Hand5 of 5 cards (community cards) with an array of 2 Ints to for a 7 card hand
	 * @param	comCards
	 * @param	playerCards
	 * @param	name
	 * @return	a Hand7
	 */
	public function getTexasHoldem7Hand(comCards:Hand, playerCards:Array<Int>,name:String = ""):Hand
	{
		return new Hand(playerCards.concat(comCards.getCardReps()), name);
	}
	
	/**
	 * Shuffles the deck, causing cards to be in random order
	 * 
	 * <p>Should nearly always be the first thing you do after initializing a deck</p>
	 */
	public function shuffle():Void
	{
		PokerLib.shuffle_deck(this._deck);
	}
	
	/**
	 * Resets the deck, causing all cards to be present and unordered
	 */
	public function resetShuffled():Void
	{
		this.reset();
		this.shuffle();
	}
	
	/**
	 * Resets the deck, causing all cards to be present and ordered
	 */
	public function reset():Void
	{
		PokerLib.init_deck(this._deck);
	}
	
	/**
	 * Pulls a new cards cactuskev strength representation from the deck
	 * @see net.houen.cactuskev.PokerLib
	 */
	private function pullCardRep():Int
	{
		var cardRep:Int = this._deck.pop();
		return cardRep;
	}
	
}