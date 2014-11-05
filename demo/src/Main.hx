package ;

import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.Event;
import tools.FPSCounter;

import skeletoraxe.engine.Engine;
import skeletoraxe.atlas.AtlasStorageSkAxe;
import skeletoraxe.atlas.MovieClip;

import flash.Lib;

#if (!android && !html5 )
import com.standard.log.alcon.Debug;
#end

/**
 * @author ispebo
 */


 
class Main extends Engine
{
	private static inline var MODE_ATLAS				: Int = 1;
	private static inline var MODE_PNGS					: Int = 2;
	private static var MODE_LOADING						: Int = MODE_PNGS;
	public static var STAGE								: Stage;
	private var _animsDefinition						: Array<String> ;
	
	public function new()
	{		
		super();
		STAGE = Lib.current.stage;
		
	#if ( flash ) 
		setDebug();
	#end
	
		
	#if ( android || ios )
		STAGE.addEventListener( Event.DEACTIVATE, pause );
		STAGE.addEventListener( Event.ACTIVATE, resume );
		STAGE.addEventListener( KeyboardEvent.KEY_UP, keyUp );
	#end
		
		setSkeletalAtlas();
		AtlasStorageSkAxe.SAMES_ENTITIES_MAX = 0;
		AtlasStorageSkAxe.BUFFER = 0;	
		loadMovie();
		setFrameRate( 30 );
		playEngine();
		
		
	}
	
//-------------------------------------------------------------------------------------
	#if ( android || ios )
		private function keyUp( e : KeyboardEvent ) : Void 
		{
			if ( e.keyCode == 27 ) { //Back
				e.stopImmediatePropagation();
				e.stopPropagation();
				Lib.exit();
			}
		}
		
		private function pause( e: Event ) : Void
		{
			pauseEngine();
		}
		
		private function resume( e: Event ) : Void
		{
			playEngine();
		}
	#end
	
	//-------------------------------------------------------------------------------------
#if ( flash )
	//Mise en place du debugger
	private function setDebug() : Void
	{
		Debug.clear();
		Debug.delimiter();
		Debug.mark( 0xff0000 );
		Debug.redirectTrace();
		Debug.monitor( STAGE );
		Debug.enabled = true;
	}
#end
	

//--------------------------------------------------------------------
	//On insère tous les Movieclips en Atlas à charger en fonction du mode de chargement( Atlas ou PNGs )
	private function setSkeletalAtlas() : Void
	{
		if ( MODE_LOADING == MODE_ATLAS ) addSkeletalAtlas("xmls/CrocoAtlas.xml", "gfx/CrocoAtlas.png");
		else addSkeletalPNGs("xmls/CrocoPNGS.xml", "gfx/CrocoPNGS.png");
	}
	
	//---------------------------------------------------------------------
	//Tous les Skeletal Atlas on été pris en compte et charges
	override private function loadingFinish() : Void 
	{
		_animsDefinition = [ 
						"CrocodileHappy",
						"CrocodileSurprised",
						"CrocodileStones",
						"CrocodileWait",
						"CrocodileWorried"
										
					];
			
										
			
		for ( i in 0 ... 5 ) 
			for ( j in 0 ... 3 )
			 createAnim(  i * 180 + 100, j * 280 + 100 );
			 
	
		start();
		var fpsCounter: FPSCounter = new FPSCounter();
		addChild( fpsCounter );
		fpsCounter.draw();
		fpsCounter.start();
					
	
	}
	
	//--------------------------------------------------------------------------
	private function createAnim(  _x: Float, _y: Float ) : Void
	{
		
		var movie: MovieClip = createMovieClip( _animsDefinition[ Std.random(_animsDefinition.length) ] );
		addChild( movie );
		movie.x = _x;
		movie.y = _y;
		displayMovie( movie  );
		movie.addFrameScript( movie.totalFrames - 1, function() 
													{ 
														if ( Std.random(5) == 1 ) 
														{
															movie.addFrameScript( movie.totalFrames - 1, null);
															movie.removeFlag = true;
														}
													} );
	}
	
	
	//--------------------------------------------------------------------------
	override private function enterframe( e: Event  ) : Void
	{
		var i : Int = 0;
	
		
		while ( i < _enableMovies.length )
		{
			var movie: MovieClip = _enableMovies[i];
			if ( movie.removeFlag )
			{
				removeChild( movie );
				unDisplayMovie( movie  );
				createAnim( movie.x, movie.y);
			}
			else 
			{
				
				movie.update();
				i++;
			}
		}
	}

	//---------------------------------------------------------------------------
	
	public static function main() : Void
	{
		var mainInstance: Main = new Main() ;
		Lib.current.stage.addChild( mainInstance );
	}
	
}