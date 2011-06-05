/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#MAINCLASS=MAINCLASS or "Only2"

#(

STATES=STATES or
	{

	login="Login",
	
	play="Only2Play",
	
	about="PlayAbout",
	high="PlayHigh",
	
--	menu="Only2Menu",
	menu=false,
	
	rainbow="Only2Rainbow",

	}

#)


#include "../base/src/Main.as"

