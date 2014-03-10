package skeletoraxe.atlas;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.geom.Matrix;

/**
 * @autor ispebo
 */

 
typedef TextureData = {
	var bmpData: BitmapData;
	var id: Int;
}

typedef TextureFrameConfig = {
	var textureData: TextureData;
	var matrix	: Matrix;
	var frame: Int;
}

typedef AtlasConfig = {
	var idTexture	: Int;
	var x			: Float;
	var y			: Float;
	var w			: Int;
	var h			: Int;
}

class AtlasSkAxe
{
	private var _id							: Int;
	private var _atlasBMP					: Bitmap;
	private var _textures					: Map<Int,BitmapData>;
	
	private var _atlasConfig				: Array<AtlasConfig>;
	
	
	public function new( ident: Int, atlasBmp: Bitmap, atlasConfig: Array<AtlasConfig> ) : Void
	{
		_id = ident;
		
		_atlasBMP = atlasBmp;
		_atlasConfig = atlasConfig;
		createTextures( atlasConfig );
		
	}
	//-----------------------------------------------------------
	//On crée 
	private function createTextures( atlasConfig: Array<AtlasConfig>  ) : Void
	{
		_textures = new Map();
		for ( aC in atlasConfig )
		{
			var bmpData: BitmapData = cut( aC.x, aC.y, aC.w, aC.h );
			_textures.set( aC.idTexture, bmpData );
	
		}
	}
	//---------------------------------------------------------------------------
	public var id (get_id, null ) : Int;
	private function get_id( ): Int { return _id; };
	
	//---------------------------------------------------------------------------
	public var atlasBMP (get_atlasBMP, null ) : Bitmap;
	private function get_atlasBMP( ): Bitmap { return _atlasBMP; };
	
	//---------------------------------------------------------------------------
	public var atlasConfig (get_atlasConfig, null ) : Array<AtlasConfig>;
	private function get_atlasConfig( ):  Array<AtlasConfig> { return _atlasConfig.copy(); };
	
	//---------------------------------------------------------------------------
	private function cut( _x: Float, _y: Float, _w: Int, _h: Int ) : BitmapData
	{
		var color =  Math.random() * 0xFFFFFF;
		var bmpData: BitmapData = new BitmapData( _w, _h , true, cast( color));	
		bmpData.copyPixels( _atlasBMP.bitmapData, new Rectangle( _x, _y, _w, _h), new Point(0, 0) );
		return bmpData;
	}
	//---------------------------------------------------------------------------
	public function getTextureById( idTexture: Int ) : BitmapData
	{
		return _textures.get( idTexture );
	}
		//---------------------------------------------------------------------------
	public function destroy() : Void
	{
		_atlasBMP.bitmapData.dispose();
		_atlasBMP = null;
		
		var i : Iterator<Int> = _textures.keys();		
		while( i.hasNext() )
		{
			var texture: BitmapData = _textures.get( i.next() );
			texture.dispose();
			
		}
		_textures = null;
		_atlasConfig = null;
	}
	
}