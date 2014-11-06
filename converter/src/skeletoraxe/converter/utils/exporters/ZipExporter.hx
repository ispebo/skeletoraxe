package skeletoraxe.converter.utils.exporters;

import deng.fzip.FZip;
import deng.fzip.FZipErrorEvent;
import deng.fzip.FZipFile;
import deng.fzip.FZipLibrary;
import flash.events.OutputProgressEvent;
import flash.utils.ByteArray;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileStream;
import flash.filesystem.FileMode;
import haxe.Timer;

class ZipExporter
{
	private var _zip: FZip;
	private var _bytePNG		: Array<ByteArray>;
	private var _byteXml		: ByteArray;
	private var _modeAtlas		: Bool;

	public function new() : Void { }
	
	public function convert(bytePNG: Array<ByteArray>, byteXml: ByteArray, modeAtlas: Bool ):  Void
	{
		_bytePNG = bytePNG;
		_byteXml = byteXml;
		_modeAtlas = modeAtlas;
		
		var appPath:File = File.applicationDirectory.resolvePath("");
		appPath.browseForSave("nothing");
		appPath.addEventListener( Event.SELECT, onFolderSelected );
		appPath.addEventListener( Event.CANCEL, canceled );
		
	}

	//------------------------------------------------------------------
	
	private function onFolderSelected( e: Event) : Void
	{
		var file: File = cast(e.currentTarget, File);
		var path: String = StringTools.replace( file.nativePath, file.name, "");
	
		var nameFile: String = StringTools.replace( file.name, ".zip", "");
		var fromUserPath:File = File.userDirectory.resolvePath( path+nameFile+".zip" );
		var stream: FileStream = new FileStream();
		stream.open(fromUserPath, FileMode.WRITE);
		
		_zip = new FZip();
		if (!_modeAtlas) 
		{
			for ( i in 0 ... _bytePNG.length )
				_zip.addFile( nameFile+"__"+(i+1)+".png", _bytePNG[i] );
		}
		else _zip.addFile( nameFile+".png", _bytePNG[0]);
		_zip.addFile( nameFile+".xml", _byteXml );
		_zip.serialize( stream );
		
		stream.close();
		
		Timer.delay( function() { LoaderApp.instance.visible = false; }, 1000 );
	}
	//------------------------------------------------------------------
	private function canceled( e: Event ) : Void
	{
		 LoaderApp.instance.visible = false;
	}
	
}