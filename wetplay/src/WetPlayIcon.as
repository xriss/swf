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

#include "src/opts.as"


//
// Throbing icon in TR corner, turns into player interface when mouse is moved over it
//

class WetPlayIcon
{
	var mcs;
	var mc;
	
	var wetplayMP3:WetPlayMP3;
	var wetplayGFX:WetPlayGFX;
	
	var mc_play_icon;
	
	var wall;
	var hall;
	var xall;
	var yall;
	
	var scale_800x600;
	var mute;
	
	var update_do;

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function get_width()
	{
		if(scale_800x600)
		{
			return 800;
		}
		else
		{
			return Stage.width;
		}
	}
	function get_height()
	{
		if(scale_800x600)
		{
			return 600;
		}
		else
		{
			return Stage.height;
		}
	}
	
	function WetPlayIcon(stropts)
	{
	var i;
		scale_800x600=false;
		mute=false; // special mode for the mute game
	
		if(stropts)
		{
		var aaopts;
		var opt;
	
			aaopts=stropts.split(",");
			for(i=0; i<aaopts.length ; i++ )
			{
				switch(aaopts[i])
				{
					case "scale_800x600":
						scale_800x600=true;
					break;
					
					case "mute":
						mute=true;
					break;
				}
			}
		}
	}
	
	var donelogindone=false;
	function logindone()
	{
		if(!donelogindone) // only do once
		{
			setup();
			donelogindone=true;
		}
		
		if(mute) { return; }
		
		if(_root.login.opt_sound) // make sure sound is on
		{
			wetplayMP3.set_vol(50);
		}
		else // make sure sound is off
		{			
			wetplayMP3.set_vol(0);
		}
	}
	
	function setup()
	{
	
		mcs=gfx.create_clip(_root,16384+32-16);
		mc=gfx.create_clip(mcs);
		
		
		mc_play_icon=gfx.add_clip(mc,"WetPlayIcon",null,get_width()-11,11);
//		mc.onEnterFrame=delegate(update);
		
		wetplayGFX=new WetPlayGFX(this);
		wetplayMP3=new WetPlayMP3(this);
		
		wall=(wetplayMP3.w+wetplayMP3.x*2);
		hall=(wetplayMP3.h+wetplayMP3.y*2);
		xall=(wetplayMP3.x*2);
		yall=(wetplayMP3.y*2);
		
// create a filter
//	    wetplayMP3.mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 20, 20, 2, 3) ];

		wetplayMP3.setup();
//		wetplayMP3.mc._visible=false;
		wetplayMP3.mc.dx=get_width()+xall;
		wetplayMP3.mc.dy=-hall;
		wetplayMP3.mc._x=wetplayMP3.mc.dx;
		wetplayMP3.mc._y=wetplayMP3.mc.dy;
		wetplayMP3.mc.ox=wetplayMP3.mc._x;
		wetplayMP3.mc.oy=wetplayMP3.mc._y;
		wetplayMP3.mc.idx=0;
		
		
		if(mute)
		{
			wetplayMP3.set_vol_start(100,false);
		}
		
		update_do=delegate(update,null);
		MainStatic.update_add(_root.updates,update_do);
	}

	function clean()
	{
		MainStatic.update_remove(_root.updates,update_do);
		update_do=null;
	}
	
	function update()
	{
		if(scale_800x600) // scale everything to standard size
		{
			_root.scalar.apply(mcs);
		}		
		
		mc_play_icon._x=get_width()-11;
		mc_play_icon._y=11;
		
// show or hide wetplay ?

		var pok=_root.poker.snapshot();
		mc.globalToLocal(pok);

		if(_root.popup==wetplayMP3)
		{
			if( ( (pok.x<(get_width()-(wall-(xall/2)))) || (pok.y>hall) ) && ((!_root.poker.poke_now)&&(!_root.poker.poke_up)) )
			{
				wetplayMP3.mc._visible=false;
				_root.popup=null;
			}	
		}
		else
		if((!_root.popup)&&(!mute))
		{
			if( (pok.x>(get_width()-20)) && (pok.y<20) && ((!_root.poker.poke_now)&&(!_root.poker.poke_up)) )
			{
				_root.popup=wetplayMP3;
				wetplayMP3.mc._visible=true;
				wetplayMP3.mc._x=get_width()-(wall-(xall/2));
				wetplayMP3.mc._y=yall/2;
			}
			else
			{
				wetplayMP3.mc._visible=false;
			}
		}
		else
		{
// autohide if something steal focus
			wetplayMP3.mc._visible=false;
			if( (_root.popup==wetplayMP3) )
			{
				_root.popup=null;
			}
		}
		
		if(_root.popup)
		{
			mc_play_icon._visible=false;
		}
		else
		{
			mc_play_icon._visible=true;
		}
		mc_play_icon._xscale=50+wetplayMP3.throbe*150;
		mc_play_icon._yscale=mc_play_icon._xscale;
		mc_play_icon._alpha=60;
			
// always update these parts

		wetplayMP3.update();
	}
	
	
	
	function PlaySFX(nam,chan,loops,vol)
	{
		return wetplayMP3.PlaySFX(nam,chan,loops,vol);
	}
	
}


