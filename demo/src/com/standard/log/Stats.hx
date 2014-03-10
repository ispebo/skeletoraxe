package com.standard.log;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.Lib;
import flash.events.KeyboardEvent;
	
class Stats extends Sprite
{		
	private var graph : BitmapData;
		
	private var fpsText : TextField;
	private var msText : TextField;
	private var memText : TextField;
	private var format : TextFormat;
		
	private var fps : Int;
	private var timer : Float;
	private var ms : Float;
	private var msPrev : Float;
	private var mem : Float;

	public function new ( )
	{
		super (); msPrev = 0; mem = 0;

		graph = new BitmapData( 60, 50, false, 0x333 );
		var gBitmap:Bitmap = new Bitmap( graph );
		gBitmap.y = 35;
		addChild(gBitmap);

		format = new TextFormat( "_sans", 9 );

		graphics.beginFill(0x333);
		graphics.drawRect(0, 0, 60, 35 /*50*/);
		graphics.endFill();

		fpsText = new TextField();
		msText = new TextField();
		memText = new TextField();

		fpsText.defaultTextFormat = msText.defaultTextFormat =
memText.defaultTextFormat = format;
		fpsText.width = msText.width = memText.width = 60;
		fpsText.selectable = msText.selectable = memText.selectable = false;

		fpsText.textColor = 0xFFFF00;
		fpsText.text = "FPS: ";
		addChild(fpsText);

		msText.y = 10;
		msText.textColor = 0x00FF00;
		msText.text = "MS: ";
		addChild(msText);

		memText.y = 20;
		memText.textColor = 0x00FFFF;
		memText.text = "MEM: ";
		addChild(memText);

		addEventListener(MouseEvent.CLICK, mouseHandler);
		ShortCut.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		addEventListener(Event.ENTER_FRAME, update);
	}
		
	private function mouseHandler( e:MouseEvent ):Void
	{
		if (this.mouseY > this.height * .35)
			stage.frameRate --;
		else
			stage.frameRate ++;

		fpsText.text = "FPS: " + fps + " / " + stage.frameRate;
	}	
	
	private function keyHandler( e:KeyboardEvent ):Void
	{
		if ( e.keyCode == 38 )  stage.frameRate ++;
		if ( e.keyCode == 40 ) stage.frameRate --;
	}
		
	private function update( e:Event ):Void
	{
		timer = Lib.getTimer();
		fps++;

		if( timer - 1000 > msPrev )
		{
			msPrev = timer;
			mem = Std.int ( ( System.totalMemory / 1048576 ) * 1000 ) / 1000;

			var fpsGraph : Int = Std.int (Math.min( 50, 50 / stage.frameRate * fps ));
			var memGraph : Int = Std.int (Math.min( 50, Math.sqrt( Math.sqrt(mem * 5000 ) ) )) - 2;

			graph.scroll( 1, 0 );
			graph.fillRect( new Rectangle( 0, 0, 1, graph.height ), 0x333 );
			graph.setPixel( 0, graph.height - fpsGraph, 0xFFFF00);
			graph.setPixel( 0, graph.height - ( Math.round( timer - ms ) >> 1 ), 0x00FF00 );				
			graph.setPixel( 0, graph.height - memGraph, 0x00FFFF);

			fpsText.text = "FPS: " + fps + " / " + stage.frameRate;
			memText.text = "MEM: " + mem;

			fps = 0;
		}

		msText.text = "MS: " + (timer - ms);
		ms = timer;
	}
}