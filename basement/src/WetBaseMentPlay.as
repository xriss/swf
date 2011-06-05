/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class WetBaseMentPlay
{
	var up;
	
	var talky;
	
	var level;
	
	var mc;
	
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

#WCELL=2

	var water_chars_bmp;
	var water_bmp;
	var water_active;	// acitive water streams
	var water;			// water cells
	
	var water_seep; // seep data, fill in water from bottom
	var water_waves; // active wave array
	var dribble_vol;
	
	var chats;
	var chat;
	var chat_idx;
	var chat_tim;
	
	var gamemode;
	var gameskill;
	
	var state;
	
	function WetBaseMentPlay(_up)
	{
	var t,tt;
	
		gamemode="race"; // or story
		gameskill="easy"; // or hard
		
		up=_up;
		
		_root.bmc.clear_loading();
		_root.bmc.remember( "water_chars" , bmcache.create_img , 
		{
			url:"water_chars" ,
			bmpw:220 , bmph:80 , bmpt:true ,
			hx:0 , hy:0
		} );
		
		_root.bmc.remember( "water" , bmcache.create_null , 
		{
			url:"water_chars" ,
			bmpw:800 , bmph:600 , bmpt:true ,
			hx:0 , hy:0
		} );
		
		talky=new Talky(this);
		
		
		
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
	
		level=up.levels[up.level_idx];
		chat=level.chat_start;

		up.game_seed=level.game_seed; // we worked out the right seed for each level at the start
		rnd_seed(up.game_seed);
		
		frame=0;
		score=0;
		
		dribble_vol=-1; // flag start sound

		items=[];
		pickups=[];
		blubs=[];
		
		if(snapbmp)
		{
			snapmc=gfx.create_clip(up.mc,null);
			snapmc.attachBitmap(snapbmp,0,"auto",true);
			
			snapmc._y=0;
			mc._y=snapmc._y-600;
			
			snapold.dest=null;
		}
		else
		{
			snapmc=null;
		}
		
		mc=gfx.create_clip(up.mc,null);
		
/*		
		w=800;
		h=600;
		d=400;
		bmc=gfx.add_clip(mc,"back_test",null,0,0);
		bmc.cacheAsBitmap=true;
*/

//2d origin and bounds
		
		x2=0;
		y2=600;
		
		x2_min=0;
		y2_min=0;
		x2_max=800;
		y2_max=600;
		
//3d origin	and bounds

		x3=0;
		y3=0;
		z3=0;
		
		x3_min=0;
		y3_min=0;
		z3_min=0;
		
		x3_max=800;
		y3_max=600;
		z3_max=0;
		
		

		
		
		bmc=gfx.add_clip(mc,level.img_bak,null,0,0);
		bmc.cacheAsBitmap=true;
				
		imc=gfx.create_clip(mc,null);

		tards=[];

		
// process collision data

		setcols(level.col);


		
		tards[0]=new Vtard2d(this,"talker");
		tards[0].setup(up.tards[up.tard_idx].img1);
		tards[0].state="talker";
		tards[0].chat_id=1;
		
		tards[0].px=start_x;
		tards[0].py=start_y;
		
		if(gamemode=="story")
		{
			if(tards[1]==undefined)
			{
				tards[1]=new Vtard2d(this,"player");
				tards[1].setup("vtard_kriss");		
				tards[1].state="talker";
				tards[1].chat_id=0;
			}
		}
		
		chat_idx=-1;
		chat_tim=0;
		
		focus=tards[0];
		
		
		blubs_mc=gfx.create_clip(mc,null);;
		
		wmc=_root.bmc.create(mc,"water" ,null);
		wmc._alpha=50;
		
//		wmc._y=6;
		
//		gfx.blur(wmc , 1,1,1 );
		
//		gfx.blur( wmc , 16 , 16 , 1 );
//		gfx.blur( wmc , 16 , 16 , 1 );

/*
	wmc.filters = [
	
//	new flash.filters.BlurFilter( 4, 4, 1 ) ,
	new flash.filters.GlowFilter(  0xffffff, (255/255), 4, 4, 2,1, false, false ) 
//	new flash.filters.DropShadowFilter( 4, 45, 0x000000, (255/255), 1, 1, 1,3, false, false, false ) 
	
	];
*/
	
		fmc=gfx.create_clip(mc,null);
		gfx.clear(fmc);
		fmc.style.fill=0xff000000;
		gfx.draw_box(fmc,0,0,0,20,600);
		gfx.draw_box(fmc,0,0,600-20,800,20);
		gfx.draw_box(fmc,0,800-20,0,20,600);
		
//		fmc.bmp=gfx.add_clip(fmc,level.img_for,null,0,0);

		fmc.cacheAsBitmap=true;
		
		
		
		
		tfd=gfx.create_text_html(mc,null,0,0,800,600);
		txd=[];
		
		_root.replay.reset();
		
		talky.setup();
		
		tards[0].talk=talky.create(tards[0].mc,0,-30);
		tards[1].talk=talky.create(tards[1].mc,0,-30);
		
		activate_item();
		
		mc_score=gfx.create_clip(mc,null);
		mc_score.tf1=gfx.create_text_html(mc_score,null,300,0,200,75);
		gfx.glow(mc_score , 0xffffff, .8, 16, 16, 1, 3, false, false );

		
		_root.signals.signal("#(VERSION_NAME)","set",this);
		_root.signals.signal("#(VERSION_NAME)","start",this);
		
		
		state="start";
		
		if(gamemode=="race")
		{
			_root.wetplay.PlaySFX(null,3,65536,0);
			up.high.setup();
			
			for(i=0;i<_root.menu.customItems.length;i++)
			{
				if(_root.menu.customItems[i].id=="restart")
				{
					_root.menu.customItems[i].visible=true;
				}
			}
		}
		else
		if(gamemode=="story")
		{
// reset story base score on 1st level
			if(up.level_idx==1)
			{
				scores_story_total=0;
			}
		}
		
		update();
		update();
		
	}
	
// take a snapshot of this level so we can scroll it off for a level transition.
	function build_snapbmp()
	{
		snapbmp=new flash.display.BitmapData(800,600,false,0x00000000);
		snapbmp.draw(mc);
		snapold=new Object();
		snapold.x=tards[0].mc._x;
		snapold.y=tards[0].mc._y;
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

		talky.clean();
		tards[0].clean();
		tards[1].clean();
		mc.removeMovieClip();
		snapmc.removeMovieClip();
	}

var wibble;
var wiblur;

	function update()
	{
	var s;
	var i;
	
		if(_root.popup) { return; }

		if(state=="start")
		{
			if(gamemode=="story")
			{
				if(snapmc) // do fade in
				{
				var d,dd;
				
					wibble++;
				
					tards[0].mc._visible=false;
					tards[1].mc._visible=false;
								
					if(frame>0)
					{
						tards[0].mc._visible=true;
						
						if(snapold.dest==null)
						{
							snapold.dest=new Object();
							
							snapold.dest.x=tards[0].mc._x;
							snapold.dest.y=tards[0].mc._y;
							
							tards[0].mc.x=snapold.x;
							tards[0].mc.y=snapold.y+600;
						}
						
						d=600-snapmc._y; dd=Math.floor(d/16);
						dd=d/16; if(dd>8) {dd=8;} if(dd<-8) {dd=-8;}
						if(dd<1) { dd=1; }
						snapmc._y+=dd;
						mc._y=snapmc._y-600;
					
						if(wibble>1)
						{
							d=snapold.dest.y-tards[0].mc.y;
							dd=d/16; if(dd>12) {dd=12;} if(dd<-12) {dd=-12;}
							tards[0].mc.y+=dd;
							
							d=snapold.dest.x-tards[0].mc.x;
							dd=d/16; if(dd>12) {dd=12;} if(dd<-12) {dd=-12;}
							tards[0].mc.x+=dd;
							
							tards[0].mc._x=tards[0].mc.x;
							tards[0].mc._y=tards[0].mc.y;//-mc._y;
						}
						
						wiblur=wiblur+((0-wiblur)/32);
						
						gfx.blur( tards[0].mc , wiblur , wiblur , 1 );
//				gfx.blur( tards[0].mc , 16+(16*(((wibble%17)-8)/8)), 16+(16*((((wibble+8)%17)-8)/8)) , 1 );
					}
					else
					{
						wibble=0;
						wiblur=64;
					}
				
					if(snapmc._y>=600)
					{
						mc._y=0;
						
						snapmc.removeMovieClip();
						snapmc=null;
						
						tards[0].mc._visible=true;
						tards[1].mc._visible=true;
						tards[0].mc.filters=null;
						
						state="play";
					}
					else
					{
						if(frame>0)
						{
							return;
						}
					}
				}
				else
				{
					state="play";
				}
			}
			else
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
		}
		
		if(state=="end")
		{
			tards[0].mc._visible=false;
			tards[1].mc._visible=false;
		
			if(!_root.popup) // wait for popup to clear
			{
				if(gamemode=="story")
				{
					up.state_next="play";
					up.level_idx++;
					if(up.level_idx==11)
					{
						up.title.state="end1_all";
						up.state_next="title";
						up.level_idx=1;
					}
				}
				else
				{
					if(up.high.retry) // play high requested a retry
					{
						up.state_next="play";
					}
					else
					{
						up.title.state="levels_all";
						up.state_next="title";
					}
				}
				
				state="end_done";
			}
			
			return;
		}
		
		if(state=="end_done")
		{
			return;
		}
		
				
		_root.signals.signal("#(VERSION_NAME)","update",this);
		
		frame++;
		
		talky.update();
		
		if((score>0)&&(pickups.length>0))
		{
			score--;
		}
		
		
		_root.replay.apply_keys_to_prekey();		
		_root.replay.update();
		
		update_water();
		
		for(i=0;i<tards.length;i++)
		{
			tards[i].update();
		}
		
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
		
		if(gamemode=="story")
		{
			if(state=="play")
			{
				gfx.set_text_html(mc_score.tf1,32,0xffffff,"<p align=\"center\"><b>"+(scores_story_total+score)+"</b>"+levnamestr+"</p>");
			}
			else
			{
				gfx.set_text_html(mc_score.tf1,32,0xffffff,"<p align=\"center\"><b>"+(scores_story_total)+"</b>"+levnamestr+"</p>");
			}
		}
		else
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
		
		for(i=0;i<blubs.length;i++)
		{
			if(blub_update(blubs[i]))
			{
				blub_remove(blubs[i]);
				blubs.splice(i,1);
				i--;
			}
		}
/*
		if(focus)
		{
		var x,y
		
			x=-focus.mc._x+400;
			y=-focus.mc._y+300;
			if(x>-x2_min) { x=-x2_min; }
			if(y>-y2_min) { y=-y2_min; }
			if(x<-x2_max+800) { x=-x2_max+800; }
			if(y<-y2_max+600) { y=-y2_max+600; }
			
			mc._x=mc._x+(x-mc._x)*0.5;
			mc._y=mc._y+(y-mc._y)*0.5;
			
			if( x2_max-x2_min < 800 ) mc._x=(800-(x2_max-x2_min))/2;
			if( y2_max-y2_min < 600 ) mc._y=(600-(y2_max-y2_min))/2;
		}
*/

		s="";
		for(i=0;i<txd.length;i++)
		{
			s+=txd[i];
		}
		gfx.set_text_html(tfd,16,0x00ff00,s);
		

		txd=[];
	}
	

	
	
	
	function activate_item(olditem)
	{
	var i;
	
		if(olditem) // prepare for launch
		{
		var l;
		var p={};
		var vx,vy;
		var dx,dy
		
			p.x=0;
			p.y=0;
			olditem.mc.localToGlobal(p);
			up.over.mc.globalToLocal(p);
			
			vx=( tards[0].vx);
			vy=(-tards[0].vy);
			
			for(i=5;i>0;i--)
			{
				dx=16*((rndg()-0x8000)/0x8000);
				dy=8*((rndg()-0x8000)/0x8000)-32;
				l=FieldItem.hard_launch(up.over, "ether", p.x,p.y , vx+dx, vy+dy );
			}
			
			up.over.add_floater("<b>500</b><font size=\"12\">pts</font>",p.x,p.y);
			
			_root.wetplay.PlaySFX("sfx_jar",1);
		}
			
// check that we have items remaining
		if(pickups.length>23-13)
//		if(pickups.length>0)
		{
			i=rnd()%pickups.length;
			pickups[i].activate();
		}
		else
		{
			state="end";			
			_root.signals.signal("#(VERSION_NAME)","won",this);
			
			if(gamemode=="race")
			{
				_root.wetplay.PlaySFX(null,3,65536,0);
				up.high.setup("results");
			}
			else
			if(gamemode=="story")
			{
				if(up.level_idx==10) // disply ranks at end of last level
				{
					_root.wetplay.PlaySFX(null,3,65536,0);
					up.high.setup("rank");
				}
			}
		}
	}
	
	
	var blubs;
	var blubs_mc;
	
	function blub_add(_x,_y)
	{
	var bb={};
	
		bb=gfx.create_clip(mc,null);
		bb._x=Math.floor(_x+(((rndg()&255)-127)/32));
		bb._y=Math.floor(_y+(((rndg()&255)-127)/16));
		
		gfx.clear(bb);
		bb.style.out=0x80ffffff;
		bb.style.fill=0x80ffffff;
		gfx.draw_rounded_rectangle(bb,0,5,2,-5,-5,10,10);
		bb._alpha=50;
		
		bb.pop=false;
		
		blubs[blubs.length]=bb;
	}
	
	function blub_update(bb)
	{
	var w;
	
		if(bb.pop)
		{
			bb._xscale+=20;
			bb._yscale+=20;
			bb._alpha-=10;
			
			if(bb._alpha<=0)
			{
				return true;
			}
		}
		else
		{
			bb._y-=2;
			
			if( (bb._y%8) < 4 )
			{
				bb._x-=1;
			}
			else
			{
				bb._x+=1;
			}
			
			w=getwet( Math.floor((bb._x)/20) , Math.floor((600-bb._y)/20) );
			
			if((w<0.5)||(w==2))
			{
				bb.pop=true;
				
				_root.wetplay.PlaySFX("sfx_plop2",2);
			}
		}
		
		return false;
	}

	function blub_remove(bb)
	{
		bb.removeMovieClip();
	}
	
	
	function dbgframe(s)
	{
		txd[txd.length]=s;
	}

	
// higher than 128 is special placement chars, not collision so ignore in col layers, just treat as 0, empty

#function MASK_COLLID(c) 
	if( #(c) >= 128) { #(c) = 0; }
#end


	function setcols(dat)
	{
	var i,x,y,w,h;
	var ids,wi,a;
	var item;
	
		ids=[];
		
		w=40;
		h=30;
	
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
		
// fill in water layers

		water_active=[];
		water=[];
		
		for(y=0;y<h;y++)
		{
			for(x=0;x<w;x++)
			{
				ids[0]=dat[(x)+(y)*w];
				wi=(x*#(WCELL))+(y*w*#(WCELL));

#MASK_COLLID("ids[ 0]")

				water[wi+0]=0; // x velocity -1 +1
				water[wi+1]=0; // filled with water 0-1 ( >=2 then not water just a blockage)
				
				if(ids[ 0])
				{
					water[wi+1]=2;
				}
			}
		}
		
		
		water_waves=[]; // clear waves
		
// search for special chars and place items at their location
		for(y=0;y<h;y++)
		{
			for(x=0;x<w;x++)
			{
				ids[0]=dat[(x)+(y)*w];
				wi=(x*#(WCELL))+(y*w*#(WCELL));

				if( (ids[ 0]>=0xd0) && (ids[ 0]<0xf0) )
				{
					var inout=ids[ 0]&0x10;
					var inout_id=ids[ 0]&0x0f;
					var otheridx=-1;
					
					for(i=0;i<items.length;i++)
					{
						if(items[i].type=="inout")
						{
							if(items[i].id==inout_id)
							{
								otheridx=i;
							}
						}
					}
					
					item=new PlayItem(this,x,y,"inout");
					item.id=inout_id;
					if(inout) { item.activate(); }
					item.other=null;
					if(otheridx>=0)
					{
						item.other=items[otheridx];
						items[otheridx].other=item;
					}
					
//					dbg.print("inout "+inout+" "+inout_id+" "+otheridx);
					
					items[items.length]=item;
				}
				else
				if(ids[ 0]==255)
				{
					a=new Object();
					
					a.px=x;
					a.py=y;
					
					a.vx=0; // vel
					a.vy=0;
					
					wi=(a.px*#(WCELL))+(a.py*w*#(WCELL));
					water[wi+1]=0.1;
					add_wave(a.px,a.py);
			
					water_active[0]=a;
				}
				else
				if(ids[ 0]==254)
				{
//					dbg.print(x+" "+y);
					pickups[pickups.length]=new PlayItem(this,x,y,"meta");
				}
				else
				if(ids[ 0]==253)
				{
					start_x=x*20+10;
					start_y=y*20;
				}
				else
				if(ids[ 0]==252)
				{
//					dbg.print(x+" "+y);
					items[items.length]=new PlayItem(this,x,y,"bump");
				}
				else
				if(ids[ 0]==251)
				{
//					dbg.print(x+" "+y);
					items[items.length]=new PlayItem(this,x,y,"cannon");
				}
				else
				if(ids[ 0]==250)
				{
					if(gameskill=="hard")
					{
						items[items.length]=new PlayItem(this,x,y,"whirl");
					}
				}
				else
				if(ids[ 0]==249)
				{
					tards[1]=new Vtard2d(this);
					tards[1].setup("vtard_kriss","chucker");
					tards[1].px=x*20+10;
					tards[1].py=y*20;
					tards[1].chat_id=0;
					
					tards[1].data.whirl1=new PlayItem(this,x,y,"whirl");
					tards[1].data.whirl1.disable();					
					items[items.length]=tards[1].data.whirl1;
				}
			}
		}

		_root.bmc.bmp_fill("water",0,0,800,600,0x00000000);	
		
		for(y=0;y<h;y++)
		{
			for(x=0;x<w;x++)
			{
				draw_water(x,y); // draw all water cells
			}
		}
		
		a=new Object();
		
		a.px=1;
		a.py=0;
		
		water_seep=a;
		
	}
	
	function getcol(x,y,w)
	{
		if(x<0) return 0;
		if(x>=40) return 0;
		if(y<0) return 0;
		if(y>=30) return 0;
		if(w==1) return col[1][x+y*40];
		return col[0][x+y*40];
	}
	
	function getwet(x,y)
	{
		if(x<0) return 0;
		if(x>=40) return 0;
		if(y<0) return 0;
		if(y>=30) return 0;
		
		return water[( x*#(WCELL))+(y*40*#(WCELL))+1 ];
	}
	
	function draw_water(x,y,bend)
	{
	var ret;
	var wi,wid,w,h;
	var t;
	
		w=40;
		h=30;
	
		wi=(x*#(WCELL))+(y*w*#(WCELL));
		
		wid=(x*#(WCELL))+((y-1)*w*#(WCELL));
		
		ret=water[wi+1];
		
		if( water[wi+1] !=2  )
		{
			t=Math.floor(10*ret);
			if(bend) { t=t+bend; }
			if(t<0) {t=0;}
			if(t>10) {t=10;}
			
			if( water[wi+0]==2 ) //seepage
			{
				_root.bmc.bmp_blit("water_chars","water",20*t,20*1,20,20,x*20,580-y*20);
			}
			else
			if(y>0) // check bellow
			{
				if(water[wid+1] < 1) // falling
				{
					_root.bmc.bmp_blit("water_chars","water",20*t,20*2,20,20,x*20,580-y*20);
				}
				else
				{
					_root.bmc.bmp_blit("water_chars","water",20*t,20*3,20,20,x*20,580-y*20);
				}
			}
			else
			{
				_root.bmc.bmp_blit("water_chars","water",20*t,20*3,20,20,x*20,580-y*20);
			}
		}
		else
		{
			_root.bmc.bmp_blit("water_chars","water",20*0,20*3,20,20,x*20,580-y*20);
		}
	
		return ret;
	}
	
	function add_wave(x,y)
	{
	var a;
		a=new Object();
		
		a.px=x;
		a.py=y;
			
		water_waves[water_waves.length]=a;
		
	}
	
	function update_water()
	{
	var w,h;
	var i,a;
	var wi,wil,wir,wid,wiu,wif;
	var x,y,wify;
	var r,t;
	
		w=40;
		h=30;
		
		if(dribble_vol==-1)
		{
			_root.wetplay.PlaySFX("sfx_dribble",3,65536,0);
		}
		
		dribble_vol=water_waves.length/256;
		if(dribble_vol>1) { dribble_vol=1; }
				
		_root.wetplay.PlaySFX(null,3,65536,dribble_vol);
		
		for(i=0;i<water_active.length;i++)
		{
			a=water_active[i];
			
			wi=(a.px*#(WCELL))+(a.py*w*#(WCELL));
			
			wil=((a.px-1)*#(WCELL))+(a.py*w*#(WCELL));
			wir=((a.px+1)*#(WCELL))+(a.py*w*#(WCELL));
			
			wiu=(a.px*#(WCELL))+((a.py+1)*w*#(WCELL));
			wid=(a.px*#(WCELL))+((a.py-1)*w*#(WCELL));
			
			if( (water[wid+1] < 1) && (water[wid+0]!=2) ) // fall down if it didnt used to be solid
			{
				a.py-=1;
			}
			else
			if( ( water[wir+1] < water[wil+1] ) && ( water[wir+1] < water[wi+1] ) && (water[wir+0]!=2) )
			{
				a.px+=1;
				a.vx= 1;
			}
			else
			if( ( water[wil+1] < water[wir+1] ) && ( water[wil+1] < water[wi+1] ) && (water[wil+0]!=2) )
			{
				a.px-=1;
				a.vx=-1;
			}
			else
			if( ( water[wi+0] > 0 ) && (water[wi+0]!=2) ) // keep going in the same direction
			{
				if( ( water[wir+1] < 2 ) && (water[wir+0]!=2) )
				{
					a.px+=1;
					a.vx= 1;
				}
				else
				{
					a.vx=-1;
				}
			}
			else
			{
				if( ( water[wil+1] < 2 ) && (water[wil+0]!=2) )
				{
					a.px-=1;
					a.vx=-1;
				}
				else
				{
					a.vx= 1;
				}
			}
			
			wi=(a.px*#(WCELL))+(a.py*w*#(WCELL));
			wiu=(a.px*#(WCELL))+((a.py+1)*w*#(WCELL));
			
			if(a.py<29)
			{
				if( water[wi+1] == 1 ) // this one is full, try going up
				{
					if( water[wiu+1] < 2 )
					{
						a.py+=1;
					}
				}
			}
			
			wi=(a.px*#(WCELL))+(a.py*w*#(WCELL));
			
				
			water[wi+1]+=0.1;
			if( water[wi+1] > 0.95 ) water[wi+1]=1;
			if(water[wi+0]<2) water[wi+0]=a.vx;
			
			if(water[wi+1]==0.1)
			{
				add_wave(a.px,a.py);
			}
			
			draw_water(a.px,a.py);
		}
		
		a=water_seep;
		wif=-1;
		for(y=0;y<30;y++)
		{
			wi=(a.px*#(WCELL))+(y*w*#(WCELL));
			
			if(water[wi+1]==1)
			{
				if(wif!=-1) // seep down, if full and below has been empty
				{
					if(water[wif+1]==0) continue;
					
					if(water[wif+1]==2) { water[wif+1]=0; water[wif+0]=2; }
					
					water[wif+1]+=0.1;
					
					if( water[wif+1] > 0.95 ) water[wif+1]=1;
					
					add_wave(a.px,wify);
					draw_water(a.px,wify);
					
					wif=-1;
//					break;
				}
			}
			else
			{
				wif=wi;
				wify=y;
			}
		}
		a.px+=1;
		if(a.px>38) { a.px=1; }
		
		

//dbg.print(water_waves.length)

		if((frame%2)==0)
		{
			for(i=0;i<water_waves.length;i++)
			{
				a=water_waves[i];
				
				t=(a.px+a.py+(frame/2))%4;
				if(t>1) { t=4-t; } 
				t=1-t;
				
				r=draw_water(a.px,a.py,t);
				
				if(r==1) // remove this wave as it is now full
				{
					draw_water(a.px,a.py,0);
					water_waves.splice(i,1);
					i--;
				}
			}
		}
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



