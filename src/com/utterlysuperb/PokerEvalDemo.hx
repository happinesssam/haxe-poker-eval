/*Copyright (c) 2015 Sam Bellman
 
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

package com.utterlysuperb;
import com.utterlysuperb.Button;
import com.utterlysuperb.CardDisplay;
import haxe.Log;
import net.houen.pokerface.Deck;
import net.houen.pokerface.Hand;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Sam Bellman
 */
class PokerEvalDemo extends Sprite
{
	private var deck:Deck;
	
	private var cardsDisplay:CardDisplay;
	
	private var handInfo:TextField;

	private var themButton:Button;
	private var themComboButton:Button;
	
	private var hand:Hand;
	
	public function new() 
	{
		super();
		
		cardsDisplay = new CardDisplay();
		addChild(cardsDisplay);
		
		handInfo = new TextField();
		addChild(handInfo);
		handInfo.selectable = false;
		handInfo.embedFonts = true;
		handInfo.x = 10;
		handInfo.y = 330;
		var font:Font = Assets.getFont ("fonts/Montserrat-Regular.ttf");
		handInfo.defaultTextFormat = new TextFormat(font.fontName, 14, 0x121212);
		
		deck = new Deck();
		
		themButton = new Button("Texas hold em steps");
		addChild(themButton);
		themButton.x = 600;
		themButton.y = 80;
		themButton.addEventListener(MouseEvent.CLICK, clickHoldEm);
		
		themComboButton = new Button("Texas hold em combo");
		addChild(themComboButton);
		themComboButton.x = 600;
		themComboButton.y = 160;
		themComboButton.addEventListener(MouseEvent.CLICK, clickHoldEmCombo);
	}
	
	private function clickHoldEmCombo(e:MouseEvent):Void 
	{
		cardsDisplay.clearCards();
		
		deck.resetShuffled();
		
		var hand0:Hand = deck.pull2Hand();
		var hand1:Hand = deck.pull2Hand();
		var comcards:Hand = deck.pull5Hand();
		
		hand0.addCards(comcards.getCardReps());
		hand1.addCards(comcards.getCardReps());
		
		var cardsUsed0:Array<Int> = hand0.cardsUsed;
		var cardsUsed1:Array<Int> = hand1.cardsUsed;
		for (i in 0...2)
		{
			cardsDisplay.addCard(hand0.getCard(i).cardRep, i, 0);
		}
		for (i in 0...5)
		{
			cardsDisplay.addCard(comcards.getCard(i).cardRep, i, 1);
		}
		for (i in 0...2)
		{
			cardsDisplay.addCard(hand1.getCard(i).cardRep, i, 2);
		}
		
		var str:String = "Hand 1 has " + hand0.category + " using " + getCardsUsed(hand0, cardsUsed0) +", hand strength " + hand0.strength;
		str += "\nHand 2 has " + hand1.category + " using " + getCardsUsed(hand1, cardsUsed1) +", hand strength " + hand1.strength;
		str += hand0.compare(hand1) > 0 ? "\nHand 1 wins" : "\nHand 2 wins";
		handInfo.text = str;
		handInfo.width = handInfo.textWidth + 5;
		handInfo.height = handInfo.textHeight + 5;
	}
	
	private function getCardsUsed(hand:Hand, cardsUsed:Array<Int>):String
	{
		var cards:String = "";
		for (i in 0...cardsUsed.length)
		{
			if (i > 0) cards += ", ";
			cards += hand.getCard(cardsUsed[i]).toString();
		}
		return cards;
	}
	
	/**
	 * Simple step by step hold
	 * @param	e
	 */
	private function clickHoldEm(e:MouseEvent):Void
	{
		if (hand != null && hand.numCards == 7)
		{			
			hand = null;
		}
		if (hand == null)
		{
			deck.resetShuffled();
			hand = deck.pull2Hand();
			handInfo.text = hand.toString() + " Chen score:" + hand.chenScore;
		}
		else
		{
			var numCardsToAdd:Int = hand.numCards == 2 ? 3 : 1;
			var cardsToAdd:Array<Int> = [];
			for (i in 0...numCardsToAdd)
			{
				cardsToAdd.push(deck.pullCard().cardRep);
			}
			hand.addCards(cardsToAdd);
			handInfo.text = hand.toString() + " hand score:" + hand.strength;
		}		
		
		cardsDisplay.clearCards();
		var cardsUsed:Array<Int> = hand.cardsUsed;
		for (i in 0...hand.numCards)
		{
			cardsDisplay.addCard(hand.getCard(i).cardRep, i, 0, cardsUsed.indexOf(i)==-1);
		}
		handInfo.width = handInfo.textWidth + 5;
		handInfo.height = handInfo.textHeight + 5;
	}
}