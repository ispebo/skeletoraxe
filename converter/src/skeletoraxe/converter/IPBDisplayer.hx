package skeletoraxe.converter;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import flash.display.Shader;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.Timer;
import skeletoraxe.atlas.MovieClip;
import skeletoraxe.converter.utils.MaxRectPacker;

/**
 * @autor ispebo
 */

class IPBDisplayer extends Sprite
{
	private var _width						: Int;
	private var _height						: Int;
	private var _currentAnims				: Array<MovieClip>;
	private var _swfCurrentAnims			: Array<flash.display.MovieClip>;
	private var _previewViewContainer		: Sprite;
	private var _atlasViewContainer			: Sprite;
	private var _swfView					: Sprite;
	
	private var _colors						: Array<UInt>;
	private var _playing					: Bool;
	
	public function new() : Void
	{
		super();
		
		_width = AppMain.STAGE.stageWidth - ToolsInterface.WIDTH;
		_height = AppMain.STAGE.stageHeight;
		_playing = false;
		_colors = [ 0xff0000, 0x00ff00, 0x0000ff];
		clear();
		_atlasViewContainer.visible = false;
		this.graphics.lineStyle(1, 1, 1);
		this.graphics.beginFill(0xfe6300);
		this.graphics.drawRect(0, 0, _width, _height );
	}
	//-------------------------------------------------------------
	public function resize() : Void
	{
		_width = AppMain.STAGE.stageWidth - ToolsInterface.WIDTH;
		_height = AppMain.STAGE.stageHeight;
		this.graphics.clear();
		this.graphics.lineStyle(1, 1, 1);
		this.graphics.beginFill(0xff7822);
		this.graphics.drawRect(0, 0, _width, _height );
		
		if ( _atlasViewContainer.numChildren == 1 ) 
		{
			var bmp: Bitmap = cast( _atlasViewContainer.getChildAt(0), Bitmap );
			bmp.x = (_width - bmp.width) / 2;
			bmp.y = (_height - bmp.width) / 2;
		}
		
	
		updateColors();
	}
	
	//-------------------------------------------------------------
	public function changeBackColor() : Void
	{
		_colors = [ Std.random(0xffffff), Std.random(0xffffff), Std.random(0xffffff)];
		updateColors();
		
	}
	//-------------------------------------------------------------
	private function updateColors() : Void
	{
		if ( _previewViewContainer != null ) 
		{
			_previewViewContainer.graphics.clear();
			_previewViewContainer.graphics.beginFill(_colors[0], 0.3);
			_previewViewContainer.graphics.drawRect(0,0, _width, _height );
		}
		
		if ( _swfView != null ) 
		{
			_swfView.graphics.clear();
			_swfView.graphics.beginFill(_colors[1], 0.3);
			_swfView.graphics.drawRect(0,0, _width, _height );
		}
		
		if ( _atlasViewContainer != null ) 
		{
			_atlasViewContainer.graphics.clear();
			_atlasViewContainer.graphics.beginFill(_colors[2], 0.3);
			_atlasViewContainer.graphics.drawRect(0,0, _width, _height );
		}
	
	}
	
	//-------------------------------------------------------------
	public function showAnimation( anim: Array<MovieClip> ) : Void
	{
		_currentAnims = anim;
		Timer.delay( updatePosition, 200 );
	}
	//------------------------------------------------------------
	public function showAtlas( bmp : Bitmap ) : Void
	{
		_atlasViewContainer.addChild( bmp );
		bmp.x = (_width - bmp.width) / 2;
		bmp.y = (_height - bmp.height) / 2;
	}
	//------------------------------------------------------------
	public function showSwfAnimations( swfAnimations: Array<flash.display.MovieClip> ) : Void
	{
		
		_swfCurrentAnims = swfAnimations;
		var packer:MaxRectPacker = new MaxRectPacker( _width - 100, _height - 100);
	
	
		for ( swfAnim in swfAnimations ) 
		{
			
			var bounds = swfAnim.getBounds( null );
			
			var rect: Rectangle = packer.quickInsert(bounds.width , bounds.height );
			
		
			_swfView.addChild( swfAnim );
			swfAnim.x = rect.x-bounds.x+100;
			swfAnim.y = rect.y-bounds.y+100;
			
			
		}
		
		if ( this.hasEventListener(  Event.ENTER_FRAME  ) ) this.removeEventListener( Event.ENTER_FRAME, oef );
	}
	
	
	
	//------------------------------------------------------------
	private function oef( e: Event ) : Void
	{
		if ( _playing ) 
		{
			for ( anim in _currentAnims ) anim.update();
			for ( swfAnim in _swfCurrentAnims ) 
			{
				if ( swfAnim.currentFrame < swfAnim.totalFrames - 1 ) swfAnim.nextFrame();
				else swfAnim.gotoAndStop(1);
			
			}
		}
	}
	//------------------------------------------------------------
	public function showSwfView() : Void
	{
		_atlasViewContainer.visible = _previewViewContainer.visible = false;
		_swfView.visible = true;
	}
	//------------------------------------------------------------
	public function showPreviewView() : Void
	{
		_previewViewContainer.visible = true;
		_atlasViewContainer.visible = _swfView.visible = false;
	}
	
	//------------------------------------------------------------
	public function showAtlasView() : Void
	{
		_atlasViewContainer.visible = true;
		_previewViewContainer.visible = _swfView.visible = false;
	}
	//------------------------------------------------------------
	private function updatePosition() : Void
	{
		for ( anim in _currentAnims ) 
		{
			_previewViewContainer.addChild( anim );
			var p : Point = getXYByName( anim.id );
			anim.x = p.x;
			anim.y = p.y;
		}
		play();
		if ( !this.hasEventListener(  Event.ENTER_FRAME  ) ) addEventListener( Event.ENTER_FRAME, oef );
	
	}
	//------------------------------------------------------------
	private function getXYByName( nam: String ) : Point
	{
		var p : Point = null;
		var i : Int = 0;
		while ( i < _swfCurrentAnims.length && p == null )
		{
			if ( _swfCurrentAnims[i].name == nam ) p = new Point( _swfCurrentAnims[i].x, _swfCurrentAnims[i].y );
			i++;
		}
		return p;
	}
	//------------------------------------------------------------
	public function clear() : Void
	{
		while ( this.numChildren > 0 ) this.removeChildAt( 0 );
		_previewViewContainer = new Sprite();
		addChild( _previewViewContainer );
		
		_swfView = new Sprite();
		addChild( _swfView );
		
		_atlasViewContainer = new Sprite();
		addChild( _atlasViewContainer );
		
		updateColors();
		
		_previewViewContainer.visible = _swfView.visible = false;
		
		_currentAnims = new Array();
		_swfCurrentAnims  = new Array();
	}
	
	//------------------------------------------------------------
	public function play() : Void
	{
		
		for ( currentAnim in _currentAnims ) currentAnim.playing = true;
		_playing = true;
		
		
	}
	
	//------------------------------------------------------------
	public function pause() : Void
	{
		for ( currentAnim in _currentAnims ) currentAnim.playing = false;
		_playing = false;
	}
}