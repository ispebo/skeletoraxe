package ;

import flash.desktop.NativeApplication;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import com.standard.log.alcon.Debug;
import flash.utils.ByteArray;
import skeletoraxe.converter.utils.LoaderApp;
import skeletoraxe.converter.IPBDisplayer;
import skeletoraxe.converter.ToolsInterface;


@:bitmap( "bin/icons/icon16.png" ) class Icon16 extends Bitmap { public function new() { super() ; } }

@:bitmap( "bin/icons/icon32.png" ) class Icon32 extends Bitmap { public function new() { super() ; } }
@:bitmap( "bin/icons/icon48.png" ) class Icon48 extends Bitmap { public function new() { super() ; } }
@:bitmap( "bin/icons/icon128.png" ) class Icon128 extends Bitmap { public function new() { super() ; } }
class AppMain extends Sprite
{
	public static var STAGE						: Stage;
	private var _ipbDisplayer					: IPBDisplayer;
	private var _toolsInterface					: ToolsInterface;
	
	
	public function new()
	{		
		super();
		
		
	}
	
	//-------------------------------------------------------------------------------------
	public function initialize() : Void
	{
		if ( NativeApplication.supportsSystemTrayIcon) {
			NativeApplication.nativeApplication.icon.bitmaps = [ new Icon16().bitmapData, new Icon32().bitmapData ];
			
		}
		if ( NativeApplication.supportsDockIcon) 
		{
			NativeApplication.nativeApplication.icon.bitmaps = [ new Icon32().bitmapData, new Icon48().bitmapData ];
		}
	
		STAGE = Lib.current.stage;
		//STAGE.displayState =  StageDisplayState.FULL_SCREEN;
		STAGE.scaleMode = StageScaleMode.NO_SCALE;
		STAGE.align = StageAlign.TOP_LEFT;
		setDebug();
		
		
		_ipbDisplayer = new IPBDisplayer();
		addChild( _ipbDisplayer );
		_ipbDisplayer.x = ToolsInterface.WIDTH;
		
		_toolsInterface = new ToolsInterface( _ipbDisplayer );
		addChild( _toolsInterface );
		
		addChild( LoaderApp.instance );		
		STAGE.addEventListener( Event.RESIZE, onResize );
		
	
	}
	
	//-------------------------------------------------------------------------------------
	private function onResize( e: Event ) : Void
	{
		_ipbDisplayer.resize();
		_toolsInterface.resize();
	}
	
	//-------------------------------------------------------------------------------------
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
	
	
	//---------------------------------------------------------------------------
	
	private static function addedToStage( e : Event ) : Void
	{
		Lib.current.removeEventListener( Event.ADDED_TO_STAGE, addedToStage );
		var mainInstance: AppMain = new AppMain() ;
		Lib.current.stage.addChild( mainInstance );
		mainInstance.initialize();
		
	}
	//---------------------------------------------------------------------------
	
	public static function main() : Void
	{
		Lib.current.addEventListener( Event.ADDED_TO_STAGE, addedToStage );
	}
	
	
}