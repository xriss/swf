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

// some dumb particle fx


class RunParts
{
	var up;
	
	var mc;
	
	var parts;
	
	
	
	function RunParts(_up)
	{
		up=_up;
		parts=[];
		
		mc=gfx.create_clip(up.mc,null);
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}
	
	function rnd_range(a,b)
	{
		return a+((b-a)*(rnd()/65535));
	}
	
	function launch(x,y,id)
	{
	var b,i,m;
		b=parts.length;
	
		switch(id)
		{
			case "hearts":
				for(i=b;i<b+30;i++)
				{
					parts[i]=gfx.add_clip(mc,"particles_heart",null);
					m=parts[i];
					m._x=x+rnd_range(-10,10);
					m._y=y;
					m.vx=rnd_range(-4,4);
					m.vy=rnd_range(-8,-16);
				}
			break;
			
			case "confetti":
				for(i=b;i<b+30;i++)
				{
					parts[i]=gfx.create_clip(mc,null);
					m=parts[i];
					gfx.clear(m);
					gfx.draw_box(m,0,-4,-4,8,8);
					m.cacheAsBitmap=true;
					m._x=x+rnd_range(-10,10);
					m._y=y;
					m.vx=rnd_range(-4,4);
					m.vy=rnd_range(-8,-16);
				}
			break;
		}
		
	}
	
	function clean()
	{
			
		mc.removeMovieClip();
		mc=null;
	}
	
	function clear_parts()
	{
	var i,m;
		if(parts[0]) // if it contains any
		{
			for(i in parts)
			{
				m=parts[i];
				m.removeMovieClip();
			}
			parts=[];
		}
	}
	
	function update()
	{
	var i,m;
	var act=false;
		for(i in parts)
		{
			m=parts[i];
			if(m._visible)
			{
				m._x+=m.vx;
				m._y+=m.vy;
				
				m.vy+=0.5;
				
				if(m._y>100)
				{
					m._visible=false;
				}
				else
				{
/*
					if(up.getcol(x,y,0))
					{
						m._visible=false;
					}
*/
				}
				act=true;
			}
		}
		
		if(!act) // all dead remove them all
		{
			clear_parts();
		}
		return false;
	}
	
	
}
