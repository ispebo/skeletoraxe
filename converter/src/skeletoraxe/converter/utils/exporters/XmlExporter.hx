package skeletoraxe.converter.utils.exporters;

import flash.net.FileReference;
import flash.events.IOErrorEvent;
import flash.events.Event;
import flash.utils.ByteArray;

import haxe.io.BytesOutput;

/**
 * @autor ispebo
 */
class XmlExporter extends IPBExporter
{
	public function new( cb: Bool->Void = null ) : Void
	{
		super( cb );
	}
	
	//------------------------------------------------------------------------
	public function export( xml: String, nameFile: String ) : Void
	{	
		save( generateByteArray( xml ), nameFile );	
		
	}
	
	//------------------------------------------------------------------------
	public function generateByteArray( xml: String) : ByteArray
	{	
		var bytes : ByteArray = new ByteArray();
		bytes.writeUTFBytes( xml ) ;
		return bytes;
	}
	
	
}