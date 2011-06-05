//
// FlashZXSpectrum48k Copyright 2006 Jon Pollard
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// version 2 as published by the Free Software Foundation.
//
// ZXSpectrum.as
//
// Main class derived from Sprite for Sinclair ZX Spectrum 48k emulation
//
// Portions of code in this file inspired by and/or ported to flash from
// the Java Spectrum emulator QAOP http://wizard.ae.krakow.pl/~jb/qaop
//

package {
 	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.geom.Rectangle;
	import flash.utils.Endian;
	import ZXScreenData;
	import ZXBorderData;
	import ZXKeyboard;
	import SM;
	import Z80;
 	
 	public class ZXSpectrum extends Sprite implements Z80Env
	{
		public var _ram:ByteArray;
		
		private var _rom:ByteArray;
		private var _if1rom:ByteArray, _rom48k:ByteArray;
		private var _romLoaded:Boolean = false;

		private var _scrn:Bitmap, _border:Bitmap;
	
		public var _zxKeyboard:ZXKeyboard;
	
		private var _zxScreenData:ZXScreenData;
		private var _zxBorderData:ZXBorderData;
		private var _z80:Z80;
				
		private var _flashCount:uint = 0;
			
		public var internalPaused:Boolean = true;
		public var userPaused:Boolean = false;

		private var _beeper:int; 	//(byte);
		private var _beepert:int;
			
		private const MEM_FIRST_RAM:uint = 0x4000;		
		private const MEM_ROM_LENGTH:uint = 0x4000;
		private const MEM_RAM_LENGTH:uint = 0xC000;
		private const MEM_SCREEN:uint = 0x4000;
		
		public var _signals:ZXSignals;
		
  		public function ZXSpectrum( p:InteractiveObject )
		{
			focusRect = false;
			
			addEventListener( Event.ENTER_FRAME, onEnterFrame );
			addEventListener( MouseEvent.CLICK, onClick );
			
			_ram = new ByteArray();
			_ram.length = MEM_RAM_LENGTH;
			_rom48k = new ByteArray();
			_rom48k.length = MEM_ROM_LENGTH;
			_rom = _rom48k;
				
			_zxKeyboard = new ZXKeyboard( p );
			
			_z80 = new Z80(this);
			_z80.reset();
			
			_zxBorderData = new ZXBorderData();
			_border = new Bitmap( _zxBorderData );
			addChild( _border );
	
			_zxScreenData = new ZXScreenData( _ram );
			_scrn = new Bitmap( _zxScreenData );
			addChild( _scrn );
			_scrn.x = SM.BORDER_WIDTH;
			_scrn.y = SM.BORDER_HEIGHT;
			
			_beepert = _z80.ticks;
		
			_signals = new ZXSignals(this);
		}
		
		public function reset():void
		{
			_z80.reset();
		}

		public function onClick(event:MouseEvent):void
		{
			// this is required
			stage.focus = this;
		}
		
		public function pokeStream( src:ByteArray, start:uint, len:uint ):void
		{
			start -= MEM_FIRST_RAM;
			start = Math.max( Math.min(start, MEM_RAM_LENGTH), 0 );				
				// between 0 and MEM_RAM_LENGTH
			len = Math.max( Math.min(len, Math.min(MEM_RAM_LENGTH - start, src.bytesAvailable)), 0 );
				// between start and min of bytesavailable and ram space
						
			if( len > 0 ) { // write len bytes from src[src.position] to _ram[start]
				_ram.position = start;
				_ram.writeBytes( src, src.position, len );
			}
		}

		public function loadSNA( src:ByteArray ):Boolean
		{
			src.endian = Endian.LITTLE_ENDIAN;
			
			_z80.reset();
			_z80.iW( src.readUnsignedByte() );
			_z80.hlW( src.readUnsignedShort() ); _z80.deW( src.readUnsignedShort() ); _z80.bcW( src.readUnsignedShort() );
			_z80.afW( src.readUnsignedShort() );
			_z80.exx(); _z80.ex_af();
			_z80.hlW( src.readUnsignedShort() ); _z80.deW( src.readUnsignedShort() ); _z80.bcW( src.readUnsignedShort() );
			_z80.iyW( src.readUnsignedShort() ); _z80.ixW( src.readUnsignedShort() );
			_z80.eiW( src.readUnsignedByte() != 0 );
			_z80.rW( src.readUnsignedByte() );
			_z80.afW( src.readUnsignedShort() );
			_z80.spW( src.readUnsignedShort() );
			_z80.im( src.readUnsignedByte() );
			output( 254, src.readUnsignedByte() );
			
			pokeStream( src, 0x4000, 0xc000 );
			
			var sp:int = _z80.spR();
			_z80.pcW( mem16R(sp) );
			_z80.spW( sp+2 & 0xFFFF );
			mem16W( sp, 0 );
			
			//_zxScreenData.invalidateScreen();
			
			return true;
		}
		
		public function loadRom48k( src:ByteArray ):Boolean
		{
			if( src.length == MEM_ROM_LENGTH ) {
				_rom48k.position = 0;
				_rom48k.writeBytes( src, 0, MEM_ROM_LENGTH );
				_romLoaded = true;
				return true;
			} else
				return false;
		}
				
		public function isRomLoaded():Boolean
		{
			return _romLoaded;
		}
				
		public function onEnterFrame(event:Event):void
		{
			if( !userPaused && !internalPaused ) {
				runCPUOneFrame();
//				runCPUOneFrame();
				
				_zxScreenData.scan();			
				_zxScreenData.render();
				_zxBorderData.scan( true );
				_zxBorderData.render();
								
				_flashCount++;
				if( _flashCount == 16 ) {
					_zxScreenData.toggleFlash();
					_flashCount = 0;
				}
				
				_signals.update();
			}
		}
		
		public function runCPUOneFrame() : void
		{
			_zxKeyboard.update();
			
			_z80.interrupt(0xFF);
			_z80.execute();

			_z80.ticks -= 69888;
			_beepert = _z80.ticks;
		}
		
		public function flashScreen() : void
		{
			_zxScreenData.toggleFlash();
			_zxScreenData.scan();			
			_zxScreenData.render();
			_zxBorderData.scan( true );
			_zxBorderData.render();
		}
		
		public function screenSpeedTest():void
		{
			//var t:uint = getTimer();
			//for( var i:int = 0; i < 25; i++ )
			//	flashScreen();
			//MyTrace.trace( getTimer() - t );
		}
		
		public function z80SpeedTest():void
		{
			// reserved for speed tests of emulation code
		}
		
		/* Z80Env */
		
		private function contention( t:int ):void 
		{
			t += _z80.ticks;
			if( t < 0 || t >= 191*224+126 ) 
				return;
			if( (t&7) >= 6 ) 
				return;
			if( t % 224 < 126 )
				_z80.ticks += 6 - (t & 7);
		}

		public function cont( addr:int, n:int ):void
		{
			if( addr >= 0x4000 && addr < 0x8000 && _z80.ticks + n > 0 )
				for( var i:int = 0; i < n; i++ )
					contention(i);
		}

		public function m1( addr:int ):int
		{
			if( addr >= 0x4000 ) {		// 0x4000 = MEM_FIRST_RAM in ram
				addr -= 0x4000;			// offset to beginning of ram
				if( addr < 0x4000 )		// if in first 0x4000 of ram
					contention(0);
				return _ram[addr];
			}
			var b:int = _rom[addr];		// must be in rom
			if( _if1rom == null || (addr & 0xE8F7) != 0 )
				return b;
			if( addr == 0x0008 || addr == 0x1708 )
				_rom = _if1rom;
			else if( addr == 0x0700 )
				_rom = _rom48k;
			return b;
		}

		public function memR( addr:int ):int 
		{
			addr -= 0x4000;				// 0x4000 = MEM_FIRST_RAM in ram
			if( addr >= 0 ) {			// if in ram
				if( addr < 0x4000 )		// if in first 0x4000 of ram
					contention(0);
				return _ram[addr];		// return ram
			}
			return _rom[addr+0x4000];	// return rom
		}

		public function mem16R( addr:int ):int
		{
			if( (addr & 0x3FFF ) != 0x3FFF ) {
				if( addr < 0x4000 )
					return _rom[addr] | _rom[addr+1]<<8;
				addr -= 0x4000;
				if( addr < 0x4000 ) {
					contention(0);
					contention(3);
				}
				return _ram[addr] | _ram[addr+1]<<8;
			}
			var v:int = memR(addr);
			_z80.ticks += 3;
			v |= memR( addr+1 & 0xFFFF ) << 8;
			_z80.ticks -= 3;
			return v;
		}

		public function memW( addr:int, v:int ):void
		{
			addr -= 0x4000;								// move relative to beginning of ram
			if( addr < 0x4000 ) {						// if in first 0x4000 of ram
				if( addr < 0 )							// if in rom
					return;
				contention(0);
				/*if( addr < 0x1800 && _ram[addr] != v )		// in pixel space
					_zxScreenData.pixelsChanged(addr);
				else if( addr < 0x1B00 && _ram[addr] != v ) // must be in attributes then
					_zxScreenData.attrsChanged(addr);*/
			}
			_ram[addr] = v;
		}

		public function mem16W( addr:int, v:int ):void
		{
			if( ( addr + 1 & 0x3FFF ) !=0 ) {
				addr -= 0x4000;						// move relative to beginning of ram
				if( addr < 0 )						// if in rom
					return;
				if( addr >= 0x8000 ) {				// if above 32k in ram
					_ram[addr] = v & 0xFF;
					_ram[addr+1] = v >>> 8;
					return;
				}
				addr += 0x4000;						// move back relative to beginning of address space
			}
			memW( addr, v & 0xFF );
			_z80.ticks += 3;
			memW( addr + 1 & 0xFFFF, v >>> 8 );
			_z80.ticks -= 3;
		}

		public function output( port:int, v:int ):void
		{
			if( ( port & 0x0001 ) == 0 ) {
				contention(1);				
				_zxBorderData.setBorder(v & 0x07);
				
				var b:int = v & 0x10;
				if( b != _beeper ) {
					_beeper = b;
					var t:int = _z80.ticks;
					//audio.pulse( t - beepert );	// not implemented at present
					_beepert = t;
				}
			}
		}

		public function input( port:int ):int
		{
			var v:int = 0xFF;
			if( ( port & 0x00E0 ) == 0 )
				return _zxKeyboard.getKempston();
			if( ( port & 0x0001 ) == 0 ) {
				contention(1);
				for( var i:int = 0; i < 8; i++)
					if( ( port & 0x100 << i ) == 0)
						v &= _zxKeyboard.getKeyboard(i);
				v &= _beeper << 2 | 0xBF;
			} else if( _z80.ticks >= -2 ) {
				var t:int = _z80.ticks;
				var y:int = t / 224;
				t %= 224;
				if( y < 192 && t < 124 && (t & 4) == 0 ) {
					var x:int = t>>1 & 1 | t>>2;
					if( (t&1) == 0 )
						x += y & 0x1800 | y<<2 & 0xE0 | y<<8 & 0x700;
					else
						x += 6144 | y<<2 & 0x3E0;
					v = _ram[x];
				}
			}
			return v;
		}
	}
}