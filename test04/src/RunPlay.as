/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class  RunPlay
{
	var up;
	
//	var talky;
	
	var level;
	
	var mc;
	var mco;
	
	var bmc;
	var imc;
	var vmc;
	var tmc;
	var wmc;
	var fmc;
	
	var frame;
	
	var dir;
	
	var x2;
	var y2;
	var x2_min;
	var y2_min;
	var x2_max;
	var y2_max;
	
	var x3;
	var y3;
	var z3;
	var x3_min;
	var y3_min;
	var z3_min;
	var x3_max;
	var y3_max;
	var z3_max;
	
	var tards;
	
	var start_x=100;
	var start_y=40;
	
	var focus;
	
	var col;

	var tfd;
	var txd;
	
	var pickups;
	var items;

	
	var score;
	var mc_score;
	
	var snapold;
	var snapbmp;
	var snapmc;

	var gamemode;
	var gameskill;
	
	var state;
	
	var gen_talk;
	
	var playsfx;
	
	var chat;
	
	function  RunPlay(_up)
	{
	var t,tt;
	
		gamemode="race"; // or story
		gameskill="easy"; // or hard
		
		up=_up;
		
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; rndg_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}

	var rndg_num:Number=0;
	function rndg_seed(n:Number) { rndg_num=n&65535; }
	function rndg() // returns a number between 0 and 65535
	{
		rndg_num=(((rndg_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rndg_num;
	}


	

	function setup()
	{
	var i;
	
		chat=new PlayChat(up);
		chat.setup();
		
		level=new Run1Level_level_01();//up.levels[up.level_idx];
//		chat=level.chat_start;

		up.game_seed=level.game_seed; // we worked out the right seed for each level at the start
		rnd_seed(up.game_seed);
		
		frame=0;
		score=0;
//		mute=0;
		
//		dribble_vol=-1; // flag start sound

		items=[];
		
		
		mc=gfx.create_clip(up.mc,null);
		
		mco=gfx.create_clip(up.mc,null);
		

//2d origin and bounds
		
		x2=0;
		y2=0;
		
		x2_min=0;
		y2_min=0;
		x2_max=level.pw;
		y2_max=level.ph;
		
//3d origin	and bounds

		x3=0;
		y3=0;
		z3=0;
		
		x3_min=0;
		y3_min=0;
		z3_min=0;
		
		x3_max=level.pw;
		y3_max=level.ph;
		z3_max=0;
		
		
		bmc=gfx.add_clip(mc,"level_01_bak",null,0,0-level.ph); // bottom left of image is at 0,0
		bmc.cacheAsBitmap=true;
				
		imc=gfx.create_clip(mc,null);

		tards=[];

		
// process collision data

		setcols(level.col);


		
		
	//	chat_idx=-1;
//		chat_tim=0;
		
		focus=tards[0];
		
		_root.replay.reset();
		
//		talky.setup();
		
//		tards[0].talk=talky.create(tards[0].mc,0,-30);
//		tards[1].talk=talky.create(tards[1].mc,0,-30);
		
//		gen_talk=talky.create(tards[0].mc,0,0);
		
		activate_item();
		
		mc_score=gfx.create_clip(mco,null);
		mc_score.tf1=gfx.create_text_html(mc_score,null,300,0,200,75);
		gfx.glow(mc_score , 0x000000, .8, 16, 16, 1, 3, false, false );

		
		_root.signals.signal("#(VERSION_NAME)","set",this);
		_root.signals.signal("#(VERSION_NAME)","start",this);
		
		
		state="start";
		
//		up.high.setup("rank");
		
		update();
		update();
		
	}
	
// take a snapshot of this level so we can scroll it off for a level transition.
	function build_snapbmp()
	{
/*
		snapbmp=new flash.display.BitmapData(800,600,false,0x00000000);
		snapbmp.draw(mc);
		snapold=new Object();
		snapold.x=tards[0].mc._x;
		snapold.y=tards[0].mc._y;
*/
	}
	
	function clean_snapbmp()
	{
		snapbmp=null;
	}
	
	function clean()
	{
	var i;
	
		_root.wetplay.PlaySFX(null,3);
	
		_root.signals.signal("#(VERSION_NAME)","end",this);
		
		for(i=0;i<_root.menu.customItems.length;i++)
		{
			if(_root.menu.customItems[i].id=="restart")
			{
				_root.menu.customItems[i].visible=false;
			}
		}
			
		tards[0].mc._visible=false;
		tards[1].mc._visible=false;

		build_snapbmp();
		
		chat.clean();

//		talky.clean();
		tards[0].clean();
		tards[1].clean();
		mc.removeMovieClip();
		mco.removeMovieClip();
		snapmc.removeMovieClip();
	}

var wibble;
var wiblur;

	function update()
	{
	var s;
	var i;
	
		if(_root.popup) { return; }

		
		dbgframe(" "+Math.floor(_root.scalar.t_ms)+"ms : "+ Math.floor(1000/_root.scalar.t_ms) +"fps"+" : "+Math.floor(_root.code_time/20)+"ms\n");


					
		if(state=="start")
		{
			if(!_root.popup) // wait for popup to clear
			{
				state="play";
			}
			else
			{
				return;
			}
		}
		
		if(state=="end")
		{
			tards[0].mc._visible=false;
			tards[1].mc._visible=false;
		
			if(!_root.popup) // wait for popup to clear
			{
				up.state_next="title";
			}
			
			return;
		}
		
		if(state=="end_done")
		{
			return;
		}
		
				
		_root.signals.signal("#(VERSION_NAME)","update",this);
		
		frame++;
		
		if(focus.px<400) { chat.hide(); } else
		if(focus.px<800) { chat.show(); } else
						 { chat.hide(); }
		chat.update();
		
//		talky.update();
		
/*
		if((score>0)&&(pickups.length>0))
		{
			score--;
		}
*/		
		
		_root.replay.apply_keys_to_prekey();		
		_root.replay.update();
		
//		update_water();
		
		for(i=0;i<tards.length;i++)
		{
			tards[i].update();
		}
		
//dbg.print( focus.mc._y );

//		var ny=focus.mc._y;
		
		var show_width=640;
		var show_height=480;
		
				
		if(chat.mc._visible)
		{
			show_height=chat.mc._y;
		}
		
		var sx=-(focus.px-(show_width/2));
		var sy=-(focus.py-50-(show_height/2));
		
		if(sx>x2_min) 					{sx=x2_min;}
		if(sy>(y2_max))		{sy=(y2_max);}

		if(sx<-(x2_max-show_width))		{sx=-(x2_max-show_width);}
		if(sy<y2_min+show_height)					{sy=y2_min+show_height;}

		
		mc.scrollRect=new flash.geom.Rectangle(-sx, -sy, 640,show_height);
//dbg.print(sy);

		for(i=0;i<pickups.length;i++)
		{
			if(pickups[i].update())
			{
			var	olditem=pickups[i];
				pickups.splice(i,1); // remove item
				i--;
				activate_item(olditem); // before we try and activate a new one...
				olditem.clean();
			}
		}
		
		var levnamestr=("<font size=\"12\"><br><b>"+(level.name)+"</b></font>");
		
		{
			gfx.set_text_html(mc_score.tf1,32,0xffffff,"<p align=\"center\"><b>"+score+"</b>"+levnamestr+"</p>");
		}
		
		for(i=0;i<items.length;i++)
		{
			if(items[i].update())
			{
				items[i].clean();
				items.splice(i,1);
				i--;
			}
		}

//		s="";
//		for(i=0;i<txd.length;i++)
//		{
//			s+=txd[i];
//		}
//		gfx.set_text_html(tfd,24,0x00ff00,s);
		

		txd=[];
		
	}
	

	
	
	
	function activate_item(olditem)
	{
	var i;
	}
	
	
	
	function dbgframe(s)
	{
		txd[txd.length]=s;
	}

	
// higher than 4 is special placement chars, not collision so ignore in col layers, just treat as 0, empty

#function MASK_COLLID(c) 
	if( #(c) >= 4) { #(c) = 0; }
#end


	function setcols(dat)
	{
	var i,x,y,w,h;
	var ids,wi,a;
	var item;
	
		dat=dat.split(",");
		for(i=0;i<dat.length;i++)
		{
			dat[i]=Math.floor(dat[i]);
		}
	
		ids=[];
		
		w=level.cw;
		h=level.ch;
	
		col=[];
		
		col[0]=[];
		for(y=0;y<h;y++)
		{
			for(x=0;x<w;x++)
			{
				ids[0]=dat[(x)+(y)*w];
			
#MASK_COLLID("ids[0]")

				col[0][x+y*w]=ids[0];
			}
		}
		
		col[1]=[];
		for(y=0;y<h;y++)
		{
			for(x=0;x<w;x++)
			{
				ids[0]=dat[(x)+(y)*w];
				
				if(x>0) 	{	ids[-1]=dat[(x-1)+(y)*w];	}
				else		{	ids[-1]=0;	}
				
				if(x<(w-1))	{	ids[ 1]=dat[(x+1)+(y)*w];	}
				else		{	ids[ 1]=0;	}
				
#MASK_COLLID("ids[-1]")
#MASK_COLLID("ids[ 0]")
#MASK_COLLID("ids[ 1]")

				if((ids[-1]==1)||(ids[ 0]==1)||(ids[ 1]==1))
				{
					col[1][x+y*w]=1;
				}
				else
				if(ids[0])
				{
					col[1][x+y*w]=ids[0];
				}
				else
				{
					if((ids[-1])||(ids[ 1]))
					{
						col[1][x+y*w]=17;
					}
					else
					{
						col[1][x+y*w]=ids[0];
					}
				}
			}
		}
		
// spread the super collision upwards on all layers

		for(i=0;i<2;i++)
		{
			for(x=0;x<w;x++)
			{
				for(y=1;y<h;y++)
				{
					if(col[i][x+y*w])
					{
						if(col[i][x+(y-1)*w]==1)
						{
							col[i][x+y*w]=1;
						}
					}
				}
			}
		}

// search for special chars and place items at their location
		for(y=0;y<h;y++)
		{
			for(x=0;x<w;x++)
			{
				ids[0]=dat[(x)+(y)*w];

				if(ids[ 0]==255) // start
				{
					tards[0]=new Vtard2d(this);
					tards[0].setup("vtard_shi");
					tards[0].px=x*20+10;
					tards[0].py=-y*20;
				}
			}
		}
		
	}
	
	function getcol(x,y,w)
	{
		y=-y-1;
		if(x<0) return 0;
		if(x>=level.cw) return 0;
		if(y<0) return 0;
		if(y>=level.ch) return 0;
		if(w==1) return col[1][x+y*level.cw];
		return col[0][x+y*level.cw];
	}
	

// apply the current best score, if it is more than the best score we already know about
// then return the total of all currently ranked games

var scores_easy;
var scores_hard;

// also setup new / old for display at end of level
var scores_best_new;
var scores_best_old;
var scores_story_total;

// this is called by signals, after a level win
	function get_rank_score(best)
	{
	var a;
	var total;
	var i;
	
		scores_best_new=best;
		scores_best_old=0;
						
		total=0;
	
		if(gameskill=="easy")
		{
			a=scores_easy;
		}
		else // hard
		{
			a=scores_hard;
		}
						
		if(a)
		{
//dbg.print("gota");
			for(i=0;i<10;i++)
			{
				if(a[i][2]==up.game_seed)
				{
					scores_best_old=a[i][0];
					
					if(a[i][0] < best) // replace with higher score
					{
						a[i][0]=best;
					}
					
					scores_story_total+=a[i][0];
				}
				
				if(a[i][0])
				{
					total+=a[i][0];
				}
			}
		}
//dbg.print("TOTAL="+total);
		return total;
	}
}



