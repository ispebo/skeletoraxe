package skeletoraxe.converter.utils.exporters;

import flash.net.FileReference;
import flash.events.IOErrorEvent;
import flash.events.Event;
import flash.utils.ByteArray;

/**
 * @autor ispebo
 */
class IPBExporter 
{
	private var _myFileRefSave					: FileReference;
	private var _loading						: Bool;
	private var _cb								: Bool->Void;
	
	public function new( cb: Bool->Void = null  ) : Void
	{
		_myFileRefSave = new FileReference();
		setEventFileRef( true );
		_loading = false;
		_cb = cb;
		
	}
	
	//------------------------------------------------------------------------
	public function save( bytes: ByteArray, nameFile: String ) : Void
	{
		_myFileRefSave.save( bytes, nameFile );
	}
	//------------------------------------------------------------------------
	
	private function setEventFileRef( b: Bool) : Void
	{
		if ( b ) 
		{
			_myFileRefSave.addEventListener(Event.CANCEL, cancelHandler);
			_myFileRefSave.addEventListener(Event.COMPLETE, completeHandler);
			_myFileRefSave.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);	
			_myFileRefSave.addEventListener(Event.OPEN, openHandler);
			_myFileRefSave.addEventListener(Event.SELECT, selectHandler);
		}
		else
		{
			_myFileRefSave.removeEventListener(Event.CANCEL, cancelHandler);
			_myFileRefSave.removeEventListener(Event.COMPLETE, completeHandler);
			_myFileRefSave.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);	
			_myFileRefSave.removeEventListener(Event.OPEN, openHandler);
			_myFileRefSave.removeEventListener(Event.SELECT, selectHandler);
		}
        
	}
	
	
	
	//------------------------------------------------------------------------
	private function completeHandler( event: Event ) : Void 
	{
		_loading = false;
		if ( _cb != null ) _cb( true );
		trace("completeHandler");
	}
	//------------------------------------------------------------------------
	private function cancelHandler( ?event: Event ) : Void 
	{
		_loading = false;
		if ( _cb != null ) _cb( false );
		trace("cancelHandler");
	}
	//------------------------------------------------------------------------
	private function ioErrorHandler( event: IOErrorEvent ) : Void 
	{
		_loading = false;
		if ( _cb != null ) _cb( false );
		trace("ioErrorHandler");
	}
	//------------------------------------------------------------------------
	private function openHandler( event: Event ): Void
	{
		_loading = true;
		trace("openHandler");
	}
	//------------------------------------------------------------------------
	private function selectHandler( event: Event ): Void
	{
		_loading = true;
		trace("selectHandler");	
	}
	
	//------------------------------------------------------------------------
	public function destroy() : Void
	{
		setEventFileRef( false ); 
		_loading = false;
	}
	
	
}