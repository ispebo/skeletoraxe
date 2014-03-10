package com.standard.log.alcon;


import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import haxe.Timer;
//import flash.utils.getTimer;	

class FPSMeter extends EventDispatcher{
	////////////////////////////////////////////////////////////////////////////////////////
	// Variables                                                                          //
	////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The FPSMeter.FPS_UPDATE constant defines the value of the type property
	 * of an fpsUpdate event object.
	 */
	public static inline var FPS_UPDATE:String = "fpsUpdate";
	
	
	public var	fps(get_fps, null)		:Float;
	public var	frt(get_frt, null)		:Float;
	
	
	private var _stage:Stage;
	private var _timer:Timer;
	private var _pollInterval:Int;
	private var _fps:Float;
	private var _frt:Float;
	private var _ms:Float;
	private var _isRunning:Bool;
	
	private var _delay:Int;
	private var _delayMax:Int;
	private var _prev:Float;
	
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Public Methods                                                                     //
	////////////////////////////////////////////////////////////////////////////////////////
	
	public function new(stage:Stage, pollInterval:Int = 500)
	{
		super();
		_stage = stage;
		_pollInterval = pollInterval;
		
		this._delayMax = 10;
		
		reset();
		
	}
	
	
	/**
	 * Starts FPS/FRT polling.
	 */
	public function start():Void
	{
		if (!_isRunning)
		{
			_isRunning = true;
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_timer = new Timer(_pollInterval);
			_timer.run = onTimer;
		}
	}
	
	
	/**
	 * Stops FPS/FRT polling.
	 */
	public function stop():Void
	{
		if (_isRunning)
		{
			_timer.stop();
			_timer.run = null;
			_stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_timer = null;
			reset();
		}
	}
	
	
	/**
	 * Resets the FPSMeter to it's default state.
	 */
	public function reset():Void
	{
		_fps = 0;
		_frt = 0;
		_ms = 0;
		_delay = 0;
		_prev = 0;
		_isRunning = false;
	}
	
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Getters & Setters                                                                  //
	////////////////////////////////////////////////////////////////////////////////////////
	
	public function get_fps():Float
	{
		return _fps;
	}
	
	public function get_frt():Float
	{
		return _frt;
	}
	
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Event Handlers                                                                     //
	////////////////////////////////////////////////////////////////////////////////////////
	
	
	private function onTimer():Void
	{
		dispatchEvent(new Event(FPSMeter.FPS_UPDATE));
	}
	
	
	private function onEnterFrame(event:Event):Void
	{
		var t = Timer.stamp();
		_delay++;
		
		if (_delay >= _delayMax)
		{
			_delay = 0;
			_fps = (_delayMax) / (t - _prev) ;
			_prev = t;
		}
		
		_frt = (t - _ms)*1000;
		_ms = t;
		//trace(_fps + " " + _frt);
		
		
	}
}
