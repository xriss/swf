/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// lets handle some scores

class PlayWon
{
	var up;
	
	var mc;
	
	var mcs;
	var tfs;
	
	var finished;
	var steady;
	
//	var defuck;
	
	var maxads;
	
	var done;
	var notdone;

	var state;
	
	var mc_whore;

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function PlayWon(_up)
	{
		up=_up;
	}
	
	var defuck;
	
	function setup(_state)
	{
	var i;
	var bounds;
	var mct;
	var s;
	
		defuck=_root._highquality;
		
		
		if(_state) { state=_state; } else { state="won"; }
	
//		defuck=_root._highquality;
	
	
//		up.dikecomms.send_score_check();

//		show_ranks=false;
		
		_root.popup=this;
		
		mcs=new Array();
		tfs=new Array();
			
		mc=gfx.create_clip(_root.mc_popup,null);
		mc.cacheAsBitmap=true;
		gfx.dropshadow(mc,5, 45, 0x000000, 1, 20, 20, 2, 3);
//	    mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 20, 20, 2, 3) ];
		
//		mc.onRelease=delegate(onRelease,null);
		
		mc._y=0;
		
		mc.dx=0;
		mc._x=-800;
		
		mc.onEnterFrame=delegate(update,null);

		finished=false;
		steady=false;
		
		gfx.clear(mc);
		
		mc.style.out=0xff000000;
		mc.style.fill=0x60000000;
		gfx.draw_box(mc,0,100+16,0+16,600-32,600-32);
		
		mcs[2]=gfx.create_clip(mc,null);
		tfs[0]=gfx.create_text_html(mcs[2],null,150,50,500,100)
		
		if(state!="ws")
		{
			s="";
			s+="<p align=\"center\"><font size=\"32\"> You scored : <b>"+(up.hud.points)+"</b></font></p>";
			s+="<p align=\"center\"><font size=\"16\">";
			s+="Click here or outside of this box to continue.<br>";
			s+="</font></p>";
		}
		else
		{
			s="";
			s+="<p align=\"center\"><font size=\"32\"> You scored : <b>";
			
			if(up.player==0)
			{
				s+=up.hud.points1;
			}
			else
			{
				s+=up.hud.points2;
			}
			s+="</b></font></p>";
			
			s+="<p align=\"center\"><font size=\"16\">";
			if(up.player==0)
			{
				if(up.hud.points2 < up.hud.points1)
				{
					s+="Which beats "+up.hud.points2+" Yay!<br>";
				}
				else
				{
					s+="Unfortunately they scored "+up.hud.points2+"<br>";
				}
			}
			else
			{
				if(up.hud.points1 < up.hud.points2)
				{
					s+="Which beats "+up.hud.points1+" Yay!<br>";
				}
				else
				{
					s+="Unfortunately they scored "+up.hud.points1+"<br>";
				}
			}
			s+="</font></p>";
		}

		
		tfs[0].multiline=true;
		tfs[0].wordWrap=true;
		tfs[0].html=true;
		tfs[0].selectable=false;
		
		gfx.set_text_html(tfs[0],22,0xffffff,s);

		mcs[2].onRelease=delegate(click,"top");

		mcs[0]=gfx.create_clip(mc,null);
		tfs[1]=gfx.create_text_html(mcs[0],null,150,50+100,500,500-100)
		
		s="";
		s+="<p align=\"center\"><font size=\"16\">";
		s+="Thank you, please come again.<br>";
		s+="</font></p>";
		
		tfs[1].multiline=true;
		tfs[1].wordWrap=true;
		tfs[1].html=true;
		tfs[1].selectable=false;
		
		gfx.set_text_html(tfs[1],22,0xffffff,s);

		mcs[0].onRelease=delegate(click,"text");
		
		
//		mcs[0]=gfx.create_clip(mc,null,100+16,600-16-(220*(600-32)/640),100*(600-32)/640,100*(600-32)/640);
//		mcs[0]=gfx.create_clip(mc,null,0,550-(220*800/640),100*800/640,100*800/640);
		mcs[1]=gfx.create_clip(mc,null,200,150,100*400/350,100*400/350);
		
		newad=true;
//		display_mochi();

/*		
		mc_topsub=gfx.create_clip(mc,null,100,100);
		tf_topsub=gfx.create_text_html(mc_topsub,null,0,0,600,75);
		mc_topsub.onRelease=delegate(click,"topsub");
*/
		
		mc_whore=gfx.create_clip(mc,null,150,200);
//		mc_whore.onRelease=delegate(click,"whore");
//		mc_whore.text=gfx.create_text_html(mc_whore,null,175+25,0,250,275);

		MochiAd.showClickAwayAd({id:"#(VERSION_MOCHIADS)",clip:mc_whore,res:"500x350"});

				
		thunk();
		
		Mouse.addListener(this);
		
		done=false;
		notdone=false;
		
		_root.signals.signal("diamonds","won",this);
	}

	var newad;
	
	function flagnewad()
	{
		newad=true;
	}	
/*
	function display_mochi()
	{
		if(_root.wethidemochiads) { return; }
		
		notdone=true;
		
		if(newad==true)
		{
			mcs[2]=gfx.create_clip(mcs[1],null);
			mcs[2].play=delegate(flagnewad);
			MochiAd.showTimedAd({ id:"#(VERSION_MOCHIADS)" , res:"350x350" , clip:mcs[2] });
		}
		newad=false;
	}
*/	
	function thunk()
	{
	}
	
	
	function click(s)
	{
//	dbg.print(s);
		switch(s)
		{
			case "text":
//				display_mochi();
			break;
			
			case "whore":
			
/*
				if(_root.diamonds.wonderfulls[mc_whore.idx].url)
				{
					getURL(_root.diamonds.wonderfulls[mc_whore.idx].url,"_blank");
				}
*/
				
			break;
		}
	}
	
	function clean()
	{
		if(_root.popup != this)
		{
			return;
		}
		
		MochiAd.unload(mc_whore);
		
		
//		_root._highquality=defuck;
		
		mc.removeMovieClip();
		_root.popup=null;
		
		Mouse.removeListener(this);
		
// cause gaeme to restart, this will display scores

		up.up.high.setup();
		up.gameover=true;
		
		_root._highquality=defuck;
	}

	function onMouseUp()
	{
		if(_root.popup != this)
		{
			return;
		}
		
		done=true;
	}

	function update()
	{
	var s;
	
		if( (_root.popup != this) || (_root.pause) )
		{
			return;
		}
		
// load on an ad?
/*
		if(mc_whore)
		{
			if(!mc_whore.ad) // check if we have loaded an ad
			{
				if(_root.diamonds.wonderfulls) // check if we know what ad to load
				{
					mc_whore.idx=up.rnd()%8;
					
					mc_whore.ad=gfx.create_clip(mc_whore, null,0,0,150,150);
					mc_whore.ad.loadMovie(_root.diamonds.wonderfulls[mc_whore.idx].img);

					s="";
					s+="<font face=\"Bitstream Vera Sans\" size=\"24\" color=\"#ffffff\">";
					s+="<p align=\"center\">";
					s+=_root.diamonds.wonderfulls[mc_whore.idx].txt;
					s+="</p>";
					s+="</font>";
					mc_whore.text.htmlText=s;
				}
			}
		}
*/		
		
		mc._x+=(mc.dx-mc._x)/4;

		if( (mc._x-mc.dx)*(mc._x-mc.dx) < (16*16) )
		{
			steady=true;
			if(finished)
			{
				clean();
			}
		}
		else
		{
			steady=false;
		}
		
		if(done && !notdone)
		{
			if(steady)
			{
				finished=true;
				mc.dx=_root.scalar.ox;
			}
		}
		done=false;
		notdone=false;
		
	}
		
	

}
