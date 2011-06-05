/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class #(VERSION_BASENAME)Data
{

	static var up; // Main
	
	static function #(VERSION_BASENAME)Data(_up)
	{
		up=_up;
	}
	
		
	
	static function setup()
	{
	var i,j;
	

		for(i in pages)
		{
			pages[i].id=i;
			for(j in pages[i])
			{
				pages[i][j].id=j;
			}
		}
	}
	
	static var 	pages={
#include "art/data.as"
/*
		main:{
			display:{
				type:"xhtml",
				w:600,h:440,x:20,y:20
			}
		}
*/
	};

	
}
