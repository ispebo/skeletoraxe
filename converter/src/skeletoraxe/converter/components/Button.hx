package skeletoraxe.converter.components;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;

/**
 * @autor ispebo
 */
class Button extends Sprite
{
	private var _textField			: TextField;
	private var _zoneClick			: Sprite;
	private var _back				: Sprite;
	private var _cb					: String->Void;
	private var _enabled			: Bool;
	private var _colorTxt			: UInt;
	
	
	public function new( text: String, nam: String, cb: String->Void, color: UInt = 0xbbbbbb, colorTxt: UInt = 0x555555  ) : Void
	{
		super();
		
		_enabled = true;
		this.name = nam;
		_cb = cb;
		_colorTxt = colorTxt;
		_back = new Sprite();
		addChild( _back );
		createTextField( text );
		
		var widthBack: Int = Std.int( _textField.width + 12 );
		if ( widthBack < 23 ) widthBack = 23;
		
		var widthHeight: Int = Std.int( _textField.height + 5 );
		
		
		_textField.x = (widthBack - _textField.width) / 2;
		_back.graphics.lineStyle(1, 0x999999, 1);
		_back.graphics.beginFill(color);
		_back.graphics.drawRect(0, 0, widthBack, widthHeight );
		
		
		_zoneClick = new Sprite();
		_zoneClick.graphics.beginFill( 0xff0000,0 );
		_zoneClick.graphics.drawRect( 0, 0,_back.width + 2, _back.height + 2);
		addChild( _zoneClick );
		
		applyUp();
		
		setMouseEvents( true );
	}
	//------------------------------------------------------------------
	private function setMouseEvents( b: Bool ) : Void
	{
		if ( b) 
		{
			_zoneClick.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			_zoneClick.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			_zoneClick.addEventListener( MouseEvent.ROLL_OUT, onOut );
			_zoneClick.addEventListener( MouseEvent.ROLL_OVER, onOver );
		}
		else
		{
			_zoneClick.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			_zoneClick.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			_zoneClick.removeEventListener( MouseEvent.ROLL_OUT, onOut );
			_zoneClick.removeEventListener( MouseEvent.ROLL_OVER, onOver );
		}
		
		_zoneClick.buttonMode = b;
		
	}
	//------------------------------------------------------------------
	private function onMouseDown( e : MouseEvent ) : Void
	{
		if ( _enabled ) 
		{
			_back.filters = [];
			_back.x = _back.y = 2;
		}
	}
	//------------------------------------------------------------------
	private function onMouseUp( e : MouseEvent  ) : Void
	{
		if ( _enabled ) 
		{
			applyUp();
			_cb( this.name );
		}
	}
	//------------------------------------------------------------------
	
	private function applyUp() : Void
	{
		_back.filters = [  new DropShadowFilter(3, 60, 0x666666, 5, 5, 3, 1)];
		_back.x = _back.y = 0;
	}
	//------------------------------------------------------------------
	private function onOver( e : MouseEvent ) : Void
	{
		if ( _enabled )  _textField.textColor = 0x000000;
	}
	//------------------------------------------------------------------
	private function onOut( e : MouseEvent ) : Void
	{
		if ( _enabled )  _textField.textColor = _colorTxt;
	}
	//------------------------------------------------------------------
	
	private function createTextField( text: String ) : Void
	{
		var _format : TextFormat = new TextFormat();
		_format.align = TextFormatAlign.LEFT;
		_format.font = "Arial Black";
		_format.size = 12;
		_format.color = _colorTxt;
		
		_textField = new TextField();
		_textField.defaultTextFormat =  _format ;
		_textField.autoSize = TextFieldAutoSize.LEFT;
		_textField.selectable = false;
		_textField.htmlText = text.toUpperCase();
		//_textField.border = true;
		_textField.multiline = false;
		_textField.x = 6;
		_textField.y = 3;
		
		_textField.embedFonts = true;
		_back.addChild( _textField );
	}
	//------------------------------------------------------------------
	public function destroy() : Void
	{
		setMouseEvents( false );
	}
}