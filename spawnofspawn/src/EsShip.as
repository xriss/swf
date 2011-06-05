/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

//import com.wetgenes.gfx;
//import com.wetgenes.dbg;

class EsShip
{
	var mc;

	var up;
	
	var reload;
	
	var ss;
	
	var submerged;
	var fill_up;
	
	var hit;
	
	function EsShip(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function setup()
	{
	var s1,s2;
	
		ss=1;
	
		reload=0;
		
		mc=gfx.create_clip(up.mc,null);
		
		mc.lineStyle(8,0x00ff00,100);
		mc.beginFill(0x008000,50);

		s1=32;
		s2=24;
		
		
		mc.moveTo(-s1,-s2);
		mc.lineTo(s1,0);
		mc.lineTo(-s1,s2);
		mc.lineTo(-s1/2,0);
		mc.lineTo(-s1-s2);
		
		mc.endFill();
		
		reset();
			
//		mc._x=400;
//		mc._y=300;
		
		
		submerged=0;
		fill_up=0;
		
		hit=null;
	}
	
	function clean()
	{
		mc.removeMovieClip();
	}
	
	function reset()
	{
		fizix_setup(mc,0,-800,0,-32,1,32,34,4);
		_root.wetplay.PlaySFX("sfx_teleport",3);
	}

	function update()
	{
	var rad,deg,p,p1,p2;
	var vx,vy;
	var rx,ry,xr,yr;
	
	
		if(hit)
		{
			if(hit.type="pinger")
			{
				if(hit.oy>=mc.oy)
				{
					up.pinger.splat(hit);
				}
				else
				{
					reset();
				}
			}
			hit=null;
		}
	
	
		if(reload>0) { reload--; }
		if(fill_up>0) { fill_up--; }
		
	
		p=_root.poker.snapshot();
		mc._rotation=0;
		mc.globalToLocal(p);
		
		rad = Math.atan2(p.y,p.x);
        deg = Math.round(rad*180/Math.PI);

		mc._rotation=deg;
				

		if((p.key&1)&&(reload==0)&&(up.tank>0))
		{
			up.tank-=1;
			p1={x:32,y:0};
			mc.localToGlobal(p1);
			p2={x:p1.x,y:p1.y};
			mc._rotation=0;
			mc.globalToLocal(p1);
			mc._rotation=deg;
			up.mc.globalToLocal(p2);
			up.shot.shoot(p2.x,p2.y,p1.x,p1.y);
			mc.vx-=p1.x/2;
			mc.vy-=p1.y/2;
			reload=8;
			
			_root.wetplay.PlaySFX("sfx_shot",0);
		}

		mc.ox=mc._x; // remember old pos
		mc.oy=mc._y;
		fizix_update(mc);
		
		if(mc.hit)
		{
/*
			up.heart.reset(mc.hit);
			fizix_setup(mc,0,-800,0,-32,1,32,34,4);
			
			_root.wetplay.PlaySFX("sfx_teleport",3);	
*/
			
		}
		
var s,sy,cy;
		cy=up.back.GetYcol(mc._x);
		sy=(cy.y/*-cy.wet*/)-mc._y;
		
//		if(mc.min_dd<sy*sy) { sy=Math.sqrt(mc.min_dd); }
		
		if(sy>200)
		{
			s=200/sy;
			if(s<(1/8)) { s=(1/8); }
			if(s>(1/2)) { s=(1/2); }
		}
		else
		{
			s=1/2;
		}
		ss=ss*0.75+s*0.25;
		
		up.mc._xscale=100*ss;
		up.mc._yscale=100*ss;
		
		rx=mc._x-(400/ss);
		ry=mc._y-(300/ss);
		xr=_root.scalar.ox/ss;
		yr=_root.scalar.oy/ss;
		
		if(rx< up.back.min_view_x)		rx=up.back.min_view_x;
		if(ry< up.back.min_view_y)		ry=up.back.min_view_y;
		if(rx+xr> up.back.max_view_x)	rx=up.back.max_view_x-xr;
		if(ry+yr> up.back.max_view_y)	ry=up.back.max_view_y-yr;
		
		
		up.mc.scrollRect=new flash.geom.Rectangle(rx, ry, xr, yr);
	}
	
#FIZTTYPE="ship"	
#include "src/fizix.as"

}