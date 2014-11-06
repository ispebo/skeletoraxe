package skeletoraxe.converter.utils;


import flash.display.Sprite;

//@:bind class AnimLoader extends MovieClip { function new() : Void { super(); } }

class LoaderApp extends Sprite
{
	private static var _instance				: LoaderApp;
	
	private function new() : Void
	{
		super();
		this.graphics.beginFill(0, 0.7);
		this.graphics.drawRect(0, 0, AppMain.STAGE.stageWidth, AppMain.STAGE.stageHeight );
		var anim = new AnimLoader();
		addChild( anim );
		anim.x = (AppMain.STAGE.stageWidth - anim.width) / 2;
		anim.y = (AppMain.STAGE.stageHeight - anim.height) / 2;
		this.visible = false;
	}
	
	//-----------------------------------------------
	public static var instance( get_instance, null ) 		: LoaderApp;
	private static function get_instance( ) : LoaderApp
	{
		if ( _instance == null ) _instance = new LoaderApp();
		return _instance;
	}
	//-----------------------------------------------
	public function destroy(): Void
	{
		if ( parent != null ) parent.removeChild( this );
		_instance = null;
	}
}