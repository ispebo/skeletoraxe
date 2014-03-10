package skeletoraxe.atlas;

import flash.display.Bitmap;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.events.Event;
import flash.geom.Matrix;
import flash.Lib;
import flash.net.URLLoader;
import skeletoraxe.atlas.AtlasSkAxe;


/**
 * @autor ispebo
 */
class AtlasStorageSkAxe 
{
	private var _cb								: Void->Void;
	private var _bitmap							: Bitmap;
	private var _xml							: Xml;
	
	private var _originalMovieClipsAtlas		: Map<String, MovieclipSkAxe>;//On stocke tous les movieclips du jeu
	
	public static  var BUFFER					: Int = 50; //Max de movieclips dans la pool
	private var _pool							: Array<MovieclipSkAxe>;
	private var _toLoad							: Int;
	
	public function new( cb:   Void->Void ) : Void
	{
		_cb = cb;
		_originalMovieClipsAtlas = new Map();	
		_pool = new Array();
		_toLoad = 0;
	}
	
	//-------------------------------------------------------------------
	public function getMovieByName( id: String ) : MovieclipSkAxe 
	{	
		var movie: MovieclipSkAxe = getFromPool( id );
		if ( movie == null )
		{
			
			var originMovie: MovieclipSkAxe = _originalMovieClipsAtlas.get(id); 
			movie = new MovieclipSkAxe( id, originMovie.ipbAtlas, originMovie.framesConfig );
		}
		
		return movie;
	}
	//-------------------------------------------------------------------
	//On vient de supprimer un IPBAtlasMovieclip de la scène
	public function removeChildFromStage( movie: MovieclipSkAxe ) : Void
	{
		movie.playing = false;
		var destroyMovie: Bool = true;
		if ( _pool.length < BUFFER )
		{
			var i : Int = 0;
			var counter: Int = 0;
			while ( i < _pool.length )
			{
				if ( _pool[i].id == movie.id ) counter++;
				i++;
			}
			
			destroyMovie = (counter >= 3);
			if ( ! destroyMovie ) _pool.push( movie );	
			
			
		}
		
		if( destroyMovie )  movie.destroy();
	}
	//-------------------------------------------------------------------
	private function getFromPool( id: String ) : MovieclipSkAxe
	{
		var movie: MovieclipSkAxe = null;
		var i : Int = 0;
		while ( movie == null  && i < _pool.length )
		{
			if ( _pool[i].id == id )
			{
				movie = _pool[i];
				_pool.splice(i, 1);
			}
			i++;
		}
		return movie;
	}
	//-------------------------------------------------------------------
	private function duplicateIPBAtlas( ipbAtlas: AtlasSkAxe ) : AtlasSkAxe
	{
		return new AtlasSkAxe( ipbAtlas.id, ipbAtlas.atlasBMP, ipbAtlas.atlasConfig );
	}
	//-------------------------------------------------------------------
	//Possibilité de le charger dynamiquement
	public function addAtlasByUrl( urlXml: String, urlBmp: String ) 
	{
	trace("ADD: " + urlXml + "<->" + urlBmp);
		loadConfigXml( urlXml );
		loadImage( urlBmp );
	}
	
	
	//-------------------------------------------------------------------
	private function loadImage(  urlBmp: String ) : Void
	{
		var	_loader: Loader = new Loader();
		_loader.contentLoaderInfo.addEventListener( flash.events.Event.COMPLETE, imageLoaded ) ;
		var url = new flash.net.URLRequest( urlBmp );
		_loader.load( url ) ;
	}
	
	//-------------------------------------------------------------------
	private function loadConfigXml( urlXml: String ) : Void
	{
		var url = new flash.net.URLRequest( urlXml );
		var _urlLoader: URLLoader = new URLLoader() ;
		_urlLoader.addEventListener( flash.events.Event.COMPLETE, xmlLoaded ) ;
		_urlLoader.load( url ) ;
	}
	
	//-------------------------------------------------------------------
	private function imageLoaded( e: Event ) : Void
	{
		_bitmap = cast ( e.currentTarget.content, Bitmap );
		parse();
	}
	
	//-------------------------------------------------------------------
	private function xmlLoaded ( e: Event ) : Void
	{
		_xml = Xml.parse( e.currentTarget.data  );
		parse();
	}
	
	//-------------------------------------------------------------------
	public function getMovieClips() : Array<MovieclipSkAxe>
	{
		var movies: Array<MovieclipSkAxe> = new Array();
		var i : Iterator<String> = _originalMovieClipsAtlas.keys();		
		while( i.hasNext() )
		{
			var movie: MovieclipSkAxe = _originalMovieClipsAtlas.get( i.next() );
			movies.push( movie );
		}
		
		return movies;
	
	}
	//-------------------------------------------------------------------
	//Possibilité de lui donner directement les données nécessaires
	public function addAtlas( xml: Xml, bmp: Bitmap ) 
	{
		_xml = xml;
		_bitmap = bmp;
		parse();
	}
	//-------------------------------------------------------------------
	private function parse() : Void
	{		
	
		if ( _xml != null && _bitmap != null ) 
		{
			_toLoad++;
			var ipbAtlas: AtlasSkAxe = null;
		
			
			for (node in _xml.elements() ) 
			{
				
				switch (node.nodeName )
				{
					case "atlas":
						var idAtlas: Int = Std.parseInt( node.get("id") );
						
						var atlasConfig: Array<AtlasConfig> = new Array();
						for ( child in node.elements() )
						{
							var identTexture: Int = Std.parseInt( child.get("id") );
							var xy: Array<String> = child.get("xy").split(",");
							var wh: Array<String> = child.get("wh").split(",");
							
							var aC: AtlasConfig  = {
								idTexture	: identTexture,
								x			: Std.parseFloat( xy[0] ),
								y			: Std.parseFloat( xy[1] ),
								w			: Std.parseInt( wh[0] ),
								h			: Std.parseInt( wh[1] ),
							}
							atlasConfig.push( aC );
							//trace("xy: " + aC);
						}
						
						ipbAtlas = new AtlasSkAxe( idAtlas, _bitmap, atlasConfig);
						
					case "anim":
						
						var framesConfiguration: Array<Array<TextureFrameConfig>> = new Array();	
					
						for ( child in node.elements() )
						{
							var tab: Array<TextureFrameConfig> = new Array();
							framesConfiguration.push( tab);
							for ( gC in child.elements() )
							{
							
								
								var texturData : TextureData = 
								{
									bmpData: null,
									id: Std.parseInt( gC.get("id") )
								}
								
								//Matrix
								var mat: Array<String> = gC.get("mat").split("|");
								var newMatrix: Matrix = new Matrix();
								newMatrix.a = Std.parseFloat( mat[0] );
								newMatrix.b = Std.parseFloat( mat[1] );
								newMatrix.c = Std.parseFloat( mat[2] );
								newMatrix.d = Std.parseFloat( mat[3] );
								newMatrix.tx = Std.parseFloat( mat[4] );
								newMatrix.ty = Std.parseFloat( mat[5] );
								
								
								
								var frameConfig:  TextureFrameConfig = {
									textureData: texturData,
									matrix	: newMatrix,
									frame: Std.parseInt( child.get("id") )
								
								}
							
								tab.push( frameConfig );
							}
						}
						//trace("=> " + node.get("id"));
						_originalMovieClipsAtlas.set( node.get("id"), new MovieclipSkAxe(  node.get("id"), ipbAtlas, framesConfiguration) );
				}
				
			}
			
			_toLoad--;
			if ( _toLoad == 0 ) _cb(  );
			
		}
	}
	
	//-------------------------------------------------------------
	
	public function destroy() : Void
	{
		_xml = null;
		
		var i : Iterator<String> = _originalMovieClipsAtlas.keys();		
		while( i.hasNext() )
		{
			var movie: MovieclipSkAxe = _originalMovieClipsAtlas.get( i.next() );
			movie.destroy(  );
		}
	
		_bitmap.bitmapData.dispose();
		_bitmap = null;
		_originalMovieClipsAtlas = null;
	}
	
}