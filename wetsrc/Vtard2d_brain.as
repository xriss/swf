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

class Vtard2d_brain
{
	var up;
	
	var flavour;
	
	var replay;
	
	
	var vx=0;
	
	function Vtard2d_brain(_up,_flavour)
	{
		up=_up;
		
		replay=new Replay();
		
		setup(_flavour);
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	
	function setup(_flavour)
	{
		flavour=_flavour;
		
		vx=-1;
		
		up.fizix=up.fizix_walk;
	}
	
	function clean()
	{
	}
	
	function hitby(it,_vx,_vy)
	{
		if(_vx<0)
		{
			vx=1;
		}
		else
		{
			vx=-1;
		}
	}

	function think_roam()
	{
	var cf,cw,cd;
	var attack=false;
		
		if(up.state=="onfloor")
		{
			if(vx<0)
			{
				cd=up.up.getcol(up.cx-1,up.cy+2,1);
				cf=up.up.getcol(up.cx-1,up.cy+1,1);
				cw=up.up.getcol(up.cx-1,up.cy-1,1);
				if(((cf==0)&&(cd==0))||(cw!=0)) { vx=1; }
			}
			else
			if(vx>0)
			{
				cd=up.up.getcol(up.cx+1,up.cy+2,1);
				cf=up.up.getcol(up.cx+1,up.cy+1,1);
				cw=up.up.getcol(up.cx+1,up.cy-1,1);
				if(((cf==0)&&(cd==0))||(cw!=0)) { vx=-1; }
			}
			
			var p=up.up.player;
			var dx,dy;
			
			dx=p.px-up.px;
			dy=p.py-up.py;
			if((dy*dy)<(100*100))
			{
				if( ((up.hold.mc.hxs<0)&&(dx<0)) || ((up.hold.mc.hxs>0)&&(dx>0)) )
				{
					if((dx*dx)<(200*200))
					{
						attack=true;
					}
				}
			}
		}
		
		
		replay.update();
		if(vx<0)
		{
			replay.play_key_on(Replay.KEY_LEFT);
			replay.play_key_off(Replay.KEY_RIGHT);
		}
		else
		if(vx>0)
		{
			replay.play_key_off(Replay.KEY_LEFT);
			replay.play_key_on(Replay.KEY_RIGHT);
		}
		else
		{
			replay.play_key_off(Replay.KEY_LEFT);
			replay.play_key_off(Replay.KEY_RIGHT);
		}
		if(attack)
		{
			replay.play_key_on(Replay.KEY_FIRE);
		}
		else
		{
			replay.play_key_off(Replay.KEY_FIRE);
		}
		
		return replay;
	}
	function think()
	{
		switch(flavour)
		{
			case "roam":
				return think_roam();
			break;
		}
		
		return replay;
	}
	
}
