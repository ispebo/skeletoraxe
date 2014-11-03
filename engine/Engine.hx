package skeletoraxe.engine;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Sprite;
import flash.Lib;
import flash.system.System;


import flash.events.Event;
import haxe.Resource;
import haxe.Timer;
import haxe.xml.Fast;
import skeletoraxe.atlas.AtlasStorageSkAxe;
import skeletoraxe.atlas.MovieClip;
import openfl.Assets;



class Engine extends Sprite
{
	public  var _memoryMax								: Int = -1;
	private var _memoryClearnerCounter					: Int;
	private var _fpsTimeToClean							: Int;
	private var _fpsToUpdate							: Int;
	private var _fpsToUpdateCounter						: Int;
	
	private var _atlasStockage							: AtlasStorageSkAxe;
	private var _moviesToLoad							: Array<Dynamic>;
	
	private var _loading								: Bool;
	public var loading( get_loading, set_loading ) 		: Bool;
	
	private var _pause									: Bool;
	
	private var _enableMovies							: Array<MovieClip>;
	
	
	private var _lastTime								: Int;
	private var _timerStocker							: Float;
	private var _fps									: Float;

	
	public function new( )
	{
		super();
		_pause = true;
		_loading = false;
		
		_moviesToLoad = new Array();
		_enableMovies = new Array();
		_atlasStockage = new AtlasStorageSkAxe( loadMovie );
		_fpsToUpdate = _fpsToUpdateCounter = 1;
		
		
	}
	
	//---------------------------------------------------------------------
	public function setFrameRate( n : Int ) : Void
	{
		_fps = 1 /  n;
		_timerStocker = 0;
	}
	//---------------------------------------------------------------------
	//On met une limite pour la mémoire
	public function setMemoryMax( n : Int, timeToClean: Int = 400 ) : Void
	{
		if ( n > 0 ) 
		{
			_memoryMax = n;
			_fpsTimeToClean = timeToClean;
			_memoryClearnerCounter = 0;
		}
	}
	
	//---------------------------------------------------------------------
	public function addSkeletalAtlas(  urlXml: String, urlPng: String ) : Void
	{
		loading = true;
		_moviesToLoad.push( { xml: urlXml, bmp: urlPng } );
	}
	
	//---------------------------------------------------------------------
	public function addSkeletalPNGs(  urlXml: Dynamic, urlPngs: String, openflLibrary: String = ""  ) : Void
	{
		
		var idName: Array<String> = urlPngs.split(".");
		var pngsName: Array<String> = new Array();
		
		var xmlParsed: Xml = null;
		if ( Std.is( urlXml, Xml) ) xmlParsed = cast(urlXml, Xml);
		else xmlParsed = Xml.parse(Assets.getText( openflLibrary+urlXml ));

		
		var n: Int = Std.parseInt( xmlParsed.firstElement().get("n"));
		for ( i in 0 ... n )
		{
			var nam: String = idName[0] + "__" + (i + 1) + "." + idName[1];
			pngsName.push( openflLibrary+nam );
			
		}
		
		loading = true;
		_moviesToLoad.push( { xml: xmlParsed, pngs: pngsName } );
		
	}
	
	
	//---------------------------------------------------------------------
	//On essaie de charger le prochain Movieclip. Si tout est charger alors on fait appel à LOADING = true;
	private function loadMovie() : Void
	{
		if ( _moviesToLoad.length > 0 ) 
		{
			var m: Dynamic = _moviesToLoad[0];
			_moviesToLoad.splice(0, 1);
			if (  m.bmp != null ) 
			{
				_atlasStockage.addAtlas( Xml.parse(Assets.getText( m.xml )), new Bitmap( Assets.getBitmapData( m.bmp ) ) );
			}
			else if ( m.pngs != null )
			{
				var pngs: Array<String> = m.pngs;
				var allBmpData: Array<BitmapData> = new Array();
				for ( png in pngs ) allBmpData.push( Assets.getBitmapData( png ) );
				
				_atlasStockage.addAtlasByPNG( m.xml, allBmpData );
			}
			else throw("ERROR: no mode PNGs, no mode Atlas");
		}
		else loading = false;
	}
	
	//---------------------------------------------------------------------

	private function get_loading() : Bool { return _loading; }
	private function set_loading( l: Bool ) : Bool 
	{ 
		if ( _loading != l )
		{
			_loading = l;	
			if ( !_loading ) loadingFinish();
		}
		return _loading; 
	}
	//---------------------------------------------------------------------
	//On vient de charger tous les Movieclips
	private function loadingFinish() : Void { }
	
	//---------------------------------------------------------------------
	public function start() : Void
	{
		_memoryClearnerCounter = 0;
		playEngine();
		
	}
	//---------------------------------------------------------------------
	//On met tout en PAUSE
	public function pauseEngine() : Void
	{
		if ( !_pause )
		{
			_pause = !_pause;
			stopEngine();
		}
	}
	//---------------------------------------------------------------------
	//On execute les animations
	public function playEngine() : Void
	{
		if ( _pause )
		{
			 _lastTime = Lib.getTimer();
			_pause = !_pause;
			this.addEventListener( Event.ENTER_FRAME, enterframe);	
		}
	}
	//---------------------------------------------------------------------
	public function stopEngine() : Void
	{
		this.removeEventListener( Event.ENTER_FRAME, enterframe);	
	}
	
	//---------------------------------------------------------------------
	//Création d'un Movieclip à partir du nom
	public function createMovieClip(  nameMovie: String ) : MovieClip {	return _atlasStockage.getMovieByName( nameMovie ); }
	
	//---------------------------------------------------------------------
	public function displayMovie( movie: MovieClip ) : Void
	{
		if ( !movie.playing  )
		{
			_enableMovies.push( movie );
			movie.removeFlag = false;
			movie.playing = true;
		}
	}
	
	//---------------------------------------------------------------------
	public function unDisplayMovie( movie: MovieClip ) : Void
	{
		if ( movie.playing  )
		{
			_enableMovies.remove( movie );
			_atlasStockage.removeChildFromStage( movie );
			movie.removeFlag = false;
		}
	}
	
	//---------------------------------------------------------------------
	private function enterframe( e: Event  ) : Void 
	{ 
		updateDeltaTime();
	
		var times: Int = Math.floor(_timerStocker / _fps);
		
		var c: Int = 0;
		while ( _timerStocker >= _fps )
		{
			
			_timerStocker -= _fps; 
			#if local
				updateMemoryCleaner();
			#end
		
			c++;
			updateEnableMovies( times == c );
			
		}
	}
	//---------------------------------------------------------------------
	private function updateDeltaTime() : Void
	{
		var t: Int = Lib.getTimer();
		var dt: Float = ( t - _lastTime) * 0.001;
		_timerStocker += dt;
		_lastTime = t;
	}
	//---------------------------------------------------------------------
	private function updateMemoryCleaner() : Void
	{
		if ( _memoryMax	> 0 )
		{
			_memoryClearnerCounter++;
			if ( _memoryClearnerCounter >= _fpsTimeToClean )
			{
				
				_memoryClearnerCounter = 0;
				var currentMemory: Int = Std.int (  System.totalMemory / 1048576 );
				if ( currentMemory >= _memoryMax ) System.gc();
			}
		}
	}
	//---------------------------------------------------------------------
	private function updateEnableMovies( force : Bool = true ) : Void
	{	
		var i: Int = 0;
	
		while ( i < _enableMovies.length )
		{
			var movie: MovieClip = _enableMovies[i];
			if ( movie != null )
			{
				movie.update( _fpsToUpdateCounter == 1 && force );
				i++;
			}
		}
		
		if ( force )
		{
			_fpsToUpdateCounter++;
			if ( _fpsToUpdateCounter > _fpsToUpdate ) _fpsToUpdateCounter = 1;
		}
	}
	//--------------------------------------------------------------------------------
	public function destroy(): Void
	{
		pauseEngine();
		for ( movie in _enableMovies ) movie.destroy();
		_atlasStockage.destroy();
	}

	

}