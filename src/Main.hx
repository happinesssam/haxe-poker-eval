package;

import net.houen.pokerface.Hand;
import openfl.display.Sprite;
import openfl.Lib;
import src.com.utterlysuperb.PokerEvalDemo;

/**
 * ...
 * @author Sam Bellman
 */

class Main extends Sprite 
{

	public function new() 
	{
		super();
		
		// Assets:
		// openfl.Assets.getBitmapData("img/assetname.jpg");
		
		var pokerDemo:PokerEvalDemo = new PokerEvalDemo();
		addChild(pokerDemo);
		var hand:Hand;
	}
}
