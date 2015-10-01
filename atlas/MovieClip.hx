package skeletoraxe.atlas;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.GradientType;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.system.System;
import flash.Vector.Vector;
import haxe.Timer;
import skeletoraxe.atlas.AtlasSkAxe;
import skeletoraxe.engine.Engine;

/**
 * @autor ispebo
 */
class MovieClip extends Sprite
{
	

	private var _group									: String;
	private var _id										: String;	//Normalement c'est le nom de la classe
	
	private var _ipbAtlas								: AtlasSkAxe;
	private var _framesConfig							: Array<Array<TextureFrameConfig>>;
	
	private var _currentFrame							: Int;
	public var currentFrame( get_currentFrame, null )	: Int;
	
	private var _isPlaying								: Bool;
	public var isPlaying( get_isPlaying, null )			: Bool;
	
	public var playing( get_playing, set_playing )		: Bool;
	private var _framesScript							: Map<Int,Dynamic>;	// Hash qui contient les scripts pour chaque frame
	
	private var _cacheAsBitmap							: Bool;
	
	private var _smoothing								: Bool;			
	public var smoothing( get_smoothing, set_smoothing ): Bool;
		
	public var totalFrames( get_totalFrames, null )		: Int;
	
	public var reversingMode							: Bool;			// Si true alors on lis le Movieclip à l'inverse
	
	private var _texturesCreated						: Map<Int,Bitmap>;
	private var _width									: Int;
	private var _height									: Int;
	
	public var removeFlag								: Bool;
	private var _oldAttached							: Array<DisplayObject>;
	
	private var _alphaMaps								: Array<BitmapData>;
	
	private var _p0										: Array<Float>;
	private var _p1										: Array<Float>;
	private var _p2										: Array<Float>;
	private var _p3										: Array<Float>;
	private var _destroyed								: Bool;

	public function new( ident:String, ipbAtlas: AtlasSkAxe, framesConf: Array<Array<TextureFrameConfig>>, gr: String = "" ) : Void
	{
		super();
		
		//ID++;
		//myID = ID;
	
		_destroyed = false;
		_id = ident;
		_group = gr;
		_ipbAtlas = ipbAtlas;
		_framesConfig = framesConf;
		_texturesCreated = new Map();
		cacheAsBitmap = false;
		smoothing = false;
		_width = _height = 0;
		if ( _framesConfig == null ) throw("######## FRAME CONFIG IS NULL IN CONSTRUCTOR =>"+ident );
		reset();
		
	
		
		for ( frameConfig in _framesConfig )
			for ( frame in frameConfig )
			{
					if ( frame.textureData == null ) throw( "frame.textureData is null: " + _id);
				var texture: BitmapData = ipbAtlas.getTextureById(frame.textureData.id);
				if ( texture == null ) throw( "texture is null: " + _id);
				if ( texture.width > _width ) _width = Std.int ( texture.width );
				if ( texture.height > _height ) _height = Std.int ( texture.height );
			}
		
		
	}
	//---------------------------------------------------------------------------
	public var group( get_group, null ) : String;
	private function get_group( ) : String { return _group; }
	//---------------------------------------------------------------------------
	public var framesConfig (get_framesConfig, null ) : Array<Array<TextureFrameConfig>> ;
	private function get_framesConfig( ):  Array<Array<TextureFrameConfig>> {return _framesConfig;}
	
	//---------------------------------------------------------------------------
	public var ipbAtlas( get_ipbAtlas, null ) 		: AtlasSkAxe;
	private function get_ipbAtlas( ): AtlasSkAxe { return _ipbAtlas; }
	//---------------------------------------------------------------------------
	public var id (get_id, null ) : String;
	private function get_id( ): String { return _id; };
	//---------------------------------------------------------------------------------------
	
	private function get_playing(  ) : Bool { return _isPlaying; }
	private function set_playing( b: Bool ) : Bool
	{
		if ( _isPlaying != b ) _isPlaying = b;
	
		return _isPlaying;
	}
	//---------------------------------------------------------------------------------------
	
	@:getter( width ) function getterWidth() : Float  {	 return _width; }
	
	//---------------------------------------------------------------------------------------
	@:getter( height ) function getterHeight() : Float  {	 return _height; }
	
	//---------------------------------------------------------------
	public function addFrameScript( frame: Int, ?p1: Dynamic ) : Void
	{
		if ( _framesScript != null )
		{
			if ( p1 == null ) _framesScript.remove(  frame );
			else _framesScript.set( frame, p1 );
		}
	}
	//---------------------------------------------------------------
	private function get_currentFrame() : Int { return _currentFrame; }
	//---------------------------------------------------------------
	private function get_isPlaying() : Bool { return _isPlaying; }
	//---------------------------------------------------------------------------------------
	//On fait un 'cacheAsBitmap' pour tous les bitmaps du Movieclip
	@:getter( cacheAsBitmap ) function getterCAB() : Bool  {	 return _cacheAsBitmap; }
	@:setter( cacheAsBitmap ) function setterCAB( b: Bool ) : Void  
	{ 
		for ( bitmap in _texturesCreated )
		{
			
			bitmap.cacheAsBitmap = b;
		}
		_cacheAsBitmap = b;
	}
	//---------------------------------------------------------------
	public var texturesCreated( get_texturesCreated, null ) : Map<Int,Bitmap>;
	private function get_texturesCreated() : Map<Int,Bitmap> { return _texturesCreated;}
	
	//---------------------------------------------------------------
	//On fait un 'smoothing' pour tous les bitmaps du Movieclip
	private function get_smoothing() : Bool { return _smoothing; }
	private function set_smoothing( b: Bool ) : Bool 
	{ 
		for ( bitmap in _texturesCreated ) bitmap.smoothing = b;
		_smoothing = b;
		return _smoothing; 
	}
	
	//-------------------------------------------------------------
	public function reinit() : Void
	{
		if ( _framesConfig != null )
			for ( f in  _framesConfig )
			{
				if ( f != null ) 
					for (  t in f )
						if ( t != null )
							if ( t.matrix != null )
							{
								t.matrix.a +=  Math.random() * 0.5 + 0.5;
								t.matrix.b +=  Math.random() * 0.5 + 0.5;
								t.matrix.c +=  Math.random() * 0.5 + 0.5;
								t.matrix.d +=  Math.random() * 0.5 + 0.5;
								t.matrix.tx +=  Math.random() * 0.5 + 0.5;
								t.matrix.ty +=  Math.random() * 0.5 + 0.5;		
							}
			}
		
	}
//---------------------------------------------------------------
	private function get_totalFrames() : Int
	{
		var total: Int = 1;

		if (  !_destroyed )
		{
			if ( _framesConfig != null ) total = _framesConfig.length;
			if ( total == 0 ) total = 1;
		}
		return total;
	}

	

	//---------------------------------------------------------------
	
	public function update( display: Bool = true  ) : Void
	{
		if ( _isPlaying && !_destroyed)
		{
			if ( reversingMode ) 
			{
				if ( !prevFrame( display ) ) gotoAndPlay(totalFrames, display);
			}
			else
			{	
				if ( !nextFrame( display ) ) gotoAndPlay(0, display);
			
			}
			
		
			var currentScript : Dynamic = _framesScript.get( _currentFrame );
				
			//On execute le script de la frame en cours
			if ( currentScript != null ) currentScript();
		}
		//else trace("NO PLAYING=========>" + _id);
		
	}
	
	
	//---------------------------------------------------------------
	public function reset() : Void
	{
		_alphaMaps = new Array();
		_oldAttached = new Array();
		removeFlag = false;
		_framesScript = new Map<Int,Dynamic>();
		_currentFrame = -1;
		reversingMode = false;
		_isPlaying = false;
		
		
	}
	//---------------------------------------------------------------
	
	private function displayBitmap(  ) : Void
	{
		#if html5
			applyMethodOne();
		#else
			applyMethodOne();
			//applyMethodTwo();
		#end
		
		
	}
	//---------------------------------------------------------------
	//-- METHODE 1 --
	private function applyMethodOne() : Void
	{
	
		_oldAttached = [];
		for ( j in 0 ... this.numChildren ) 
		{
			var child: DisplayObject = this.getChildAt(j);
			_oldAttached.push( child );
		}
		
		
		var idTexture: Int = 0;
		var matrix1: Matrix = null;
		var matrix2: Matrix = null;
		var newIDTexture: Int  = 0;
		var counter: Map<Int,Int> = new Map();
		var c: Int = 0;
		if ( currentFrame <  framesConfig.length )
			for (  obj in _framesConfig[_currentFrame] )
			{
				idTexture=  obj.textureData.id ;
				c = 0;
				if ( counter.exists( idTexture ) ) c = counter.get(idTexture);	
			
				newIDTexture = idTexture + c;
				var texture: Bitmap =  _texturesCreated.get(newIDTexture );
				
				if ( texture == null  )
				{
					texture = new Bitmap(  _ipbAtlas.getTextureById( idTexture ) );
					texture.smoothing = true;
					texture.name = "" + newIDTexture;
					
					_texturesCreated.set( newIDTexture, texture );
				}
				
				c += 5000;
				counter.set( idTexture, c );
				
				
				this.addChild( texture );	
				_oldAttached.remove( texture );
				
				matrix1 = obj.matrix;
				matrix2 = texture.transform.matrix;
				if ( matrix1 != null )
				{
					if ( matrix1.a != matrix2.a || matrix1.b != matrix2.b || matrix1.c != matrix2.c || matrix1.d != matrix2.d || matrix1.tx != matrix2.tx || matrix1.ty != matrix2.ty  )
					{
						texture.transform.matrix = matrix1;
					}
				}
				
				
				if ( texture.alpha !=  obj.alpha ) texture.alpha = obj.alpha;
			
			
			}
			
		
		//On enleve ceux qui n'ont pas été attaché
		removeOldAttached();
	
	}
	//---------------------------------------------------------------
	private function removeOldAttached() : Void
	{
		if ( _oldAttached != null )
		{
			while ( _oldAttached.length > 0 )
			{
				this.removeChild( _oldAttached[0] );
				_oldAttached.splice(0, 1);
			}
			_oldAttached = null;
		}
		
	}
	
	//---------------------------------------------------------------
	//-- METHODE 2 --
	private function applyMethodTwo() : Void
	{
		removeAlphaMaps();
	
		var bmpData: BitmapData = null;
		var textureMap: BitmapData = null;
		var alphaMap:BitmapData = null;
		this.graphics.clear();
		if ( currentFrame <  framesConfig.length )
		   for (  obj in _framesConfig[_currentFrame] )
		   {
			   bmpData = _ipbAtlas.getTextureById( obj.textureData.id );
			
			   if ( bmpData != null )
			   {
				   //bmpData.lock();
				
					if ( obj.alpha < 1 )
					{
						textureMap = new BitmapData(bmpData.width, bmpData.height);
						_alphaMaps.push( textureMap );
						#if flash
						var _alphaStr: String = "0x" + StringTools.hex( Std.int(obj.alpha * 255), 2) + "000000";
						alphaMap = new BitmapData(bmpData.width,bmpData.height,true, untyped _alphaStr);
						textureMap.copyPixels(bmpData, bmpData.rect, new Point(), alphaMap);	
						alphaMap.dispose();
						alphaMap = null;
						bmpData = textureMap;
						#else
						textureMap.copyPixels(bmpData, bmpData.rect, new Point());
						#end
						
					}
					
				/*
					
					if ( obj.alpha < 1 )
					{
						//textureMap = new BitmapData(bmpData.width, bmpData.height);
						
						//var _alphaStr: String = "0x" + StringTools.hex( Std.int(obj.alpha * 255), 2) + "000000";
						textureMap = new BitmapData(bmpData.width, bmpData.height, false, 0xffffff);// , true, untyped _alphaStr);
						_alphaMaps.push( textureMap );
						textureMap.copyPixels(bmpData, bmpData.rect, new Point(), textureMap);	
						//alphaMap.dispose();
						//alphaMap = null;
						bmpData = textureMap;
						
					}
					*/
					if ( obj.matrix == null )
					{
						this.graphics.beginBitmapFill(bmpData, null, false, true);
						this.graphics.drawRect(0, 0, bmpData.width, bmpData.height );
					}
					else
					{
						var a : Float =  obj.matrix.a * bmpData.width;
						var b: Float = obj.matrix.b * bmpData.width;
						_p0 = [ obj.matrix.tx, obj.matrix.ty ];
						_p1 = [ a + _p0[0], b + _p0[1]];
						_p3 = [ obj.matrix.c* bmpData.height + _p1[0], obj.matrix.d * bmpData.height + _p1[1] ] ;
						_p2 = [ -a + _p3[0], -b + _p3[1] ] ;	
						
						
						//Update UpperLeft
						this.graphics.beginBitmapFill(bmpData, obj.matrix, false, true);
						this.graphics.moveTo ( _p0[0], _p0[1] );
						this.graphics.lineTo ( _p1[0], _p1[1] );
						this.graphics.lineTo ( _p3[0], _p3[1] );
							
						//and update it for the lowerleft triangle, P0, P3, P2
						this.graphics.lineTo (_p2[0], _p2[1]);
						//bmpData.unlock();
						//this.graphics.endFill();
					}
							
					
					_p0 = _p1 = _p2 = _p3 = null;
					
			   }
			 
		   }
		
		this.graphics.endFill();
	}
	//---------------------------------------------------------------
	public function removeAlphaMaps() : Void
	{
		if ( _alphaMaps != null)
			while ( _alphaMaps.length > 0 )
			{
				
				_alphaMaps[0].dispose();
				_alphaMaps.splice(0, 1);
				
			}
		
	
	}
	
	//---------------------------------------------------------------
	public function gotoAndPlay( frameToGo: Int, display: Bool = true ) : Void {	gotoAndStop( frameToGo, true, display );	}
	//---------------------------------------------------------------
	public function gotoAndStop( frameToGo: Int, playAnimation: Bool = false, display: Bool = true ) : Void
	{
		if ( !_destroyed )
		{
			if ( _framesConfig == null ) throw("#### _framesConfig is null =>id: "+_id+"--->"+_destroyed);
			if ( _framesConfig.length >= frameToGo ) _currentFrame = frameToGo;
			else _currentFrame = _framesConfig.length;
		
			playing = playAnimation;
			if ( display ) displayBitmap();
		}
		
	}
	//---------------------------------------------------------------
	public function play() : Void {	gotoAndPlay( _currentFrame );	}
	//---------------------------------------------------------------
	public function stop() : Void {	gotoAndStop( _currentFrame, false );	}
	//---------------------------------------------------------------
	public function nextFrame( display: Bool = true ) : Bool 
	{
		var ok : Bool = false;
	
		if (  !_destroyed )
		{
			if ( _currentFrame < _framesConfig.length-1 )
			{
				_currentFrame++;
				if ( display ) displayBitmap();
				ok = true;
			}
		}
		return ok;
	}
	
	//---------------------------------------------------------------
	public function prevFrame( display: Bool = true ) : Bool 
	{
		var ok : Bool = false;
		if (  !_destroyed )
		{
			if ( _currentFrame > 2 )
			{
				_currentFrame--;
				if ( display ) displayBitmap();
				ok = true;
			}
		}
		return ok;
	}
	//---------------------------------------------------------------
	public function destroy( completely: Bool = false  ) : Void
	{
		_group = null;
		
		_id = null;
		_destroyed = true;
		removeAlphaMaps();
		_alphaMaps = null;
	
		playing = false;
		_texturesCreated = null;
		if ( completely ) if ( _ipbAtlas != null )  _ipbAtlas.destroy();
		_ipbAtlas = null;
		_framesScript = null;
		
		if ( _framesConfig != null )
		{
			if( completely )
				for ( f in  _framesConfig )
				{
					if ( f != null ) 
						for (  t in f )
							if ( t != null )
							{
								
								if ( t.matrix != null ) t.matrix = null;
								if ( t.textureData != null )
								{
									
									t.textureData.bmpData = null;
								}
								
							}
				}
			_framesConfig = null;
		
		}
		
		_p0 = null;
		_p1 = null;
		_p2 = null;
		_p3 = null;
		
		removeOldAttached();
		this.graphics.clear();
		while ( this.numChildren > 0 ) this.removeChildAt(0);
	
	
		
	}
}