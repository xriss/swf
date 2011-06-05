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



class PlayChat
{
	var up;
	
	var mc;

	var active=false;
	
	var state="none";
	
	var speed=2;
	var id;
	
	var txt;
	
	var height;
	var time;
	
	var pos;
	var show_height;
	
	var new_txt;
	var new_state;
	
	var seen_count;
	
	function PlayChat(_up)
	{
		up=_up;
	}

	function setup(_pos)
	{
		pos=_pos;
		txt=null;
		
		mc=gfx.create_clip(up.mc,null);
		mc._x=0;
		mc._y=480;
		
		mc.draw=gfx.create_clip(mc,null);
		mc.draw.cacheAsBitmap=true;
				
		mc.draw.tf=gfx.create_text_html(mc.draw,null,20,20,640-40,240);
		
		
		state="none";
		
		hide();
		time=10000;
		show_height=0; // start off hidden
	}

	function clean()
	{
		mc.removeMovieClip();
	}
	
	
	function show(_txt)
	{
		if(_txt==undefined)
		{
			hide();
		}
		else
		{
			new_txt=_txt;
			new_state="show";
		}
	}
	
	function hide()
	{
		new_state="hide";
	}
// defer updates	
	function showhide()
	{
		if(new_state=="show")
		{
			if((state!="show")||(txt!=new_txt))
			{
				if(new_txt)
				{
					txt=new_txt;
					gfx.set_text_html(mc.draw.tf,32,0xffffff,txt);
				}
				else
				{
					txt=null
					return;
				}
				
				state="show";
				speed=1;
				
				height=40+mc.draw.tf.textHeight;
				time=0;
				
				gfx.clear(mc.draw);
				mc.draw.style.fill=0xff000000;
				if(pos=="top")
				{
					gfx.draw_box(mc.draw,0,0,-240,640,240+height);
				}
				else
				{
					gfx.draw_box(mc.draw,0,0,0,640,480);
				}
				seen_count=0;
			}
		}
		else
		if(new_state=="hide")
		{
			if(state!="hide")
			{
				up.play.player.idle_anim="idle";
					
				if(height!=0)
				{
					speed=1;
					state="hide";
					time=0;
				}
				seen_count=0;
			}
		}
		
		new_state="none";
	}
	
	function update()
	{
	var d;
	
		showhide(); // check for state change

		if(state=="show")
		{
			if(height!=show_height)
			{
				d=(height)-show_height;
				d=d*0.125;
				if(d>0) d=Math.ceil(d);
				if(d<0) d=Math.floor(d);
				
//				if(d>10)  {d=10;}
//				if(d<-10) {d=-10;}
				
				if(d*d<1)
				{
					mc._visible=true;
					show_height=height;
				}
				else
				{
					mc._visible=true;
					show_height+=d;
				}
			}
			else
			{
				seen_count++;
			}
			
		}
		else
		if(state=="hide")
		{
			if(height!=0)
			{
				d=(0)-show_height;
				d=d*0.125;
				if(d>0) d=Math.ceil(d);
				if(d<0) d=Math.floor(d);
				
				if(d>3)  {d=3;}
				if(d<-3) {d=-3;}
				
				if(d*d<1)
				{
					mc._visible=false;
					show_height=0;
				}
				else
				{
					mc._visible=true;
					show_height+=d;
				}
			}
		}
		
		if(pos=="top")
		{
			if( mc._visible )
			{
				mc._y=-height+show_height;
			}
		}
		else
		{
			if( mc._visible )
			{
				mc._y=480-show_height;
			}
		}
	}
}


