package skeletoraxe.converter.components;

import flash.display.Sprite;
import skeletoraxe.converter.components.Button;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;
import haxe.Timer;

/**
 * @autor ispebo
 */

class SpeedDisplayer extends Sprite
{
	public static inline var MORE_SPEED			: String = "moreSpeed";
	public static inline var LESS_SPEED			: String = "lessSpeed";
	
	private var _moreButton						: Button;
	private var _lessButton						: Button;
	private var _fpsDisplayer					: TextField;
	
	private var _currentSpeedValue				: Int;
	
	public function new() : Void
	{
		super();
		
		_currentSpeedValue = Std.int( AppMain.STAGE.frameRate ) ;
		
		_lessButton = new Button("-", LESS_SPEED, clickButton);
		addChild( _lessButton );
		_lessButton.x = 10;
	
		createTextField( AppMain.STAGE.frameRate + "");
		_fpsDisplayer.x = 40;
		_fpsDisplayer.y = 4;
		
		_moreButton = new Button("+", MORE_SPEED, clickButton);
		addChild( _moreButton );
		_moreButton.x =  _fpsDisplayer.x + 55;
		
		addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
		
	}
	//---------------------------------------------------------------	
	private function createTextField( text: String ) : Void
	{
		var _format : TextFormat = new TextFormat();
		_format.align = TextFormatAlign.CENTER;
		_format.font = "Arial Black";
		_format.size = 12;
		_format.color = 0x555555;
		
		_fpsDisplayer = new TextField();
		_fpsDisplayer.type = TextFieldType.INPUT;
		_fpsDisplayer.background = true;
		_fpsDisplayer.backgroundColor = 0xffffff;
		_fpsDisplayer.defaultTextFormat =  _format ;
		_fpsDisplayer.width = 50;
		_fpsDisplayer.height = 20;
		//_fpsDisplayer.autoSize = TextFieldAutoSize.LEFT;
		_fpsDisplayer.selectable = true;
		_fpsDisplayer.htmlText = text.toUpperCase();
		_fpsDisplayer.border = true;
		_fpsDisplayer.multiline = false;
		
		
		
		
		_fpsDisplayer.embedFonts = true;
		addChild( _fpsDisplayer );
	}
	
	//---------------------------------------------------------------	
	private function onKeyUp( e: KeyboardEvent ) : Void
	{
		if ( _fpsDisplayer.text != "")
		{
			var value: Int = Std.parseInt(_fpsDisplayer.text);
			if ( value == 0 ) value = 1;
			else if ( value > 60 ) value = 60;
			_currentSpeedValue = value;
			_fpsDisplayer.htmlText = "" + _currentSpeedValue;
			AppMain.STAGE.frameRate = _currentSpeedValue;
		}
		else
		{
			Timer.delay( function() 
			{ 
				if ( _fpsDisplayer.text == "")
				{
					_fpsDisplayer.htmlText = "" + _currentSpeedValue;
					AppMain.STAGE.frameRate = _currentSpeedValue; 
				}
			}, 1000 );
		}
	
	}
	
	//---------------------------------------------------------------	
	private function clickButton( buttonName: String ) : Void
	{
		switch( buttonName )
		{
			case MORE_SPEED:		if ( AppMain.STAGE.frameRate < 60 ) AppMain.STAGE.frameRate = AppMain.STAGE.frameRate+1;
			case LESS_SPEED:		if ( AppMain.STAGE.frameRate > 1 ) AppMain.STAGE.frameRate = AppMain.STAGE.frameRate-1;
		}
		_fpsDisplayer.htmlText = "" + AppMain.STAGE.frameRate;		
	}
}