package com.standard.log.alcon;

import flash.display.Stage;
import flash.events.Event;
import flash.events.StatusEvent;
import flash.net.LocalConnection;
import flash.net.SharedObject;
import flash.net.SharedObjectFlushStatus;
import flash.system.Capabilities;
import flash.system.Security;
import flash.system.SecurityPanel;
import flash.system.System;
import flash.utils.ByteArray;
import flash.xml.XML;	
import haxe.PosInfos;
	
class Debug
{
	public static inline var LEVEL_DEBUG	:Int	= 0;
	public static inline var LEVEL_INFO		:Int	= 1;
	public static inline var LEVEL_WARN		:Int	= 2;
	public static inline var LEVEL_ERROR	:Int	= 3;
	public static inline var LEVEL_FATAL	:Int	= 4;


	////////////////////////////////////////////////////////////////////////////////////////
	// Variables                                                                          //
	////////////////////////////////////////////////////////////////////////////////////////

	
	public static var filterLevel(get_filterLevel,set_filterLevel)	:Int;
	public static var enabled(get_enabled,set_enabled)				:Bool;
	
	private static var _filterLevel			:Int	= 0;
	private static var _isConnected			:Bool	= false;
	private static var _isPollingFPS		:Bool	= false;
	private static var _isEnabled			:Bool	= true;

	private static var _stage				:Stage;
	private static var _connection			:LocalConnection;
	private static var _fpsMeter			:FPSMeter;
	private static var _stopWatch			:StopWatch;


	
	public static function redirectTrace() {
		haxe.Log.trace = function(data:Dynamic, ?inf:PosInfos) { 
			var content = inf.fileName + ':' + inf.lineNumber + ' => ' + data;
			var lvl = Debug.LEVEL_DEBUG;
			
			
			if (inf.customParams != null) {
				switch(inf.customParams[0]) {
					
					case "warning" :
						lvl = Debug.LEVEL_WARN;
					
					case "error" :
						lvl = Debug.LEVEL_ERROR;
						
					case "fatal":
						lvl = Debug.LEVEL_FATAL;
						
					case "member":
						content = inf.className + '::' + inf.methodName + ' => ' + data;
						
				}
				
			}
			Debug.trace(content, lvl);
			
		
		};
	}
	
	
	public static function trace(data:Dynamic,?level:Int):Void{
		var l:Int = (level != null) ? level : 1;
		if (l >= _filterLevel && l < 7){
			send("onData", data, l, 0);
		}
	}


	public static function traceObj(obj:Dynamic, depth:Int = 64, level:Int = 1):Void{
		if (level >= _filterLevel && level < 7)	{
			send("onData", obj, level, depth);
		}
	}


	public static function inspect(obj:Dynamic):Void{
		send("onInspect", obj, 1, -1);
	}


	public static function hexDump(obj:Dynamic):Void{
		send("onHexDump", obj, 0, 0);
	}


	public static function forceGC():Void{
		try
		{
			/* Disabled for now! */
			//System.gc();
		}
		catch (e1:Dynamic)
		{
			try
			{
				new LocalConnection().connect("forceGC");
				new LocalConnection().connect("forceGC");
			}
			catch (e2:Dynamic)
			{
			}
		}
	}

	public static function clear():Void{
		Debug.trace("[%CLR%]", 5);
	}


	public static function delimiter():Void{
		Debug.trace("[%DLT%]", 5);
	}


	public static function pause():Void{
		Debug.trace("[%PSE%]", 5);
	}


	public static function time():Void{
		Debug.trace("[%TME%]", 5);
	}


	public static function createCategory(id:Int, name:String = "",	textColor:UInt = 0x000000, bgColor:UInt = 0xFFFF00):Void{
		send("onCategory", [id, name, textColor, bgColor], 0, 0);
	}


	public static function monitor(stage:Stage, pollInterval:Int = 500):Void
	{
		if (_isPollingFPS) Debug.stop();
		
		if (_isEnabled && _fpsMeter == null)
		{
			_isPollingFPS = true;
			_stage = stage;
			//sendCapabilities();
			_fpsMeter = new FPSMeter(_stage, pollInterval);
			_fpsMeter.addEventListener(FPSMeter.FPS_UPDATE, onFPSUpdate);
			_fpsMeter.start();
		}
	}


	public static function mark(color:UInt = 0xFF00FF):Void{
		send("onMarker", color, 1, -1);
	}


	public static function stop():Void{
		if (_fpsMeter!= null)
		{
			_isPollingFPS = false;
			_fpsMeter.stop();
			_fpsMeter.removeEventListener(FPSMeter.FPS_UPDATE, onFPSUpdate);
			_fpsMeter = null;
			_stage = null;
		}
	}



	public static function timerStart(title:String = ""):Void{
		if (_isEnabled)
		{
			if (_stopWatch == null) _stopWatch = new StopWatch();
			_stopWatch.start(title);
		}
	}


	public static function timerStop():Void
	{
		if (_stopWatch != null) _stopWatch.stop();
	}


	public static function timerReset():Void
	{
		if (_stopWatch != null) _stopWatch.reset();
	}


	public static function timerInMilliSeconds():Void
	{
		if (_stopWatch != null) Debug.trace(_stopWatch.timeInMilliSeconds + "ms");
	}


	public static function timerInSeconds():Void
	{
		if (_stopWatch != null) Debug.trace(_stopWatch.timeInSeconds + "s");
	}


	public static function timerToString():Void
	{
		if (_stopWatch != null) Debug.trace(_stopWatch.toString());
	}


	public static function timerStopToString(reset:Bool = false):Void
	{
		if (_stopWatch != null)
		{
			_stopWatch.stop();
			Debug.trace(_stopWatch.toString());
			if (reset) _stopWatch.reset();
		}
	}


	////////////////////////////////////////////////////////////////////////////////////////
	// Getters & Setters                                                                  //
	////////////////////////////////////////////////////////////////////////////////////////

	public static function get_filterLevel():Int
	{
		return _filterLevel;
	}
	public static function set_filterLevel(v:Int):Int
	{
		if (v >= 0 && v < 5) _filterLevel = v;
		return _filterLevel;
	}


	public static function get_enabled():Bool
	{
		return _isEnabled;
	}
	public static function set_enabled(v:Bool):Bool
	{
		_isEnabled = v;
		return _isEnabled;
	}


	////////////////////////////////////////////////////////////////////////////////////////
	// Event Handlers                                                                     //
	////////////////////////////////////////////////////////////////////////////////////////

	private static function onFPSUpdate(e:Event):Void
	{
		send("onFPS", (_fpsMeter.fps + ","
			+ _stage.frameRate + ","
			+ _fpsMeter.frt + ","
			+ System.totalMemory));
	}


	private static function onStatus(e:StatusEvent):Void
	{
	}


	////////////////////////////////////////////////////////////////////////////////////////
	// Private Methods                                                                    //
	////////////////////////////////////////////////////////////////////////////////////////

	private static function send(m:String, d:Dynamic, l:Int = 1, r:Int = 0):Void
	{
		/* Only send if Debug is not disabled */
		if (_isEnabled)
		{
			/* Establish connection if not already done */
			if (!_isConnected)
			{
				_isConnected = true;
				_connection = new LocalConnection();
				_connection.addEventListener(StatusEvent.STATUS, onStatus);
			}
			
			/* Get the size of the data */
			var s = 0;
			if (Std.is(d,String)){
				s = cast(d,String).length;
			} else if (Std.is(d,Dynamic)) {
				var byteArray:ByteArray = new ByteArray();
				byteArray.writeObject(d);
				s = byteArray.length;
				byteArray = null;
			}
			
			/* If the data size exceeds 39Kb, use a LSO instead */
			if (s > 39000)
			{
				storeDataLSO(m, d);
				m = "onLargeData";
				d = null;
			}
			
			_connection.send("_alcon_lc", m, d, l, r, "");
		}
	}

/*
	private static function sendCapabilities():Void
	{
		var xml = new XML(Capabilities);
		var a:Array<Dynamic> = [];
		
		for(node in xml.*)
		{
			var n = node.@name.toString();
			if (n.length > 0 && n != "_internal" && n != "prototype")
			{
				a.push({p: n, v: Capabilities[n].toString()});
			}
		}
		
		//a.sortOn (["p"], Array.CASEINSENSITIVE);
		send("onCap", a);
	}
*/

	/**
	 * Stores data larger than 40Kb to a Local Shared Object.
	 * 
	 * @private
	 */
	private static function storeDataLSO(m:String, d:Dynamic):Void
	{
		var sharedObject = SharedObject.getLocal("alcon", "/");
		sharedObject.data.alconMethod = m;
		sharedObject.data.alconData = d;
		try
		{
			var flushResult = cast sharedObject.flush();
			if (flushResult == SharedObjectFlushStatus.FLUSHED)
			{
				return;
			}
		}
		catch (e:Dynamic)
		{
			Security.showSettings(SecurityPanel.LOCAL_STORAGE);
		}
	}
}

