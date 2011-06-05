//
// FlashZXSpectrum48k Copyright 2006 Jon Pollard
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// version 2 as published by the Free Software Foundation.
//
// ZXScreenData.as
//
// Class for controlling the translation and rendering of the Spectrum's
// rather strange non-linear screen memory.  This code is a bottleneck on
// the processing of each frame.  I have tried several different strategies 
// for doing this process as efficiently as possible but have settled for 
// this implementation as it could later be expanded to more accurate rendering.
//
// The function scan() scans through the memory looking for changes and 
// generates an intermediate screen buffer (_linearScreenArray) with 
// canonical rendering information.  The render() function then looks only at 
// the changed areas (according to _screenChangeArray) and expands the canonical
// information into a ByteArray as 32-bit colour data.  This ByteArray is then
// passed to setPixels()
//
// Some of the process behind this code is inspired by 
// the Java Spectrum emulator QAOP http://wizard.ae.krakow.pl/~jb/qaop
//

package {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.geom.Rectangle;
	import SM;
 	
 	public class ZXScreenData extends BitmapData
	{
		private var _ram:ByteArray;
		
		private var _rowBuf:ByteArray;
		private var _linearScreenArray:ByteArray;
		private var _screenChangeArray:ByteArray;
		
		private var _cols:Array = new Array( 0x000000, 0x0000cc, 0xcc0000, 0xcc00cc, 0x00cc00, 0x00cccc, 0xcccc00, 0xcccccc,
											0x000000, 0x0000ff, 0xff0000, 0xff00ff, 0x00ff00, 0x00ffff, 0xffff00, 0xffffff );		
		private var _scanAddressLookup:ByteArray;
		private var _attrAddressLookup:ByteArray;
		
		private var _pixelFormatLookup:ByteArray;
						
		private var _nFlashFlag:uint = 0x8000;
		
  		public function ZXScreenData( ram:ByteArray )
		{
			super( SM.PIXELS_PER_SCREEN_X, SM.PIXELS_PER_SCREEN_Y, false );
		
			_ram = ram;
									
			createScreenArrays();
			createPixelLookup();
			createScreenAddressLookups();
		}
						
		private function createScreenArrays() : void
		{
			_rowBuf = new ByteArray();
			_rowBuf.length = SM.SWF_BYTES_PER_CHAR_X * SM.CHARCOLS_PER_SCREEN * 8; 
			
			_linearScreenArray = new ByteArray();
			_linearScreenArray.length = SM.CHARCOLS_PER_SCREEN * SM.SCANLINES_PER_SCREEN * 2; // 2 bytes per short
			for( var i:int = 0; i < _linearScreenArray.length; i++ )
				_linearScreenArray[i] = 0x01;
			
			_screenChangeArray = new ByteArray();
			_screenChangeArray.length = 4 * SM.CHARROWS_PER_SCREEN;
		}
				
		private function createScreenAddressLookups() : void
		{
			_scanAddressLookup = new ByteArray();
			_scanAddressLookup.length = SM.SCANLINES_PER_SCREEN * 2;	// 2 bytes per short
			_attrAddressLookup = new ByteArray();
			_attrAddressLookup.length = SM.SCANLINES_PER_SCREEN * 2;
			
			for( var nPart:int = 0; nPart < SM.PARTS_PER_SCREEN; nPart++ ) {
				var nPartOffset:int = nPart * SM.ZX_BYTES_PER_PART;
				var nCharRowBase:int = nPart * SM.CHARROWS_PER_PART;
				for( var nCharRow:int = 0; nCharRow < SM.CHARROWS_PER_PART; nCharRow++ ) {
					var nAttrAddress:int = SM.ZX_ATTR_START + (SM.ZX_ATTR_BYTES_PER_CHARROW * (nCharRowBase+nCharRow));
					var nCharRowOffset:int = nCharRow * SM.ZX_BYTES_PER_SCANLINE;
					for( var nScanLineY:int = 0; nScanLineY < SM.SCANLINES_PER_CHARROW; nScanLineY++ ) {
						var nScanLineAddr:int = nPartOffset + nCharRowOffset + (nScanLineY * SM.ZX_BYTES_PER_8_SCANLINES);
						_scanAddressLookup.writeShort( nScanLineAddr );
						_attrAddressLookup.writeShort( nAttrAddress );
					}
				}
			}
		}
		
		private function createPixelLookup() : void
		{
			_pixelFormatLookup = new ByteArray();
			_pixelFormatLookup.length = SM.SWF_BYTES_PER_CHAR_X * SM.CHAR_LINE_COMBINATIONS 
				* SM.BRIGHT_COMBINATIONS * SM.INK_COMBINATIONS * SM.PAPER_COMBINATIONS;  // 1 meg
			
			for( var uBrightIndex:uint = 0; uBrightIndex < SM.BRIGHT_COMBINATIONS; uBrightIndex++ ) {
				var uBrightBit:uint = uBrightIndex << 6;
				var uBrightCol:uint = uBrightIndex << 3;
				for( var uPaperIndex:uint = 0; uPaperIndex < SM.PAPER_COMBINATIONS; uPaperIndex++ ) {
					var uPaperBits:uint = uPaperIndex << 3;
					var uPaperCol:uint = _cols[uBrightCol|uPaperIndex];
					for( var uInkIndex:uint = 0; uInkIndex < SM.INK_COMBINATIONS; uInkIndex++ ) {
						var uInkCol:uint = _cols[uBrightCol|uInkIndex];
						var uAttrBits:uint = (uBrightBit|uPaperBits|uInkIndex) << 8;
						_pixelFormatLookup.position = uAttrBits * SM.SWF_BYTES_PER_CHAR_X;
						for( var uPixels:uint = 0; uPixels <= 0xFF; uPixels++ )
							for( var uTest:uint = 0x80; uTest > 0; uTest >>= 1 )
								_pixelFormatLookup.writeUnsignedInt( uPixels & uTest ? uInkCol : uPaperCol );
					}
				}
			}
		}

///////////////////
//////////////////
		public function toggleFlash() : void
		{
			_nFlashFlag ^= 0x00FF;
		}
		
		public function scan() : void
		{
			var ram:ByteArray = _ram;
			var nFlashFlag:int = _nFlashFlag;
			var linearScreenArray:ByteArray = _linearScreenArray;
			
			linearScreenArray.position = 0;
			_screenChangeArray.position = 0;

			_attrAddressLookup.position = 0; 			
			var nAttrPointer:int = _attrAddressLookup.readShort();
			
			_scanAddressLookup.position = 0;
			var nCharScanPointer:int = _scanAddressLookup.readShort();
			
			var nScanlineChangeBits:int = 0, nCharRowChangeBits:int = 0;
			
			var nPixBits:int = 0;
			do {
				nPixBits = ram[nAttrPointer]<<8 | ram[nCharScanPointer];
				if( nPixBits & 0x8000 ) // unset flash bit and toggle pixels
					nPixBits ^= nFlashFlag;
				if(linearScreenArray.readShort() != nPixBits ) {
					linearScreenArray.position -= 2;
					linearScreenArray.writeShort(nPixBits);					
					nScanlineChangeBits |= 0x02;
				}
				nCharScanPointer++;
				nAttrPointer++;

				nPixBits = ram[nAttrPointer]<<8 | ram[nCharScanPointer];
				if( nPixBits & 0x8000 ) // unset flash bit and toggle pixels
					nPixBits ^= nFlashFlag;
				if(linearScreenArray.readShort() != nPixBits ) {
					linearScreenArray.position -= 2;
					linearScreenArray.writeShort(nPixBits);
					nScanlineChangeBits |= 0x01;
				}
				nCharScanPointer++;
				nAttrPointer++;
				
				if( (nCharScanPointer & 0x1F) != 0 ) {	// multiple of 0x20 = bytes per scanline
					nScanlineChangeBits <<= 2;
				} else {
					nCharRowChangeBits |= nScanlineChangeBits;
					nScanlineChangeBits = 0;
					if( (linearScreenArray.position & 0x1FF) == 0 ) { // end of char row 512 = 8 scanlines * 32 chars * 2 bytes per short
						_screenChangeArray.writeInt( nCharRowChangeBits );
						nCharRowChangeBits = 0;
					}
					if( _attrAddressLookup.position < _attrAddressLookup.length ) {
						nAttrPointer = _attrAddressLookup.readShort();
						nCharScanPointer = _scanAddressLookup.readShort();
					} else // end of screen
						break;
				}
			} while( true );
		}
		
		public function render() : void
		{
			var rowBuf:ByteArray = _rowBuf;
			var pixelFormatLookup:ByteArray = _pixelFormatLookup;
			var linearScreenArray:ByteArray = _linearScreenArray;
			
			linearScreenArray.position = 0;
			_screenChangeArray.position = 0;
			
			var nScanLine:int, nBytes:int;
							
			for( var nCharScanline:int = 0; nCharScanline < SM.SCANLINES_PER_SCREEN; nCharScanline += 8 ) {
				var nCharRowChangeBits:int = _screenChangeArray.readInt();
				if( nCharRowChangeBits != 0 ) {							// only part of the row needs to be updated
					var nBlockByteStart:int = 0, nBlockByteWidth:int = 0;
					while( nCharRowChangeBits != 0 ) {
						while( (nCharRowChangeBits & 0x80000000) == 0 ) {
							nCharRowChangeBits <<= 1;
							nBlockByteStart += 2;						// 2 bytes per short
						}
						nBlockByteWidth = 2;							// 
						nCharRowChangeBits <<= 1;
						while( (nCharRowChangeBits & 0x80000000) != 0 ) {
							nCharRowChangeBits <<= 1;
							nBlockByteWidth += 2;						// 2 bytes per short
						}
						rowBuf.position = 0;
						linearScreenArray.position = nCharScanline * 64 + nBlockByteStart;
						for( nScanLine = 0; nScanLine < 8; nScanLine++ ) {
							for( nBytes = 0; nBytes < nBlockByteWidth; nBytes += 2 )
								rowBuf.writeBytes( pixelFormatLookup, linearScreenArray.readShort() << 5, 32 );
							linearScreenArray.position += 64 - nBlockByteWidth;	// go to beginning of block on next scanline (64 coded bytes per scanline)
						}
						rowBuf.position = 0;
						setPixels( new Rectangle(nBlockByteStart * 4, nCharScanline, nBlockByteWidth * 4, 8), rowBuf );
						nBlockByteStart += nBlockByteWidth;
					}
				}
			}
		}	
	}
}