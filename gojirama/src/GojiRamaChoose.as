/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class GojiRamaChoose
{
	var up;
	var mc;
	
	var mcs;
	
	var frame;
	var framerate;
	
	var over;
	
	var sound_last;
	
	function GojiRamaChoose(_up)
	{
		up=_up;
	}

	
var mcnames=
[
"",			// 1
"goj1",		// 2
"goj2",		// 3
"",			// 4
"poj1",		// 5
"poj2",		// 6
""
];
	
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
		
		mcs=new Array()
		
		frame=0;
		framerate=100;
		
		for(i=0;i<6;i++)
		{
			mcs[i]=gfx.add_clip(mc,"swf_choose",null);
			mcs[i].gotoAndStop(i+1);
			
			mcs[i].cacheAsBitmap=true;
			
			mcs[i].id=mcnames[i];
			
			mcs[ mcnames[i] ]=mcs[i];
			
			mcs[i].onRollOver=delegate(hover,mcs[i]);
		}
		
		t=15;
//		tp=15;		
		
		
		clicky(mcs["goj1"],mcs["goj2"],"goj");
		clicky(mcs["poj1"],mcs["poj2"],"poj");
		
		sound_last="";

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
		if(nam=="goj")
		{
			up.actor="goj";
			up.state_next="play";
			_root.wetplay.PlaySFX("sfx_gojira",1);	
		}
		else
		if(nam=="poj")
		{
			up.actor="poj";
			up.state_next="play";
			_root.wetplay.PlaySFX("sfx_peijira",1);	
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
	
	function update()
	{
	var i;
	
		frame++;
		
		if(over=="goj")
		{
			if(sound_last!="sfx_gojira")
			{
				sound_last="sfx_gojira";
				_root.wetplay.PlaySFX("sfx_gojira",1);	
				
			}
			_root.poker.ShowFloat("Gojira has tiny arms, remember to time the punch so you connect with the building or you will miss.",10);
		}
		else
		if(over=="poj")
		{
			if(sound_last!="sfx_peijira")
			{
				sound_last="sfx_peijira";
				_root.wetplay.PlaySFX("sfx_peijira",1);	
				
			}
			_root.poker.ShowFloat("Peijira also has tiny arms, remember to time the punch so you connect with the building or you will miss.",10);
		}
		else
		{
			sound_last="";
		}
		
		for(i=0;i<6;i++)
		{
			if( mcs[i].update ) mcs[i].update();
		}
	}
	
}