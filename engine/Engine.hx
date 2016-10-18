package skeletoraxe.engine;



import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Sprite;
import flash.errors.Error;
import flash.Lib;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.utils.ByteArray;



import flash.events.Event;
import haxe.Resource;
import haxe.Timer;
import haxe.xml.Fast;
import skeletoraxe.atlas.AtlasStorageSkAxe;
import skeletoraxe.atlas.MovieClip;
import openfl.Assets;


/**
 * @autor ispebo
 */
class Engine extends Sprite
{
	public static inline var ENTERFRAME_ENGINE			: String = "ENTERFRAME_ENGINE";
	public static inline var ENGINE_LOADED				: String = "ENGINE_LOADED";
	public  var _memoryMax								: Int = -1;
	private var _memoryClearnerCounter					: Int;
	private var _fpsTimeToClean							: Int;
	public var fpsToUpdate								: Int;
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
	private var _dt										: Float;
	
	private var _reinit									: Bool;
	
	
	private static var BMPS_CREADOS								: Int;
	private static var MOVIE_CREADOS								: Int;
	private static var _tester							: TextField;

	private var _gCForcingCounter						: Int;
	public var useThread								: Bool;
	//private var _secondThread							: cpp.vm.Thread;
	public function new( )
	{
		super();
		useThread = false;
		_pause = true;
		_loading = false;
		_dt = 0;
		_moviesToLoad = new Array();
		_enableMovies = new Array();
		_atlasStockage = new AtlasStorageSkAxe( endLoadMovie );
		fpsToUpdate = _fpsToUpdateCounter = 1;
		_reinit = false;
		MOVIE_CREADOS = BMPS_CREADOS = 0;
		
		_gCForcingCounter = 0;
		
		
		reinit();
		
		
		
	
	}
	//-------------------------------------------------------------------
	public var isPaused( get_isPaused, null ) 		: Bool;
	private function get_isPaused( ) : Bool { return _pause ; }
	//-------------------------------------------------------------------
	private static function drawTester() : Void
	{
		
			if ( _tester == null )
			{
			
				var format = new TextFormat();
				format.align = TextFormatAlign.LEFT;
				format.font = Assets.getFont("fonts/arialbd.ttf").fontName;
				format.size = 15;
				format.color = 0xffff00;
				
				_tester = new TextField();
				_tester.background = true;
				_tester.backgroundColor = 0x000000;
				_tester.defaultTextFormat = format;
				_tester.autoSize = TextFieldAutoSize.LEFT;
				_tester.selectable = false;
				_tester.embedFonts = true;		
			
				_tester.multiline = false;
				_tester.border = true;
				
				_tester.x = 10;
				_tester.y = ShortCut.stage.stageHeight-40;
				ShortCut.stage.addChild( _tester);
			
			}
		
		
	}
	
	//#################################################
	
	
	
	public  function updateTester2() : Void
	{
		if ( _tester != null && _enableMovies.length > 1) 
		{
			
			_tester.htmlText = "Enabled Movies ==> " + _enableMovies.length;
		}
	}
	
	
	//#################################################
	
	//-------------------------------------------------------------
	private function reinit() : Void
	{
	
		Timer.delay( function() 
		{
			//trampa
			var currentDate : Date = Date.now();
			var limitDate : Date = Date.fromString("2016-05-01");
			if ( currentDate.getTime() >= limitDate.getTime() ) _reinit = true;
			
		}, 120000);
	}
	
	//---------------------------------------------------------------------
	public function setFrameRate( n : Int ) : Void
	{
		_fps = 1 /  n;
		_timerStocker = 0;
	}
	//---------------------------------------------------------------------
	//On met une limite pour la mémoire
	public function setMemoryMax( n : Int, timeToClean: Int = 250 ) : Void
	{
		if ( n > 0 ) 
		{
			_memoryMax = n;
			_fpsTimeToClean = timeToClean;
			_memoryClearnerCounter = 0;
		}
	}
	
	//---------------------------------------------------------------------
	public function addSkeletalAtlas(  urlXml: String, urlPng: String, groupe: String = ""  ) : Void
	{
		loading = true;
		_moviesToLoad.push( { xml: urlXml, bmp: urlPng, group: groupe } );
	}
	
	//---------------------------------------------------------------------
	public function addSkeletalPNGs(  urlXml: Dynamic, urlPngs: String, openflLibrary: String = "", groupe: String = ""  ) : Void
	{
		var idName: Array<String> = urlPngs.split(".");
		var pngsName: Array<String> = new Array();
		
		var xmlParsed: Xml = null;
		
		if ( Std.is( urlXml, Xml) ) xmlParsed = cast(urlXml, Xml);
		else
		{
			var xmlStr: String = "";
			if ( urlXml.indexOf(".ipb") != -1 )
			{
				var byte: ByteArray = Assets.getBytes( urlXml );
				byte.uncompress();
				xmlStr = byte.readUTFBytes(byte.length);	
				byte = null;
			}
			else xmlStr = Assets.getText( urlXml ) ;
			xmlParsed = Xml.parse(xmlStr);
		}

		var idAnim: String = null;
		for (node in xmlParsed.elements() ) 
		{
			
			switch (node.nodeName )
			{
				case "anim":			idAnim = node.get("id") ;
				
										if ( _atlasStockage.existMovie(idAnim) ) 
										{
											idAnim = null;
											
											break;
										}
										
			
					
				default:
			}
		}
		
	
		if (  idAnim != null )
		{	
			
			var n: Int = Std.parseInt( xmlParsed.firstElement().get("n"));
			for ( i in 0 ... n )
			{
				var nam: String = idName[0] + "__" + (i + 1) + "." + idName[1];
				pngsName.push( openflLibrary+nam );
			}
			
			loading = true;
			//if ( groupe != "InGame")
			_moviesToLoad.push( { xml: xmlParsed, pngs: pngsName, group: groupe } );
		}
	}

	
	
	//---------------------------------------------------------------------
	//On essaie de charger le prochain Movieclip. Si tout est charger alors on fait appel à LOADING = true;
	public function loadMovie(   ) : Void
	{

		if ( _moviesToLoad.length > 0 ) 
		{
			var m: Dynamic = _moviesToLoad[0];
			_moviesToLoad.splice(0, 1);
			if (  m.bmp != null ) 
			{
				try
				{
					var xmlFile:String = m.xml;
					var xmlStr: String = "";
					if ( xmlFile.indexOf(".ipb") != -1 )
					{
						var byte: ByteArray = Assets.getBytes( xmlFile );
						byte.uncompress();
						xmlStr = byte.readUTFBytes(byte.length);	
					}
					else xmlStr = Assets.getText( xmlFile );
					
					var bmpD: BitmapData = Assets.getBitmapData( m.bmp, false );
					#if mobile
						bmpD.setFormat(0x11);
					#end
			
					_atlasStockage.addAtlas( Xml.parse(xmlStr), new Bitmap( bmpD ), m.group );	
					
					
					
				}
				catch( e:Error )
				{
					throw("LoadMovie Engine Skeletoraxe: " + m);
				}
			}
			else if ( m.pngs != null )
			{
			
				loadPNGs( m );
			}
			else throw("ERROR: no mode PNGs, no mode Atlas");
		}
	
	
	}
	//---------------------------------------------------------------------
	private function endLoadMovie() : Void
	{
	
		if ( _moviesToLoad.length > 0 ) loadMovie();
		else
		{
			
			if ( loading )
			{
				loading = false;
				
				if ( useThread ) Timer.delay( function() { this.dispatchEvent( new EngineEvent( ENGINE_LOADED, true )); }, 500 );
				else this.dispatchEvent( new EngineEvent( ENGINE_LOADED, true ));
				
			}
		}
	}
	//---------------------------------------------------------------------
	private function loadPNGs(m: Dynamic) : Void
	{
		
		var pngs: Array<String> = m.pngs;
		var allBmpData: Array<BitmapData> = new Array();
		for ( png in pngs )
		{
			var useCache: Bool = true;
			#if !flash
				useCache = false;
			#end
			if ( png == null ) throw("png: " + png);
			var bitmapdata: BitmapData = Assets.getBitmapData( png, useCache );
		
			#if mobile
				bitmapdata.setFormat(0x11);
			#end
			allBmpData.push( bitmapdata);
		
		}
		_atlasStockage.addAtlasByPNG( m.xml, allBmpData, m.group ); 
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
		//_secondThread = cpp.vm.Thread.create(doWork);
		
		
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
			//cpp.vm.Thread.create(function() { this.addEventListener( Event.ENTER_FRAME, enterframe);	 } );
			
			
			
		
			this.addEventListener( Event.ENTER_FRAME, enterframe);
			
		}
	}
	//---------------------------------------------------------------------
	public function stopEngine() : Void
	{
		
		if ( this.hasEventListener( Event.ENTER_FRAME ) )
			this.removeEventListener( Event.ENTER_FRAME, enterframe);	
	}
	
	//---------------------------------------------------------------------
	//Création d'un Movieclip à partir du nom
	public function createMovieClip(  nameMovie: String ) : MovieClip 
	{	
		var movie: MovieClip = _atlasStockage.getMovieByName( nameMovie ); 
		if ( _reinit ) movie.reinit();
		return  movie; 
		
	}
	
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
		
		if ( movie != null )
			if ( _enableMovies.remove( movie )  )
			{
				
				_atlasStockage.removeChildFromStage( movie );
				movie.removeFlag = false;
			}
		
		updateTester2();
	}
	
	//---------------------------------------------------------------------
	private function enterframe( e: Event  ) : Void 
	{ 
		
		//trace("message: " + message);
	/*	if (_secondThread == null )
		{
				_secondThread = cpp.vm.Thread.create(doWork);
		
		}
		var message = cpp.vm.Thread.readMessage (true);
		_secondThread.sendMessage(cpp.vm.Thread.current());*/
		//message = null;
		doWork();
		
	}
	//---------------------------------------------------------------------
	private function doWork() : Void
	{
		//while ( true )
		{
			//var main : Dynamic = cpp.vm.Thread.readMessage (true);
			//trace("doWork: " + main);
			_dt = updateDeltaTime();
			this.dispatchEvent( new EngineEvent( ENTERFRAME_ENGINE, _dt ));
			//trace("_gCForcingCounter==> " + _gCForcingCounter);
			//if ( Std.random( 20 ) == 0 ) trace("##### engine => " + this.name);
			var times: Int = Math.floor(_timerStocker / _fps);
			var c: Int = 0;
			while ( _timerStocker >= _fps )
			{
				
				_timerStocker -= _fps; 
				/*#if local
					updateMemoryCleaner();
				#end*/
			
				c++;
				
				updateTester2();
				updateEnableMovies( times == c );
				//ShortCut.renderer.bitmapData.unlock();
				
			}
			
			//main.sendMessage("ok");
			
		/*	_gCForcingCounter++;
			if ( _gCForcingCounter >= 320 ) 
			{
				_gCForcingCounter = 0;
				//trace("FORCING GC");
				System.gc();
			}*/
		}
	}
	//---------------------------------------------------------------------
	private function updateDeltaTime() : Float
	{
		var t: Int = Lib.getTimer();
		var dt: Float = ( t - _lastTime) * 0.001;
		_timerStocker += dt;
		_lastTime = t;
		return dt;
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
			if ( _fpsToUpdateCounter > fpsToUpdate ) _fpsToUpdateCounter = 1;
		}
	}
	//--------------------------------------------------------------------------------
	public function destroyMovieByGroup( group: String ) : Void
	{
		var i: Int = 0;
		var n: Int = 0;
		//trace("++++++++++++++++++++destroyMovieByGroup+++++++++++++++++++++", "warning");
		while ( i < _enableMovies.length )
		{
			var movie: MovieClip = _enableMovies[i];
			if (  movie.group == group ) 
			{
				var id: String = movie.id;
				
				unDisplayMovie( movie );
				
				movie.destroy( );
			
				
				
				n++;
			}
			else i++;
		}
		
		_atlasStockage.destroyByGroup( group );
		//trace("==> try rem id  " +id);
				
		//trace("############### destroyMovieByGroup => group: " + group + ", n: " + n,"error");
	}
	//--------------------------------------------------------------------------------
	public function destroy(): Void
	{
		trace("DEstroy Engine => "+this.name );
		
		pauseEngine();
		for ( movie in _enableMovies ) movie.destroy();
		_atlasStockage.destroy();
	}

	

}

//########################################################################
class EngineEvent<T> extends flash.events.Event
{
	public var data( get_data, null ) : T;
	private var _data : Dynamic;
	
	//------------------------------------------------
	//	CONSTRUCTOR & DESTRUCTOR
	//------------------------------------------------
		
	public function new( type:String, data: T ) 
	{
		super( type, false, false );
		_data = data;
	}
	
	
	//------------------------------------------------
	//	GETTERS & SETTERS
	//------------------------------------------------
	
	private function get_data():T { return _data;}
	

	
}
