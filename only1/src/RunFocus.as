/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class RunFocus
{
	var up;
	
	var it; // main object to focus on
	
	var slack;
	var force;
	var px;
	var py;
	
	
	function RunFocus(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function setup()
	{
		slack=1;
		px=0;
		py=0;
	}
	
	function clean()
	{
	}
	
	function update()
	{
	var dx,dy;
	
		dx=(it.px-px);
		dy=(it.py-py);
		
		if(((dx*dx)+(dy*dy))<=1) // lock solid on the player?
		{
			if(it==up.player)
			{
				slack=1;
			}
		}
		
		if(dx>0) dx=Math.ceil(dx*slack);
		if(dx<0) dx=Math.floor(dx*slack);
				
		if(dy>0) dy=Math.ceil(dy*slack);
		if(dy<0) dy=Math.floor(dy*slack);
		
		px=px+dx;
		py=py+dy;
		
		
		if(up.up.do_trigger)
		{
			var t=up.up.do_trigger;
			up.up.do_trigger=null;
			force=up.items_by_id[t];
			set(force,up.up.do_slack);
			force.vars.convo=up.up.do_convo;
		}
	
	}
	
	function set(_it,_slack)
	{
		it=_it;
		slack=_slack;
		
		update();
	}
	
}