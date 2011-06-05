//
// FlashZXSpectrum48k Copyright 2006 Jon Pollard
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// version 2 as published by the Free Software Foundation.
//
// SM.as
// 
// SM = Screen metrics. This class is made of constants which attempt to 
// rationlise and clarify the use of the many magic numbers involved in
// dealing with the ZX Spectrums rather strange video memory layout.
//

package {
	public class SM
	{
		// scan = 1px high scan line (full width)
		// row = 8px high character line (full width)
		// char = 8 * 8 character block
		// part = third of the screen

		static public const CHAR_LINE_COMBINATIONS:uint = 0xFF;
		static public const FLASH_COMBINATIONS:uint = 2;
		static public const BRIGHT_COMBINATIONS:uint = 2;
		static public const INK_COMBINATIONS:uint = 8;
		static public const PAPER_COMBINATIONS:uint = 8;				

		static public const PIXELS_PER_SCREEN_X:uint = 256;
		static public const PIXELS_PER_SCREEN_Y:uint = 192;
		
		static public const BORDER_WIDTH:uint = 32;
		static public const BORDER_HEIGHT:uint = 24;
		static public const BORDER_AND_SCREEN_X:uint = PIXELS_PER_SCREEN_X + BORDER_WIDTH * 2;
		static public const BORDER_AND_SCREEN_Y:uint = PIXELS_PER_SCREEN_Y + BORDER_HEIGHT * 2;
		
		static public const PARTS_PER_SCREEN:uint = 0x03;
		static public const CHARROWS_PER_PART:uint = 0x08;
		static public const SCANLINES_PER_CHARROW:uint = 0x08;
		
		static public const CHARROWS_PER_SCREEN:uint = CHARROWS_PER_PART * PARTS_PER_SCREEN;
		static public const CHARCOLS_PER_SCREEN:uint = 0x20;
		static public const SCANLINES_PER_SCREEN:uint = SCANLINES_PER_CHARROW * CHARROWS_PER_SCREEN;
		
		static public const ZX_BYTES_PER_SCANLINE:uint = 0x20;
		static public const ZX_BYTES_PER_CHARROW:uint = ZX_BYTES_PER_SCANLINE * SCANLINES_PER_CHARROW;
		static public const ZX_BYTES_PER_PART:uint = ZX_BYTES_PER_CHARROW * CHARROWS_PER_PART;
		static public const ZX_BYTES_PER_SCREEN:uint = ZX_BYTES_PER_PART * PARTS_PER_SCREEN;
		static public const ZX_BYTES_PER_8_SCANLINES:uint = ZX_BYTES_PER_SCANLINE * 8;
		
		static public const ZX_PIXELS_PER_CHAR_X:uint = 0x08;
		
		static public const ZX_ATTR_START:uint = ZX_BYTES_PER_SCREEN;
		static public const ZX_ATTR_BYTES_PER_CHARROW:uint = 0x20;

		static public const SWF_BYTES_PER_PIXEL:uint = 0x04;
		static public const SWF_BYTES_PER_CHAR_X:uint = SM.SWF_BYTES_PER_PIXEL * SM.ZX_PIXELS_PER_CHAR_X;
	}
}