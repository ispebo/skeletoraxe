/*
 * Copyright (c) 2005 Pablo Costantini (www.luminicbox.com). All rights reserved.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * All code is original, except version adapted to FlashInspector 0.30
 * Rewrited into haXe by Michel Romecki aka filt3rek
 * 
 */

package com.standard.log;

#if flash9
	import flash.net.LocalConnection;
	import flash.display.MovieClip;
#else
	import flash.LocalConnection;
	import flash.MovieClip;
	import flash.Color;
#end

/*
* This abtract class contains definitions for the message's levels.<br />
* The predefined levels are: ALL, LOG, DEBUG, INFO, WARN, ERROR, FATAL and NONE.
*/
class Level
{
	/* private fields */
	private var _name	: String;
	private var _value	: Int;
	
	/* constructor*/
	private function new ( name : String, value : Int )
	{
		_name = name;
		_value = value;
	}	
	
	/*
	* The ALL level designates the lowest level possible. 
	*/
	public static var ALL:Level = new Level("ALL", 1);
	/*
	* The LOG level designates fine-grained informational events.
	*/
	public static var LOG:Level = new Level("LOG", 1);
	/*
	* The DEBUG level designates fine-grained debug information.
	*/
	public static var DEBUG:Level = new Level("DEBUG", 2);
	/*
	* The INFO level designates informational messages that highlight the progress of the application at coarse-grained level.
	*/
	public static var INFO:Level = new Level("INFO",4);
	/*
	* The WARN level designates potentially harmful situations. 
	*/
	public static var WARN:Level = new Level("WARN",8);
	/*
	* The ERROR level designates error events that might still allow the application to continue running. 
	*/
	public static var ERROR:Level = new Level("ERROR",16);
	/*
	* The FATAL level designates very severe error events that will presumably lead the application to abort or stop. 
	*/
	public static var FATAL:Level = new Level("FATAL",32);
	/*
	* The NONE level when used with setLevel makes all messages to be ignored.
	*/
	public static var NONE:Level = new Level("NONE", 1024);
	
	//public static var INSPECT:Level = new Level("INSPECT", 0);
	
	/*
	* Returns the level's name.
	*/
	public function getName():String { return _name; }
	/*
	* Returns the level's bitwise value.
	*/
	public function getValue():Int { return _value; }
	/*
	* Return the level's name.
	*/
	public function toString():String { return getName(); }
}

/*
* Represents a log message with information about the object to inspect, its level, the originator logger and other information.<br />
* THIS CLASS IS USED INTERNALLY. It should only be used when implementing publishers.
*/
class LogEvent
{
	var time		: Date;
	var loggerId	: String;
	var level		: Level;
	var argument	: Dynamic;
	
	/*
	* Creates a LogEvent instance.
	* @param loggerId The originators logged id. It may be null.
	* @param argument The message or object to log.
	* @param level The level of the event.
	*/
	public function new ( loggerId : String, argument : Dynamic, level : Level )
	{
		this.loggerId = loggerId;
		this.argument = argument;
		this.level = level;
		time = Date.now();
	}
	
	/*
	* Serializes the LogEvent object into an object that can be passed to LocalConnection or similar objects.
	* @param logEvent A LogEvent obj.
	* @returns A serialized LogEvent obj.
	*/
	public static function serialize( logEvent : LogEvent ) : Dynamic
	{
		return { loggerId : logEvent.loggerId, time : logEvent.time, levelName : logEvent.level.getName(), argument : logEvent.argument };
	}
	
	/*
	* Deseriliazes a serialized LogEvent object into a LogEvent obj.
	* @param o The serialized LogEvent obj.
	* @returns A LogEvent obj.
	*/
	static function deserialize( o : Dynamic ) : LogEvent
	{
		var l : Level = Reflect.field( Level, o.levelName );
		var e : LogEvent = new LogEvent( o.loggerId, o.argument, l);
		e.time = o.time;
		return e;
	}
}

/**
* This class contains methods for logging messages at differente levels.<br />
* These messages can me basic types (strings, numbers, dates) or complex objects and MovieClips.<br />
* There are also configuration methods.
* <h4>Example:</h4>
* <code>
* import log.LuminicTracer;<br />
* var log = new LuminicTracer();<br />
* log.debug( "debug message" );<br />
* log.info( "info message" );<br />
* ...<br />
* <strong>OR</strong><br />
* log.setTraceRedirection();<br />
* trace ( "trace message or object" );
* </code>
**/
class LuminicTracer
{
	
	private var _loggerId	: String;
	private var _publisher	: ConsolePublisher;
	private var _level		: Level;
	
	/**
	* Redirect all <em>traces</em> to LuminicTracer
	*/
	public function setTraceRedirection()
	{
        haxe.Log.trace = traceLuminicTracer;
    }
 
    private function traceLuminicTracer( v : Dynamic, ?inf : haxe.PosInfos )
	{
        if ( 	Std.is ( v, String )	||
				Std.is ( v, Int )		||
				Std.is ( v, Float )		||
				Std.is ( v, Bool ) 		||
				Std.is ( v, Date )		||
				Std.is ( v, null )
				#if !flash9
					|| Std.is( v, Color )
				#end
			)
			log( inf.fileName + ":" + inf.lineNumber + ": " + v );
		else
			log ( v );
    }
	
	/**
	* Sets the lowest required [level] for any message.<br />
	* Any message that have a [level] that is lower than the supplied value will be ignored.<br />
	*/
	public function setLevel( level : Level ) : Void
	{
		_level = level;
	}
	
	/**
	* Instanciate the LuminicTracer.<br />
	* The [logId] parameter is optional. It identifies the logger and all messages to the publisher will be sent with this ID.
	*/
	public function new ( ?logId : String )
	{
		if( logId != null && logId.length > 0 )
			_loggerId = logId;
		else
			_loggerId = "Default Log";
		
		_level = Level.LOG;
		_publisher = new ConsolePublisher();
	}
	/**
	* Logs an object or message with the DEBUG level.
	*/	
	public function debug( argument : Dynamic ):Void { publish(argument, Level.DEBUG); }
	/**
	* Logs an object or message with the INFO level.
	*/
	public function info( argument : Dynamic ):Void { publish(argument, Level.INFO); }
	/**
	* Logs an object or message with the WARN level.
	*/	
	public function warn( argument : Dynamic ):Void { publish(argument, Level.WARN); }
	/**
	* Logs an object or message with the ERROR level.
	*/	
	public function error( argument : Dynamic ):Void { publish(argument, Level.ERROR); }
	/**
	* Logs an object or message with the FATAL level.
	*/	
	public function fatal( argument : Dynamic ):Void { publish(argument, Level.FATAL); }
	/**
	* Logs an object or message with the LOG level.
	*/
	public function log( argument : Dynamic ) : Void { publish(argument, Level.LOG); }
	
	private function publish ( argument : Dynamic, level : Level ) : Void
	{
		if( level.getValue() >= _level.getValue() )
		{
			var e : LogEvent = new LogEvent( _loggerId, argument, level );
			_publisher.publish( e );
		}
	}
}

/*
* Publishes logging messages into the FlashInspector (if available)<br />
* This publisher can be used in any enviroment as long as the FlashInspector is running. It can be used from inside the Flash editor or from the final production enviroment. This allows to see the logging messages even after the final SWF is in production.
*/
class ConsolePublisher
{	
	private var _version	: Float;
	private var _maxDepth	: Float;
	
	/*
	* Sets the max. inspection depth.<br />
	* The default value is 4.
	* The max. valid value is 255.
	*/
	function setMaxDepth( value : Float )
	{
		_maxDepth = if ( _maxDepth > 255 ) 255 else value;
	}
	/*
	* Gets the max. inspection depth
	*/
	function getMaxDepth() : Float
	{
		return _maxDepth;
	}
	
	/*
	* Creates a ConsolePublisher instance with a default max. inspection depth of 4.
	*/
	public function new()
	{
		// filt3rek : original version = 0.1 doesn't work with FlashInspector 0.30, must set it to 0.15
		
		_version = 0.15;
		_maxDepth = 4;
	}
	
	/*
	* Serializes and sends a log message to the FlashInspector window.
	*/
	public function publish( e : LogEvent ) : Void
	{
		var o = LogEvent.serialize( e );
		o.argument = serializeObj( o.argument, 1 );
		o.version = _version;
			
		var lc = new LocalConnection();
		#if flash9
		lc.addEventListener( flash.events.StatusEvent.STATUS, statusHandler );
		#end
		lc.send( "_luminicbox_log_console", "log", o );
	}
	
	private function statusHandler ( e ){}
	
	private function serializeObj( o : Dynamic, depth : Int ) : Dynamic
	{
		var type = _getType(o);
		var serial = { value : null, reachLimit : false, type : null, name : null, id : null };
		
		if( !type.inspectable ) 
		{
			serial.value = o;
		}
		else if( type.stringify ) 
		{
			serial.value = o+"";
		}
		else 
		{
			if( depth <= getMaxDepth() ) 
			{
				if( type.name == "movieclip" )
					serial.id = o + "";
				var items : Array<Dynamic> = new Array();
				if( Std.is( o, Array ) ) 
				{
					for( pos in 0...( o.length ) )
						items.push( { property : pos, value : serializeObj( o[ pos ], ( depth + 1 ) ) } );
				} else 
				{
					for( prop in Reflect.fields( o ) )
						items.push( { property : prop, value : serializeObj( Reflect.field( o, prop ), ( depth+1 ) ) } );
				}
				serial.value = cast items;
			} else 
			{
				serial.reachLimit = true;
			}
		}
		serial.type = type.name;
		return serial;
	}
	
	private function _getType( o ) : Dynamic
	{
		var type = { name : null, inspectable : true, stringify : false };
		
		if ( Std.is( o, String ) )
		{
			// STRING
			type.name = "string";
			type.inspectable = false;
		}
		else if ( Std.is( o, Bool ) )
		{
			// BOOLEAN
			type.name = "boolean";
			type.inspectable = false;
		}
		else if ( Std.is( o, Int ) || Std.is( o, Float ) )
		{
			// NUMBER
			type.name = "number";
			type.inspectable = false;
		}
		else if ( Std.is( o, null ) )
		{
			// NULL
			type.name = "null";
			type.inspectable = false;
		}
		else if( Std.is( o, Date ) ) 
		{
			// DATE
			type.inspectable = false;
			type.name = "date";
		} else if( Std.is( o, Array ) ) 
		{
			// ARRAY
			type.name = "array";
		} else if( Std.is( o, MovieClip ) ) 
		{
			// MOVIECLIP
			type.name = "movieclip";
		} else if( Std.is( o, Xml ) ) 
		{
			// XML
			type.name = "xml";
			type.stringify = true;
		}
		#if !flash9
			else if( Std.is( o, Color ) ) 
			{
				// COLOR
				type.name = "color";
				type.inspectable = false;
			}
		#end
		else if ( Std.is( o, Dynamic ) )
		{
			// OBJECT
			type.name = "object";
		}
		return type;
	}
}