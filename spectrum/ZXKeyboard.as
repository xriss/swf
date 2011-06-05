//
// FlashZXSpectrum48k Copyright 2006 Jon Pollard
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// version 2 as published by the Free Software Foundation.
//
// ZXKeyboardData.as
// 
// Class for converting key presses sent in from the player to the input
// bytes that mean something to the Spectrum.  The ZX Spectrum has two
// qualifier keys (symbol shift and caps shift) and the code below to read
// in equivalent key presses from a Mac or PC keyboard has not been 
// straightforward to develop as ctrl/alt/option etc key presses are often
// consumed before they get to the actionscript.  It's possible some of this
// code may get broken as future versions of the Flash player are released.
//
// Some of the process behind this code is inspired by 
// the Java Spectrum emulator QAOP http://wizard.ae.krakow.pl/~jb/qaop
//

package {
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.ui.KeyLocation;
	import flash.utils.ByteArray;
	import flash.ui.Keyboard;
	import flash.system.Capabilities;

 	public class ZXKeyboard
	{
		private var _keyboard:ByteArray, _kempston:int = 0;
		private var _keyEvents:Array;
				
		private var _arrowsDefault:Array;
		private var _arrows:Array;
		private var _arrowsUseKempston:Boolean = false;
		
		private var _pressedMatrix:ByteArray;
		
		private var _translateNumberKeySymbols:Boolean = true;
		private var _isMac:Boolean = false;
	
		public function getKempston():int				{ return _kempston; }
		public function getKeyboard( i:int ):int		{ return _keyboard[i]; }
		
		private const ZXK_CAPSSHIFT:uint = 0x01;
		private const ZXK_SYMBOLSHIFT:uint = 0x02;
	
  		public function ZXKeyboard( eventSrc:InteractiveObject )
		{
			_isMac = Capabilities.os.indexOf("Mac", 0) != -1;
		
			super();
			
			_arrowsDefault = new Array();
			_arrowsDefault[0] = new ZXKeyboardCode( 35, ZXK_CAPSSHIFT ); //0x63;	// 0143;
			_arrowsDefault[1] = new ZXKeyboardCode( 20, ZXK_CAPSSHIFT ); //0x54;	// 0124;
			_arrowsDefault[2] = new ZXKeyboardCode( 28, ZXK_CAPSSHIFT ); //0x5c;	// 0134;
			_arrowsDefault[3] = new ZXKeyboardCode( 36, ZXK_CAPSSHIFT ); //0x64;	// 0144;
			
			_arrows = _arrowsDefault;
			
			_pressedMatrix = new ByteArray();
			_pressedMatrix.length = 5;
			
			_keyEvents = new Array(8);
			
			_kempston = 0;
			_keyboard = new ByteArray();
			_keyboard.length = 8; // 8 bytes
			for( var i:int = 0; i < 8; i++ )
				_keyboard[i] = 0xFF;
			
			eventSrc.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            eventSrc.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		private function keyDownHandler(event:KeyboardEvent):void 
		{
			var emptySlot:int = -1;
			var alreadyPressed:Boolean = false;
			for( var i:int = 0; i < _keyEvents.length; i++ ) {
				if( _keyEvents[i] == null )
					emptySlot = i;
				else if( _keyEvents[i].keyCode == event.keyCode && _keyEvents[i].keyLocation == event.keyLocation ) {
					_keyEvents[i] = event;
					alreadyPressed = true;
				}
			}

			if( !alreadyPressed && emptySlot != -1 )
				 _keyEvents[emptySlot] = event;
        }

        private function keyUpHandler(event:KeyboardEvent):void 
		{
			for( var i:int = 0; i < _keyEvents.length; i++ )
				if( _keyEvents[i] != null && _keyEvents[i].keyCode == event.keyCode
						/*&& _keyEvents[i].keyLocation == event.keyLocation*/ ) // problem on pc where keyboardlocation 
							// not sent back with multiple keys
					_keyEvents[i] = null;
        }
		
		public function update():void
		{
			for( var i:int = 0; i < 8; i++ ) 
				_keyboard[i] = 0xFF;
			_kempston = 0;

			for( i = 0; i < _pressedMatrix.length; i++ )
				_pressedMatrix[i] = -1;
			
			var defaultQualifiers:int = 0, overrideQualifiers:int = 0;
			
			for( i = 0; i < _keyEvents.length; i++) {
				if( _keyEvents[i] != null ) {
					defaultQualifiers |= getQualifierCode(_keyEvents[i]);
					if( _arrowsUseKempston )
						_kempston |= getKempstonCode(_keyEvents[i]);
				}
			}
			var keyPress:Boolean = false;
			for( i = 0; i < _keyEvents.length; i++) {
				if( _keyEvents[i] != null ) {
					var k:ZXKeyboardCode = translateKey(_keyEvents[i], defaultQualifiers);
					if( k != null ) {
						keyPress = true;
						registerPress(k.zxKeycode);
						if( k.zxOverrideQualfiers != 0 )
							overrideQualifiers = k.zxOverrideQualfiers;
					}					
				}
			}
			
			var qualifiers:int =  overrideQualifiers != 0 ? overrideQualifiers : defaultQualifiers;
			if( qualifiers & ZXK_CAPSSHIFT )
				registerPress(0x00);			// press caps shift
			if( qualifiers & ZXK_SYMBOLSHIFT )
				registerPress(0x0F);			// press symbol shift
		}
		
		private function getQualifierCode( e:KeyboardEvent ):int
		{
			if( _isMac )
				return (e.shiftKey /*|| e.keyCode == Keyboard.SHIFT*/ ? ZXK_CAPSSHIFT : 0) 
					| (e.ctrlKey || e.keyCode == Keyboard.CONTROL ? ZXK_SYMBOLSHIFT : 0);
			else
				return (e.keyCode == Keyboard.SHIFT && e.keyLocation == KeyLocation.LEFT ? ZXK_CAPSSHIFT : 0) 
					| (e.keyCode == Keyboard.SHIFT && e.keyLocation == KeyLocation.RIGHT ? ZXK_SYMBOLSHIFT : 0);
		}
		
		private function getKempstonCode( e:KeyboardEvent ):int
		{
			switch(e.keyCode) {
				case Keyboard.NUMPAD_4:
				case Keyboard.LEFT:
					return 0x02;
				case Keyboard.NUMPAD_2:
				case Keyboard.DOWN:
					return 0x04;
				case Keyboard.NUMPAD_8:
				case Keyboard.UP:
					return 0x08;
				case Keyboard.NUMPAD_6:
				case Keyboard.RIGHT:
					return 0x01;
				case Keyboard.TAB:
					return 0x10;
			}
			return 0;
		}
		
		private function translateKey( e:KeyboardEvent, qualifiers:int ):ZXKeyboardCode
		{
			if( e.charCode != 0 ) {
				var i:int = -1;
				if( !(_translateNumberKeySymbols && isNumberKeySymbol(e, qualifiers)) ) {
					if( e.keyCode == 0x30 )					// special case for 0
						return new ZXKeyboardCode( 4, 0 );
					else {
						var keyCode:int = e.keyCode;
						if( e.ctrlKey && keyCode <= 26 && _isMac )	// on mac if ctrl pressed then ctrl code returned
							keyCode += 64;

						i = "\0AQ10P\r ZSW29OL\0XDE38IKMCFR47UJNVGT56YHB".indexOf(String.fromCharCode(keyCode));
						if( i >= 0 )
							return new ZXKeyboardCode( i, 0 );
					}
				}
			
				if( e.charCode == 0xA3 )				// £ not handled properly for some reason
					return new ZXKeyboardCode( 0x10, ZXK_SYMBOLSHIFT );
				else {
					i = "\0\0\0!_\"\0\0:\0\0@);=\0£\0\0#(\0+.?\0<$'\0-,/\0>%&\0^*".indexOf(String.fromCharCode(e.charCode));				
					if( i >= 0 )
						return new ZXKeyboardCode( i, ZXK_SYMBOLSHIFT );
				}
			}
			
			switch(e.keyCode) {
				case Keyboard.INSERT:
				case Keyboard.ESCAPE:
					return new ZXKeyboardCode( 3, ZXK_CAPSSHIFT );
				case Keyboard.BACKSPACE:
					return new ZXKeyboardCode( 4, ZXK_CAPSSHIFT );
			}
			
			if( !_arrowsUseKempston ) {
				var arrowIndex:int = -1;
				switch(e.keyCode) {
					case Keyboard.NUMPAD_4:
					case Keyboard.LEFT:
						arrowIndex = 0;
						break;
					case Keyboard.NUMPAD_2:
					case Keyboard.DOWN:
						arrowIndex = 3;
						break;
					case Keyboard.NUMPAD_8:
					case Keyboard.UP:
						arrowIndex = 2;
						break;
					case Keyboard.NUMPAD_6:
					case Keyboard.RIGHT:
						arrowIndex = 1;
				}
				if( arrowIndex != -1 ) 
					return _arrows[arrowIndex];					
			}
				
			return null;
		}
		
		private function registerPress( zxKeycode:int ):void
		{
			var row:int = zxKeycode & 0x7
			var col:int = (zxKeycode >>> 3) & 0x7;
			var newRowBits:int = _keyboard[row] & ~(1 << col);	// unset the col bit on this row
			var alreadyPressedRow:int = _pressedMatrix[col];	// row for the key previously pressed on this col
			_keyboard[row] = newRowBits;
			_pressedMatrix[col] = row;
			if( alreadyPressedRow >= 0 )
				newRowBits |= _keyboard[alreadyPressedRow];
			for( var i:int = 0; i < 8; i++ )
				if( (_keyboard[i] | newRowBits) != 0xFF )	// the same col is active on both rows
					_keyboard[i] = newRowBits;
		}
		
		public function setArrows( s:String ):void
		{
			_arrowsUseKempston = false;
			_arrows = new Array();
			for( var i:int = 0; i < 4; i++ ) {
				var c:int = -1;
				if( i < s.length )
					c = "Caq10pE_zsw29olSxde38ikmcfr47ujnvgt56yhb".indexOf(s.charAt(i));
				_arrows[i] = c < 0 ? _arrowsDefault[i] : new ZXKeyboardCode( c, 0 );
			}
		}
		
		public function setArrowsUseKempston( state:Boolean ):void
		{
			_arrowsUseKempston = state;
		}
	
		public function arrowsUseDefault():void
		{
			_arrowsUseKempston = false;
			_arrows = _arrowsDefault;
		}
				
		private function isNumberKeySymbol( e:KeyboardEvent, qualifiers:int ):Boolean
		{
			return e.keyCode >= 0x30 && e.keyCode <= 0x39 && e.shiftKey && !e.ctrlKey && !e.altKey &&  !(qualifiers & ZXK_SYMBOLSHIFT);
		}
	}
}

class ZXKeyboardCode
{
	public var zxKeycode:int, zxOverrideQualfiers:int;
	
	public function ZXKeyboardCode( zxKeycode1:int, zxOverrideQualfiers1:int )
	{
		zxKeycode = zxKeycode1;
		zxOverrideQualfiers = zxOverrideQualfiers1;
	}
};