package skeletoraxe.atlas;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.events.Event;
import skeletoraxe.atlas.AtlasSkAxe;


/**
 * @autor ispebo
 */
class MovieClip extends Sprite
{
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
	
	public function new( ident:String, ipbAtlas: AtlasSkAxe, framesConf: Array<Array<TextureFrameConfig>> ) : Void
	{
		super();
		_id = ident;
		
		_ipbAtlas = ipbAtlas;
		_framesConfig = framesConf;
		_texturesCreated = new Map();
		cacheAsBitmap = false;
		smoothing = false;
		_width = _height = 0;
	
		reset();
		
	
		
		for ( frameConfig in _framesConfig )
			for ( frame in frameConfig )
			{
				
				var texture: BitmapData = ipbAtlas.getTextureById(frame.textureData.id);
				if ( texture.width > _width ) _width = Std.int ( texture.width );
				if ( texture.height > _height ) _height = Std.int ( texture.height );
			}
	}
	
	
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
		if ( p1 == null ) _framesScript.remove(  frame );
		else _framesScript.set( frame, p1 );
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
	//---------------------------------------------------------------
	private function get_totalFrames() : Int { return _framesConfig.length; }
	//-----------------------------------------------------------
	

	//---------------------------------------------------------------
	
	public function update( display: Bool = true  ) : Void
	{
		
		if ( _isPlaying )
		{
			if ( reversingMode ) 
			{
				if ( !prevFrame( display ) ) gotoAndPlay(totalFrames, display);
			}
			else
			{	
				if ( !nextFrame( display ) ) gotoAndPlay(0, display);
			
			}
			
			var currentScript : Dynamic = _framesScript.get(_currentFrame );
				
			//On execute le script de la frame en cours
			if ( currentScript != null ) currentScript();
		}
		
	}
	
	
	//---------------------------------------------------------------
	public function reset() : Void
	{
		removeFlag = false;
		_framesScript = new Map<Int,Dynamic>();
		_currentFrame = -1;
		reversingMode = false;
		_isPlaying = false;
	}
	//---------------------------------------------------------------
	
	private function displayBitmap(  ) : Void
	{
		var oldAttached: Array<DisplayObject> = new Array();
		for ( j in 0 ... this.numChildren ) 
		{
			var child: DisplayObject = this.getChildAt(j);
			oldAttached.push( child );
		}
		var coucou: Int = 0;
		var counter: Map<Int,Int> = new Map();
		if ( currentFrame <  framesConfig.length )
			for (  obj in _framesConfig[_currentFrame] )
			{
				coucou++;
				if ( coucou > 200 ) throw("=> " + _currentFrame + "->" + this.id);
				var idTexture: Int =  obj.textureData.id ;
				var c: Int = 0;
				if ( counter.exists( idTexture ) ) c = counter.get(idTexture);	
			
				var newIDTexture: Int = idTexture + c;
				var texture: Bitmap =  _texturesCreated.get(newIDTexture );
				
				if ( texture == null  )
				{
					var bmpData: BitmapData = _ipbAtlas.getTextureById( idTexture );
					texture = new Bitmap( bmpData );
					//texture.cacheAsBitmap = false;
					texture.smoothing = true;
					texture.name = "" + newIDTexture;
					
					_texturesCreated.set( newIDTexture, texture );
				}
				
				c += 10000;
				counter.set( idTexture, c );
				
				this.addChild( texture );
				oldAttached.remove( texture );
				var matrix1: Matrix = obj.matrix;
				var matrix2: Matrix = texture.transform.matrix;
				if ( matrix1.a != matrix2.a || matrix1.b != matrix2.b || matrix1.c != matrix2.c || matrix1.d != matrix2.d || matrix1.tx != matrix2.tx || matrix1.ty != matrix2.ty )
				{
					texture.transform.matrix = matrix1;
				}
				if ( texture.alpha !=  obj.alpha ) texture.alpha = obj.alpha;
			}
			
	
		//On enleve ceux qui n'ont pas été attaché
		while ( oldAttached.length > 0 )
		{
			this.removeChild( oldAttached[0] );
			oldAttached.splice(0, 1);
		}
	
		
	}
	//---------------------------------------------------------------
	public function gotoAndPlay( frameToGo: Int, display: Bool = true ) : Void {	gotoAndStop( frameToGo, true, display );	}
	//---------------------------------------------------------------
	public function gotoAndStop( frameToGo: Int, playAnimation: Bool = false, display: Bool = true ) : Void
	{
		if ( _framesConfig.length >= frameToGo ) _currentFrame = frameToGo;
		else _currentFrame = _framesConfig.length;
	
		playing = playAnimation;
		if ( display ) displayBitmap();
		
	}
	//---------------------------------------------------------------
	public function play() : Void {	gotoAndPlay( _currentFrame );	}
	//---------------------------------------------------------------
	public function stop() : Void {	gotoAndStop( _currentFrame, false );	}
	//---------------------------------------------------------------
	public function nextFrame( display: Bool = true ) : Bool 
	{
		var ok : Bool = false;
	
		if ( _currentFrame < _framesConfig.length-1 )
		{
			_currentFrame++;
			if ( display ) displayBitmap();
			ok = true;
		}
		return ok;
	}
	
	//---------------------------------------------------------------
	public function prevFrame( display: Bool = true ) : Bool 
	{
		var ok : Bool = false;
		if ( _currentFrame > 2 )
		{
			_currentFrame--;
			if ( display ) displayBitmap();
			ok = true;
		}
		return ok;
	}
	//---------------------------------------------------------------
	public function destroy( ) : Void
	{
		playing = false;
		_texturesCreated = null;
		_ipbAtlas = null;
		_framesConfig = null;
		
	}
}