package com.utterlysuperb;

import aze.display.SparrowTilesheet;
import aze.display.TileLayer;
import aze.display.TileSprite;
import net.houen.cactuskev.PokerLib;
import net.houen.cactuskev.PokerVars;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Tilesheet;

/**
 * ...
 * @author Sam Bellman
 */
class CardDisplay extends Sprite
{
	private var cardsLayer:TileLayer;
	private var cards:Array<TileSprite> = [];
	
	private var cardWidth:Int = 140;
	private var cardHeight:Int = 190;
	private var cardScale:Float = 0.5;
	
	public function new() 
	{
		super();
		
		var sheetData = Assets.getText("img/playingCards.xml");
		var cardsTilesheet = new SparrowTilesheet(Assets.getBitmapData("img/playingCards.png"), sheetData);
		
		cardsLayer = new TileLayer(cardsTilesheet);
		addChild(cardsLayer.view);
		cards = [];
	}
	
	public function addCard(cardRep:Int, column:Int, row:Int, faded:Bool = false):Void
	{
		var suit:String;
		switch(PokerLib.SUIT(cardRep))
		{
			case "s":
				suit = "Spades";
			case "d":
				suit = "Diamonds";
			case "c":
				suit = "Clubs";
			case "h":
				suit = "Hearts";
			default:
				throw "Could not get suit";
		}
		var cardStr:String = "card" + suit + PokerVars.cardRank[PokerLib.RANK(cardRep)] +".png";
		
		var card:TileSprite = new TileSprite(cardsLayer, cardStr);
		
		cardsLayer.addChild(card);
		
		var wd = cardWidth * cardScale;
		var hg = cardHeight * cardScale;
		
		card.x = column * (wd + 10) + wd * 0.5;
		card.y = hg * 0.5 + row * (hg + 10);
		card.scale = cardScale;
		
		if (faded) card.alpha = 0.5;
		
		cards.push(card);
		
		cardsLayer.render();
	}
	
	public function fadeCard(index:Int):Void
	{
		cards[index].alpha = 0.5;		
	}
	
	public function render():Void
	{
		cardsLayer.render();
	}
	
	public function clearCards():Void
	{
		cardsLayer.removeAllChildren();
		cards = [];
	}
}