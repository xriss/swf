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

class Vtard2d_react
{
	var up;
	
	var state;
	
	
	var hp_max;
	var hp;

	
	function Vtard2d_react(_up)
	{
		up=_up;
		
		setup();
		
		hp=100;
		hp_max=hp;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	
	function setup()
	{
		state="none";
	}
	
	function clean()
	{
	}

	function think_dam(replay)
	{
		if(up.state=="onfloor")
		{
			state="none";
		}
		
		return replay;
	}
	
	function think(replay)
	{
		switch(state)
		{
			case "dam":
				return think_dam();
			break;
		}
		
		return replay;
	}
	
	function draw_health()
	{
	var d;
	var r,g;
	
		if(hp_max&&hp<(hp_max))
		{
			if(!up.mc.hp)
			{
				up.mc.hp=gfx.create_clip(up.mc,100,0,5);
			}
			var m=up.mc.hp;
			
			d=(hp/hp_max);
			
			if( m.last_draw != d )
			{
				m.last_draw=d;
				
				gfx.clear(m);
				
				g=(d)*255;
				if(g<0){g=0;}
				if(g>255){g=255;}
				r=(1-d)*2*255;
				if(r<0){r=0;}
				if(r>255){r=255;}
				
				m.style.fill=0xff000000+(r<<16)+(g<<8);
				
				gfx.draw_box(m,0,-50*d,0,100*d,10);
				
			}
		}
	}
	
	function make_dead()
	{
		hp=0;
		
		var vt={};
		vt.name="loot_coin";
		vt.stack=10;

		up.hold.clean();

		up.item.setup(up.px,up.py,vt);
		
// we are still in the mobs list, but now we are loot.
// loot will delete itself when pickedup...

	}
	
	function launch_dam(it,vx,vy)
	{
		up.vx+=vx;
		up.vy+=vy;
		up.idle_anim="scared";
		state="dam";
		up.state="jump";
		
		
		up.brain.hitby(it,vx,vy);
		
		hp-=10;
		if(hp<=0) // deceased
		{
			make_dead();
		}
		
		draw_health();
	}
}
