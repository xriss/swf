/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#MAINCLASS=MAINCLASS or "WetV"

#(

STATES=STATES or
	{

	login="Login",
	
	play=MAINCLASS.."Play",
	
	about="PlayAbout",
	code="PlayCode",
	
	menu=false,

	}
	
SCALE_MODE="normal"

#)

#include "../base/src/Main.as"


