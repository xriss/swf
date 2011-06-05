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
#CLASSNAME = CLASSNAME or "GizmoLine"..CLASSVERSION
class #(CLASSNAME)
{

	var str; // string to be displayed
	var str_disp; // last string we displayed, compare to str to check for update
	
	var xp,yp;	// scroll position of text
	var xs,ys;	// size of text
	
	var tf;
	var tf_fmt;
	
	var base_alpha;
	
	var state;
	var state_disp;
	
#include "../wetsrc/Gizmo.base.inc.as"


	function #(CLASSNAME)(_up)
	{
		up=_up;
		setup();
		
		str="";
		str_disp="";
		
		state="";
		state_disp="";
		
		xp=0;
		yp=0;
		
		xs=0;
		ys=0;
		
		base_alpha=100;
		
	}
	
	function setup()
	{
		setup_base();
		mc.cacheAsBitmap=true;
		
		
		
		tf=#(GFX).create_text_html(mc,null,0,0,0,0);
		tf.multiline=false;

		tf_fmt=#(GFX).create_text_format(16,0xffffff);
		
		tf.setNewTextFormat(tf_fmt);
		
	}
	
	function clean()
	{
		clean_base();
	}

	function update()
	{
	var ext;
	
		if((str!=str_disp) || (state!=state_disp) )// update new string
		{
//			#(GFX).set_text_html(tf,tf_size,tf_argb,str);

			if(state=="selected")
			{
				tf_fmt.bold=true;
			}
			else
			{
				tf_fmt.bold=false;
			}
			
			ext=tf_fmt.getTextExtent(str);
			
			xs=ext.width;//*1.1; // because getTextExtents is broken?
			ys=ext.height;//*1.1;
			
			tf._width=xs+100;
			tf._height=ys+8;

			
			tf.setNewTextFormat(tf_fmt);
			tf.text=str;
			
			str_disp=str;
			state_disp=state;
		}
		
		if((tf.textWidth+4)>w)
		{
//			draw_mask(xp-top.spine*((tf.textWidth+4)-w),0);
//			tf._x=xp-top.spine*((tf.textWidth+4)-w);
		}
		else
		{
//			draw_mask(xp,0);
//			tf._x=xp;
		}
		tf._y=yp;
		
		mc._alpha-=5;
		if(mc._alpha < base_alpha) { mc._alpha=base_alpha; }
		
		
	
		update_base();
	}
	
	function input(snapshot)	// called on mouse or button or keyboard interaction, pass in the replay class containing data
	{		
		if( (top.focus==null) && (snapshot.x>0) && (snapshot.y>0) && (snapshot.x<w) && (snapshot.y<h) )
		{
			mc._alpha=100;
			up.hover=this;
			
			if( (snapshot.key_on&1) )
			{
				if(onClick)
				{
					onClick(this);
				}
				else
				if(up.onClick)
				{
					up.onClick(this);
				}
			}
		}
			
		input_base(snapshot); // filter down until it gets handled
		return top.focus;
	}
	
}
