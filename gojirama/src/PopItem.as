/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class PopItem
{
	var upmc;
	
	var mc;
	var mc2;

	var x,y;
	var _x,_y;
	var vx,vy;
	
	function PopItem(_upmc)
	{
		upmc=_upmc;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	
	static function setup_pops()	// return a new array of items
	{
	var	aa=new Array();
		
		return aa;
	}
	static function insert_pops(aa, _mc, nam, xx,yy,_vx,_vy)
	{
	var l;
	
		l=new PopItem(_mc);
		
		l.setup(nam);
		l.setxy(xx,yy);
		l.vx=_vx;
		l.vy=_vy;
		
		aa.push(l);
	}
	
	static function update_pops(aa)	// update all items in array
	{
	var i;
		for(i=0;i<aa.length;i++)
		{
			if(aa[i].update())
			{
				aa[i].clean();
				aa.splice(i,1);
				i--;
			}
		}
	}
	static function clean_pops(aa)	// remove all items from array	
	{
		while(aa.length>0)
		{
			aa[0].clean();
			aa.splice(0,1);
		}
	}
	
	
	function setup(idx)
	{
		mc=gfx.create_clip(upmc,null);
		mc2=gfx.add_clip(mc,"swf_pop",null);
		mc2._x=-400*1.5;
		mc2._y=-300*1.5;
		mc2.gotoAndStop(idx);
		mc2._xscale=150;
		mc2._yscale=150;
		
	}
	function clean()
	{
		mc.removeMovieClip();
	}
	
	function setxy(setx,sety)
	{
		_x=setx;
		_y=sety;
		if(mc)
		{
			mc._x=setx;
			mc._y=sety;
		}
	}

	function update()
	{
		vy+=8;
		
		setxy(_x+vx,_y+vy);
		
		mc._rotation+=vx;
		
		if(mc._y > 1200) return true;
	
		return false; // live
	}
	
}