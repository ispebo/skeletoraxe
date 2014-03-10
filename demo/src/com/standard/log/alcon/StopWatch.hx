package com.standard.log.alcon;

import haxe.Timer;

class StopWatch
{
	////////////////////////////////////////////////////////////////////////////////////////
	// Variables                                                                          //
	////////////////////////////////////////////////////////////////////////////////////////
	
	public	var started(get_started, null)		:Bool;
	public  var timeInMilliSeconds(get_timeInMilliSeconds, null) :Float;
	public  var timeInSeconds(get_timeInSeconds, null) :Float;
	
	
	private var _started			:Bool;
	private var _startTimeKeys		:Array<Float>;
	private var _stopTimeKeys		:Array<Float>;
	private var _title				:String;
	
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Public Methods                                                                     //
	////////////////////////////////////////////////////////////////////////////////////////
	
	public function new()
	{
		this._started = false;
		reset();
		
	}
	
	
	public function start(title:String = ""):Void	{
		if (!_started)
		{
			_title = title;
			_started = true;
			_startTimeKeys.push(Timer.stamp());
		}
	}
	
	
	public function stop():Void
	{
		if (_started)
		{
			var stopTime = Timer.stamp();
			_stopTimeKeys[_startTimeKeys.length - 1] = stopTime;
			_started = false;
		}
	}
	
	
	/**
	 * Resets the Stopwatch total running time.
	 */
	public function reset():Void
	{
		_startTimeKeys = [];
		_stopTimeKeys = [];
		_started = false;
	}
	
	
	/**
	 * Generates a string representation of the Stopwatch that includes
	 * all start and stop times in milliseconds.
	 * 
	 * @return the string representation of the Stopwatch.
	 */
	public function toString():String
	{
		var s = "\n ********************* [STOPWATCH] *********************";
		if (_title != "") s += "\n * " + _title;
		var i = 0;
		for (i in 0..._startTimeKeys.length)
		{
			var s1 = _startTimeKeys[i];
			var s2 = _stopTimeKeys[i];
			s += "\n * started ["
				+ this.format(s1) + "ms] stopped ["
				+ this.format(s2) + "ms] time ["
				+ this.format(s2 - s1) + "ms]";
		}
		
		if (i == 0) s += "\n * never started.";
		else s += "\n * total runnning time: " + timeInSeconds + "s";
		
		s += "\n *******************************************************";
		return s;
	}
	
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Getters & Setters                                                                  //
	////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Returns whether the Stopwatch has been started or not.
	 */
	public function get_started():Bool
	{
		return _started;
	}
	
	
	/**
	 * Calculates and returns the elapsed time in milliseconds. The Stopwatch
	 * will not be stopped by calling this method. If the Stopwatch
	 * is still running it takes the current time as stoptime for the result.
	 */
	public function get_timeInMilliSeconds():Float
	{
		if (_started)
		{
			_stopTimeKeys[_startTimeKeys.length - 1] = Timer.stamp();
		}
		var r:Float = 0;
		for (i in 0..._startTimeKeys.length)
		{
			r += (_stopTimeKeys[i] - _startTimeKeys[i]);
		}
		return r;		
	}
	
	
	/**
	 * Calculates and returns the elapsed time in seconds. The Stopwatch
	 * will not be stopped by calling this method. If the Stopwatch is still
	 * running it takes the current time as stoptime for the result.
	 */
	public function get_timeInSeconds():Float
	{
		return timeInMilliSeconds / 1000;
	}
	
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Private Methods                                                                    //
	////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Formats a value for toString Output.
	 * 
	 * @private
	 */
	private function format(v:Float):String
	{
		var s:String = "";
		var l = Std.string(v).length;
		for (i in 0...(5 - l))
		{
			s += "0";
		}
		return s + v;
	}
}

