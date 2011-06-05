/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class GojiRamaSplash
{
	var up;
	var mc;
	
	var mcs;
	
	var frame;
	var framerate;
	
	var over;
	
	var about;
	
	function GojiRamaSplash(_up)
	{
		up=_up;
	}

	
var mcnames=
[
"",			// 1
"",			// 2
"goj",		// 3
"",			// 4
"",			// 5
"",			// 6
"pop",		// 7
"",			// 8
"txt1",		// 9
"txt2",		// 10
"txt3",		// 11
"txt4",		// 12
"txt5",		// 13
"",			// 14
"about1",	// 15
"about2",	// 16
"play1",	// 17
"play2",	// 18
"",			// 20
"rld1",		// 21
"rld2"		// 22
];
//#3 goj walk

//#7 pop up

//#9,10,11,12,13 text on from right

//#15+16 about + rollover

//#17+18 play + rollover
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function setup()
	{
	var i;
	var t;
	var tp;
	
		mc=gfx.create_clip(up.mc,null);
//		mc.cacheAsBitmap=true;
		mc._alpha=100;
		
		about=new PlayAbout(this);
		
		mcs=new Array()
		
		frame=0;
		framerate=100;
		
		for(i=0;i<mcnames.length;i++)
		{
			if( mcnames[i]=="goj" ) // spesh
			{
				mcs[i]=gfx.create_clip(mc,null);
				mcs[i].goj=gfx.add_clip(mcs[i],"swf_goji",null);
				mcs[i].goj.gotoAndStop(1);
			}
			else
			{
				mcs[i]=gfx.add_clip(mc,"swf_splash",null);
				mcs[i].gotoAndStop(i+1);
			}
			mcs[i].cacheAsBitmap=true;
			
			mcs[i].id=mcnames[i];
			
			mcs[ mcnames[i] ]=mcs[i];
			
			mcs[i].onRollOver=delegate(hover,mcs[i]);
		}
		
		t=25;
//		tp=15;		
		
		swishup(mcs["pop"],t); t+=10;
		
		swishleft(mcs["txt1"],t); t+=1*5;
		swishleft(mcs["txt2"],t); t+=1*5;
		swishleft(mcs["txt3"],t); t+=1*5;
		swishleft(mcs["txt4"],t); t+=1*5;
		swishleft(mcs["txt5"],t); t+=1*5;
		
		clicky(mcs["about1"],mcs["about2"],"about");
		
		clicky(mcs["play1"],mcs["play2"],"play");
		
		clicky(mcs["rld1"],mcs["rld2"],"rld");
		
		walky(mcs["goj"]);
		
		_root.wetplay.PlaySFX(null,2);
	}
	
	function clean()
	{
		
		mc.removeMovieClip();
	}

	function hover(m)
	{
		over=m.over;
//		if(over) { dbg.print(over); }
	}
	function click(nam)
	{
		if(_root.popup) return;
		
		if(nam=="play")
		{
			up.state_next="skip";
			_root.wetplay.PlaySFX("sfx_gojira",1);	
		}
		else
		if(nam=="about")
		{
			about.setup();
			_root.wetplay.PlaySFX("sfx_gojira",1);	
		}
		else
		if(nam=="rld")
		{
			getURL("http://rldzine.wordpress.com","_blank");
		}
	}
	
	function walky(m)
	{
		m.update=delegate(walkyupdate,m);
		m.goj._x-=400*0.5;
		m.goj._y-=300*0.5;
		m.goj._xscale=150;
		m.goj._yscale=150;
		
		m._x=-800;
	}
	function walkyupdate(m)
	{
		m._x+=10;
		if( m._x > 800 ) { m._x-=1600; }
		
		m.goj.gotoAndStop( 1+(Math.floor(frame/5)%6) );
		
		if( ( (frame+10) % 15 ) == 0 )
		{
			m._y=-10;
			mc._y=-10;
			
			_root.wetplay.PlaySFX("sfx_stomp",1);	
		}
		
		if(m._y>0)
		{
			m._y=-(m._y-1);
		}
		else
		if(m._y<0)
		{
			m._y=-(m._y+1);
		}
		
		if(mc._y>0)
		{
			mc._y=-(mc._y-1);
		}
		else
		if(mc._y<0)
		{
			mc._y=-(mc._y+1);
		}
	}
	
	function clicky(mc1,mc2,tt)
	{
		mc1.update=delegate(clickyupdate1,mc1);
		mc2.update=delegate(clickyupdate2,mc2);
		
		mc1.onRelease=delegate(click,tt);
		mc2.onRelease=delegate(click,tt);
		
		mc1.over=tt;
		mc2.over=tt;
							
	}
	function clickyupdate1(m)
	{
//		if(m._alpha<100) { m._alpha+=5; }		
//		if(over==m.over) { m._alpha=0; }
	}
	function clickyupdate2(m)
	{
		if(m._alpha>0) { m._alpha=0; }
		if(over==m.over) { m._alpha=100; }
	}
	
	function swishleft(m,t)
	{
		m.time_in=t;
		m.active=false;
		m._x=400;
		m.update=delegate(swishupdate,m);
	}

	function swishup(m,t)
	{
		m.time_in=t;
		m.active=false;
		m._y=600;
		m.update=delegate(swishupdate,m);
	}

	function swishupdate(m)
	{
		if( frame>=m.time_in)
		{
			if(!m.active)
			{
				m.active=true;
			}
		}
		
		if(m.active)
		{
			if(m._y>0) { m._y=0; }
			
			m._x*=0.75;
			m._y*=0.75;
			if( (m._x*m._x<=1) && (m._y*m._y<=1) )
			{
				m.active=false;
				m._x=0;
				m._y=0;
				m.update=null;
			}
		}
	}
	
	function update()
	{
	var i;
	
		if(_root.popup) return;
		
		frame++;
		
//		if(mc._alpha<99) { mc._alpha=100-((100-mc._alpha)*0.75); }
//		else { mc._alpha=100; }
		
		for(i=0;i<mcnames.length;i++)
		{
			if( mcs[i].update ) mcs[i].update();
		}
	}
	
}