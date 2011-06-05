/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// lets handle some scores

class WetDikeStats
{
	var mc;
	var mcs;
	var tfs;
	
	var up; // WetDike
	
	
	var done;
	var steady;

	var stats;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	

// state to use, set before changing master state to this
	var state;



	function WetDikeStats(_up)
	{
		up=_up;

		stats=new_reset_stats();
		
//		up.dikecomms.get_stats();
	}
	
	function new_reset_stats()
	{
		var a:Array=new Array();
		
		a["utime"]=12345;
		a["uhigh"]=5000;
		
		return a;
	}
	

	function setup()
	{
	var i;
	var box;
	var mct;
	var fmt;
	
		up.dikecomms.send_score_check();
		
		_root.popup=this;
		
		mcs=new Array();
		tfs=new Array();
			
		mc=gfx.create_clip(_root.mc_popup,null);
		mc.cacheAsBitmap=true;
	    mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 20, 20, 2, 3) ];
		mc._y=0;
		
		mc.dx=0;
		mc._x=800;
				
		fmt=new TextFormat();
		fmt.font="Bitstream Vera Sans";
		fmt.size=24;
		fmt.color=0x00ffffff;
		fmt.bold=false;
		fmt.align="center";
		
		for(i=1;i<=5;i++)
		{
			mcs[i]=gfx.add_clip(mc,'statsback',null);
			mcs[i].gotoAndStop(i+1);
			

			if( (i>=3) && (i<=5) )
			{
				box = mcs[i].getBounds(mc);
				
				mcs[i].removeMovieClip();
				mcs[i]=gfx.create_text_edit(mc,null,box.xMin,box.yMin,box.xMax-box.xMin,box.yMax-box.yMin);
				mcs[i].setNewTextFormat(fmt);
			}

		}
		mcs[1].name="user_stats";
		mcs[2].name="pack_stats";

		fmt.size=32;
		mcs[3].setNewTextFormat(fmt);
		
		fmt.size=24;
		mcs[4].setNewTextFormat(fmt);

		
/*
		mcs[2].text="2";
		mcs[3].text="3";
		mcs[3]._y+=80;
		mcs[4].text="4";
		mcs[4]._y+=192;
*/
		
		thunk();
		
		mc.onEnterFrame=delegate(update,null);

		done=false;
		steady=false;



//		var i;
		var s;
		var tfi;
		var a:Array;
		
		
		mc.style=new Array();

/*
		switch(state)
		{
			case "none":
			break;

			default:
			case "scores":
			
				mc.style.out=0xffffffff;
				mc.style.fill=0xc0ffffff;
//				gfx.draw_box(mc,0,100+16,0+16,600-32,600-32);
				
				mcs[0]=gfx.add_clip(mc,'statsback',null);
				mcs[0].gotoAndStop(2);
				mcs[0]._x=0;
				mcs[0]._y=0;

			break;
		}
*/
/*		
		tfi=0;
		for(i=0;i<10;i++)
		{
			tfs[tfi]=gfx.create_text_html(mc,null,50,150+i*40,200,50);
			tfi++;
			tfs[tfi]=gfx.create_text_html(mc,null,250,150+i*40,150,50);
			tfi++;
			tfs[tfi]=gfx.create_text_html(mc,null,400,150+i*40,550,50);
			tfi++;
		}
		
		thunk();
*/

		_root[_root.click_name]=delegate(click_str);
		
		up.dikecomms.get_stats();
		
		Mouse.addListener(this);
	}
	
	function thunk()
	{
		var t,h,s;
		
		var th,tl;
		
		var games,wins,score,moves;
		
		var s2;
		
		
		if(mcs[2].name=="user_stats")
		{
			h=Math.floor(stats["uhigh"]);
			t=Math.floor(stats["utime"]);
			
			games=Math.floor(stats["ugames"]);
			wins=Math.floor(stats["uwins"]);
			score=Math.floor(stats["uscore"]);
			moves=Math.floor(stats["umoves"]);
		}
		else
		{
			h=Math.floor(stats["phigh"]);
			t=Math.floor(stats["ptime"]);
			
			games=Math.floor(stats["pgames"]);
			wins=Math.floor(stats["pwins"]);
			score=Math.floor(stats["pscore"]);
			moves=Math.floor(stats["pmoves"]);
		}
			
		
		if(t>=(60*60*24))
		{
			th=Math.floor(t/(60*60*24));
			tl=Math.floor((t-(th*60*60*24))/(60*60));
			
			s=""+th;
			s+=(th>1)?" days":" day";
			if(tl>0)
			{
				s+=" and "+tl;
				s+=(tl>1)?" hours":" hour";
			}
		}
		else
		if(t>=(60*60))
		{
			th=Math.floor(t/(60*60));
			tl=Math.floor((t-(th*60*60))/60);
			
			s=""+th;
			s+=(th>1)?" hours":" hour";
			if(tl>0)
			{
				s+=" and "+tl;
				s+=(tl>1)?" minutes":" minute";
			}
		}
		else
		if(t>=(60))
		{
			th=Math.floor(t/60);
			tl=Math.floor((t-(th*60))/1);
			
			s=""+th;
			s+=(th>1)?" minutes":" minute";
			if(tl>0)
			{
				s+=" and "+tl;
				s+=(tl>1)?" seconds":" second";
			}
		}
		else
		{
			s=""+t;
			s+=(t>1)?" seconds":" second";
		}
		
		var pct_wins=Math.floor(100*wins/games);
		var scorepermove=Math.floor(score/moves);
					
		s2="";
		s2+="<b>"+games+" games</b> have been played and a total of <b>"+score+" points</b> scored. ";
		s2+="Only <b>"+wins+"</b> of these games were completed which is <b>"+pct_wins+"%</b> of all games played. ";
		s2+="During this time <b>"+moves+"</b> moves were made, an average of <b>"+scorepermove+" points</b> scored per action. ";
		
		mcs[5].multiline=true;
		mcs[5].wordWrap=true;
		mcs[5].html=true;
		
		mcs[3].text=h;
		mcs[4].text=s;
		
		gfx.set_text_html(mcs[5],24,0xffffff,s2);
//		mcs[5].htmlText=s2;
	}
	
	
	function clean()
	{
		if(_root.popup != this)
		{
			return;
		}
				
//		up.up.do_str("won");
		
		mc.removeMovieClip();
		
		_root.popup=null;
		
		Mouse.removeListener(this);
	}

	function onMouseDown()
	{
//		dbg.print("click");
		
		if(_root.popup != this)
		{
			return;
		}

		if(steady)
		{
			done=true;
			mc.dx=-800;
		}
	}

	function click_str(id:String)
	{
		var a:Array;
		
		a=id.split('_');
		
		trace(a);
		
		switch(a[0])
		{
			case "none":
			break;
			case "submit":
			break;
			break;
		}
	}


	function update()
	{
	var t;
	
			
		if(_root.popup != this)
		{
			return;
		}
		
		if(mc._ymouse<=300)
		{
			if(mcs[2].name!="pack_stats")
			{
				mcs[1].swapDepths(mcs[2]);
				t=mcs[1];
				mcs[1]=mcs[2];
				mcs[2]=t;
				
				thunk();
			}
		}
		else
		{
			if(mcs[2].name!="user_stats")
			{
				mcs[1].swapDepths(mcs[2]);
				t=mcs[1];
				mcs[1]=mcs[2];
				mcs[2]=t;
				
				thunk();
			}
		}
		
		mcs[1]._alpha=25;
		mcs[2]._alpha=100;
		
		mc._x+=(mc.dx-mc._x)/4;

		if( (mc._x-mc.dx)*(mc._x-mc.dx) < (16*16) )
		{
			steady=true;
			if(done)
			{
				clean();
			}
		}
		else
		{
			steady=false;
		}
	}
		
	

}
