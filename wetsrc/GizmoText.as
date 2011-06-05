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
#CLASSNAME = CLASSNAME or "GizmoText"..CLASSVERSION
class #(CLASSNAME)
{

	var str; //text to display
/*
	var items; // data item array
	var lines; // array of visible lines
	
	var lh; // height of each line
	
	var xp,yp; // base offset to display lines at
	var lp,lc; // line start , line count
*/	
	var tf;
	var tf_fmt;
	
	var fntsiz; //uses html
	var fntcol;
	
	var vgizmo; // vertical scroll gizmo
	var hgizmo; // horizontal scroll gizmo
/*	
	var selected;
	
	var base_alpha;
	
	var hover;
*/

#include "../wetsrc/Gizmo.base.inc.as"


	function #(CLASSNAME)(_up)
	{
		up=_up;
		setup();
	}
	
	function setup()
	{
		setup_base();
		mc.cacheAsBitmap=true;
		
//		mc.cacheAsBitmap=true;
		
		fntsiz=16;
		fntcol=0xffffff;
		tf_fmt=#(GFX).create_text_format(fntsiz,fntcol);
		
		tf=null;
/*		
		lp=0;
		lh=20;
		xp=0;
		yp=0;
		
		base_alpha=50;
		
		selected=-1;
		
		items=new Array();
		lines=new Array();
*/		
	}
	
	function clean()
	{
		clean_base();
	}

	function clear_tf()
	{
		tf.removeTextField();
		tf=null;
		tf.cachestr="";
	}
	
	function update()
	{
	
		if(tf==null)
		{
			tf=#(GFX).create_text_html(mc,null,0,0,w,h);
			tf.setNewTextFormat(tf_fmt);
		}
		
		if(tf.cachestr!=str)
		{
			tf.cachestr=str;
			#(GFX).set_text_html(tf,fntsiz,fntcol,str);
			
//dbg.print(tf.htmlText);
//dbg.print("size="+w+":"+h);
		}
		
		if(vgizmo)
		{
		var yp;
		
			yp=Math.floor((tf.maxscroll)*vgizmo.y_knob);
			if(yp<1) { yp=1; }
			
			if(yp!=tf.scroll) { tf.scroll=yp; }
			//dbg.print(yp+" : "+tf.scroll); }
		}
		
/*	
		var i,g,ln,it;
		var yp_max;
//		var yp_sub;

		lc=Math.floor((h+lh-1)/lh)+1;
		
		if(lc!=lines.length) // allocate display
		{
			for(i=0;i<lc;i++)
			{
				g=child(new GizmoLine(this));
				
				g.base_alpha=base_alpha;
			
				g.set_area(0,i*lh,w,lh);
				
				g.str="";

				g.tf_fmt.size=tf_fmt.size;
				g.tf_fmt.color=tf_fmt.color;
				
				lines[i]=g;
			}

			draw_mask(0,0);
		}
		
		yp_max=(items.length*lh)-h; // scroll amount, if non neg
		
		if(vgizmo)
		{
			if(yp_max>0)
			{
				yp=Math.floor(vgizmo.y_knob*yp_max);
			}
			else
			{
				yp=0;
			}
		}
		
		lp=Math.floor(yp/lh);
		
//		yp_sub=(yp-lp*lh);

		for(i=lp;i<lp+lc;i++)
		{
			ln=lines[i-lp];
				
				
			if( (i<0) || (i>=items.length) ) // blank item
			{
				ln.str="";
				ln.item=-1;
				ln.state="";
			}
			else
			{
				it=items[i];
				
				ln.str=it.str;
				ln.item=i;
				ln.state="";
				
				if(i==selected)
				{
					ln.state="selected";
				}
			}
		
			ln.set_area(0,(i*lh)-yp,w,lh);
//			ln.y=(i*lh)-yp;
		}
*/
		
		update_base();
	}
	
	function input(snapshot)	// called on mouse or button or keyboard interaction, pass in the replay class containing data
	{
		input_base(snapshot); // filter down until it gets handled
		return top.focus;
	}
	
}
