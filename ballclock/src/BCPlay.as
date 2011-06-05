/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class BCPlay
{
	var mc;

	var up;
	
	var utc=false;

	
	function BCPlay(_up,_utc)
	{
		up=_up;
		
		if(_utc){utc=_utc;}
	}
	
	function delegate(f,d) { return com.dynamicflash.utils.Delegate.create(this,f,d); }
	
	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}

	var aim=0;

	function setup(_utc)
	{
	var d,h,m;
	
		if(_utc){utc=_utc;}
	
		rnd_seed(up.game_seed);
		
		mc=gfx.create_clip(up.mc,null);
		
		create_mcs();
		

		d=new Date();
		
		if(utc)
		{
			h=d.getUTCHours();
			m=d.getUTCMinutes();
		}
		else
		{
			h=d.getHours();
			m=d.getMinutes();
		}
		
		hours=h;
		score_h=h;
		
		minutes=m;
		score_m=m;
		
		update_time();
		
		
//		_root.signals.signal("#(VERSION_NAME)","start",up);
	}
	
	function clean()
	{
//		_root.signals.signal("#(VERSION_NAME)","end",up);
					
		mc.removeMovieClip();
	}

	function update()
	{
	var i;
	
//		if(_root.popup){return;}

		update_time();
		
		bat_update(mc.bat1);
		bat_update(mc.bat2);

		ball_update(mc.ball);

		pat_update(mc.pats);
		
//		_root.signals.signal("#(VERSION_NAME)","update",up);
	}
	
	var hours=-1;
	var minutes=-1;
	
	var score_h;
	var score_m;
	
	var miss_h=0;
	var miss_m=0;
	
	function update_time()
	{
	var d,h,m;
	var h1,h2;
	var m1,m2;
	
		d=new Date();
		if(utc)
		{
			hours=d.getUTCHours();
			minutes=d.getUTCMinutes();
		}
		else
		{
			hours=d.getHours();
			minutes=d.getMinutes();
		}
		
		if(hours!=score_h)
		{
			if(miss_h<0)
			{
				score_h=hours;
				miss_h=0;
				mc.num3._alpha=100;
				mc.num2._alpha=100;
			}
			else
			{
				miss_h=1;
			}
		}
		
		if(minutes!=score_m)
		{
			if(miss_m<0)
			{
				score_m=minutes;
				miss_m=0;
				mc.num1._alpha=100;
				mc.num0._alpha=100;
			}
			else
			{
				miss_m=1;
			}
		}
		
		h=score_h;
		m=score_m;

		h1=Math.floor(h/10);
		h2=Math.floor(h%10);
	
		m1=Math.floor(m/10);
		m2=Math.floor(m%10);
		
		if(mc.num0._alpha==100)
		{
			mc.num0.gotoAndStop(1);
			mc.num1.gotoAndStop(1);
			mc.num0.gotoAndStop(m2+2);
			mc.num1.gotoAndStop(m1+2);
		}
		
		if(mc.num2._alpha==100)
		{
			mc.num2.gotoAndStop(1);
			mc.num3.gotoAndStop(1);
			mc.num2.gotoAndStop(h2+2);
			mc.num3.gotoAndStop(h1+2);
		}

		if(mc.num0._alpha>50) { mc.num0._alpha-=2; }
		if(mc.num1._alpha>50) { mc.num1._alpha-=2; }
		if(mc.num2._alpha>50) { mc.num2._alpha-=2; }
		if(mc.num3._alpha>50) { mc.num3._alpha-=2; }

	}
	
	function ball_setup(t)
	{

		t.x=400;
		t.y=300;
		t.w=16;
		t.h=16;

		t.xv=8;
		t.yv=-12;

//		drawbox(t,t.x,t.y,t.w,t.h);

		gfx.glow(t , 0x00ff00, .8, 16, 16, 1, 3, false, false );
	}

	function ball_update(t)
	{

		t.clear();

		t.ymin=0+26+(t.h/2);
		t.ymax=600-26-(t.h/2);

		t.xmin=48;//0+26+(t.h/2);
		t.xmax=800-48;

		t.xl=800-80-16;
		t.xh=800-80+16;


		if(t.h>0)
		{
			if(t.yv>0)
			{
				if(t.yv<3)
				{
					t.yv=3;
				}
				else
				if(t.yv>32)
				{
					t.yv=32;
				}
			}
			else
			{
				if(t.yv>-3)
				{
					t.yv=-3;
				}
				else
				if(t.yv<-32)
				{
					t.yv=-32;
				}
			}
					
					
			t.y+=t.yv;
			t.x+=t.xv;

			if(t.y<t.ymin)
			{
				pat_add_imp(mc.pats,t.x,t.y,0,t.yv,8)

				t.y=t.ymin;
				t.yv*=-1;

				_root.wetplay.PlaySFX("sfx_beep1",1);	

			}
			else
			if(t.y>t.ymax)
			{
				pat_add_imp(mc.pats,t.x,t.y,0,t.yv,8)

				t.y=t.ymax;
				t.yv*=-1;

				_root.wetplay.PlaySFX("sfx_beep1",1);	
			}

			if((t.x<t.xmin)&&(miss_m!=1))
			{
				aim=rnd();
				
				pat_add_imp(mc.pats,t.x,t.y,t.xv,0,8)

				t.x=t.xmin;
				t.xv*=-1;

				t.fixy=(t.y-mc.bat1.y)/4;
				
				if(t.fixy> 16) { t.fixy= 16; }
				if(t.fixy<-16) { t.fixy=-16; }
				
				t.yv+=t.fixy;
				mc.bat1.yv-=t.fixy/4;
					
				_root.wetplay.PlaySFX("sfx_beep2",1);	
			}
			
			if((t.x>t.xmax)&&(miss_h!=1))
			{
				aim=rnd();
				
				pat_add_imp(mc.pats,t.x,t.y,t.xv,0,8)

				t.x=t.xmax;
				t.xv*=-1;
				
				t.fixy=(t.y-mc.bat2.y)/4;
				
				if(t.fixy> 16) { t.fixy= 16; }
				if(t.fixy<-16) { t.fixy=-16; }
				
				t.yv+=t.fixy;
				mc.bat2.yv-=t.fixy/4;

				_root.wetplay.PlaySFX("sfx_beep2",1);	
			}
/*		
		else
		if( (t.x>t.xl) && (t.x<t.xh) )	// bat hit
		{
			if( (t.xv>0) && (mc.bat2.h>0) )// only going towards bat
			{
				t.bymin=mc.bat2.y-(mc.bat2.h/2)-8;
				t.bymax=mc.bat2.y+(mc.bat2.h/2)+8;

				if( (t.y>t.bymin) && (t.y<t.bymax) ) // on bat
				{
					pat_add_imp(mc.pats,t.x,t.y,t.xv,0,8)

					if(t.y<mc.bat2.y)
					{
						t.fixy=(mc.bat2.y-t.y)/(mc.bat2.y-t.bymin);
						t.fixx=1-t.fixy;
						t.fixy*=-8;
					}
					else
					{
						t.fixy=(t.y-mc.bat2.y)/(t.bymax-mc.bat2.y);
						t.fixx=1-t.fixy;
						t.fixy*=8;
					}
	//				t.x=t.xl;

					t.yv+=t.fixy;
					mc.bat2.yv-=t.fixy;

					if(t.yv>0)
					{
						if(t.yv<3)
						{
							t.yv=3;
						}
					}
					else
					{
						if(t.yv>-3)
						{
							t.yv=-3;
						}
					}

					t.xv*=-1;

					_root.wetplay.PlaySFX("sfx_beep2",2);	
				}
			}
		}
		else
*/
			if(t.x>800)
			{
				pat_add_imp(mc.pats,t.x,t.y,t.xv,0,48)

				t.x=800;
				t.xv=0;
				t.yv=0;

				t.h=0;
				
				miss_h=-1;

				_root.wetplay.PlaySFX("sfx_beep3",3);
				
				ball_setup(mc.ball);
			}

			if(t.x<0)
			{
				pat_add_imp(mc.pats,t.x,t.y,t.xv,0,48)

				t.x=0;
				t.xv=0;
				t.yv=0;

				t.h=0;

				miss_m=-1;
				
				_root.wetplay.PlaySFX("sfx_beep3",3);
				
				ball_setup(mc.ball);
			}
			
			drawbox(t,t.x,t.y,t.w,t.h);
		}

	}

	function bat_setup(t)
	{

//		t.x=800-80;
		t.y=300;
		t.w=16;
		t.h=96;

		t.xv=0;
		t.yv=0;

//		drawbox(t,t.x,t.y,t.w,t.h);

		gfx.glow(t , 0x00ff00, .8, 16, 16, 1, 3, false, false );
	}

	function bat_update(t)
	{
	var tim;
	var hy;
	
		t.clear();

		
		
		if	(
				((mc.ball.xv>0)&&(t.x>400)&&(mc.ball.x>400))
				||
				((mc.ball.xv<0)&&(t.x<400)&&(mc.ball.x<400))
			)
		{
			if( (mc.ball.x > 40) && (mc.ball.x < 800-40) )
			{
				tim=Math.abs((t.x-mc.ball.x)/mc.ball.xv);
				tim=Math.floor(tim);
				
				if(tim>0)
				{
					hy=mc.ball.y+(mc.ball.yv*tim);
					
					if( ((t.x>400)&&(miss_h==1)) || ((t.x<400)&&(miss_m==1)) )
					{
						if(aim&0x8000)
						{
							hy-=64+aim%16;
						}
						else
						{
							hy+=64+aim%16;
						}
					}
					else
					{
						if(aim&0x8000)
						{
							hy-=aim%48;
						}
						else
						{
							hy+=aim%48;
						}
					}
					
					while( (hy<mc.ball.ymin) || (hy>mc.ball.ymax) )
					{
						if(hy<mc.ball.ymin)
						{
							hy=mc.ball.ymin+(mc.ball.ymin-hy);
						}
						
						if(hy>mc.ball.ymax)
						{
							hy=mc.ball.ymax-(hy-mc.ball.ymax);
						}
					}
					
					t.yv=(hy-t.y)/tim;
				}
			}
		}
		
		t.ymin=0+26+(t.h/2);
		t.ymax=600-26-(t.h/2);

		t.y+=t.yv;

		if(t.y<t.ymin)
		{
			pat_add_imp(mc.pats,t.x,t.y-(t.h/2),t.xv,t.yv,8)

			t.y=t.ymin;
			t.yv*=-1;

			
			_root.wetplay.PlaySFX("sfx_beep1",1);	
		}
		else
		if(t.y>t.ymax)
		{
			pat_add_imp(mc.pats,t.x,t.y+(t.h/2),t.xv,t.yv,8)

			t.y=t.ymax;
			t.yv*=-1;

			_root.wetplay.PlaySFX("sfx_beep1",1);	
		}

		if(t.h>0)
		{
			drawbox(t,t.x,t.y,t.w,t.h);
		}

	}

	function pat_setup(t)
	{
		t.p_next=0;
		t.p_max=64;
		t.p_i=[0];
		t.p_x=[0];
		t.p_y=[0];
		t.p_xv=[0];
		t.p_yv=[0];
	}

	function pat_add(t,x,y,xv,yv,s)
	{
	var i=t.p_next;

		t.p_i[i]=s;
		t.p_x[i]=x;
		t.p_y[i]=y;
		t.p_xv[i]=xv;
		t.p_yv[i]=yv;

		t.p_next++;
		if(t.p_next >= t.p_max)
		{
			t.p_next=0;
		}
	}

	function pat_add_imp(t,x,y,xv,yv,n)
	{
	var i;

		for(i=0;i<n;i++)
		{
			pat_add(mc.pats,x,y,(Math.random()-0.5)*12-xv,(Math.random()-0.5)*12-yv,8);
		}
	}

	function pat_update(t)
	{
		var s;
		var a;
		var x;
		var y;
		var i;

		t.clear();

		t.lineStyle(0,0x000000,0);

		for(i=0;i<t.p_max;i++)
		{
			if(t.p_i[i]>0) // active
			{
				s=t.p_i[i];
				a=t.p_i[i];
				if(a>5) { a=5; }

				t.p_x[i]+=t.p_xv[i];
				t.p_y[i]+=t.p_yv[i];

				x=t.p_x[i];
				y=t.p_y[i];

				t.moveTo(x-s,y-s);

				t.beginFill(0x00ff00,a);

				t.lineTo(x+s,y-s);
				t.lineTo(x+s,y+s);
				t.lineTo(x-s,y+s);
				t.lineTo(x-s,y-s);

				t.endFill();

				t.p_i[i]-=0.125;
			}
		}
	}

	function drawbox(t,x,y,w,h)
	{

		var ww=w/2;
		var hh=h/2;

		t.lineStyle(3,0x00ff00,100);

		t.moveTo(x-ww,y-hh);

		t.beginFill(0x008000,100);

		t.lineTo(x+ww,y-hh);
		t.lineTo(x+ww,y+hh);
		t.lineTo(x-ww,y+hh);
		t.lineTo(x-ww,y-hh);

		t.endFill();

	}

	function create_mcs()
	{
	var num;
	var bx,bs,by;
	var ss=1.5;


		mc.clear();

//		mc.attachMovie("BC_layout","bak",1);
//		mc.bak._x=-8;
//		mc.bak._y=-8;
//		mc.bak.gotoAndStop(1);
		
		mc.createEmptyMovieClip("bak", 8);
		
		drawbox(mc.bak,400,16,800-16,16);
		drawbox(mc.bak,400,600-16,800-16,16);
		
		mc.bak.cacheAsBitmap=true;


		mc.createEmptyMovieClip("bat1", 9);
		mc.bat1.x=32;
		bat_setup(mc.bat1);

		mc.createEmptyMovieClip("bat2", 10);
		mc.bat2.x=800-32;
		bat_setup(mc.bat2);

		mc.createEmptyMovieClip("ball", 11);
		ball_setup(mc.ball);

		mc.createEmptyMovieClip("pats", 12);
		pat_setup(mc.pats);

		bx=400+(1.5*56*ss);
		bs=-56;
		by=48;

		mc.attachMovie("BC_numbers","num0",100);
		num=mc.num0;
		num.gotoAndStop(2);
		num._x=bx;
		num._y=by;
		num._xscale=100*ss;num._yscale=num._xscale;
//		num._alpha=50;
		gfx.glow(num , 0x00ff00, .8, 16, 16, 1, 3, false, false );
		num.cacheAsBitmap=true;

		bx+=bs*ss;

		mc.attachMovie("BC_numbers","num1",101);
		num=mc.num1;
		num.gotoAndStop(2);
		num._x=bx;
		num._y=by;
		num._xscale=100*ss;num._yscale=num._xscale;
//		num._alpha=50;
		gfx.glow(num , 0x00ff00, .8, 16, 16, 1, 3, false, false );
		num.cacheAsBitmap=true;

		bx+=bs*ss;

		mc.attachMovie("BC_numbers","num_",102);
		num=mc.num_;
		num.gotoAndStop(12);
		num._x=bx;
		num._y=by;
		num._xscale=100*ss;num._yscale=num._xscale;
		num._alpha=50;
		gfx.glow(num , 0x00ff00, .8, 16, 16, 1, 3, false, false );
		num.cacheAsBitmap=true;

		bx+=bs*ss;

		mc.attachMovie("BC_numbers","num2",103);
		num=mc.num2;
		num.gotoAndStop(2);
		num._x=bx;
		num._y=by;
		num._xscale=100*ss;num._yscale=num._xscale;
//		num._alpha=50;
		gfx.glow(num , 0x00ff00, .8, 16, 16, 1, 3, false, false );
		num.cacheAsBitmap=true;

		bx+=bs*ss;

		mc.attachMovie("BC_numbers","num3",104);
		num=mc.num3;
		num.gotoAndStop(2);
		num._x=bx;
		num._y=by;
		num._xscale=100*ss;num._yscale=num._xscale;
//		num._alpha=50;
		gfx.glow(num , 0x00ff00, .8, 16, 16, 1, 3, false, false );
		num.cacheAsBitmap=true;

	}

}
