package skeletoraxe.engine;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import haxe.Resource;
import haxe.Timer;
import haxe.xml.Fast;
import skeletoraxe.atlas.AtlasStorageSkAxe;
import skeletoraxe.atlas.MovieClip;
import openfl.Assets;



class Engine extends Sprite
{
	private var _atlasStockage							: AtlasStorageSkAxe;
	private var _moviesToLoad							: Array<Dynamic>;
	
	private var _loading								: Bool;
	public var loading( get_loading, set_loading ) 		: Bool;
	
	private var _pause									: Bool;
	
	private var _enableMovies							: Array<MovieClip>;
	
	
	public function new()
	{
		super();
		_pause = true;
		_loading = false;
		_moviesToLoad = new Array();
		_enableMovies = new Array();
		_atlasStockage = new AtlasStorageSkAxe( loadMovie );
	}
	
	//---------------------------------------------------------------------
	public function addSkeletalAtlas(  urlXml: String, urlPng: String ) : Void
	{
		loading = true;
		_moviesToLoad.push( { xml: urlXml, bmp: urlPng } );
	}
	//---------------------------------------------------------------------
	//On essaie de charger le prochain Movieclip. Si tout est charger alors on fait appel à LOADING = true;
	private function loadMovie() : Void
	{
		if ( _moviesToLoad.length > 0 ) 
		{
			var m: Dynamic = _moviesToLoad[0];
			_moviesToLoad.splice(0, 1);
			_atlasStockage.addAtlas( Xml.parse(Assets.getText( m.xml )), new Bitmap( Assets.getBitmapData( m.bmp ) ) );
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
		playEngine();
		
	}
	//---------------------------------------------------------------------
	//On met tout en PAUSE
	public function pauseEngine() : Void
	{
		if ( !_pause )
		{
			
			_pause = !_pause;
			this.removeEventListener( Event.ENTER_FRAME, enterframe);	
		}
	}
	//---------------------------------------------------------------------
	//On execute les animations
	public function playEngine() : Void
	{
		if ( _pause )
		{
			
			_pause = !_pause;
			this.addEventListener( Event.ENTER_FRAME, enterframe);	
		}
	}
	
	//---------------------------------------------------------------------
	//Création d'un MovieClip à partir du nom
	public function createMovieClip(  nameMovie: String ) : MovieClip
	{
		var movie: MovieClip = _atlasStockage.getMovieByName( nameMovie );
		if ( movie == null ) throw(":: " + nameMovie );
		return movie;
	}
	
	//---------------------------------------------------------------------
	public function displayMovie( movie: MovieClip ) : Void
	{
		if ( !movie.playing )
		{
			movie.removeFlag = false;
			 _enableMovies.push( movie );
			 movie.playing = true;
		}
	}
	
	//---------------------------------------------------------------------
	public function unDisplayMovie( movie: MovieClip ) : Void
	{
		if ( movie.playing )
		{
			movie.removeFlag = false;
			 _enableMovies.remove( movie );
			 movie.playing = false;
		}
	}

	
	//---------------------------------------------------------------------
	private function enterframe( e: Event  ) : Void { }
	//--------------------------------------------------------------------------------
	public function destroy(): Void
	{
		pauseEngine();
		for ( movie in _enableMovies ) movie.destroy();
		_atlasStockage.destroy();
	}

	

}