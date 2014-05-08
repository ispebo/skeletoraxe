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
		removeFlag = false;
		_ipbAtlas = ipbAtlas;
		_framesConfig = framesConf;
		_currentFrame = -1;
		reversingMode = false;
		_texturesCreated = new Map();
		cacheAsBitmap = false;
		smoothing = false;
		_isPlaying = false;
		_framesScript = new Map<Int,Dynamic>();
		_width = _height = 0;
		
		
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
	private function get_framesConfig( ):  Array<Array<TextureFrameConfig>> 
	{
		var tab: Array<Array<TextureFrameConfig>> = new Array();
		for ( frameConfig in _framesConfig )
		{
			var tab2: Array<TextureFrameConfig> = new Array();
			tab.push( tab2 );
			for ( frame in frameConfig )
			{
				var fC: TextureFrameConfig = {
					textureData: frame.textureData,
					matrix: frame.matrix,
					frame: frame.frame,
					alpha: frame.alpha
				}
				tab2.push( fC );
			}
		}
		return tab; 
	};
	
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
		if ( _isPlaying != b )
		{
			_isPlaying = b;
			//if ( _isPlaying ) this.addEventListener( Event.ENTER_FRAME, enterframe );
			//else this.removeEventListener( Event.ENTER_FRAME, enterframe );
		}
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
		for ( bitmap in _texturesCreated ) bitmap.cacheAsBitmap = b;
		_cacheAsBitmap = b;
	}
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
	
/*	private function enterframe( e: flash.events.Event ) : Void
	{
		if ( _isPlaying ) update();
		
	}*/
	//---------------------------------------------------------------
	public function update(  ) : Void
	{
		if ( _isPlaying )
		{
			if ( reversingMode ) 
			{
				if ( !prevFrame() ) gotoAndPlay(totalFrames);
			}
			else
			{	
				if ( !nextFrame() ) gotoAndPlay(0);
				
			}
			
			var currentScript : Dynamic = _framesScript.get(_currentFrame );
				
			//On execute le script de la frame en cours
			if ( currentScript != null ) currentScript();
		}
		
	}
	
	//---------------------------------------------------------------
	
	private function displayBitmap(  ) : Void
	{
		var attached: Array<Int> = new Array();
		var counter: Map<Int,Int> = new Map();
	
		for (  obj in _framesConfig[_currentFrame] )
		{
			var idTexture: Int =  obj.textureData.id ;
			var c: Int = 0;
			if ( counter.exists( idTexture ) ) c = counter.get(idTexture);	
		
			var newIDTexture: Int = idTexture + c;
		
			var texture: Bitmap = _texturesCreated.get(newIDTexture );
			
			if ( texture == null  )
			{
				var bmpData: BitmapData = _ipbAtlas.getTextureById( idTexture );
				texture = new Bitmap( bmpData );
			
				texture.smoothing = true;
				texture.name = "" + newIDTexture;
				_texturesCreated.set( newIDTexture, texture );
			}
			
			c += 10000;
			counter.set( idTexture, c );
			attached.push( newIDTexture );
			this.addChild( texture );
			
			var matrix1: Matrix = obj.matrix;
			var matrix2: Matrix = texture.transform.matrix;
			if ( matrix1.a != matrix2.a || matrix1.b != matrix2.b || matrix1.c != matrix2.c || matrix1.d != matrix2.d || matrix1.tx != matrix2.tx || matrix1.ty != matrix2.ty )
				texture.transform.matrix = obj.matrix;
			texture.alpha = obj.alpha;
		}
		
	
		//On enleve ceux qui n'ont pas été attaché
		var i : Int = 0;
		while ( i < this.numChildren )
		{
			var child: DisplayObject = this.getChildAt(i);
			if ( !Lambda.has( attached, Std.parseInt(child.name) ) ) this.removeChildAt( i );
			else i++;
		}
		
	}

	//---------------------------------------------------------------
	public function gotoAndPlay( frameToGo: Int ) : Void {	gotoAndStop( frameToGo, true );	}
	//---------------------------------------------------------------
	public function gotoAndStop( frameToGo: Int, playAnimation: Bool = false ) : Void
	{
		//if ( frameToGo == 0 ) frameToGo = 1;
		
		if ( _framesConfig.length >= frameToGo ) _currentFrame = frameToGo;
		else _currentFrame = _framesConfig.length;
	
		playing = playAnimation;
		displayBitmap();
		
	}
	//---------------------------------------------------------------
	public function play() : Void {	gotoAndPlay( _currentFrame );	}
	//---------------------------------------------------------------
	public function stop() : Void {	gotoAndStop( _currentFrame, false );	}
	//---------------------------------------------------------------
	public function nextFrame() : Bool 
	{
		var ok : Bool = false;
		if ( _currentFrame < _framesConfig.length-1 )
		{
			_currentFrame++;
			displayBitmap();
			ok = true;
		}
		return ok;
	}
	//---------------------------------------------------------------
	public function prevFrame() : Bool 
	{
		var ok : Bool = false;
		if ( _currentFrame > 2 )
		{
			_currentFrame--;
			displayBitmap();
			ok = true;
		}
		return ok;
	}
	//---------------------------------------------------------------
	public function destroy( ) : Void
	{
		playing = false;
		/*for (key in _texturesCreated.keys()) 
		{
			var bmp: Bitmap = _texturesCreated.get( key );
			bmp.bitmapData.dispose();
			bmp = null;
			
		}
		_texturesCreated = null;
		*/
		//_ipbAtlas = null;
		_framesConfig = null;
		
		
		
		
		
	}
}