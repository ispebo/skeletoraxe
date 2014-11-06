package skeletoraxe.converter.utils.exporters;

import flash.display.BitmapData;
import flash.net.FileReference;
import flash.events.IOErrorEvent;
import flash.events.Event;
import flash.utils.ByteArray;
import skeletoraxe.converter.utils.exporters.pngencoder.PNGEncoder2;


class PNGExporter extends IPBExporter
{
	public function new( cb: Bool->Void = null ) : Void
	{
		super( cb );
	}
	
	//------------------------------------------------------------------------
	public function export( bitmapData: BitmapData, nameFile: String ) : Void
	{	
		save( generateByteArray( bitmapData ) , nameFile );	
	}
	
	//------------------------------------------------------------------------
	public function generateByteArray( bitmapData: BitmapData) : ByteArray
	{	
		return PNGEncoder2.encode( bitmapData);
	}
}