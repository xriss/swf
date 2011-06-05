//
// FlashZXSpectrum48k Copyright 2006 Jon Pollard
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// version 2 as published by the Free Software Foundation.
//
// FlashZXSpectrum48k.as
// 
// Application level class for setting up the main ZXSpectrum class, 
// controlling the loading of rom/ram data, managing ExternalInterface
// js commands and dealing with initial settings from FlashVars.  This
// is the main sprite on the stage.
//

package {
 	import flash.display.Sprite;
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ErrorEvent; 
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.external.ExternalInterface;
	
	import ZXSpectrum;
 	
 	public class FlashZXSpectrum48k extends Sprite
	{
		private var _spectrum:ZXSpectrum;
		private var _romLoader:URLLoader, _gameLoader:URLLoader;
		private var _initialLoadSNA:String = "";
		private var _currentlyLoadingSNA:String = "";
		
		private var _debug:TextField;
		
  		public function FlashZXSpectrum48k()
		{
			ExternalInterface.addCallback( "pause", externalPause );
			ExternalInterface.addCallback( "reset", externalReset );
			ExternalInterface.addCallback( "loadSNA", externalLoadSNA );
			ExternalInterface.addCallback( "setKeyboardArrows", externalSetKeyboardArrows );
		
			_spectrum = new ZXSpectrum( this );
			
			_spectrum._signals.wetcon=loaderInfo.parameters["wetcon"];
			
//			_spectrum.scaleX=1*800/320;
//			_spectrum.scaleY=1*600/240;
			
			addChild( _spectrum );
			stage.focus = _spectrum;
											
			loadRom(loaderInfo.parameters["loadROM"]?loaderInfo.parameters["loadROM"]:"");
			
			_initialLoadSNA = loaderInfo.parameters["loadSNA"] == null ? "" : loaderInfo.parameters["loadSNA"];
			
			var initialArrowsStr:String = loaderInfo.parameters["arrows"] == null ? "" : loaderInfo.parameters["arrows"];
			if( initialArrowsStr != "" )
				externalSetKeyboardArrows(initialArrowsStr);
								
/*
var chatLoader:Loader = new Loader();
var chatURL:URLRequest = new URLRequest("http://swf.wetgenes.local/swf/WTF_import.swf?dozxmode=1");
	addChild(chatLoader);
	chatLoader.load(chatURL);
*/

		}
		
		public function externalPause( state:Boolean ):void
		{
			_spectrum.userPaused = state;
		}
		
		public function externalReset():void
		{
			_spectrum.reset();
			_spectrum.userPaused = false;
		}
		
		public function externalLoadSNA(snaPath:String):void
		{
			loadSNA(snaPath);
		}
		
		public function externalSetKeyboardArrows(arrowsStr:String):void
		{
			if(arrowsStr.toLowerCase() == "default")
				_spectrum._zxKeyboard.arrowsUseDefault();
			else if(arrowsStr.toLowerCase() == "kempston")
				_spectrum._zxKeyboard.setArrowsUseKempston(true);
			else
				_spectrum._zxKeyboard.setArrows(arrowsStr);
		}
																					
		public function loadRom(romurl:String) : void
		{
			var urlRequest:URLRequest = new URLRequest(romurl==""?"zx.rom":romurl);
			_romLoader = new URLLoader();
			_romLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_romLoader.addEventListener( Event.COMPLETE, onRomDataLoaded)
			_romLoader.addEventListener( IOErrorEvent.IO_ERROR, onRomDataLoadFailed)
			_romLoader.load(urlRequest);
		}

		private function onRomDataLoaded( event:Event ):void 
		{
			if( _spectrum.loadRom48k( _romLoader.data ) ) {
				if( _initialLoadSNA != "" )
					loadSNA(_initialLoadSNA);
				else
					_spectrum.internalPaused = false;
			}
		}

		private function onRomDataLoadFailed(event:ErrorEvent):void 
		{
			showError("Could not load zx.rom");
		}

		private function loadSNA( localSNAPath:String ) :void
		{
			if( localSNAPath != "" && _spectrum.isRomLoaded() ) {
				_currentlyLoadingSNA = localSNAPath;

				var urlRequest:URLRequest = new URLRequest(localSNAPath);
				_gameLoader = new URLLoader();
				_gameLoader.dataFormat = URLLoaderDataFormat.BINARY;
				_gameLoader.addEventListener( Event.COMPLETE, onSNADataLoaded)
				_gameLoader.addEventListener( IOErrorEvent.IO_ERROR, onSNADataLoadFailed)
				_gameLoader.load(urlRequest);
			}
		}

		private function onSNADataLoaded( event:Event ):void 
		{
			if( !_spectrum.loadSNA( _gameLoader.data ) )
				showError("Could not load snapshot: '"+_currentlyLoadingSNA+"'");
			//_spectrum.screenSpeedTest();
			_spectrum.internalPaused = false;
		}

		private function onSNADataLoadFailed(event:ErrorEvent):void 
		{
			_spectrum.internalPaused = false;
			showError("Could not load snapshot: '"+_currentlyLoadingSNA+"'");
		}
		
		public function showError(str:String):void
		{
			ExternalInterface.call("console.log",str);
//			ExternalInterface.call("showZXError", str);			
		}
	}
}