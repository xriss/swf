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
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// a collection of static functions, pass in a class to use them with that main class
// intended to be called from the main class of games using that main class pointer


class MainStatic
{
	static var w=800;
	static var h=600;

	static	var wide=false;
	static	var notwide=false;
	static	var half=true;
		
	static function choose_and_apply_scalar(me,flags)
	{
	var i;
		var aa=flags.split(",");
		var flag;
		
		if( _root.talk && (_root.popup==_root.talk) ) // ploped over half the screen
		{
			half=true;
		}
		else
		{
			half=false;
		}
		
		for(i=0;i<aa.length;i++)
		{
			flag=aa[i];
	
			if(flag=="800x600")
			{
				w=800;
				h=600;
			}
			else
			if(flag=="640x480")
			{
				w=640;
				h=480;
			}
			else
			if(flag=="wide")
			{
				wide=true;
				half=false;
			}
			else
			if(flag=="nothalf") // half
			{
				half=false;
			}
			else
			if(flag=="notwide") // half
			{
				wide=false;
				notwide=true;
			}
		}
		_root.scalar.bx=w;
		_root.scalar.by=h;

//pick which size we require depending on available space/aspect
	
		if(_root.scale=="fixed") // non scale mode?
		{
			if( (!notwide) ) // && ( wide || (Stage.width >= 1.5*w) ) )
			{
				gfx.setscroll(me.mc, 0, 0, 1.5*w,h);
				_root.scalar.ox=1.5*w;
				_root.scalar.oy=h;
				_root.scalar.wide=true;
			}
			else
			{
				gfx.setscroll(me.mc, 0, 0, w,h);
				_root.scalar.ox=w;
				_root.scalar.oy=h;
				_root.scalar.wide=false;
			}
		}
		else
		if( (!notwide) && ( wide || ( ( Stage.width / Stage.height ) > (((w/h)+(1.5*w/h))/2) ) ) )
		{
			if(_root.scalar.ox!=1.5*w)
			{
				gfx.setscroll(me.mc, 0, 0, 1.5*w,h);
				_root.scalar.ox=1.5*w;
				_root.scalar.oy=h;
				_root.scalar.wide=true;
			}
		}
		else
		{
			if(_root.scalar.ox!=w)
			{
				gfx.setscroll(me.mc, 0, 0, w,h);
				_root.scalar.ox=w;
				_root.scalar.oy=h;
				_root.scalar.wide=false;
			}
		}
		
//		apply_800x600_scale(_root.mc_popup);
		
		_root.scalar.apply(me.mc,half);
		_root.scalar.apply(_root.mc_popup,half);
		_root.scalar.apply(_root.mc_swish,half);
		
		_root.scalar.apply(_root.__mochiservicesMC);
		_root.__mochiservicesMC._xscale*=1.5;
		_root.__mochiservicesMC._yscale*=1.5;
		
		_root.__mochiservicesMC.swapDepths(16385);
	}
	
	static function apply_800x600_scale(m)
	{
		m._xscale=100*w/800;
		m._yscale=100*h/600;
	}
	
	static function get_base_context_menu(me,ncm)
	{
	var cm;
	var cmi;
	var f;
	
		if(ncm)
		{
			cm=ncm;
		}
		else
		{
			cm = new ContextMenu();
			cm.hideBuiltInItems();
		}
		
		

		f=function()
		{
			if( _root._quality == "MEDIUM" )
			{
				_root._quality="LOW";
			}
			else
			{
				_root._quality="MEDIUM";
			}
		};
		cmi = new ContextMenuItem("Toggle quality.", com.dynamicflash.utils.Delegate.create(me,f) );
		cm.customItems.push(cmi);
		
		f=function()
		{
			if( Stage["displayState"] == "normal" )
			{
				Stage["fullScreenSourceRect"] = undefined;
				Stage["displayState"] = "fullScreen";
				if( (!MainStatic.notwide) && ( MainStatic.wide || ( ( Stage.width / Stage.height ) > (((640/480)+(1.5*640/480))/2) ) ) )
				{
					Stage["displayState"] = "normal";
					Stage["fullScreenSourceRect"] = new flash.geom.Rectangle( 0,0 , 960,480 );
					Stage["displayState"] = "fullScreen";
				}
				else
				{
					Stage["displayState"] = "normal";
					Stage["fullScreenSourceRect"] = new flash.geom.Rectangle( 0,0 , 640,480 );
					Stage["displayState"] = "fullScreen";
				}
			}
			else
			{
				Stage["displayState"] = "normal";
			}
		};
		cmi = new ContextMenuItem("Toggle fullscreen mode.", com.dynamicflash.utils.Delegate.create(me,f) );
		cm.customItems.push(cmi);

		f=function()
		{
			if( Stage["displayState"] == "normal" )
			{
				Stage["fullScreenSourceRect"] = undefined;
				Stage["displayState"] = "fullScreen";
				if( (!MainStatic.notwide) && ( MainStatic.wide || ( ( Stage.width / Stage.height ) > (((640/480)+(1.5*640/480))/2) ) ) )
				{
					Stage["displayState"] = "normal";
					Stage["fullScreenSourceRect"] = new flash.geom.Rectangle( 0,0 , 480,240 );
					Stage["displayState"] = "fullScreen";
				}
				else
				{
					Stage["displayState"] = "normal";
					Stage["fullScreenSourceRect"] = new flash.geom.Rectangle( 0,0 , 320,240 );
					Stage["displayState"] = "fullScreen";
				}
			}
			else
			{
				Stage["displayState"] = "normal";
			}
		};
		cmi = new ContextMenuItem("Toggle lowscreen mode.", com.dynamicflash.utils.Delegate.create(me,f) );
		cm.customItems.push(cmi);

		
		f=function()
		{
			this.state_next="menu";
		};
		cmi = new ContextMenuItem("Quit to Main Menu.", com.dynamicflash.utils.Delegate.create(me,f) );
		cm.customItems.push(cmi);
		
		f=function()
		{
			this.state_next="login";
		};
		cmi = new ContextMenuItem("Logout.", com.dynamicflash.utils.Delegate.create(me,f) );
		cm.customItems.push(cmi);

		cmi = new ContextMenuItem("#(VERSION_FULLTIME)",function(){},true,false);
		cm.customItems.push(cmi);
		
		return cm;
	}

// call general update functions, at the right time so mouse  and so on work well together

// returns an empty table, probably to be put in _root.updates for global use
	static function update_setup()
	{
		return new Array();
	}
	
	static function update_add(tab,func)
	{
		tab[tab.length]=func;
	}
	
	static function update_remove(tab,func)
	{
	var i;
		for(i=0;i<tab.length;i++)
		{
			if(tab[i]==func)
			{
//dbg.print("removed from updates");
				tab.splice(i,1);
				return;
			}
		}
	}
	
	static function update_do(tab)
	{
	var i;
	
		for(i=0;i<tab.length;i++)
		{
			tab[i]();
		}
	}
	
// given an input -1 0 +1  return 1 0 1 but as an S shapped curve
	static function spine(s)
	{
		if(s<0) { s=-s; }
		if(s>1) { s=1; }
		var ss=s*s;
		return((ss+(ss*2))-((ss*s)*2));
	}
// returns the 0 to 0.5 part of the spine curve ( a U bounce type curve with the floor at 1)
	static function spine_half(s)
	{
		if(s<0) { s=-s; }
		if(s>1) { s=1; }
		return spine(s*0.5)*2;
	}
	
}
