/*Copyright (c) 2009 Søren Houen
 * Haxe port 2015 Sam Bellman
 
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
import net.houen.cactuskev.PokerVars;

/**
 * A haxe port of the as3 poker hand evaluator writen by Søren Houen, based on cactuskev's poker evaluator
 */
class Card
{

	private var _valueNum:Int;
	private var _valueString:String;
	private var _suit:String;
	private var _suitValue:Int;
	private var _name:String;
	
	public var suit(get, null):String;
	public var suitValue(get, null):Int;
	public var value(get, null):Int;
	public var valueName(get, null):String;
	public var name(get, null):String;
	public var cardRep(get, null):Int;
	
	private var _cardRep:Int;
	
	/**
	 * Create new palying card
	 * @param cardRep The cards representation in cactuskev notation
	 * @param name An optional id name for the card
	 */
	public function new(cardRep:Int, name:String = "")
	{
		this._cardRep = cardRep;
		this._valueNum = PokerVars.cardRankNum[PokerLib.RANK(cardRep)];
		this._valueString = PokerVars.cardRank[PokerLib.RANK(cardRep)];
		this._suit = PokerLib.SUIT(cardRep);
		this._name = name;
		setSuitValue();
	}
	
	/**
	 * Get the cards suit
	 * @return String
	 */
	public function get_suit():String
	{
		return this._suit;
	}
	
	/**
	 * Get the cards suit
	 * @return String
	 */
	public function get_suitValue():Int
	{
		return this._suitValue;
	}
	
	/**
	 * Get the cards suit
	 * @return String
	 */
	public function setSuitValue():Void
	{
		switch(suit)
		{
			case "c":
				_suitValue = 0;
			case "d":
				_suitValue =  1;
			case "h":
				_suitValue =  2;
			case "s":
				_suitValue =  3;
		}
	}
	
	/**
	 * Get the cards numerical value (2 to 14)
	 */ 
	public function get_value():Int
	{
		return this._valueNum;
	}
	
	/**
	 * Get the cards string value (2 to A)
	 */
	public function get_valueName():String
	{
		return this._valueString;
	}
	
	/**
	 * Get the cards cactuskev representation
	 */
	public function get_cardRep():Int
	{
		return this._cardRep;
	}
	
	/**
	 * Get the cards id name
	 */
	public function get_name():String
	{
		return this._name;
	}
	
	/**
	 * Get the cards string representation
	 */
	public function toString():String
	{
		return "" + this.valueName + this.suit;
	}
}