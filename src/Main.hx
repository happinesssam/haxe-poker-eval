package;

import net.houen.pokerface.Hand;
import openfl.display.Sprite;
import openfl.Lib;
import com.utterlysuperb.PokerEvalDemo;

/**
 * ...
 * @author Sam Bellman
 */

class Main extends Sprite 
{

	public function new() 
	{
		super();
		
		var pokerDemo:PokerEvalDemo = new PokerEvalDemo();
		addChild(pokerDemo);
	}
}
