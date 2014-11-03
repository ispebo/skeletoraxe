package;


import haxe.Timer;
import haxe.Unserializer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.text.Font;
import openfl.media.Sound;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;
import openfl.Assets;

#if (flash || js)
import openfl.display.Loader;
import openfl.events.Event;
import openfl.net.URLLoader;
#end

#if sys
import sys.FileSystem;
#end

#if ios
import openfl.utils.SystemPath;
#end


@:access(openfl.media.Sound)
class DefaultAssetLibrary extends AssetLibrary {
	
	
	public var className (default, null) = new Map <String, Dynamic> ();
	public var path (default, null) = new Map <String, String> ();
	public var type (default, null) = new Map <String, AssetType> ();
	
	private var lastModified:Float;
	private var timer:Timer;
	
	
	public function new () {
		
		super ();
		
		#if flash
		
		className.set ("gfx/CrocoAtlas.png", __ASSET__gfx_crocoatlas_png);
		type.set ("gfx/CrocoAtlas.png", AssetType.IMAGE);
		className.set ("xmls/CrocoAtlas.xml", __ASSET__xmls_crocoatlas_xml);
		type.set ("xmls/CrocoAtlas.xml", AssetType.TEXT);
		className.set ("gfx/CrocoPNGS__1.png", __ASSET__gfx_crocopngs__1_png);
		type.set ("gfx/CrocoPNGS__1.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__10.png", __ASSET__gfx_crocopngs__10_png);
		type.set ("gfx/CrocoPNGS__10.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__11.png", __ASSET__gfx_crocopngs__11_png);
		type.set ("gfx/CrocoPNGS__11.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__12.png", __ASSET__gfx_crocopngs__12_png);
		type.set ("gfx/CrocoPNGS__12.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__13.png", __ASSET__gfx_crocopngs__13_png);
		type.set ("gfx/CrocoPNGS__13.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__14.png", __ASSET__gfx_crocopngs__14_png);
		type.set ("gfx/CrocoPNGS__14.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__15.png", __ASSET__gfx_crocopngs__15_png);
		type.set ("gfx/CrocoPNGS__15.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__16.png", __ASSET__gfx_crocopngs__16_png);
		type.set ("gfx/CrocoPNGS__16.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__17.png", __ASSET__gfx_crocopngs__17_png);
		type.set ("gfx/CrocoPNGS__17.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__18.png", __ASSET__gfx_crocopngs__18_png);
		type.set ("gfx/CrocoPNGS__18.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__19.png", __ASSET__gfx_crocopngs__19_png);
		type.set ("gfx/CrocoPNGS__19.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__2.png", __ASSET__gfx_crocopngs__2_png);
		type.set ("gfx/CrocoPNGS__2.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__20.png", __ASSET__gfx_crocopngs__20_png);
		type.set ("gfx/CrocoPNGS__20.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__3.png", __ASSET__gfx_crocopngs__3_png);
		type.set ("gfx/CrocoPNGS__3.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__4.png", __ASSET__gfx_crocopngs__4_png);
		type.set ("gfx/CrocoPNGS__4.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__5.png", __ASSET__gfx_crocopngs__5_png);
		type.set ("gfx/CrocoPNGS__5.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__6.png", __ASSET__gfx_crocopngs__6_png);
		type.set ("gfx/CrocoPNGS__6.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__7.png", __ASSET__gfx_crocopngs__7_png);
		type.set ("gfx/CrocoPNGS__7.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__8.png", __ASSET__gfx_crocopngs__8_png);
		type.set ("gfx/CrocoPNGS__8.png", AssetType.IMAGE);
		className.set ("gfx/CrocoPNGS__9.png", __ASSET__gfx_crocopngs__9_png);
		type.set ("gfx/CrocoPNGS__9.png", AssetType.IMAGE);
		className.set ("xmls/CrocoPNGS.xml", __ASSET__xmls_crocopngs_xml);
		type.set ("xmls/CrocoPNGS.xml", AssetType.TEXT);
		
		
		#elseif html5
		
		var id;
		id = "gfx/CrocoAtlas.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "xmls/CrocoAtlas.xml";
		path.set (id, id);
		type.set (id, AssetType.TEXT);
		id = "gfx/CrocoPNGS__1.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__10.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__11.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__12.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__13.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__14.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__15.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__16.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__17.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__18.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__19.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__2.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__20.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__3.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__4.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__5.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__6.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__7.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__8.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "gfx/CrocoPNGS__9.png";
		path.set (id, id);
		type.set (id, AssetType.IMAGE);
		id = "xmls/CrocoPNGS.xml";
		path.set (id, id);
		type.set (id, AssetType.TEXT);
		
		
		#else
		
		#if (windows || mac || linux)
		
		var useManifest = false;
		
		className.set ("gfx/CrocoAtlas.png", __ASSET__gfx_crocoatlas_png);
		type.set ("gfx/CrocoAtlas.png", AssetType.IMAGE);
		
		className.set ("xmls/CrocoAtlas.xml", __ASSET__xmls_crocoatlas_xml);
		type.set ("xmls/CrocoAtlas.xml", AssetType.TEXT);
		
		className.set ("gfx/CrocoPNGS__1.png", __ASSET__gfx_crocopngs__1_png);
		type.set ("gfx/CrocoPNGS__1.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__10.png", __ASSET__gfx_crocopngs__10_png);
		type.set ("gfx/CrocoPNGS__10.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__11.png", __ASSET__gfx_crocopngs__11_png);
		type.set ("gfx/CrocoPNGS__11.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__12.png", __ASSET__gfx_crocopngs__12_png);
		type.set ("gfx/CrocoPNGS__12.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__13.png", __ASSET__gfx_crocopngs__13_png);
		type.set ("gfx/CrocoPNGS__13.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__14.png", __ASSET__gfx_crocopngs__14_png);
		type.set ("gfx/CrocoPNGS__14.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__15.png", __ASSET__gfx_crocopngs__15_png);
		type.set ("gfx/CrocoPNGS__15.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__16.png", __ASSET__gfx_crocopngs__16_png);
		type.set ("gfx/CrocoPNGS__16.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__17.png", __ASSET__gfx_crocopngs__17_png);
		type.set ("gfx/CrocoPNGS__17.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__18.png", __ASSET__gfx_crocopngs__18_png);
		type.set ("gfx/CrocoPNGS__18.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__19.png", __ASSET__gfx_crocopngs__19_png);
		type.set ("gfx/CrocoPNGS__19.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__2.png", __ASSET__gfx_crocopngs__2_png);
		type.set ("gfx/CrocoPNGS__2.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__20.png", __ASSET__gfx_crocopngs__20_png);
		type.set ("gfx/CrocoPNGS__20.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__3.png", __ASSET__gfx_crocopngs__3_png);
		type.set ("gfx/CrocoPNGS__3.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__4.png", __ASSET__gfx_crocopngs__4_png);
		type.set ("gfx/CrocoPNGS__4.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__5.png", __ASSET__gfx_crocopngs__5_png);
		type.set ("gfx/CrocoPNGS__5.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__6.png", __ASSET__gfx_crocopngs__6_png);
		type.set ("gfx/CrocoPNGS__6.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__7.png", __ASSET__gfx_crocopngs__7_png);
		type.set ("gfx/CrocoPNGS__7.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__8.png", __ASSET__gfx_crocopngs__8_png);
		type.set ("gfx/CrocoPNGS__8.png", AssetType.IMAGE);
		
		className.set ("gfx/CrocoPNGS__9.png", __ASSET__gfx_crocopngs__9_png);
		type.set ("gfx/CrocoPNGS__9.png", AssetType.IMAGE);
		
		className.set ("xmls/CrocoPNGS.xml", __ASSET__xmls_crocopngs_xml);
		type.set ("xmls/CrocoPNGS.xml", AssetType.TEXT);
		
		
		if (useManifest) {
			
			loadManifest ();
			
			if (Sys.args ().indexOf ("-livereload") > -1) {
				
				var path = FileSystem.fullPath ("manifest");
				lastModified = FileSystem.stat (path).mtime.getTime ();
				
				timer = new Timer (2000);
				timer.run = function () {
					
					var modified = FileSystem.stat (path).mtime.getTime ();
					
					if (modified > lastModified) {
						
						lastModified = modified;
						loadManifest ();
						
						if (eventCallback != null) {
							
							eventCallback (this, "change");
							
						}
						
					}
					
				}
				
			}
			
		}
		
		#else
		
		loadManifest ();
		
		#end
		#end
		
	}
	
	
	public override function exists (id:String, type:AssetType):Bool {
		
		var assetType = this.type.get (id);
		
		#if pixi
		
		if (assetType == IMAGE) {
			
			return true;
			
		} else {
			
			return false;
			
		}
		
		#end
		
		if (assetType != null) {
			
			if (assetType == type || ((type == SOUND || type == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			#if flash
			
			if ((assetType == BINARY || assetType == TEXT) && type == BINARY) {
				
				return true;
				
			} else if (path.exists (id)) {
				
				return true;
				
			}
			
			#else
			
			if (type == BINARY || type == null) {
				
				return true;
				
			}
			
			#end
			
		}
		
		return false;
		
	}
	
	
	public override function getBitmapData (id:String):BitmapData {
		
		#if pixi
		
		return BitmapData.fromImage (path.get (id));
		
		#elseif (flash)
		
		return cast (Type.createInstance (className.get (id), []), BitmapData);
		
		#elseif openfl_html5
		
		return BitmapData.fromImage (ApplicationMain.images.get (path.get (id)));
		
		#elseif js
		
		return cast (ApplicationMain.loaders.get (path.get (id)).contentLoaderInfo.content, Bitmap).bitmapData;
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), BitmapData);
		else return BitmapData.load (path.get (id));
		
		#end
		
	}
	
	
	public override function getBytes (id:String):ByteArray {
		
		#if (flash)
		
		return cast (Type.createInstance (className.get (id), []), ByteArray);

		#elseif (js || openfl_html5 || pixi)
		
		var bytes:ByteArray = null;
		var data = ApplicationMain.urlLoaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			bytes = new ByteArray ();
			bytes.writeUTFBytes (data);
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}

		if (bytes != null) {
			
			bytes.position = 0;
			return bytes;
			
		} else {
			
			return null;
		}
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), ByteArray);
		else return ByteArray.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Font {
		
		#if pixi
		
		return null;
		
		#elseif (flash || js)
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
		#else
		
		if (className.exists(id)) {
			var fontClass = className.get(id);
			Font.registerFont(fontClass);
			return cast (Type.createInstance (fontClass, []), Font);
		} else return new Font (path.get (id));
		
		#end
		
	}
	
	
	public override function getMusic (id:String):Sound {
		
		#if pixi
		
		return null;
		
		#elseif (flash)
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif openfl_html5
		
		var sound = new Sound ();
		sound.__buffer = true;
		sound.load (new URLRequest (path.get (id)));
		return sound; 
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Sound);
		else return new Sound (new URLRequest (path.get (id)), null, true);
		
		#end
		
	}
	
	
	public override function getPath (id:String):String {
		
		#if ios
		
		return SystemPath.applicationDirectory + "/assets/" + path.get (id);
		
		#else
		
		return path.get (id);
		
		#end
		
	}
	
	
	public override function getSound (id:String):Sound {
		
		#if pixi
		
		return null;
		
		#elseif (flash)
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Sound);
		else return new Sound (new URLRequest (path.get (id)), null, type.get (id) == MUSIC);
		
		#end
		
	}
	
	
	public override function getText (id:String):String {
		
		#if js
		
		var bytes:ByteArray = null;
		var data = ApplicationMain.urlLoaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			return cast data;
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}
		
		if (bytes != null) {
			
			bytes.position = 0;
			return bytes.readUTFBytes (bytes.length);
			
		} else {
			
			return null;
		}
		
		#else
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
		#end
		
	}
	
	
	public override function isLocal (id:String, type:AssetType):Bool {
		
		#if flash
		
		if (type != AssetType.MUSIC && type != AssetType.SOUND) {
			
			return className.exists (id);
			
		}
		
		#end
		
		return true;
		
	}
	
	
	public override function list (type:AssetType):Array<String> {
		
		var items = [];
		
		for (id in this.type.keys ()) {
			
			if (type == null || exists (id, type)) {
				
				items.push (id);
				
			}
			
		}
		
		return items;
		
	}
	
	
	public override function loadBitmapData (id:String, handler:BitmapData -> Void):Void {
		
		#if pixi
		
		handler (getBitmapData (id));
		
		#elseif (flash || js)
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBitmapData (id));
			
		}
		
		#else
		
		handler (getBitmapData (id));
		
		#end
		
	}
	
	
	public override function loadBytes (id:String, handler:ByteArray -> Void):Void {
		
		#if pixi
		
		handler (getBytes (id));
		
		#elseif (flash || js)
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bytes = new ByteArray ();
				bytes.writeUTFBytes (event.currentTarget.data);
				bytes.position = 0;
				
				handler (bytes);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBytes (id));
			
		}
		
		#else
		
		handler (getBytes (id));
		
		#end
		
	}
	
	
	public override function loadFont (id:String, handler:Font -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getFont (id));
			
		//}
		
		#else
		
		handler (getFont (id));
		
		#end
		
	}
	
	
	#if (!flash && !html5)
	private function loadManifest ():Void {
		
		try {
			
			#if blackberry
			var bytes = ByteArray.readFile ("app/native/manifest");
			#elseif tizen
			var bytes = ByteArray.readFile ("../res/manifest");
			#elseif emscripten
			var bytes = ByteArray.readFile ("assets/manifest");
			#else
			var bytes = ByteArray.readFile ("manifest");
			#end
			
			if (bytes != null) {
				
				bytes.position = 0;
				
				if (bytes.length > 0) {
					
					var data = bytes.readUTFBytes (bytes.length);
					
					if (data != null && data.length > 0) {
						
						var manifest:Array<Dynamic> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							if (!className.exists (asset.id)) {
								
								path.set (asset.id, asset.path);
								type.set (asset.id, Type.createEnum (AssetType, asset.type));
								
							}
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest (bytes was null)");
				
			}
		
		} catch (e:Dynamic) {
			
			trace ('Warning: Could not load asset manifest (${e})');
			
		}
		
	}
	#end
	
	
	public override function loadMusic (id:String, handler:Sound -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getMusic (id));
			
		//}
		
		#else
		
		handler (getMusic (id));
		
		#end
		
	}
	
	
	public override function loadSound (id:String, handler:Sound -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getSound (id));
			
		//}
		
		#else
		
		handler (getSound (id));
		
		#end
		
	}
	
	
	public override function loadText (id:String, handler:String -> Void):Void {
		
		#if js
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				handler (event.currentTarget.data);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getText (id));
			
		}
		
		#else
		
		var callback = function (bytes:ByteArray):Void {
			
			if (bytes == null) {
				
				handler (null);
				
			} else {
				
				handler (bytes.readUTFBytes (bytes.length));
				
			}
			
		}
		
		loadBytes (id, callback);
		
		#end
		
	}
	
	
}


#if pixi
#elseif flash

@:keep class __ASSET__gfx_crocoatlas_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__xmls_crocoatlas_xml extends openfl.utils.ByteArray { }
@:keep class __ASSET__gfx_crocopngs__1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__10_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__11_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__12_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__13_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__14_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__15_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__16_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__17_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__18_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__19_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__20_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__4_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__5_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__6_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__7_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__8_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__gfx_crocopngs__9_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep class __ASSET__xmls_crocopngs_xml extends openfl.utils.ByteArray { }


#elseif html5


























#elseif (windows || mac || linux)


@:bitmap("lib/assets/anims/CrocoAtlas.png") class __ASSET__gfx_crocoatlas_png extends flash.display.BitmapData {}
@:file("lib/assets/anims/CrocoAtlas.xml") class __ASSET__xmls_crocoatlas_xml extends flash.utils.ByteArray {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__1.png") class __ASSET__gfx_crocopngs__1_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__10.png") class __ASSET__gfx_crocopngs__10_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__11.png") class __ASSET__gfx_crocopngs__11_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__12.png") class __ASSET__gfx_crocopngs__12_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__13.png") class __ASSET__gfx_crocopngs__13_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__14.png") class __ASSET__gfx_crocopngs__14_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__15.png") class __ASSET__gfx_crocopngs__15_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__16.png") class __ASSET__gfx_crocopngs__16_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__17.png") class __ASSET__gfx_crocopngs__17_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__18.png") class __ASSET__gfx_crocopngs__18_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__19.png") class __ASSET__gfx_crocopngs__19_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__2.png") class __ASSET__gfx_crocopngs__2_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__20.png") class __ASSET__gfx_crocopngs__20_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__3.png") class __ASSET__gfx_crocopngs__3_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__4.png") class __ASSET__gfx_crocopngs__4_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__5.png") class __ASSET__gfx_crocopngs__5_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__6.png") class __ASSET__gfx_crocopngs__6_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__7.png") class __ASSET__gfx_crocopngs__7_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__8.png") class __ASSET__gfx_crocopngs__8_png extends flash.display.BitmapData {}
@:bitmap("lib/assets/animsPNG/CrocoPNGS__9.png") class __ASSET__gfx_crocopngs__9_png extends flash.display.BitmapData {}
@:file("lib/assets/animsPNG/CrocoPNGS.xml") class __ASSET__xmls_crocopngs_xml extends flash.utils.ByteArray {}


#end
