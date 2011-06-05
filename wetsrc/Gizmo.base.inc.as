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


	var mc:MovieClip;
	var mcm;  // mask layer (possibly)

	var up;			// parent container
	
	var x,y;		// this pos (topleft)
	var w,h;		// this size
	
	var gizmos;		// array of children
	var top;		// the top most gizmo

	var	active;		// only gizmos flaged active are uhm active
	
	var onClick;	// callback when clicked

// vars for the top only

	var focus;		// the child gizmo that holds focus
	var focus_data;	// and an associated object (when this object has focus)

	
	function setup_base()
	{
		mc=#(GFX).create_clip(up.mc,null);

		mc.style=up.mc.style;
		
		gizmos=new Array();
		
		active=true;
		
		focus=null;
		focus_data=null;
		
		top=up.top;
		if(top==null)
		{
			top=this;
		}
		
	}
	
	function clean_base()
	{
	var i,v;
	
		
		for(i=0;i<gizmos.length;i++)
		{
			if(gizmos[i].active)
			{
				gizmos[i].clean();
			}
		}

		mc.removeMovieClip(); mc=null;
	}

	function update_base()
	{	
	var i,v;
	
		mc._x=x;
		mc._y=y;
	
		for(i=0;i<gizmos.length;i++)
		{
			if(gizmos[i].active)
			{
				gizmos[i].mc._visible=true;
				gizmos[i].update();
			}
			else
			{
				gizmos[i].mc._visible=false;
			}
		}
	}
	
	static function dupe_snapshot(snapshot)
	{
	var ret;
	
		ret={};
		
		ret.key=snapshot.key;
		ret.key_on=snapshot.key_on;
		ret.key_off=snapshot.key_off;
		
		ret.x=snapshot.x;
		ret.y=snapshot.y;

		ret.frame=snapshot.frame;
		
		return ret;
	}
	
	function input_base(snapshot)
	{
	var i,v;
	var newsnap;
	
	
		newsnap=dupe_snapshot(snapshot);
		mc.localToGlobal(newsnap);

		for(i=0;i<gizmos.length;i++)
		{
			if(gizmos[i].active)
			{
				gizmos[i].mc.globalToLocal(newsnap);
			
				gizmos[i].input(newsnap);
					
				gizmos[i].mc.localToGlobal(newsnap);
			}
		}
		
		return top.focus;
	}

	
// use g=gp.child(new Gizmo(gp));
//
// where gp is the gizmo parent and the newly created gizmo is returned

	function child(g)
	{
	var i,v;
	
		i=gizmos.length;
		gizmos[i]=g;
		
		return g;
	}
	

	function set_area(_x,_y,_w,_h)
	{
		x=_x;
		y=_y;
		w=_w;
		h=_h;
	}

	function draw_mask(px,py)
	{
		#(GFX).setscroll(mc,px, py, w, h);
//		mc.scrollRect=new flash.geom.Rectangle(px, py, w, h);
	
/*	
		if(!mcm)
		{
//		mcm.removeMovieClip();
			mcm=#(GFX).create_clip(up.mc,null);
//			mcm._visible=false;
			mc.setMask(mcm);
		}
		
		#(GFX).clear(mcm);
		#(GFX).draw_box(mcm,null,x,y,w,h);		
*/

	}
	
	