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
	
	var idx;
	
	var type;
	
	var flags;
	var score;
	
	
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
		
		score=0;
		
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
			if(_root._highquality<=1)
			{
				render(mc,0,0,100);
			}
			else
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
//			mc.cacheAsBitmap=true;
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

	function launch(_vx,_vy,pts)
	{
	var l;
	var p;
	
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
		
		if(pts && (pts!=0) ) // also show a score
		{
			
			p={x:0,y:0};
			l.mc.localToGlobal(p);
			up.up.up.over.mc.globalToLocal(p);
			up.up.up.over.add_floater("<b>"+pts+"</b><font size=\"12\">pts</font>",p.x,p.y);
			
			_root.wetplay.PlaySFX("sfx_jar",1);
		}
		
		up.over.bounces=0;
		
		return l;
	}
	function update_launch()
	{
		vy+=8;
		
		setxy(_x+vx,_y+vy);
//		mc._x+=vx;
//		mc._y+=vy;

		var dx=up.mc._xmouse-_x;
		
		if(up.up.state=="menu") // only on splash screen
		{
			if( dx*dx < 32*32 )
			{
				if( (_y-vy<up.mc._ymouse) && (_y>=up.mc._ymouse) )
				{
					if(vy>0)
					{
						setxy(_x, up.mc._ymouse );
						vy=-vy;
						
						up.bounces++;
						
						_root.wetplay.PlaySFX("sfx_boing",0);
			
					}
				}
			}
		}

		
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