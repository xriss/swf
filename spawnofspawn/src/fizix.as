


	function fizix_setup(o,_xp,_yp,_vx,_vy,_mas,_rad,_vm,_fm)
	{
		o._x=_xp;
		o._y=_yp;
		
		o.vx=_vx;
		o.vy=_vy;
		o.vm=128;
		
		o.fx=0;
		o.fy=0;
		o.fm=16;
		
		o.mas=_mas;
		o.rad=_rad;

		if(_vm!=undefined)	o.vm=_vm;
		if(_fm!=undefined)	o.fm=_fm;
	}
	

	function fizix_update(o)
	{
		var yy;
		var cx,cy,cr;
		var cxa,cya,cxb,cyb;
		var x,y;
		var ox,oy;
		var dx,dy,dd,d;
		var p,c;
		var nx,ny,n;
		var mx,my,m;
		var step,steps;
		
		var sx,sy;
		var fx,fy;
	
		var i,l,s;
		
//		var o=this;
		
		var friction;
		
		var col;
		var cc;
//		var min_dd;
		
		var hx,hy,hs;
		
		
#if FIZTTYPE=="breeder" then

		fx=o.dfx;
		fy=o.dfy;
		
#else

		fx=0;
		fy=1.25;	// gravity
		
#end		
		
#if FIZTTYPE=="ship" then

		col=up.back.GetYcol(o._x);
		yy=(col.y-col.wet);//-o.rad;
		yy=o._y-yy;
		if(yy>0)
		{
		var fill;
		
			yy=yy/64;
//			if(yy>4) { yy=4; }
			fy=-yy;
			
			friction=16/256;
			
			fill=false;
			
			if(col.ca.wet>=8)
			{
				if(up.tank<100)
				{
					up.tank+=1;
					col.ca.wet-=8;
					fill=true;
				}
			}
			if(col.cb.wet>=8)
			{
				if(up.tank<100)
				{
					up.tank+=1;
					col.cb.wet-=8;
					fill=true;
				}
			}
			
			if(fill)
			{
				if(fill_up==0)
				{
					fill_up=30;
					_root.wetplay.PlaySFX("sfx_fillup",2);
				}
			}
			
			if(col.wet>0)
			{
				if(submerged>2)		{ submerged--; }
				if(submerged==0)
				{
					submerged=30;
					
					o.vx*=0.5; // hit speed reduce
					o.vy*=0.5;
						
					if(o.vy>6) // speed based
					{
						_root.wetplay.PlaySFX("sfx_splash",3);
						
						
						if(col.ca.wet>32)
						{
							col.ca.wet-=32;
							cc=up.back.GetCol(col.ca.idx-1);
							cc.wet+=32;
						}
						if(col.cb.wet>32)
						{
							col.cb.wet-=32;
							cc=up.back.GetCol(col.cb.idx+1);
							cc.wet+=32;
						}
					}
				}
			}
		}
		else
		{
			if(submerged>0) { submerged--; }
			friction=4/256;
		}
		
#elseif FIZTTYPE=="pinger" then

		col=up.back.GetYcol(o._x);
		yy=(col.y-col.wet);//-o.rad;
		yy=o._y-yy;
		if(yy>0)
		{
			if(o.floater)
			{
				fy=-0.5;
				friction=32/256;
			}
			else
			{
				friction=16/256;
			}
		}
		else
		{
			if(o.floater)
			{
				fy=0.5;
				friction=32/256;
			}
			else
			{
				friction=4/256;
			}
		}
			
#else
			friction=4/256;
#end
/*
		yy=up.back.GetY(o._x);//+16-o.rad;
		yy=o._y-yy;
		if(yy>0)
		{
			yy=Math.sqrt(yy);
//			if(yy>4) { yy=4; }
			fy-=yy;
		}
*/

//dbg.print(o._y+" : "+yy);

//		if(o._y>yy)
//		{
/*
				o._y=yy;
				o.vx=0;
				o.vy=0;
				o.fx=0;
				o.fy=0;
				return 1;
*/
//				o.vy=-4;
//		}

		o.hit=null;
		
/*
		min_dd=1024*1024;
		l=0;
		for(i=0;i<up.heart.mcs.length;i++)
		{
		var	b=up.heart.mcs[i];
		
			if(b.active)
			{
				dx=o._x-b._x;
				dy=o._y-b._y;
				dd=dx*dx + dy*dy;
				
				if(dd<min_dd) { min_dd=dd; }
				
				s=b.force;
				s=s*s/dd;
				
				if((s>1/256)&&(dd>0))
				{
					l++;
					d=Math.sqrt( dd );
					fx-=(dx/d)*s;
					fy-=(dy/d)*s;
					
					if(d<=b._xscale/2)
					{
						o.hit=b;
					}
				}
			}
		}
		
		o.min_dd=min_dd;
*/		
		
//		dbg.print(l);
				
//clip force
		if(fx >  o.fm) { fx= o.fm; }
		if(fx < -o.fm) { fx=-o.fm; }
		if(fy >  o.fm) { fy= o.fm; }
		if(fy < -o.fm) { fy=-o.fm; }
//clip vel
		if(o.vx >  o.vm) { o.vx= o.vm; }
		if(o.vx < -o.vm) { o.vx=-o.vm; }
		if(o.vy >  o.vm) { o.vy= o.vm; }
		if(o.vy < -o.vm) { o.vy=-o.vm; }
		
		if(o.mas>0) // only do impulse if mass is sensible
		{
			sx    = o.vx + 0.5*o.fx / o.mas;
			sy    = o.vy + 0.5*o.fy / o.mas;
			o.vx += ( ( o.fx + fx ) / 2*o.mas );
			o.vy += ( ( o.fy + fy ) / 2*o.mas );
			o.fx  = fx - (o.vx*friction);
			o.fy  = fy - (o.vy*friction);
		}
		else
		{
			sx    = o.vx ;
			sy    = o.vy ;
		}

// move collision in small steps

		steps=Math.sqrt(sx*sx + sy*sy);
		steps=Math.ceil(steps/(o.rad/2));

var rx,ry,xr,yr;


		rx=up.back.min_view_x;
		xr=up.back.max_view_x;
		ry=up.back.min_view_y;
		yr=up.back.max_view_y;
		
		for(step=0;step<steps;step++)
		{
		
			o._x=o._x+(sx/steps); // move a fraction
			o._y=o._y+(sy/steps);
			
// bounce off of screen edges
			if(o._x-o.rad<rx) { play_bounce(); o._x=rx+o.rad; if(sx<0) {sx=-sx;} if(o.vx<0) {o.vx=-o.vx;} }
			if(o._x+o.rad>xr) { play_bounce(); o._x=xr-o.rad; if(sx>0) {sx=-sx;} if(o.vx>0) {o.vx=-o.vx;} }
			if(o._y-o.rad<ry) { play_bounce(); o._y=ry+o.rad; if(sy<0) {sy=-sy;} if(o.vy<0) {o.vy=-o.vy;} }
			if(o._y+o.rad>yr) { play_bounce(); o._y=yr-o.rad; if(sy>0) {sy=-sy;} if(o.vy>0) {o.vy=-o.vy;} }


#if FIZTTYPE=="pinger" then

			col=up.back.GetYcol(o._x);
			yy=(col.y)-o.rad;
			if(yy<o._y)
			{
				o._y=yy;//-(o.rad/2);
				
				return 1;
			}
			
#elseif FIZTTYPE=="shot" then
			col=up.back.GetYcol(o._x);
			yy=(col.y-col.wet)-o.rad;
			if(yy<o._y)
			{

				play_plop();
				
//				o.vx=0;
//				o.vy=0;
//				o.fx=0;
//				o.fy=0;
				o.active=false;
				
				col.ca.wet+=32;
				col.cb.wet+=32;
				return 1;
			}
#else
			col=up.back.GetYcol(o._x);
			yy=(col.y)-o.rad;
			if(yy<o._y)
			{
				play_bounce();

				o._y=yy;
				
				hx=col.cb.x-col.ca.x;
				hy=col.cb.y-col.ca.y;
				hs=Math.sqrt(hx*hx+hy*hy);
				hx=hx/hs;
				hy=hy/hs;
				
				hs=hy;	// rotate
				hy=-hx;
				hx=hs;
				
				hs=(o.vx*hx)+(o.vy*hy);
				
				o.vx-=hs*hx*2;
				o.vy-=hs*hy*2;
				
			
//				if(o.vy>0) o.vy=-o.vy*0.5;
				return 1;
			}
#end
		}
		return 0;
	}

#if FIZTTYPE=="ship" then
	function play_bounce() {_root.wetplay.PlaySFX("sfx_bounce",1);}
#else
	function play_bounce() {}
#end

#if FIZTTYPE=="shot" then
	var plop_idx;
	function play_plop()
	{
		if(!plop_idx) { plop_idx=0; }
		plop_idx=(plop_idx+1)&3;
		_root.wetplay.PlaySFX("sfx_plop"+2,1);	
	}
#else
	function play_plop() {}
#end
	
	