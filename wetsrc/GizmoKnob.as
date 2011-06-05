/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
// This file made available under the terms of The MIT License : http://www.opensource.org/licenses/mit-license.php
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#GFX=GFX or "gfx"
#CLASSVERSION = CLASSVERSION or ""
#CLASSNAME = CLASSNAME or "GizmoKnob"..CLASSVERSION
class #(CLASSNAME)
{

	var x_knob; // 0.0 to 1.0 x knob position relative to parent
	var y_knob; // 0.0 to 1.0 y knob position relative to parent
	
// alternative gfx

	var mc_base;
	var mc_over;
	var mc_down;
	
#include "../wetsrc/Gizmo.base.inc.as"
	
	
	function #(CLASSNAME)(_up)
	{
		up=_up;
		setup();
	}
	
	function set_knob(xx,yy)
	{
	
		if(xx!=null)
		{
			x_knob=xx;
			if(x_knob<0) { x_knob=0; }
			if(x_knob>1) { x_knob=1; }
		}
		
		if(yy!=null)
		{
			y_knob=yy;
			if(y_knob<0) { y_knob=0; }
			if(y_knob>1) { y_knob=1; }
		}
		
		if(up.w>w) { x=x_knob*(up.w-w); } else { x_knob=0; x=0; }
		if(up.h>h) { y=y_knob*(up.h-h); } else { y_knob=0; y=0; }
		
	}


	function setup()
	{
		setup_base();
//		mc.cacheAsBitmap=true;
	}
	
	function clean()
	{
		clean_base();
	}

	function update()
	{	
		if(up.w>w) { x_knob=x/(up.w-w); } else { x_knob=0; }
		if(up.h>h) { y_knob=y/(up.h-h); } else { y_knob=0; }
		
		update_base();
	}
	
	function input(snapshot)	// called on mouse or button or keyboard interaction, pass in the replay class containing data
	{
		if(top.focus==this)
		{
		var dat;
			dat=dupe_snapshot(snapshot);
			mc.localToGlobal(dat);
			up.mc.globalToLocal(dat);
			
			mc_base._visible=false;
			mc_over._visible=false;
			mc_down._visible=true;

			x=top.focus_data.orig_x + dat.x - top.focus_data.x ;
			y=top.focus_data.orig_y + dat.y - top.focus_data.y ;
			
			if((x+w)>up.w) { x=up.w-w; }
			if((y+h)>up.h) { y=up.h-h; }
			if(x<0) { x=0; }
			if(y<0) { y=0; }
			
//			update();
				
			if( (snapshot.key_off&1) )
			{
//				dbg.print("up");
				
				onClick(top.focus);
				
				top.focus=null;
				return top.focus;
			}
		}
		else
		{
//			dbg.print("x="+snapshot.x+",y="+snapshot.y);
		
			if( (top.focus==null) && (snapshot.x>0) && (snapshot.y>0) && (snapshot.x<w) && (snapshot.y<h) )
			{
				if( (snapshot.key_on&1) )
				{
				
//					dbg.print("down");
					top.focus=this;
					top.focus_data=dupe_snapshot(snapshot);
					mc.localToGlobal(top.focus_data);
					up.mc.globalToLocal(top.focus_data);
					
					top.focus_data.orig_x=x;
					top.focus_data.orig_y=y;
					
					mc_base._visible=false;
					mc_over._visible=false;
					mc_down._visible=true;
					
					return top.focus;
				}
				else
				{
					mc_base._visible=false;
					mc_over._visible=true;
					mc_down._visible=false;
				}
			}
			else
			{
				mc_base._visible=true;
				mc_over._visible=false;
				mc_down._visible=false;
			}
		}
		
		top.focus=input_base(snapshot); // filter down until it gets handled
		return top.focus;
	}
	
}
