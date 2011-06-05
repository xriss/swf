/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class rgbtdLevels
{
	var up;
	
	var mc;
		
	var levels;
	
//	var level_idx=0;
	var level;
	
	
	var mcs;
	
	var bms;
	
	var tfs;
	
	var save;
	
	var total_medal;
	
	function rgbtdLevels(_up)
	{
		up=_up;
		
	}
	
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
	var m;
	var vt;
	var x,y,i;
	
	var total;
	
//		state="none";
		
		mc=gfx.create_clip(up.mc,null);
		mc.back=gfx.add_clip(mc,"back",null);
		
		mcs=[];
		bms=[];
		tfs=[];
		
		var names=["padlock","medal_bronze","medal_silver","medal_gold"];
		var name;
		for(i=0;i<4;i++)
		{
			name=names[i];
			mcs[name]=gfx.add_clip(mc,name,null);
			bms[name]=new flash.display.BitmapData(15,15,true,0x00000000);
			bms[name].draw(mcs[name]);
			mcs[name].removeMovieClip();
		}
		
		
		
		so_load(); // check for saved files
		
		if(!save)
		{
			save=[];
		}
		
		for( i=0 ; i<26 ; i++ ) // set defaults
		{
			if(i==25)
			{
				i=up.game_seed_today;
			}
			
			manifest_level(i);			
		}
		
		total_medal=3; // start with a gold, then move downwards when we find worse scores
		
		total=0;
		for( i=0 ; i<26 ; i++ )
		{
			x=i%5;
			y=Math.floor(i/5);
			
			x=50+x*100;
			y=50+y*100;
			
			var levname=alt.Sprintf.format("level%02d",i);
			
			if(i==25)
			{
				x=600;
				y=450;
				i=up.game_seed_today;
				
				levname="levelxx";
			}
			
			
			m=gfx.create_clip(mc,null,x+12,y+12,100,100);
			mcs[i]=m;
			
			m.level=i;
			
			m.bak=gfx.add_clip(m,levname,null,12,12,50,50);
			
			m.onRollOver=		delegate(mouse_in,m);
			m.onRollOut=		delegate(mouse_out,m);
			m.onReleaseOutside=	delegate(mouse_out,m);
			m.onRelease=		delegate(mouse_click,m);
			
			mouse_out(m);
						
			m.state="unlocked";
			
			if(i<25) // just the real 25 puzzles
			{
				total+=save[i].score;
			}
			
			if(i>=25)
			{
				m.state="unlocked";
			}
			else
			if( save[i].score < up.play.levels[i].winscore[0] ) // maybe locked?
			{
				if(i>0)
				{
					if( save[i-1].score < up.play.levels[i-1].winscore[0] ) // locked
					{
						m.state="locked";
					}
				}
				
				
				if(i<25) // just the real 25 puzzles
				{
					if(total_medal > 0) { total_medal=0; }
				}
			}
			else
			if( save[i].score < up.play.levels[i].winscore[1] ) // bronze
			{
				m.state="bronze";
				
				if(i<25) // just the real 25 puzzles
				{
					if(total_medal > 1) { total_medal=1; }
				}
			}
			else
			if( save[i].score < up.play.levels[i].winscore[2] ) // silver
			{
				m.state="silver";
				
				if(i<25) // just the real 25 puzzles
				{
					if(total_medal > 2) { total_medal=2; }
				}
			}
			else // gold
			{
				m.state="gold";
				
				if(i<25) // just the real 25 puzzles
				{
					if(total_medal > 3) { total_medal=3; }
				}
			}
			
			switch(m.state)
			{
				case "locked":
				
					m.over=gfx.create_clip(m,null,20,20,400,400);
					
					m.over.attachBitmap(bms["padlock"],0,"always",false);
				
				break;
				case "bronze":
				
					m.over=gfx.create_clip(m,null,20,20,400,400);
					m.over.attachBitmap(bms["medal_bronze"],0,"always",false);
				
				break;
				case "silver":
				
					m.over=gfx.create_clip(m,null,20,20,400,400);
					m.over.attachBitmap(bms["medal_silver"],0,"always",false);
				
				break;
				case "gold":
				
					m.over=gfx.create_clip(m,null,20,20,400,400);
					m.over.attachBitmap(bms["medal_gold"],0,"always",false);
				
				break;
			}
		}
		
		if( total_medal>0 ) // hand out awards?
		{
			if(total_medal>=1)
			{
				_root.signals.signal("rgbtd0","award-bronze",this);
			}
			if(total_medal>=2)
			{
				_root.signals.signal("rgbtd0","award-silver",this);
			}
			if(total_medal>=3)
			{
				_root.signals.signal("rgbtd0","award-gold",this);
			}
		}

		
		mc.backbutton=gfx.add_clip(mc,"backbutton",null,20,20);
		m=mc.backbutton;
		m.level=-1;
		m.onRollOver=		delegate(mouse_in,m);
		m.onRollOut=		delegate(mouse_out,m);
		m.onReleaseOutside=	delegate(mouse_out,m);
		m.onRelease=		delegate(mouse_click,m);
		mouse_out(m);
		
		

		tfs.total=gfx.create_text_html(mc,null,170,20,300,100);
		gfx.set_text_html(tfs.total,40,0xffffffff,"<p align=\"center\"><b>"+total+"</b></p>");
			
		tfs.score=gfx.create_text_html(mc,null,600,15,125,400);
		
//		mcs.cheats=gfx.create_clip(mc,null);

		tfs.cook=gfx.create_text_html(mc,null,560,400,200,100);
		gfx.set_text_html(tfs.cook,16,0xffffffff,"<p align=\"center\"><b>Todays<br>Cookie<br>Challenge</b></p>");

	}
	
	function clean()
	{
		_root.swish.clean();
		_root.swish=(new Swish({style:"slide_left",mc:mc})).setup();
		
		so_save();
		
		mc.removeMovieClip();
	}
	
	function manifest_level(i) // make sure stuff we nead exists
	{
		if(!up.play.levels[i].winscore) { up.play.levels[i].winscore=[100,300,600]; } 
		
		if(!save[i])
		{
			save[i]=[];
		}
		
		if(!save[i].score)
		{
			save[i].score=0;
		}
		if(!save[i].score_fat)
		{
			save[i].score_fat=0;
		}
		if(!save[i].score_age)
		{
			save[i].score_age=0;
		}
		if(!save[i].score_lose)
		{
			save[i].score_lose=0;
		}
	}
	
	function mouse_in(m)
	{
		if(m.level==-1)
		{
			m._alpha=100;
			return;
		}
		
		m.bak._alpha=100;
		m.over._alpha=25;
		
		var sel=this;
		
		var name="<br>Level "+m.level;
		
		if( up.play.levels[m.level].name )
		{
			name+="<br>"+up.play.levels[m.level].name;
		}
		
		
		gfx.set_text_html(tfs.score,32,0xffffff,"<b><p align=\"right\"><font color=\"#00ff00\" >+"+(sel.save[m.level].score_fat)+"</font></p><p align=\"right\"><font color=\"#ff0000\" >-"+(sel.save[m.level].score_age)+"</font></p><p align=\"right\"><font color=\"#ff0000\" >-"+(sel.save[m.level].score_lose)+"</font></p><p align=\"right\">="+sel.save[m.level].score+"</p></b><p align=\"center\"><font size=\"16\" >"+name+"</font></p>");
		
	}
	function mouse_out(m)
	{
		if(m.level==-1)
		{
			m._alpha=50;
			return;
		}
		
		m.bak._alpha=50;
		m.over._alpha=100;
		
		gfx.set_text_html(tfs.score,32,0xffffff,"");
	}
	function mouse_click(m)
	{
		if(m.level==-1)
		{
			up.state_next="menu";
			return;
		}
		
		if(m.state!="locked")
		{
			up.game_seed=m.level;
			up.state_next="play";
		}
	}

	
	
	function update()
	{
	var i;
	
		_root.bmc.check_loading();
			
		
	}
	
	var so;
	var VERSION=2;

	function so_load()
	{
		so=SharedObject.getLocal("rgbtd");
		
		var t=so.data;
		
		if(t.version==VERSION)
		{
			if(t.save)		{ save=t.save; }
		}
	}
	
	function so_save()
	{
		var t=so.data;
	
		t.version=VERSION;
		t.save=save;
		
		so.flush();
	}
	
	
}