/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
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


// Collection of talky thingies


class TalkyBub
{
	var up;
	
//	var w,h;
	
	var active;
	
	var float_time;
	var float_str;
	var mc_floaterz;
	var mc_floater;
	var tf_floater;
	
	var origin_mc;
	var x,y;
	var snap;
	var offorg;
	
	var style;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

		
	function TalkyBub(_up,_orig,_x,_y,_offorg)
	{
		up=_up;
		
		origin_mc=_orig;
		x=_x;
		y=_y;
		offorg=_offorg;
		
		mc_floater=gfx.create_clip(up.mc,null);
		gfx.clear(mc_floater);
		mc_floater.w=200;
		mc_floater.h=80;
		mc_floaterz=gfx.create_clip(mc_floater,null);
		mc_floaterz._x=100;
		mc_floaterz._y=40;
		tf_floater=gfx.create_text_html(mc_floaterz,null,-100,0,200,200);
		
		tf_floater.cacheAsBitmap=true;
		
		gfx.dropshadow(mc_floater,5, 45, 0x000000, 0.5, 10, 10, 2, 3);

		float_str="";
		float_time=-100;
		
		active=false;
		snap=true;
		
	}
	
	function clean()
	{
		mc_floater.removeMovieClip();
	}
	
	function display(str,tim)
	{
		if(typeof(str)=="object")
		{
			str=str[(Math.floor(Math.random()*str.length))];
		}
	
		if((str!=null)&&(float_str!=str))
		{
			style="talk";
		
			float_str=str;
			
			
			gfx.set_text_html(tf_floater,18,0x000000,"<p align=\"center\">"+str+"</p>");			
			mc_floater.h=tf_floater.textHeight+6;
			
			if(mc_floater.h>206)
			{
				mc_floater.h=206; // clip to max text height
			}

			gfx.clear(mc_floaterz);
			mc_floaterz.style.out=0xffffffff;
			mc_floaterz.style.fill=0xffcccccc;
			gfx.draw_box(mc_floaterz,4,-100,-mc_floater.h/2,200,mc_floater.h);
			
			tf_floater._y=-mc_floater.h/2;
			mc_floaterz._y=mc_floater.h/2;
			
		}
		
		if( mc_floater.getDepth()!=up.topdepth) // bring to front
		{
			mc_floater.swapDepths(up.topdepth);
		}
			
		float_time=tim;
		
		active=true;
		
		update();
	}
	
	function display_act(str,tim)
	{
		if(typeof(str)=="object")
		{
			str=str[(Math.floor(Math.random()*str.length))];
		}
		
		if((str!=null)&&(float_str!=str))
		{
			style="act";
		
			float_str=str;
			
			
			gfx.set_text_html(tf_floater,18,0xffffff,"<p align=\"center\">"+str+"</p>");			
			mc_floater.h=tf_floater.textHeight+6;
			
			if(mc_floater.h>206)
			{
				mc_floater.h=206; // clip to max text height
			}
			
			tf_floater._y=-mc_floater.h/2;
			mc_floaterz._y=mc_floater.h/2;
			
			gfx.clear(mc_floaterz);
		}
		
		if( mc_floater.getDepth()!=up.topdepth) // bring to front
		{
			mc_floater.swapDepths(up.topdepth);
		}
			
		float_time=tim;
		
		active=true;
		
		update();
	}
	
	var lastpx=0;
	var lastpy=0;
	
	function update()
	{
	
		if(active)
		{
		var sx,sy;
		var px,py;
		var dx,dy;
		var nx,ny;
		var mx,my;
		var s,ss,ssx,ssy;
		var fx,fy;
		var qx,qy;
		
		
		var p;
		
			if(origin_mc)
			{
				if(offorg=="global")
				{
					p={x:0,y:0};
					origin_mc.localToGlobal(p);
					p.x+=x;
					p.y+=y;
					up.mc.globalToLocal(p);
				}
				else
				{
					p={x:x,y:y};
					origin_mc.localToGlobal(p);
					up.mc.globalToLocal(p);
				}
				
				lastpx=p.x;
				lastpy=p.y;
			}
			else
			{
				p={x:lastpx,y:lastpy};
			}
			
			if(style=="act")
			{
				if(float_time>0)
				{
					float_time--;
					mc_floater._visible=true;
					mc_floaterz._xscale=100;
					mc_floaterz._yscale=100;				
					mc_floater._alpha=100;
				}
				else
				{
					float_time--;
					
					mc_floaterz._xscale=100;
					mc_floaterz._yscale=100;
					
					mc_floater._alpha=100+float_time;
					
					if(float_time<=-100)
					{
						mc_floater._visible=false;
						active=false;
						snap=true;
					}
				}
				
				mc_floater._x=p.x - 100;
				mc_floater._y=p.y + float_time;
				
			}
			else // talk
			{
			
				if(float_time>0)
				{
					float_time--;
					mc_floater._visible=true;
					mc_floaterz._xscale=100;
					mc_floaterz._yscale=100;				
					mc_floater._alpha=100;
				}
				else
				{
					float_time--;
					
					mc_floaterz._xscale=100+float_time*10;
					mc_floaterz._yscale=mc_floaterz._xscale;
					mc_floater._alpha=100;
					
					if(float_time<=-10)
					{
						mc_floater._visible=false;
						active=false;
						snap=true;
					}
				}
			
				sx=mc_floater.w;
				sy=mc_floater.h;
				
				mx=up.w;
				my=up.h;
				
				if(p.x>(mx*3/4))
				{
					px=p.x-sx;
				}
				else
				{
					px=p.x;
				}
				if(p.y<(my/4))
				{
					py=p.y+80;
				}
				else
				{
					py=p.y-sy-80;
				}
				
				if(px<0) { px=0; }
				if(py<0) { py=0; }
				if(px>800-sx) { px=800-sx; }
				if(py>600-sy) { py=600-sy; }
				
				if(active)
				{
					if(snap)
					{
						mc_floater._x=px;
						mc_floater._y=py;
						snap=false;
					}
					else
					{
						mc_floater._x=mc_floater._x*0.75 + px*0.25;
						mc_floater._y=mc_floater._y*0.75 + py*0.25;
					}
				}
				
				if(float_time>0)
				{
				
					gfx.clear(mc_floaterz);
					mc_floaterz.style.out=0xffffffff;
					mc_floaterz.style.fill=0xffcccccc;
					
					dx=p.x-(mc_floater._x+mc_floaterz._x);
					dy=p.y-(mc_floater._y+mc_floaterz._y);
					ssx=dx*dx;
					ssy=dy*dy;
					ss=ssx+ssy;
					s=Math.sqrt(ss);
					if(s==0) {s=1; dx=0; dy=1;}
					nx=dx/s;
					ny=dy/s;
					
					mc_floaterz.lineStyle(undefined,undefined);
					mc_floaterz.moveTo(dx-nx*40,dy-ny*40);
					mc_floaterz.beginFill(0xffffff,100);
					mc_floaterz.lineTo(ny* mc_floater.h*0.25,nx*-mc_floater.h*0.25);
					mc_floaterz.lineTo(ny*-mc_floater.h*0.25,nx* mc_floater.h*0.25);
					mc_floaterz.lineTo(dx-nx*40,dy-ny*40);
					mc_floaterz.endFill();
			
					gfx.draw_box(mc_floaterz,4,-100,-mc_floater.h/2,200,mc_floater.h);
				}
			}
		}
		

		return false;
	}
	
}
