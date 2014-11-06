package skeletoraxe.converter;

import flash.display.Bitmap;

import flash.display.Sprite;
import flash.events.Event;
import flash.filters.GlowFilter;
import flash.display.Loader;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.utils.ByteArray;
import flash.Vector.Vector;
import skeletoraxe.converter.utils.LoaderApp;

import flash.filesystem.File;
import flash.filesystem.FileStream;

import skeletoraxe.converter.AtlasGenerator;
import skeletoraxe.atlas.AtlasStorageSkAxe;
import skeletoraxe.atlas.MovieClip;
import skeletoraxe.converter.utils.exporters.PNGExporter;
import skeletoraxe.converter.utils.exporters.XmlExporter;
import skeletoraxe.converter.utils.exporters.ZipExporter;
import skeletoraxe.converter.IPBDisplayer;
import skeletoraxe.converter.components.Button;
import skeletoraxe.converter.components.SelectionButton;
import skeletoraxe.converter.components.SpeedDisplayer;


/**
 * @autor ispebo
 */
class ToolsInterface extends Sprite
{
	public static var WIDTH					: Int = 150;
	
	public static inline var LOAD				: String = "load";
	public static inline var CLEAR				: String = "clear";
	public static inline var SAVE				: String = "save";
	public static inline var SAVE_PNGS			: String = "savePngs";
	public static inline var PLAY				: String = "play";
	public static inline var PAUSE				: String = "pause";
	public static inline var COLOR				: String = "color";
	
	public static inline var SWF_VIEW			: String = "swfView";
	public static inline var PREVIEW_VIEW		: String = "previewView";
	public static inline var ATLAS_VIEW			: String = "atlasView";
	
	
	
	private var _displayer						: IPBDisplayer;
	private var _atlasconverter					: AtlasGenerator;
	private var _allDefinitions					: Vector<String>;
	private static var _loader 					: Loader;
	private var _file							: File;
		
	//Buttons
	private var _loadButton						: Button;
	private var _resetButton					: Button;
	private var _saveButton						: Button;
	private var _savePngsButton					: Button;
	private var _playButton						: Button;
	private var _pauseButton					: Button;
	private var _speedDisplayer					: SpeedDisplayer;
	private var _colorsButton					: Button;
	
	
	private var _spLabelViews					: Sprite;
	private var _originalView					: SelectionButton;
	private var _previewView					: SelectionButton;
	private var _atlasView						: SelectionButton;
	
	
	private var _atlasStockage					: AtlasStorageSkAxe;
	
	

	
	
	public function new( atlasDisplayer: IPBDisplayer ) : Void
	{
		super();
		_displayer = atlasDisplayer;
		this.graphics.lineStyle(1, 1, 1);
		this.graphics.beginFill(0xcccccc);
		this.graphics.drawRect(0, 0, WIDTH, AppMain.STAGE.stageHeight );
	
		
		this.filters = [ new GlowFilter(0, 0.5, 10, 10, 2, 1) ];
		_loadButton = new Button("Load SWF", LOAD, clickButton);
		addChild( _loadButton );
		_loadButton.x = 10;
		_loadButton.y = 20;
		
		_resetButton = new Button("Clear", CLEAR, clickButton );
		addChild( _resetButton );
		_resetButton.x = 10;
		_resetButton.y = 60;
		
		
		_playButton = new Button("Play", PLAY, clickButton);
		addChild( _playButton );
		_playButton.x = 10;
		_playButton.y = 100;
		_playButton.visible = false;
		
		_pauseButton = new Button("Pause", PAUSE, clickButton);
		addChild( _pauseButton );
		_pauseButton.x = 10;
		_pauseButton.y = _playButton.y;
		
		_speedDisplayer = new SpeedDisplayer();
		addChild( _speedDisplayer );
		_speedDisplayer.y = 140;
		
		_colorsButton = new Button("Back Color >", COLOR, clickButton);
		addChild( _colorsButton );
		_colorsButton.x = 10;
		_colorsButton.y = 180;
		
		
		_saveButton = new Button("\n       EXPORT        \n     ANIMATION\n       (ATLAS)\n  ", SAVE, clickButton, 0x550000, 0xff0000);
		addChild( _saveButton );
		_saveButton.x = 7;
		_saveButton.y = 600;
		
		
		_savePngsButton = new Button("\n       EXPORT        \n     ANIMATION\n        (PNGs)\n  ", SAVE_PNGS, clickButton, 0x005500, 0x00ff00);
		addChild( _savePngsButton );
		_savePngsButton.x = 7;
		_savePngsButton.y = 720;
		
		
		_spLabelViews = new Sprite();
		_spLabelViews.graphics.lineStyle(1, 1, 1);
		_spLabelViews.graphics.moveTo(0, 30);
		_spLabelViews.graphics.lineTo(WIDTH, 30);
		addChild( _spLabelViews );
		var txt: TextField = createTextField("VIEWS");
		txt.x = (WIDTH - txt.width) / 2;
		_spLabelViews.addChild( txt );
		
		_spLabelViews.y = 350;
		
		_originalView = new SelectionButton( "Original >>", SWF_VIEW, clickButton );
		addChild( _originalView );
		_originalView.x = 10;
		_originalView.y = 465;
		
		_previewView = new SelectionButton( "Preview >>", PREVIEW_VIEW, clickButton );
		addChild( _previewView );
		_previewView.x = _originalView.x ;
		_previewView.y = _originalView.y - 30;
		
		_atlasView = new SelectionButton( "Atlas >>", ATLAS_VIEW, clickButton );
		addChild( _atlasView );
		_atlasView.x = _previewView.x ;
		_atlasView.y = _previewView.y-30;
		
		
		
	
		reset();
	}
	
	//-------------------------------------------------------------
	public function resize() : Void
	{
		this.graphics.clear();
		this.graphics.lineStyle(1, 1, 1);
		this.graphics.beginFill(0xcccccc);
		this.graphics.drawRect(0, 0, WIDTH, AppMain.STAGE.stageHeight );
	}
	//-------------------------------------------------------------
	private function createTextField( text: String ) : TextField
	{
		var _format : TextFormat = new TextFormat();
		_format.align = TextFormatAlign.LEFT;
		_format.font = "Arial Black";
		_format.size = 20;
		_format.color = 0x333333;
		
		var _textField : TextField = new TextField();
		_textField.defaultTextFormat =  _format ;
		_textField.autoSize = TextFieldAutoSize.LEFT;
		_textField.selectable = false;
		_textField.htmlText = text.toUpperCase();
		
		_textField.multiline = false;
		
		
		_textField.embedFonts = true;
		return _textField;
	}
	
	//---------------------------------------------------------------
	private function clickButton( buttonName: String ) : Void
	{
		switch( buttonName )
		{
			case LOAD:		selectFolderToLoad();
			case CLEAR:		clearAll();
			case SAVE:		export( true );
			case SAVE_PNGS: export( false );
			case PLAY:		_displayer.play();
							_playButton.visible = false;
							_pauseButton.visible = true;
			case PAUSE:		_displayer.pause();
							_playButton.visible = true;
							_pauseButton.visible = false;
			case COLOR: 	_displayer.changeBackColor();
			
			case SWF_VIEW:	swfViewClicked();
							
			case PREVIEW_VIEW:
							previewViewClicked() ;
							
			case ATLAS_VIEW: 
							atlasViewClicked();
				
							
				
		}
	}
	//---------------------------------------------------------------------------
	private function clearAll() : Void
	{
		_displayer.clear(); reset();
	}
	//---------------------------------------------------------------------------
	private function swfViewClicked() : Void
	{
		_originalView.selected = true;
		_previewView.selected = false;
		_atlasView.selected = false;
		_displayer.showSwfView();
	}
	//---------------------------------------------------------------------------
	private function previewViewClicked() : Void
	{
		_originalView.selected = false;
		_previewView.selected = true;
		_atlasView.selected = false;
		_displayer.showPreviewView();
	}
	
	//---------------------------------------------------------------------------
	private function atlasViewClicked() : Void
	{
		_originalView.selected = false;
		_previewView.selected = false;
		_atlasView.selected = true;
		_displayer.showAtlasView();
	}
	
	
	//---------------------------------------------------------------------------
	//On choisi un swf à partir d'un dossier 
	private function selectFolderToLoad() : Void
	{
		_file = new File();
		var appPath:File = File.applicationDirectory.resolvePath("");
		var fromUserPath:File = File.userDirectory.resolvePath(appPath.nativePath);
		_file.browse();
		_file.addEventListener( Event.SELECT, onFolderSelected );
		
	}
	//---------------------------------------------------------------------------
	//On vient de choisir l'url du fichier à charger 
	private function onFolderSelected( e: Event) : Void
	{
		loadSwf(cast(e.currentTarget, File).nativePath);
		_file.removeEventListener( Event.SELECT, onFolderSelected );
		_file = null;
		
	}
	//---------------------------------------------------------------------------
	private function reset() : Void
	{
		 _atlasconverter = null;
		_spLabelViews.visible =_atlasView.visible = _originalView.visible = _previewView.visible = _colorsButton.visible =  _speedDisplayer.visible = _pauseButton.visible = _playButton.visible = _resetButton.visible =  _savePngsButton.visible = _saveButton.visible = false;
	}
	
	//---------------------------------------------------------------------------
	private function sceneFull(): Void
	{
		_spLabelViews.visible = _atlasView.visible = _originalView.visible = _previewView.visible = _colorsButton.visible = _speedDisplayer.visible = _pauseButton.visible = _resetButton.visible =  _savePngsButton.visible = _saveButton.visible = true;
		_playButton.visible = false;
	}
	//---------------------------------------------------------------------------
	private function loadSwf( urlSwf: String ) : Void
	{
		LoaderApp.instance.visible = true;
		
		var url = new flash.net.URLRequest( urlSwf );
		_loader = new Loader();
		_loader.contentLoaderInfo.addEventListener( flash.events.Event.COMPLETE, parseSwf ) ;
		_loader.load( url ) ;
	}
	
	
	
	//---------------------------------------------------------------------------
	private function parseSwf(ev: flash.events.Event ) : Void
	{
		clearAll();
		
		_allDefinitions = _loader.contentLoaderInfo.applicationDomain.getQualifiedDefinitionNames();
		for ( i in 0 ... _allDefinitions.length )
			_allDefinitions[i] = StringTools.replace( 	_allDefinitions[i], "::", ".");
			
		_atlasconverter = new AtlasGenerator( _loader.contentLoaderInfo.applicationDomain, _allDefinitions);
		addChild( _atlasconverter );
		_atlasconverter.create();
		
		_atlasStockage = new AtlasStorageSkAxe( atlasLoaded );
		_atlasStockage.addAtlas( Xml.parse( _atlasconverter.createXml( true ) ), new Bitmap(_atlasconverter.getBitmapData()));
	
		
	}
	
	//---------------------------------------------------------------------------
	//L'atlas à été créé. On l'affiche
	private function atlasLoaded(  ) : Void
	{
		LoaderApp.instance.visible = false;
		
		var animations: Array<MovieClip> = _atlasStockage.getMovieClips();
		_displayer.showAnimation( animations.copy() );
		
		
		_displayer.showAtlas( new Bitmap (_atlasconverter.getBitmapData() ));
		
		sceneFull();
		previewViewClicked() ;
		
		var swfAnimations: Array<flash.display.MovieClip> = new Array();
		for ( i in 0 ... _allDefinitions.length )
		{
			var movie: flash.display.MovieClip = Type.createInstance( _loader.contentLoaderInfo.applicationDomain.getDefinition( _allDefinitions[i] ), [] );
			movie.name = _allDefinitions[i];
			swfAnimations.push( movie );	
		}
		_displayer.showSwfAnimations(swfAnimations );	
		
		
	}
	//---------------------------------------------------------------------------
	//Création d'un zip avec l'image et le xml
	private function export( modeAtlas: Bool ) : Void
	{ 
		LoaderApp.instance.visible = true;
		
		var zipExporter: ZipExporter = new ZipExporter();
		var byte2: ByteArray = new XmlExporter( ).generateByteArray( _atlasconverter.createXml( modeAtlas ) );
		
		if ( modeAtlas )
		{
			var byte1: ByteArray = new PNGExporter( ).generateByteArray(  _atlasconverter.getBitmapData() );	
			zipExporter.convert( [byte1], byte2,modeAtlas );
		}
		else
		{
			var bytePng: Array<ByteArray> = new Array();
			
			var pngsData: Array<Dynamic> = _atlasconverter.getPngs();
			
			for(  pngs in pngsData )
				bytePng.push( new PNGExporter( ).generateByteArray(  pngs.bmpData ) );	
			
			
			zipExporter.convert( bytePng, byte2, modeAtlas );
		}
		
		
		
		
	}
}