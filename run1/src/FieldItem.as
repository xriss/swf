/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class FieldItem
{
	var up;
	
	var mc;
	
	var type;
	
	var flags;
	
	var x,y;
	var _x,_y;
	var vx,vy;
	
	var locked;
	
	var mc2;
	
	function FieldItem(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function setup(nam)
	{
		mc=gfx.create_clip(up.mc,null);
//		mc={};
		
		locked=false;
		
		type=nam;
		
		flags=0;
		
		x=0;
		y=0;
		vx=0;
		vy=0;
		
		
		draw();
	}
	
	function draw(src)
	{
	var siz=2.00;
	
		gfx.clear(mc);
		mc2.removeMovieClip();
		mc2=null;
		
		switch(type)
		{
			case null:
			break;
			
			case "fire":
			
			if(_root._highquality<=1)
			{
				render(mc,0,0,100);
			}
			else
			{
				render(mc,0,0,100);
				mc2=gfx.add_clip(mc,"obj_fire",1);
				mc2._xscale=100*siz;
				mc2._yscale=100*siz;
			}
			break;
			
			case "earth":
			if(_root._highquality<=1)
			{
				render(mc,0,0,100);
			}
			else
			{
				render(mc,0,0,100);
				mc2=gfx.add_clip(mc,"obj_earth",1);
				mc2._xscale=100*siz;
				mc2._yscale=100*siz;
			}
			break;
			
			case "air":
			if(_root._highquality<=1)
			{
				render(mc,0,0,100);
			}
			else
			{
				render(mc,0,0,100);
				mc2=gfx.add_clip(mc,"obj_air",1);
				mc2._xscale=100*siz;
				mc2._yscale=100*siz;
			}
			break;
			
			case "water":
			if(_root._highquality<=1)
			{
				render(mc,0,0,100);
			}
			else
			{
				render(mc,0,0,100);
				mc2=gfx.add_clip(mc,"obj_water",1);
				mc2._xscale=100*siz;
				mc2._yscale=100*siz;
			}
			break;
			
			case "ether":
//			if(_root._highquality<=1)
//			{
//				render(mc,0,0,100);
//			}
//			else
			{
				render(mc,0,0,100);
				mc2=gfx.add_clip(mc,"obj_meta",1);
				mc2._xscale=100*siz;
				mc2._yscale=100*siz;
			}
			break;
		}
		
		if(_root._highquality==2)
		{
			gfx.dropshadow(mc,5, 45, 0x000000, 1, 10, 10, 2, 3);
		}
		else
		{
			mc.filters=null;
			mc.cacheAsBitmap=true;
		}
		
		if((src!=undefined)&&(src!=this))
		{
			mc2.gotoAndStop(1);
			mc2.gotoAndStop(src.mc2._currentframe);
			mc2._rotation=src.mc2._rotation;
		}
		else
		{
			mc2.gotoAndStop(1);
			mc2.gotoAndStop((up.rnd()%20)+1);
			mc2._rotation=(up.rnd()%360);
		}
	}
	
	function render(_mc,dx,dy,siz)
	{
/*
		if(_root._highquality<=1)
		{
			switch(type)
			{
				case null:
				break;
				
				case "fire":
					_mc.style.out=0xff000000;
					_mc.style.fill=0xffff0000;
					gfx.draw_box(_mc,(siz*0.10),dx-(siz*0.40),dy-(siz*0.40),(siz*0.80),(siz*0.80));
				break;
				
				case "earth":
					_mc.style.out=0xff000000;
					_mc.style.fill=0xff00ff00;
					gfx.draw_box(_mc,(siz*0.10),dx-(siz*0.40),dy-(siz*0.40),(siz*0.80),(siz*0.80));
				break;
				
				case "air":
					_mc.style.out=0xff000000;
					_mc.style.fill=0xffffff00;
					gfx.draw_box(_mc,(siz*0.10),dx-(siz*0.40),dy-(siz*0.40),(siz*0.80),(siz*0.80));
				break;
				
				case "water":
					_mc.style.out=0xff000000;
					_mc.style.fill=0xff0000ff;
					gfx.draw_box(_mc,(siz*0.10),dx-(siz*0.40),dy-(siz*0.40),(siz*0.80),(siz*0.80));
				break;
				
				case "ether":
					_mc.style.out=0xff000000;
					_mc.style.fill=0xffffffff;
					gfx.draw_box(_mc,(siz*0.10),dx-(siz*0.40),dy-(siz*0.40),(siz*0.80),(siz*0.80));
				break;
			}
		}
		else
*/
		{
/*
			_mc.style.out=0x80000000;
			_mc.style.fill=0x80000000;
			gfx.draw_box(_mc,0,dx-(siz*0.40),dy-(siz*0.40),(siz*0.80),(siz*0.80));
*/
		}		
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

	static function hard_launch(upp,typ,xx,yy,_vx,_vy)
	{
	var l;
	
		l=new FieldItem(upp.over);
		
		l.setup(typ);
		l.draw();
		l.setxy(xx,yy);
		l.vx=_vx;
		l.vy=_vy;
		
//		gfx.clear(mc);
		l.mc.filters=null;
		l.mc.cacheAsBitmap=true;

		l.mc._xscale=75;
		l.mc._yscale=75;

		l.mc2.play();

		upp.launches.push(l);

		return l;
	}
	
	function launch(_vx,_vy)
	{
	var l;
	
		l=new FieldItem(up.over);
		
		l.setup(this.type);
		l.draw(this);
		l.setxy(_x,_y);
//		l.mc._x=mc._x;
//		l.mc._y=mc._y;
		
		l.vx=_vx;
		l.vy=_vy;
		
		gfx.clear(mc);
		l.mc.filters=null;
		l.mc.cacheAsBitmap=true;

		l.mc._xscale=125;
		l.mc._yscale=125;
		

		
		l.mc2.play();
			
		up.launches.push(l);
		
		return l;
	}
	function update_launch()
	{
		vy+=8;
		
		setxy(_x+vx,_y+vy);
//		mc._x+=vx;
//		mc._y+=vy;
		
		mc._rotation+=vx;
		
		if(mc._y > 1200) return true;
	
		return false; // live
	}
	
	function clean()
	{
		mc2.removeMovieClip();
		mc.removeMovieClip();
	}

	function update()
	{
	}	
	
	function nextframe()
	{
		mc2.gotoAndStop(((mc2._currentframe+0)%20)+1);
	}
}