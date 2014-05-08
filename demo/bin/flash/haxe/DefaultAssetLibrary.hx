package;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.text.Font;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import haxe.Unserializer;
import openfl.Assets;

#if (flash || js)
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLLoader;
#end

#if ios
import openfl.utils.SystemPath;
#end


class DefaultAssetLibrary extends AssetLibrary {
	
	
	public static var className (default, null) = new Map <String, Dynamic> ();
	public static var path (default, null) = new Map <String, String> ();
	public static var type (default, null) = new Map <String, AssetType> ();
	
	
	public function new () {
		
		super ();
		
		#if flash
		
		className.set ("gfx/crocoPNG__1.png", __ASSET__gfx_crocopng__1_png);
		type.set ("gfx/crocoPNG__1.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__10.png", __ASSET__gfx_crocopng__10_png);
		type.set ("gfx/crocoPNG__10.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__11.png", __ASSET__gfx_crocopng__11_png);
		type.set ("gfx/crocoPNG__11.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__12.png", __ASSET__gfx_crocopng__12_png);
		type.set ("gfx/crocoPNG__12.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__13.png", __ASSET__gfx_crocopng__13_png);
		type.set ("gfx/crocoPNG__13.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__14.png", __ASSET__gfx_crocopng__14_png);
		type.set ("gfx/crocoPNG__14.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__15.png", __ASSET__gfx_crocopng__15_png);
		type.set ("gfx/crocoPNG__15.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__16.png", __ASSET__gfx_crocopng__16_png);
		type.set ("gfx/crocoPNG__16.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__17.png", __ASSET__gfx_crocopng__17_png);
		type.set ("gfx/crocoPNG__17.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__18.png", __ASSET__gfx_crocopng__18_png);
		type.set ("gfx/crocoPNG__18.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__19.png", __ASSET__gfx_crocopng__19_png);
		type.set ("gfx/crocoPNG__19.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__2.png", __ASSET__gfx_crocopng__2_png);
		type.set ("gfx/crocoPNG__2.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__20.png", __ASSET__gfx_crocopng__20_png);
		type.set ("gfx/crocoPNG__20.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__3.png", __ASSET__gfx_crocopng__3_png);
		type.set ("gfx/crocoPNG__3.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__4.png", __ASSET__gfx_crocopng__4_png);
		type.set ("gfx/crocoPNG__4.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__5.png", __ASSET__gfx_crocopng__5_png);
		type.set ("gfx/crocoPNG__5.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__6.png", __ASSET__gfx_crocopng__6_png);
		type.set ("gfx/crocoPNG__6.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__7.png", __ASSET__gfx_crocopng__7_png);
		type.set ("gfx/crocoPNG__7.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__8.png", __ASSET__gfx_crocopng__8_png);
		type.set ("gfx/crocoPNG__8.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/crocoPNG__9.png", __ASSET__gfx_crocopng__9_png);
		type.set ("gfx/crocoPNG__9.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("xmls/crocoPNG.xml", __ASSET__xmls_crocopng_xml);
		type.set ("xmls/crocoPNG.xml", Reflect.field (AssetType, "text".toUpperCase ()));
		
		
		#elseif html5
		
		path.set ("gfx/crocoPNG__1.png", "gfx/crocoPNG__1.png");
		type.set ("gfx/crocoPNG__1.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__10.png", "gfx/crocoPNG__10.png");
		type.set ("gfx/crocoPNG__10.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__11.png", "gfx/crocoPNG__11.png");
		type.set ("gfx/crocoPNG__11.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__12.png", "gfx/crocoPNG__12.png");
		type.set ("gfx/crocoPNG__12.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__13.png", "gfx/crocoPNG__13.png");
		type.set ("gfx/crocoPNG__13.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__14.png", "gfx/crocoPNG__14.png");
		type.set ("gfx/crocoPNG__14.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__15.png", "gfx/crocoPNG__15.png");
		type.set ("gfx/crocoPNG__15.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__16.png", "gfx/crocoPNG__16.png");
		type.set ("gfx/crocoPNG__16.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__17.png", "gfx/crocoPNG__17.png");
		type.set ("gfx/crocoPNG__17.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__18.png", "gfx/crocoPNG__18.png");
		type.set ("gfx/crocoPNG__18.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__19.png", "gfx/crocoPNG__19.png");
		type.set ("gfx/crocoPNG__19.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__2.png", "gfx/crocoPNG__2.png");
		type.set ("gfx/crocoPNG__2.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__20.png", "gfx/crocoPNG__20.png");
		type.set ("gfx/crocoPNG__20.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__3.png", "gfx/crocoPNG__3.png");
		type.set ("gfx/crocoPNG__3.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__4.png", "gfx/crocoPNG__4.png");
		type.set ("gfx/crocoPNG__4.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__5.png", "gfx/crocoPNG__5.png");
		type.set ("gfx/crocoPNG__5.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__6.png", "gfx/crocoPNG__6.png");
		type.set ("gfx/crocoPNG__6.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__7.png", "gfx/crocoPNG__7.png");
		type.set ("gfx/crocoPNG__7.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__8.png", "gfx/crocoPNG__8.png");
		type.set ("gfx/crocoPNG__8.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/crocoPNG__9.png", "gfx/crocoPNG__9.png");
		type.set ("gfx/crocoPNG__9.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("xmls/crocoPNG.xml", "xmls/crocoPNG.xml");
		type.set ("xmls/crocoPNG.xml", Reflect.field (AssetType, "text".toUpperCase ()));
		
		
		#else
		
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
						
						var manifest:Array<AssetData> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							path.set (asset.id, asset.path);
							type.set (asset.id, asset.type);
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest");
				
			}
			
		} catch (e:Dynamic) {
			
			trace ("Warning: Could not load asset manifest");
			
		}
		
		#end
		
	}
	
	
	public override function exists (id:String, type:AssetType):Bool {
		
		var assetType = DefaultAssetLibrary.type.get (id);
		
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
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), BitmapData);
		
		#elseif js
		
		return cast (ApplicationMain.loaders.get (path.get (id)).contentLoaderInfo.content, Bitmap).bitmapData;
		
		#else
		
		return BitmapData.load (path.get (id));
		
		#end
		
	}
	
	
	public override function getBytes (id:String):ByteArray {
		
		#if pixi
		
		return null;
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), ByteArray);
		
		#elseif js
		
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
		
		return ByteArray.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Font {
		
		#if pixi
		
		return null;
		
		#elseif (flash || js)
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
		#else
		
		return new Font (path.get (id));
		
		#end
		
	}
	
	
	public override function getMusic (id:String):Sound {
		
		#if pixi
		
		//return null;		
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return new Sound (new URLRequest (path.get (id)), null, true);
		
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
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return new Sound (new URLRequest (path.get (id)), null, type.get (id) == MUSIC);
		
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
	
	
}


#if pixi
#elseif flash

class __ASSET__gfx_crocopng__1_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__10_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__11_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__12_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__13_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__14_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__15_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__16_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__17_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__18_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__19_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__2_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__20_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__3_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__4_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__5_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__6_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__7_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__8_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_crocopng__9_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__xmls_crocopng_xml extends flash.utils.ByteArray { }


#elseif html5
























#end