/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2010
//
// This file made available under the terms of The MIT License : http://www.opensource.org/licenses/mit-license.php
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
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
