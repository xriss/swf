/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class WetCardAnim
{
	var up; // WetTable
	
	var from; // stack from

	var to; // stack to
	
	var to_card;
	
	
	var fx,fy;
	var tx,ty;
	var x,y;
	
	
	var done;
	
	function setup(_up)
	{
		up=_up;
		
		done=false;
		
		from=null;
		to=null;
	}

	function set_to(_to)
	{
		var p=new Array();
		
		to_card=_to;
		
		to=_to.up;
		
		set_start();
		
	}

	function set_from(_from)
	{
		var p=new Array();
		
		from=_from.up;
		
		p.x=_from.mc._x;
		p.y=_from.mc._y;
		
		from.mc.localToGlobal(p);
		
		fx=p.x;
		fy=p.y;

		set_start();

	}
	
	function set_start()
	{
		if(from && to)
		{
			var pf=new Array();
			
			pf.x=fx;
			pf.y=fy;
			
			to.mc.globalToLocal(pf);
			
			x=pf.x;
			y=pf.y;
			
			to_card.mc._x=pf.x;
			to_card.mc._y=pf.y;
			
			
			to.mc.swapDepths(to.up.top_back_stack_depth);
		}
	}

	function snap()
	{
		x=to_card.x;
		y=to_card.y;
		
		to_card.mc._x=x;
		to_card.mc._y=y;
	
		done=true;
	}
	
	function update()
	{
		x+=(to_card.x-x)/4;
		y+=(to_card.y-y)/4;
		
		to_card.mc._x=x;
		to_card.mc._y=y;
		
		if
			(
				(Math.abs(to_card.x-x)<1)
				&&
				(Math.abs(to_card.y-y)<1)
			)
		{
			snap();
		}
	}
	
	function get_dist2()
	{
		return ((to_card.x-x)*(to_card.x-x)) + ((to_card.y-y)*(to_card.y-y)) ;
	}
	
	function clean()
	{
		done=true;
	}

}
