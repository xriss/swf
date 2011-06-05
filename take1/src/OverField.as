/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class OverField
{
	var up;
	
	var mc_scalar;
	var mc;
	
	var tab_w;
	var tab_h;
	var tab;
	
	var types;
	
	var focus;
	
	var state;
	
	var launches;
	
	var mctop;
	var mcptop;
	
	var mctop_depth;
	var mcptop_depth;
	
	var ripple_wait;
	var ripple_idx;
	
	var swish_t;
	var swish_from;
	var swish_to;
	
	var chain;
	var over;
	
	var available_moves;
	
	var freeze_count;
	
	var floaters;
	
	var pixls;
	
	function OverField(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}
	
	function setup(nam)
	{
	var it;
	var idx;
	var x,y;
	var i;
	
	
		mc_scalar=gfx.create_clip(up.mc,null);
		
		mc=gfx.create_clip(mc_scalar,null);
		
		over=new Object();
		over.up=up;
		over.mc=gfx.create_clip(mc_scalar,null);

		tab_w=8;
		tab_h=8;
		
		types=new Array("fire","earth","air","water","ether");
		for(i=0;i<5;i++)
		{
			types[ types[i] ]=i;
		}
		
		launches=new Array();
				
		floaters=new Array();
		
		_root.poker.clear_clicks();
		
		update_do=delegate(update,null);
		MainStatic.update_add(_root.updates,update_do);
		
		pixls=new OverPixls(this); pixls.setup();
	}
	
	var update_do;
	
	function clean()
	{	
		MainStatic.update_remove(_root.updates,update_do);
		update_do=null;
		
		while(launches.length)
		{
			launches[0].clean();
			launches.splice(0,1);
		}
		
		while(floaters.length)
		{
			floaters[0].clean();
			floaters.splice(0,1);
		}
		
		mc.removeMovieClip();		
	}

	
	function update()
	{
	var i;

	for(i=0;i<launches.length;i++)
		{
			if(launches[i].update_launch())
			{
				launches[i].clean();
				launches.splice(i,1);
				i--;
			}
		}
		
	for(i=0;i<floaters.length;i++)
		{
			if(floaters[i].update())
			{
				if(replace_this_floater==floaters[i]) {replace_this_floater=null; } 
				
				floaters[i].clean();
				floaters.splice(i,1);
				i--;
			}
		}

		pixls.update();
	}
	
	var replace_this_floater;
	
	function replace_floater(str,xx,yy)
	{
		replace_this_floater.mc._alpha=0; // remove last floater and make a new one
		
		return add_floater(str,xx,yy)
	}
	
	function add_floater(str,xx,yy)
	{
	var l;
	
		l=new OverItem(this);
		
		l.setup("score",{str:str});
		l.setxy(xx,yy);
		l.vx=0;
		l.vy=-8;
		
		l.mc.filters=null;
		l.mc.cacheAsBitmap=true;

//		l.mc._xscale=75;
//		l.mc._yscale=75;

		floaters.push(l);

		replace_this_floater=l;
		
		return l;
	}
}