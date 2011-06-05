/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#MAINCLASS=MAINCLASS or "Only1"

#(

STATES=STATES or
	{

	login="Login",
	
	play="Only1Play",
	
	about="PlayAbout",
	high="PlayHigh",
	
	menu="Only1Menu",
--	menu=false,
	
	rainbow="Only1Rainbow",

	}

#)


#include "../base/src/Main.as"

