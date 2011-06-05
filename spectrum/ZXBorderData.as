//
// FlashZXSpectrum48k Copyright 2006 Jon Pollard
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// version 2 as published by the Free Software Foundation.
//
// ZXBorderData.as
// 
// Simple class for rendering the border around the ZX Spectrum's screen.
// Later on this could be exapnded for more accurate emulation.
//

package {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import SM;
 	
 	public class ZXBorderData extends BitmapData
	{
		private var _width:uint, _height:uint;
		private var _nBorderColIndex:int = 7, _nBorderSolidColIndex:int = -1;
		private var _bBorderChanged:Boolean = true;
		
		private var _cols:Array = new Array( 0x000000, 0x0000cc, 0xcc0000, 0xcc00cc, 0x00cc00, 0x00cccc, 0xcccc00, 0xcccccc );		
	
  		public function ZXBorderData()
		{
			_width = SM.BORDER_AND_SCREEN_X;
			_height = SM.BORDER_AND_SCREEN_Y;
			super( _width,  _height, false );
		}
		
		public function setBorder( nBorderColIndex:int ) : void
		{
			_nBorderColIndex = nBorderColIndex;
		}
		
		public function scan( bFrameEnd:Boolean ) : void
		{
			// strange implementation is a placeholder for if more accurate border rendering is implemented
			if( _nBorderSolidColIndex != _nBorderColIndex ) {
				_bBorderChanged = true;
				_nBorderSolidColIndex = _nBorderColIndex;
			} else
				_bBorderChanged = false;
		}
		
		public function render() : void
		{
			if( _bBorderChanged ) {
				fillRect( new Rectangle( 0, 0, _width, _height ), _cols[_nBorderColIndex] );
			}
		}
	}
}