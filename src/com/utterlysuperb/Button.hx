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

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Sam Bellman
 */
class Button extends Sprite
{
	private var mouseIsOver:Bool;
	private var hit:Sprite;
	private var tf:TextField;
	private var upBg:Bitmap;
	private var overBg:Bitmap;
	private var downBg:Bitmap;
	private var defaultTextY:Float;
	private var offsetTextY:Float = 3;
	
	private static var buttonTextFormat:TextFormat;
	
	public function new(copy:String = "") 
	{
		super();
		
		if (buttonTextFormat == null)
		{
			var font:Font = Assets.getFont ("fonts/Montserrat-Regular.ttf");
			buttonTextFormat = new TextFormat(font.fontName, 16, 0x121212);
		}
		
		upBg = new Bitmap(Assets.getBitmapData("img/blue_button02.png"));
		addChild(upBg);
		overBg = new Bitmap(Assets.getBitmapData("img/blue_button00.png"));
		addChild(overBg);
		downBg = new Bitmap(Assets.getBitmapData("img/blue_button01.png"));
		addChild(downBg);	
		downBg.y = offsetTextY;
		
		tf = new TextField();
		addChild(tf);
		tf.selectable = false;
		tf.embedFonts = true;
		tf.defaultTextFormat = buttonTextFormat;
		
		createHitArea(0, 0, Math.floor(upBg.width), Math.floor(upBg.height));
		
		if (copy.length > 0) setText(copy);
		
		activate();		
		
		displayDefault();
	}
	
	public function setText(copy:String) :Void
	{
		tf.text = copy;
		tf.width = tf.textWidth + 5;
		tf.height = tf.textHeight + 5;
		tf.x = (hit.width - tf.width) / 2;
		tf.y = defaultTextY = (hit.height - tf.height) / 2 - 5;
	}
	
	public function activate():Void
	{
		var hitSprite:Sprite = hit == null ? this : hit;
		hitSprite.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		hitSprite.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		hitSprite.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
		hitSprite.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
	}
	
	public function deactivate(showInactive:Bool = false):Void
	{
		if (showInactive)
		{
			displayDefault();
		}
		else
		{
			displayInactive();
		}
		var hitSprite:Sprite = hit == null ? this : hit;
		if (hitSprite.hasEventListener(MouseEvent.MOUSE_UP))
		{
			hitSprite.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			hitSprite.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			hitSprite.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			hitSprite.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
	}	
	
	public function createHitArea(x:Int, y:Int, width:Int, height:Int):Void
	{
		if (hit == null)
		{
			hit = new Sprite();			
			addChild(hit);
		}
		hit.graphics.clear();
		hit.graphics.beginFill(0, 0);
		hit.graphics.drawRect(x, y, width, height);
	}
	
	private function mouseUpHandler(e:MouseEvent):Void 
	{
		if (mouseIsOver)
		{
			displayOver();
		}
		else
		{
			displayDefault();
		}
	}
	
	private function mouseDownHandler(e:MouseEvent):Void 
	{
		displayDown();
	}
	
	private function mouseOutHandler(e:MouseEvent):Void 
	{
		mouseIsOver = false;
		displayDefault();
	}
	
	private function mouseOverHandler(e:MouseEvent):Void 
	{
		mouseIsOver = true;
		displayOver();
	}

	private function displayOver():Void
	{
		overBg.visible = true;
		upBg.visible = downBg.visible = false;
		tf.y = defaultTextY;
	}
	
	private function displayDefault():Void
	{
		upBg.visible = true;
		overBg.visible = downBg.visible = false;
		tf.y = defaultTextY;
	}
	
	public function displayDown():Void
	{
		downBg.visible = true;
		upBg.visible = overBg.visible = false;
		tf.y = defaultTextY + offsetTextY;
	}
	
	public function displayInactive():Void
	{
		displayDefault();
	}
	
	public function cleanUp():Void
	{
		deactivate();
	}
}