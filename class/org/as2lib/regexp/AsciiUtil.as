﻿/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.core.BasicClass;

/**
 * {@code AsciiUtil} provides common routines for ASCII char validations and
 * conversations.
 * 
 * @author Igor Sadovskiy
 */

class org.as2lib.regexp.AsciiUtil extends BasicClass {
    
    public static var UPPER:Number   = 0x00000100;
    public static var LOWER:Number   = 0x00000200;
    public static var DIGIT:Number   = 0x00000400;
    public static var SPACE:Number   = 0x00000800;
    public static var PUNCT:Number   = 0x00001000;
    public static var CNTRL:Number   = 0x00002000;
    public static var BLANK:Number   = 0x00004000;
    public static var HEX:Number     = 0x00008000;
    public static var UNDER:Number   = 0x00010000;
    public static var ASCII:Number   = 0x0000FF00;
    public static var ALPHA:Number   = (UPPER|LOWER);
    public static var ALNUM:Number   = (UPPER|LOWER|DIGIT);
    public static var GRAPH:Number   = (PUNCT|UPPER|LOWER|DIGIT);
    public static var WORD:Number    = (UPPER|LOWER|UNDER|DIGIT);
    public static var XDIGIT:Number  = HEX;

	public static var CHAR_NUL:Number 		= 0x00; 
	public static var CHAR_SOH:Number 		= 0x01; 
	public static var CHAR_STX:Number 		= 0x02; 
	public static var CHAR_ETX:Number 		= 0x03; 
	public static var CHAR_EOT:Number 		= 0x04; 
	public static var CHAR_ENQ:Number 		= 0x05; 
	public static var CHAR_ACK:Number 		= 0x06; 
	public static var CHAR_BEL:Number 		= 0x07; 
	public static var CHAR_BS:Number 		= 0x08;  
	public static var CHAR_HT:Number 		= 0x09;  
	public static var CHAR_LF:Number 		= 0x0A;  
	public static var CHAR_VT:Number 		= 0x0B;  
	public static var CHAR_FF:Number 		= 0x0C;  
	public static var CHAR_CR:Number 		= 0x0D;  
	public static var CHAR_SI:Number 		= 0x0E;  
	public static var CHAR_SO:Number 		= 0x0F;  
	public static var CHAR_DLE:Number 		= 0x10; 
	public static var CHAR_DC1:Number 		= 0x11; 
	public static var CHAR_DC2:Number 		= 0x12; 
	public static var CHAR_DC3:Number 		= 0x13; 
	public static var CHAR_DC4:Number 		= 0x14; 
	public static var CHAR_NAK:Number 		= 0x15; 
	public static var CHAR_SYN:Number 		= 0x16; 
	public static var CHAR_ETB:Number 		= 0x17; 
	public static var CHAR_CAN:Number 		= 0x18; 
	public static var CHAR_EM:Number 		= 0x19;  
	public static var CHAR_SUB:Number 		= 0x1A; 
	public static var CHAR_ESC:Number 		= 0x1B; 
	public static var CHAR_FS:Number 		= 0x1C;  
	public static var CHAR_GS:Number 		= 0x1D;  
	public static var CHAR_RS:Number 		= 0x1E;  
	public static var CHAR_US:Number 		= 0x1F;  
	public static var CHAR_SP:Number 		= 0x20; 
	public static var CHAR_EXCL:Number 		= 0x21;		// !     
	public static var CHAR_QUOT:Number 		= 0x22;		// "     
	public static var CHAR_NUM:Number 		= 0x23; 	// #     
	public static var CHAR_DOLLAR:Number 	= 0x24;		// $     
	public static var CHAR_PERCNT:Number 	= 0x25;		// %     
	public static var CHAR_AMP:Number 		= 0x26;		// &     
	public static var CHAR_APOS:Number 		= 0x27;		// '     
	public static var CHAR_LPAR:Number 		= 0x28; 	// (     
	public static var CHAR_RPAR:Number 		= 0x29; 	// )     
	public static var CHAR_AST:Number 		= 0x2A; 	// *     
	public static var CHAR_PLUS:Number 		= 0x2B; 	// +     
	public static var CHAR_COMMA:Number 	= 0x2C;		// ,     
	public static var CHAR_MINUS:Number 	= 0x2D;		// -     
	public static var CHAR_PERIOD:Number 	= 0x2E; 	// .     
	public static var CHAR_SOL:Number 		= 0x2F;		// /
	public static var CHAR_0:Number 		= 0x30;     
	public static var CHAR_1:Number 		= 0x31;     
	public static var CHAR_2:Number 		= 0x32;     
	public static var CHAR_3:Number 		= 0x33;     
	public static var CHAR_4:Number 		= 0x34;     
	public static var CHAR_5:Number 		= 0x35;     
	public static var CHAR_6:Number 		= 0x36;     
	public static var CHAR_7:Number 		= 0x37;     
	public static var CHAR_8:Number 		= 0x38;     
	public static var CHAR_9:Number 		= 0x39;     
	public static var CHAR_COLON:Number 	= 0x3A;		// :     
	public static var CHAR_SEMI:Number 		= 0x3B;		// ;     
	public static var CHAR_LT:Number 		= 0x3C;		// <     
	public static var CHAR_EQUALS:Number 	= 0x3D;		// =     
	public static var CHAR_GT:Number 		= 0x3E;		// >     
	public static var CHAR_QUEST:Number 	= 0x3F;		// ?     
	public static var CHAR_COMMAT:Number 	= 0x40;		// @     
	public static var CHAR_A:Number 		= 0x41;     
	public static var CHAR_B:Number 		= 0x42;     
	public static var CHAR_C:Number 		= 0x43;     
	public static var CHAR_D:Number 		= 0x44;     
	public static var CHAR_E:Number 		= 0x45;     
	public static var CHAR_F:Number 		= 0x46;     
	public static var CHAR_G:Number 		= 0x47;     
	public static var CHAR_H:Number 		= 0x48;     
	public static var CHAR_I:Number 		= 0x49;     
	public static var CHAR_J:Number 		= 0x4A;     
	public static var CHAR_K:Number 		= 0x4B;     
	public static var CHAR_L:Number 		= 0x4C;     
	public static var CHAR_M:Number			= 0x4D;     
	public static var CHAR_N:Number 		= 0x4E;     
	public static var CHAR_O:Number 		= 0x4F;     
	public static var CHAR_P:Number 		= 0x50;     
	public static var CHAR_Q:Number 		= 0x51;     
	public static var CHAR_R:Number 		= 0x52;     
	public static var CHAR_S:Number 		= 0x53;     
	public static var CHAR_T:Number 		= 0x54;     
	public static var CHAR_U:Number 		= 0x55;     
	public static var CHAR_V:Number 		= 0x56;     
	public static var CHAR_W:Number 		= 0x57;     
	public static var CHAR_X:Number 		= 0x58;     
	public static var CHAR_Y:Number 		= 0x59;     
	public static var CHAR_Z:Number 		= 0x5A;     
	public static var CHAR_LSQB:Number 		= 0x5B; 	// [     
	public static var CHAR_BSOL:Number 		= 0x5C; 	// \     
	public static var CHAR_RSQB:Number 		= 0x5D; 	// ]     
	public static var CHAR_CIRC:Number 		= 0x5E;		// ^     
	public static var CHAR_LOWBAR:Number 	= 0x5F;		// _     
	public static var CHAR_GRAVE:Number 	= 0x60;		// `     
	public static var CHAR_LOW_A:Number 	= 0x61;     
	public static var CHAR_LOW_B:Number 	= 0x62;     
	public static var CHAR_LOW_C:Number 	= 0x63;     
	public static var CHAR_LOW_D:Number 	= 0x64;     
	public static var CHAR_LOW_E:Number 	= 0x65;     
	public static var CHAR_LOW_F:Number 	= 0x66;     
	public static var CHAR_LOW_G:Number 	= 0x67;     
	public static var CHAR_LOW_H:Number 	= 0x68;     
	public static var CHAR_LOW_I:Number 	= 0x69;     
	public static var CHAR_LOW_J:Number 	= 0x6A;     
	public static var CHAR_LOW_K:Number 	= 0x6B;     
	public static var CHAR_LOW_L:Number 	= 0x6C;     
	public static var CHAR_LOW_M:Number 	= 0x6D;     
	public static var CHAR_LOW_N:Number 	= 0x6E;     
	public static var CHAR_LOW_O:Number 	= 0x6F;     
	public static var CHAR_LOW_P:Number 	= 0x70;     
	public static var CHAR_LOW_Q:Number 	= 0x71;     
	public static var CHAR_LOW_R:Number 	= 0x72;     
	public static var CHAR_LOW_S:Number 	= 0x73;     
	public static var CHAR_LOW_T:Number 	= 0x74;     
	public static var CHAR_LOW_U:Number 	= 0x75;     
	public static var CHAR_LOW_V:Number 	= 0x76;     
	public static var CHAR_LOW_W:Number 	= 0x77;     
	public static var CHAR_LOW_X:Number 	= 0x78;     
	public static var CHAR_LOW_Y:Number 	= 0x79;     
	public static var CHAR_LOW_Z:Number 	= 0x7A;     
	public static var CHAR_LCUB:Number 		= 0x7B;		// {     
	public static var CHAR_VERBAR:Number 	= 0x7C;		// |     
	public static var CHAR_RCUB:Number 		= 0x7D;		// }     
	public static var CHAR_TILDE:Number 	= 0x7E;		// ~     
	public static var CHAR_DEL:Number 		= 0x7F; 


    private static var charTypes:Array = [
        CNTRL,                  /* 00 (NUL) */
        CNTRL,                  /* 01 (SOH) */
        CNTRL,                  /* 02 (STX) */
        CNTRL,                  /* 03 (ETX) */
        CNTRL,                  /* 04 (EOT) */
        CNTRL,                  /* 05 (ENQ) */
        CNTRL,                  /* 06 (ACK) */
        CNTRL,                  /* 07 (BEL) */
        CNTRL,                  /* 08 (BS)  */
        SPACE+CNTRL+BLANK,      /* 09 (HT)  */
        SPACE+CNTRL,            /* 0A (LF)  */
        SPACE+CNTRL,            /* 0B (VT)  */
        SPACE+CNTRL,            /* 0C (FF)  */
        SPACE+CNTRL,            /* 0D (CR)  */
        CNTRL,                  /* 0E (SI)  */
        CNTRL,                  /* 0F (SO)  */
        CNTRL,                  /* 10 (DLE) */
        CNTRL,                  /* 11 (DC1) */
        CNTRL,                  /* 12 (DC2) */
        CNTRL,                  /* 13 (DC3) */
        CNTRL,                  /* 14 (DC4) */
        CNTRL,                  /* 15 (NAK) */
        CNTRL,                  /* 16 (SYN) */
        CNTRL,                  /* 17 (ETB) */
        CNTRL,                  /* 18 (CAN) */
        CNTRL,                  /* 19 (EM)  */
        CNTRL,                  /* 1A (SUB) */
        CNTRL,                  /* 1B (ESC) */
        CNTRL,                  /* 1C (FS)  */
        CNTRL,                  /* 1D (GS)  */
        CNTRL,                  /* 1E (RS)  */
        CNTRL,                  /* 1F (US)  */
        SPACE+BLANK,            /* 20 SPACE */
        PUNCT,                  /* 21 !     */
        PUNCT,                  /* 22 "     */
        PUNCT,                  /* 23 #     */
        PUNCT,                  /* 24 $     */
        PUNCT,                  /* 25 %     */
        PUNCT,                  /* 26 &     */
        PUNCT,                  /* 27 '     */
        PUNCT,                  /* 28 (     */
        PUNCT,                  /* 29 )     */
        PUNCT,                  /* 2A *     */
        PUNCT,                  /* 2B +     */
        PUNCT,                  /* 2C ,     */
        PUNCT,                  /* 2D -     */
        PUNCT,                  /* 2E .     */
        PUNCT,                  /* 2F /     */
        DIGIT+HEX+0,            /* 30 0     */
        DIGIT+HEX+1,            /* 31 1     */
        DIGIT+HEX+2,            /* 32 2     */
        DIGIT+HEX+3,            /* 33 3     */
        DIGIT+HEX+4,            /* 34 4     */
        DIGIT+HEX+5,            /* 35 5     */
        DIGIT+HEX+6,            /* 36 6     */
        DIGIT+HEX+7,            /* 37 7     */
        DIGIT+HEX+8,            /* 38 8     */
        DIGIT+HEX+9,            /* 39 9     */
        PUNCT,                  /* 3A :     */
        PUNCT,                  /* 3B ;     */
        PUNCT,                  /* 3C <     */
        PUNCT,                  /* 3D =     */
        PUNCT,                  /* 3E >     */
        PUNCT,                  /* 3F ?     */
        PUNCT,                  /* 40 @     */
        UPPER+HEX+10,           /* 41 A     */
        UPPER+HEX+11,           /* 42 B     */
        UPPER+HEX+12,           /* 43 C     */
        UPPER+HEX+13,           /* 44 D     */
        UPPER+HEX+14,           /* 45 E     */
        UPPER+HEX+15,           /* 46 F     */
        UPPER+16,               /* 47 G     */
        UPPER+17,               /* 48 H     */
        UPPER+18,               /* 49 I     */
        UPPER+19,               /* 4A J     */
        UPPER+20,               /* 4B K     */
        UPPER+21,               /* 4C L     */
        UPPER+22,               /* 4D M     */
        UPPER+23,               /* 4E N     */
        UPPER+24,               /* 4F O     */
        UPPER+25,               /* 50 P     */
        UPPER+26,               /* 51 Q     */
        UPPER+27,               /* 52 R     */
        UPPER+28,               /* 53 S     */
        UPPER+29,               /* 54 T     */
        UPPER+30,               /* 55 U     */
        UPPER+31,               /* 56 V     */
        UPPER+32,               /* 57 W     */
        UPPER+33,               /* 58 X     */
        UPPER+34,               /* 59 Y     */
        UPPER+35,               /* 5A Z     */
        PUNCT,                  /* 5B [     */
        PUNCT,                  /* 5C \     */
        PUNCT,                  /* 5D ]     */
        PUNCT,                  /* 5E ^     */
        PUNCT|UNDER,            /* 5F _     */
        PUNCT,                  /* 60 `     */
        LOWER+HEX+10,           /* 61 a     */
        LOWER+HEX+11,           /* 62 b     */
        LOWER+HEX+12,           /* 63 c     */
        LOWER+HEX+13,           /* 64 d     */
        LOWER+HEX+14,           /* 65 e     */
        LOWER+HEX+15,           /* 66 f     */
        LOWER+16,               /* 67 g     */
        LOWER+17,               /* 68 h     */
        LOWER+18,               /* 69 i     */
        LOWER+19,               /* 6A j     */
        LOWER+20,               /* 6B k     */
        LOWER+21,               /* 6C l     */
        LOWER+22,               /* 6D m     */
        LOWER+23,               /* 6E n     */
        LOWER+24,               /* 6F o     */
        LOWER+25,               /* 70 p     */
        LOWER+26,               /* 71 q     */
        LOWER+27,               /* 72 r     */
        LOWER+28,               /* 73 s     */
        LOWER+29,               /* 74 t     */
        LOWER+30,               /* 75 u     */
        LOWER+31,               /* 76 v     */
        LOWER+32,               /* 77 w     */
        LOWER+33,               /* 78 x     */
        LOWER+34,               /* 79 y     */
        LOWER+35,               /* 7A z     */
        PUNCT,                  /* 7B {     */
        PUNCT,                  /* 7C |     */
        PUNCT,                  /* 7D }     */
        PUNCT,                  /* 7E ~     */
        CNTRL                   /* 7F (DEL) */
    ]; 
    
	private function AsciiUtil(Void) {
		super();
	}

    public static function getType(ch:Number):Number {
        return ((ch & 0xFFFFFF80) == 0 ? charTypes[ch] : 0);
    }

    public static function isType(ch:Number, type:Number):Boolean {
        return (getType(ch) & type) != 0;
    }

    public static function isAscii(ch:Number):Boolean {
        return ((ch & 0xFFFFFF80) == 0);
    }

    public static function isAlpha(ch:Number):Boolean {
        return isType(ch, ALPHA);
    }

    public static function isDigit(ch:Number):Boolean {
        return ((ch - CHAR_0) | (CHAR_9 - ch)) >= 0;
    }

    public static function isAlnum(ch:Number):Boolean {
        return isType(ch, ALNUM);
    }

    public static function isGraph(ch:Number):Boolean {
        return isType(ch, GRAPH);
    }

    public static function isPrint(ch:Number):Boolean {
        return ((ch - CHAR_SP) | (CHAR_TILDE - ch)) >= 0;
    }

    public static function isPunct(ch:Number):Boolean {
        return isType(ch, PUNCT);
    }

    public static function isSpace(ch:Number):Boolean {
        return isType(ch, SPACE);
    }

    public static function isHexDigit(ch:Number):Boolean {
        return isType(ch, HEX);
    }

    public static function isOctDigit(ch:Number):Boolean {
        return ((ch - CHAR_0) | (CHAR_7 - ch)) >= 0;
    }

    public static function isCntrl(ch:Number):Boolean {
        return isType(ch, CNTRL);
    }

    public static function isLower(ch:Number):Boolean {
        return ((ch - CHAR_LOW_A) | (CHAR_LOW_Z - ch)) >= 0;
    }

    public static function isUpper(ch:Number):Boolean {
        return ((ch - CHAR_A) | (CHAR_Z - ch)) >= 0;
    }

    public static function isWord(ch:Number):Boolean {
        return isType(ch, WORD);
    }

    public static function toDigit(ch:Number):Number {
        return (charTypes[ch & 0x7F] & 0x3F);
    }

    public static function toLower(ch:Number):Number {
        return isUpper(ch) ? (ch + 0x20) : ch;
    }

    public static function toUpper(ch:Number):Number {
        return isLower(ch) ? (ch - 0x20) : ch;
    }

}