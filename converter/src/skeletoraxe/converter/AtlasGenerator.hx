package skeletoraxe.converter;

import air.update.ApplicationUpdater;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import flash.display.PNGCompressOptions;
import flash.display.PNGEncoderOptions;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.display.IGraphicsData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.Graphics;
import flash.display.GraphicsPathCommand;
import flash.utils.ByteArray;
import flash.Vector;
import flash.utils.Object;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.system.ApplicationDomain;
import skeletoraxe.atlas.AtlasSkAxe;
import skeletoraxe.converter.utils.MaxRectPacker;


/**
 * @autor ispebo
 * C'est classe genere un bitmap ( atlas ) et un fichier xml contenant toutes les données de
 * l'animation
 */
class AtlasGenerator extends Sprite
{
	private var _texturesDatasStock				: Array<TextureData>;
	private var _frames							: Array<Array<TextureFrameConfig>>;
	private var _bmpDataParams					: Array<AtlasConfig>;
	private var _atlasBitmapData				: BitmapData;
	private var _animsDefinition				: Vector<String>;
	private var _aD								: ApplicationDomain;
	private var _animationFrames				: Map <String, Array<Array<TextureFrameConfig>> > ;
	
	public function new( aD: ApplicationDomain, animsDefinition: Vector<String> ) : Void
	{
		super();
		_aD = aD;
		
		_animsDefinition = animsDefinition;
		_texturesDatasStock = new Array();
	}

	//---------------------------------------------------------------------------
	public function create(  ) : Void
	{
		_animationFrames = new Map();
		for ( def in _animsDefinition )
		{
			
			var _animation: flash.display.MovieClip = Type.createInstance( _aD.getDefinition( def ), [] );
			_animation.name = def;
			
			addChild( _animation );
			_animation.stop();
			_frames = new Array();
			_animationFrames.set( def, _frames );
			recursiveGenerator( _animation, -1 );
			_animation.nextFrame();
		
			removeChild( _animation );
		}
		generateAtlas();
	}
	
	
	//---------------------------------------------------------------------------
	private function createBmp( originShape: Shape, b: Bool = true ) : BitmapData
	{
		var bounds: Rectangle = originShape.getBounds( null );
		var bmpData: BitmapData = new BitmapData( Std.int ( bounds.width ), Std.int( bounds.height), b, Std.random(0xff0000));
		var matrix: Matrix = new Matrix();
		matrix.translate( -bounds.left, -bounds.top );
		bmpData.draw( originShape, matrix);
		return bmpData;
	}
	
	//---------------------------------------------------------------------------
	private function recursiveGenerator ( mc: Dynamic, fram: Int ) : Void
	{
		if (mc == null ) throw("is n");
		if ( Std.is ( mc, Shape ) )
		{
			var origShape: Shape = cast(mc, Shape);
			var newMatrix: Matrix = origShape.transform.concatenatedMatrix.clone();
			
			var bounds: Rectangle = origShape.getBounds( null );
			var origin : Point = origShape.localToGlobal( new Point( bounds.left, bounds.top ) );
			newMatrix.tx = origin.x;
			newMatrix.ty = origin.y;
			
			var alphaShape : Float = 1;
			//Gestion de l'alpha
			if ( mc.parent != null )
			{
				var obj: Dynamic = mc;
				while ( Std.is( obj, DisplayObject ) )
				{
					if ( obj.alpha < 1 ) alphaShape *= obj.alpha;
					obj = obj.parent;
				}
			}
			
			var bmpData: BitmapData =  createBmp(  origShape, true );
			
			var idBmpDataComp: Int = compareBitmapsData( bmpData, _texturesDatasStock );
			var bDI: TextureData = null;
			if ( idBmpDataComp == -1 ) //C'est un nouveau
			{
				bDI = {	bmpData: bmpData, id: (_texturesDatasStock.length + 1) };
				_texturesDatasStock.push( bDI );
			}
			else bDI =  getBitmapDataInfosById( idBmpDataComp );
			
			var frameConfig: TextureFrameConfig = {
				textureData: bDI,
				matrix: newMatrix,
				frame: fram,
				alpha: alphaShape
			}
		
			
			
			if ( fram >= _frames.length )  _frames[fram] = new Array();
			_frames[fram].push( frameConfig );
		}
		else 
		{
			if ( Std.is( mc, DisplayObjectContainer ) ) 
			{
				if ( Std.is( mc, flash.display.MovieClip ) )
				{
					
					var movie: flash.display.MovieClip = cast( mc, flash.display.MovieClip );
					movie.cacheAsBitmap = true;
				
					for ( i in 0 ... movie.totalFrames ) 
					{
						movie.gotoAndStop( i + 1 );
						if ( fram == -1 )
						{
							for ( j in 0 ... movie.numChildren )  recursiveGenerator( movie.getChildAt( j ), i );
						}
						else 
						{
							for ( j in 0 ... movie.numChildren ) recursiveGenerator( movie.getChildAt( j ), fram  );
						}
					}
				}
				else
				{
					if ( Std.is( mc, flash.display.MovieClip ) )
					{
						var sp: DisplayObjectContainer = cast( mc, DisplayObjectContainer );
						for ( i in 0 ... sp.numChildren ) recursiveGenerator( sp.getChildAt( i ), fram);	
					}
				}
			}
		}
	}
	
	
	//---------------------------------------------------------------------------
	private function getBitmapDataInfosById( id: Int ) : TextureData
	{
		var bmpDataInfo: TextureData = null;
		var i : Int = 0;
		while ( i < _texturesDatasStock.length && bmpDataInfo == null ) 
		{
			var bDI: TextureData = _texturesDatasStock[i];
			if ( bDI.id == id ) bmpDataInfo = bDI;
			else i++;
		}
		return bmpDataInfo;
	}
	//---------------------------------------------------------------------------
	private function generateAtlas( ) : Void
	{
		_bmpDataParams = new Array();
		
		var maxWidth: Int = 4000;
		var maxHeight: Int = 4000;
		var bitmapList: Array<TextureData> = _texturesDatasStock.copy();
		
		var rect:Rectangle = null;
		while ( rect == null ) 
		{
			var packer:MaxRectPacker = new MaxRectPacker(maxWidth, maxHeight);
		
			var atlasBitmap:BitmapData = new BitmapData( maxWidth, maxHeight, true, 0x0000ff );
			
			var maxWidthReal: Float = 0;
			var maxHeightReal: Float = 0;
			for ( i in 0 ... bitmapList.length )
			{
				var bitmapData : BitmapData = bitmapList[i].bmpData;
				
				rect = packer.quickInsert(bitmapData.width, bitmapData.height);
				if ( rect == null ) 
				{
					maxWidth += 100;
					maxHeight += 100;
					break;
				}
				
				var _w: Float = rect.x + rect.width;
				if ( _w > maxWidthReal ) maxWidthReal = _w;
				var _h: Float = rect.y + rect.height;
				if ( _h > maxHeightReal ) maxHeightReal = _h;
				
				var aC: AtlasConfig = {
					idTexture	: bitmapList[i].id, 
					x: 	rect.x,
					y: rect.y,
					w: Std.int( bitmapData.width ),
					h: Std.int( bitmapData.height ),
				}
				_bmpDataParams.push( aC ) ;
				
				//Draw the single image into the larger atlasBitmap, at the correct X/Y position
				var matrix : Matrix = new Matrix();
				matrix.translate(rect.x, rect.y);
				atlasBitmap.draw( bitmapData, matrix);
			}
			
			_atlasBitmapData = null;
			_atlasBitmapData = new BitmapData( Std.int(maxWidthReal), Std.int(maxHeightReal), true );
			_atlasBitmapData.copyPixels( atlasBitmap, new Rectangle(0, 0, maxWidthReal, maxHeightReal), new Point(0, 0));
			

			
		}
	}

	//---------------------------------------------------------------------------
	private function compareBitmapsData( bmpData: BitmapData, tab: Array<TextureData> ) : Int
	{
		var found: Int = -1;
		var i : Int = 0;
		while ( found == -1 && i < tab.length )
		{
			var obj: Object =  bmpData.compare( tab[ i ].bmpData );
			if ( obj == 0 ) found = tab[ i ].id;
			else i++;
		}
		return found;
	}
	//---------------------------------------------------------------------------
	public var frames( get_frames, null ) : Array<Array<TextureFrameConfig>>;
	private function get_frames() :  Array<Array<TextureFrameConfig>> { return _frames; }
	
	//---------------------------------------------------------------------------
	public function createXml( modeAtlas: Bool ) : String
	{
		var xml: String = "";
		if ( modeAtlas )
		{
			xml= "<atlas id='1'>";
			for ( at in _bmpDataParams ) 
				xml += "<bmp id='" + at.idTexture + "' xy='"+at.x+","+at.y+"' wh='"+at.w+","+at.h+"'/>";
			xml += "</atlas>\n";
		}
		else
		{
			xml= "<pngs n='"+_texturesDatasStock.length+"'/>";
		
			
		}
		
		var iter : Iterator<String> = _animationFrames.keys();
		while ( iter.hasNext() )
		{
			var key : String = iter.next();
			_frames = _animationFrames.get( key );
			xml += "<anim id='" + key + "'>";
			var c: Int = 0;
			for ( frame in _frames )
			{
				c++;
				xml += "<frm id='" + c + "'>";
				if (frame != null )
				{
					for ( frameConfig in frame )
					{
						var m: Matrix = frameConfig.matrix;
						var matrix: String = m.a + "|" + m.b + "|" + m.c + "|" + m.d + "|" + m.tx + "|" + m.ty;
						xml += "<bmp id='"+frameConfig.textureData.id+"' mat='"+matrix+"' alph='"+frameConfig.alpha+"'/>";
					}
					
				}
				else xml += "null";
				xml += "</frm>";
			}
			xml += "</anim>";	
		}
			
		return xml;
	}
	//---------------------------------------------------------------------------
	
	public function getPngs() : Array<Dynamic> 
	{
		var bitmaps: Array<Dynamic> = new Array();
		var bitmapList: Array<TextureData> = _texturesDatasStock.copy();
		for ( i in 0 ... bitmapList.length )
			bitmaps.push( { id: bitmapList[i].id, bmpData: bitmapList[i].bmpData } );
			
		
		return bitmaps;
	}
	//---------------------------------------------------------------------------
	
	public function getBitmapData() : BitmapData { return  _atlasBitmapData.clone();	}
}