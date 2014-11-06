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
class SelectionButton extends Button
{
	private var _selected					: Bool;
	public function new(text: String, nam: String, cb: String->Void) : Void
	{
		super( text, nam, cb );
		
		selected = false;
		
	}
	//---------------------------------------------------------------------
	public var selected( get_selected, set_selected ) : Bool;
	private function get_selected() : Bool { return _selected; }
	private function set_selected( s: Bool ) : Bool 
	{
		if (_selected != s )
		{
			_selected = s;
			_enabled = !_selected;
			onOut( null );
			this.alpha = _selected ? 0.3 : 1;
		}
		return _selected; 
	}
	
	
}