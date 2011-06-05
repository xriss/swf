/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class EsBackCol
{

	var up;

	var idx;
	
	var x;
	var y;
	var yv;
	
	var wet; // wetness here
	var wv; //momentum, left or  right -1 0 +1

	function EsBackCol(_up,_idx)
	{
	var i;
	var last;
	
		up=_up;
		idx=_idx;
		
		wet=0;
		wv=0;
		
		if(idx>0) // relative to x-1
		{
			last=up.GetCol(idx-1);
		}
		else
		if(idx<0) // relative to x+1
		{
			last=up.GetCol(idx+1);
		}
		
		if(idx==0) // seed
		{
			x=0;
			y=0;
			yv=0;
		}
		else
		{
		var cent=256*16;
		var xabs;
		var rnd_fix;
		
			x=idx*up.cw;
			
			xabs=x;
			if(xabs<0) { xabs=-xabs; }
			
			if(xabs<cent)
			{
				rnd_fix=0.05-(xabs/cent);	// 0 to -1
			}
			else
			{
				rnd_fix=0.05-1;
			}
			
			yv=(last.yv+(((up.rnd()/65535)+rnd_fix)*(up.cw/32)));
			y=last.y+yv+ (((up.rnd()/65535)-0.5)*(up.cw));
			
			if(y>up.maxy) { up.maxy=y; }
			if(y<up.miny) { up.miny=y; }
		}
		
		if(y>1200)
		{
			wet=y-1200;
		}
	}	
}
