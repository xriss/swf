//
// FlashZXSpectrum48k Copyright 2006 Jon Pollard
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// version 2 as published by the Free Software Foundation.
//
// ZXEnv.as
// 
// Interface for managing communication between the Z80 emulation class
// and the main ZXSpectrum class (ZXSpectrum implements this interface).
// It abstracts the access of memory and I/O operations.
//
// This file is a direct port from Java to ActionScript of code in 
// the Java Spectrum emulator QAOP http://wizard.ae.krakow.pl/~jb/qaop
//

package {
	public interface Z80Env {
		function m1(addr:int):int;
		function memR(addr:int):int;
		function memW(addr:int, v:int):void;
		function input(port:int):int;
		function output(port:int, v:int):void;

		function mem16R(addr:int):int;
		function mem16W(addr:int, v:int):void;

		function cont(addr:int, n:int):void; // possible contention on T..T+n-1
	}
}