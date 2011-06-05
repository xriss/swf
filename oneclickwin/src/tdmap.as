/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class tdmap
{
	var up;
	
	var mc;
	
	var comms;
	
	var room;

	var state;
	
	var pixls;
	
	var mcs;
	var bms;
	var tfs;
	
	var creep_entrance=[1,1];
	var creep_exit=[28,28];
	
	var block_idx=0; // which block to place
	var block_type=0; // which type of block to place
	
	var mc_blocks;
	var bm_blocks;
	var map_blocks=	[
	
					[  5, 1 ,  6, 1 ,  6, 2 ,  5, 2 ],
					
					[  2, 2 ,  2, 1 ,  2, 3 ,  2, 4 ],					
					[  5, 4 ,  4, 4 ,  6, 4 ,  7, 4 ],
					
					[  2, 7 ,  2, 6 ,  2, 8 ,  3, 8 ],
					[  6, 7 ,  6, 6 ,  6, 8 ,  5, 8 ],					
					[  3,11 ,  3,10 ,  2,10 ,  3,12 ],
					[  5,11 ,  5,10 ,  6,10 ,  5,12 ],
					
					[  2,14 ,  3,14 ,  1,14 ,  1,15 ],
					[  6,14 ,  5,14 ,  7,14 ,  7,15 ],
					[  2,18 ,  1,17 ,  1,18 ,  3,18 ],
					[  6,18 ,  7,17 ,  7,18 ,  5,18 ],
					
					[  2,21 ,  2,20 ,  1,21 ,  3,21 ],
					[  6,20 ,  5,20 ,  7,20 ,  6,21 ],
					[  3,24 ,  3,23 ,  2,24 ,  3,25 ],
					[  5,24 ,  5,23 ,  6,24 ,  5,25 ],
					
					[  3,28 ,  3,27 ,  2,28 ,  2,29 ],
					[  5,28 ,  5,27 ,  6,28 ,  6,29 ],
					[  2,32 ,  1,32 ,  2,31 ,  3,31 ],
					[  6,31 ,  5,31 ,  6,32 ,  7,32 ]
					
					];
					
	var block_groups=[ // the rotated groups of 6-7 distinct shapes
	
						[0,0,0,0],
						[1,2,1,2],
						[3,7,5,10],
						[4,9,6,8],
						[11,14,12,13],
						[17,16,18,15]
	
					];
					
	var sfx_pop_order=[4,3,2,1,3,2,1,6,2,1,6,5,1,5,8,7,8,5,6,8,5,6,1,1,2,3,2,1,1,2,3];
			
	var block_flags;
	

	var block_groups_reverse;
	
	var map_blocks_reverse;
	
	var map;
	var creeps;
	
	var maxx,maxy;
	
	var teleportals;
	
	var talky;
	var talker;
	
	var rainbow_colors=[
					0xffff0000,0xffff6600,0xffffcc00,
					0xffffff00,0xffccff00,0xff66ff00,
					0xff00ff00,0xff00ff66,0xff00ffcc,
					0xff00ffff,0xff00ccff,0xff0066ff,
					0xff0000ff,0xff6600ff,0xffcc00ff,
					0xffff00ff,0xffff00cc,0xffff0066];
	
	function tdmap(_up)
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
	var x,y,t,xx,yy;
	var i,j,v;
	
	
		tim=0;
		tim_mod=0;
		tim_pop=0;
		tim_flag=true;
		
		sfx_pop_idx=0;
	
		rnd_seed( up.up.game_seed );
		
		teleportals=[];
	
		map_blocks_reverse=[]; // build reverse lookup
		for(i=0;i<map_blocks.length;i++)
		{
			v=map_blocks[i];
			for(j=0;j<map_blocks[i].length;j+=2) // always 4 parts
			{
				if(!map_blocks_reverse[ v[j] ])
				{
					map_blocks_reverse[ v[j] ]=[];
				}
				map_blocks_reverse[ v[j] ][ v[j+1] ]=i+1;
			}
		}
		block_groups_reverse=[]; // build reverse lookup
		for(i=0;i<block_groups.length;i++)
		{
			v=block_groups[i];
			for(j=0;j<v.length;j++)
			{
				block_groups_reverse[ v[j] ]=i;
			}
		}
		block_flags=[];
		for(i=0;i<6;i++)
		{
			block_flags[i]=[];
			block_flags[i].total=0;
			block_flags[i].next=0;
			block_flags[i].cycle=0;
		}
	
		state="none";
		
		mc=gfx.create_clip(up.mc,null);
		
		mcs=[];
		tfs=[];
		bms=[];
		bms=[];
		bms=[];
		bms=[];
		bms=[];
		bms=[];
		map=[];
		creeps=[];
		
		maxx=30;
		maxy=30;
		
		bms[0]=new flash.display.BitmapData(maxx*5,maxy*5,true,0x00000000);
		mcs[0]=gfx.create_clip(mc,null);
		mcs[0].attachBitmap(bms[0],0,"always",false);
		mcs[0]._xscale=400;
		mcs[0]._yscale=400;
		
		bms[1]=new flash.display.BitmapData(maxx*5,maxy*5,true,0x00000000);
		mcs[1]=gfx.create_clip(mc,null);
		mcs[1].attachBitmap(bms[1],0,"always",false);
		mcs[1]._xscale=400;
		mcs[1]._yscale=400;
		
		
		mcs.blocks=gfx.add_clip(mc,"pixl_blocks",null);
		bms.blocks=new flash.display.BitmapData(11*5,34*5,true,0x00000000);
		bms.blocks.draw(mcs.blocks);
		mcs.blocks.removeMovieClip();

/*
		mcs.blocks=gfx.create_clip(mc,null);
		mcs.blocks._x=600;
		mcs.blocks._y=0;
		mcs.blocks._xscale=300;
		mcs.blocks._yscale=300;
		mcs.blocks.attachBitmap(bms.blocks,0,"always",false);
*/		
		mcs.plots=gfx.add_clip(mc,"pixl_plots",null);
		bms.plots=new flash.display.BitmapData(25*15,4*15,true,0x00000000);
		bms.plots.draw(mcs.plots);
		mcs.plots.removeMovieClip();
		
		for(i=2;i<2+6;i++)
		{
			bms[i]=new flash.display.BitmapData(6*5,6*5,true,0x00000000);
			mcs[i]=gfx.create_clip(mc,null);
			mcs[i].attachBitmap(bms[i],0,"always",false);
			mcs[i]._xscale=300;
			mcs[i]._yscale=300;
			mcs[i]._x=600+50;
			mcs[i]._y=100+ 4*15*(i-0);
			
			if(i==2) { mcs[i]._x-=3*3; }
			if(i==3) { mcs[i]._x-=3*3; }
			
			if(i>=2) { mcs[i]._y-=15; }
			if(i>=4) { mcs[i]._y+=15; }
			
			mcs[i].block=i-2;
			mcs[i].onRollOver=delegate(block_over,mcs[i]);
			mcs[i].onRollOut=delegate(block_out,mcs[i]);
			mcs[i].onReleaseOutside=delegate(block_out,mcs[i]);
			mcs[i].onRelease=delegate(block_press,mcs[i]);
			
		}
		
		tfs.score=gfx.create_text_html(mc,null,600,15,125,200);		
		
		mcs.end=gfx.create_clip(mc,null);
		mcs.end.txt=gfx.create_text_html(mcs.end,null,620,190,120,30);
		gfx.set_text_html(mcs.end.txt,24,0xffffffff,"<b><p align=\"center\">FINISH</p></b>");		
		mcs.end.block=-1;			
		mcs.end.onRollOver=delegate(block_over,mcs.end);
		mcs.end.onRollOut=delegate(block_out,mcs.end);
		mcs.end.onReleaseOutside=delegate(block_out,mcs.end);
		mcs.end.onRelease=delegate(block_press,mcs.end);
		
		mcs.high=gfx.create_clip(mc,null);
		mcs.high.txt=gfx.create_text_html(mcs.high,null,600,190-35,125,30);		
//		gfx.set_text_html(mcs.high.txt,24,0xffffffff,"<b><p align=\"center\">High</p></b>");		
		mcs.high.block=-2;
		mcs.high.onRollOver=delegate(block_over,mcs.high);
		mcs.high.onRollOut=delegate(block_out,mcs.high);
		mcs.high.onReleaseOutside=delegate(block_out,mcs.high);
		mcs.high.onRelease=delegate(block_press,mcs.high);
		
		if(up.level)
		{
			map_load(up.level);
		}
		else
		{
			map_generate();
		}
		
		if(up.up.select.save[up.up.game_seed].map)
		{
			str_to_map( up.up.select.save[up.up.game_seed].map );
		}
		
		block_idx=0;
		block_type=0;
		
		path_step=0;
		
		score_fat=0;
		score_age=0;
		display_score();
		
		show_next_blocks();
		
		path_check();
		draw_back();
		draw_over();
		
		if(up.level.help)
		{
			tfs.help=gfx.create_text_html(mc,null,20,20,560,560);
			gfx.set_text_html(tfs.help,24,0xffffffff,up.level.help);
		}

		pixls=new OverPixls(up); pixls.setup(); // effect layer
		
		Mouse.addListener(this);
		mouse_click=false;
		mouse_down=false;
		
		
		talky=new Talky(this);
		talky.setup();
		
		talker=gfx.create_clip(mc,null);
		
		talker.bub=talky.create(talker,0,0);
	}
	
	function clean()
	{
		talky.clean();
	
//		if(up.level)
		{
			up.up.select.save[up.up.game_seed].map=map_to_str();
		}
		
		up.up.select.so_save(); // force save
	
		pixls.clean();
		
		mc.removeMovieClip();
	}
	
	function clear_map()
	{
	var i;
		block_flags=[];
		for(i=0;i<6;i++)
		{
			block_flags[i]=[];
			block_flags[i].total=0;
			block_flags[i].next=0;
			block_flags[i].cycle=0;
		}
		
		tim=0;
		tim_mod=0;
		tim_pop=0;
		tim_flag=true;
		
		if(up.level)
		{
			map_load(up.level);
		}
		else
		{
			map_generate();
		}
		creeps=[];
		
		
	}
	
	function set_map_str(s)
	{
		clear_map();
		str_to_map( s );
		
		display_score();
		
		show_next_blocks();
		
		path_check();
		draw_back();
		draw_over();
	}
	
	function map_to_str()
	{
	var s,ss;
	var x,y,i,d,t;
	
		i=0;
		d=0;
		
		s=Clown.tostr(0x01,2); // simple version header
		for(y=0;y<30;y++)
		{
			ss="";
			for(x=0;x<30;x++)
			{
				t=map[ y*maxx + x ];
				
				if( ( t.type=="wall" ) && (t.mx==x)  && (t.my==y) ) // check it is the master placed block
				{
					ss+= Clown.tostr(d,2) + Clown.tostr(t.idx,1);
					d=1; // reset delta count
				}
				else
				{
					d=d+1; // just count delta till next block
				}
			}
			s+=ss;
		}
	
		return s;
	}
	function str_to_map(s)
	{
	var ver;
	var i,x,y,d,b;
	
		d=0;
		i=0;
		ver=Clown.tonum(s,i,2); i+=2;
		while(i<s.length)
		{
			d+=Clown.tonum(s,i,2); i+=2;
			b=Clown.tonum(s,i,1); i+=1;
			
			x=(d)%30;
			y=Math.floor(d/30)%30;
			
			if( (x>=0) && (x<30) && (y>=0) && (y<30) && (b>=0) && (b<map_blocks.length) )
			{
				just_add_block(x,y,b);
			}
		}
	}
	
	function map_load(level)
	{
	var m;
	var vt;
	var x,y,t,xx,yy;
	var i,j,v;
	
	var uid=0;
	var pid=0;
	
		i=0;
		for(y=0;y<maxy;y+=1)
		{
			for(x=0;x<maxx;x+=1)
			{
				t=[];
				m=level.col[i++];
				
				t.type="empty";
				t[0]=0xffff;
				
				if(m==0x11) // black
				{
					t.type="wall";
					t.wall="black";
				}
				else
				if(m==0x13) // white
				{
					t.type="wall";
					t.wall="white";
				}
				else
				if(m==0x33) // food
				{
					t.type="food";
					t.id=uid++; // unique id for each piece of food
				}
				else
				if(m==0x31) // fart
				{
					t.type="fart";
					t.id=uid++; // unique id for each piece of food
				}
				else
				if(m==0x37) // enter
				{
					t.type="enter";
					creep_entrance[0]=x ;
					creep_entrance[1]=y ;
				}
				else
				if(m==0x35) // exit
				{
					t.type="exit";
					creep_exit[0]=x ;
					creep_exit[1]=y ;
				}
				else
				if((m&0xf0)==0x50) // portal in
				{
					pid=m&0x0f;
					t.type="portal_in";
					t.portal=pid;
					t.id=uid++; // unique id
					teleportals[pid*4+0]=x ;
					teleportals[pid*4+1]=y ;
				}
				else
				if((m&0xf0)==0x70) // portal out
				{
					pid=m&0x0f;
					t.type="portal_out";
					t.portal=pid;
					t.id=uid++; // unique id
					teleportals[pid*4+2]=x ;
					teleportals[pid*4+3]=y ;
				}
				
				map[ y*maxx + x ]=t;
			}
		}
	}
	
	
	function map_generate()
	{
	var m;
	var vt;
	var x,y,t,xx,yy;
	var i,j,v;
	
		for(x=0;x<maxx;x+=1)
		{
			for(y=0;y<maxy;y+=1)
			{
				t=[];
				
				if( (x==0) || (y==0) || (x==maxx-1) || (y==maxy-1) )
				{
					t["type"]="wall";
					t[0]=0xffff;
				}
				else
				{
					t["type"]="empty";
					t[0]=0xffff;
				}
				
				map[ y*maxx + x ]=t;
			}
		}
		
		var uid=0;
		
		for(i=0;i<40;i++)
		{
			x=(rnd()%28) + 1;
			y=(rnd()%28) + 1;
			t=map[ y*maxx + x ];
			
			t["type"]="wall";
			t[0]=0xffff;
		}
		for(i=1;i<6;i++)
		{
			x=(rnd()%28) + 1;
			y=(rnd()%28) + 1;
			t=map[ y*maxx + x ];
			
			t["type"]="fart";
			t[0]=0xffff;
			t.id=uid++; // unique id for each piece of bad food
		}
		for(i=0;i<10;i++)
		{
			x=(rnd()%28) + 1;
			y=(rnd()%28) + 1;
			t=map[ y*maxx + x ];
			
			t["type"]="food";
			t[0]=0xffff;
			t.id=uid++; // unique id for each piece of food
		}
		
		x=(rnd()%28) + 1;
		y=(rnd()%28) + 1;
		t=map[ y*maxx + x ];
		creep_entrance[0]=x ;
		creep_entrance[1]=y ;
		t["type"]="enter";
		t[0]=0xffff;
		
		x=(rnd()%28) + 1;
		y=(rnd()%28) + 1;
		t=map[ y*maxx + x ];
		creep_exit[0]=x ;
		creep_exit[1]=y ;
		t["type"]="exit";
		t[0]=0xffff;
	}
	
	
	var score_fat=0;
	var score_age=0;
	function display_score(c)
	{
		var i;
		var lose=0;
		
		var sel=up.up.select;
		
		for(i=0;i<6;i++)
		{
			lose+=block_flags[i].total;
		}
		lose=lose*4; // each block is 4 squares
		var score=score_fat-score_age-lose;
		
		var oldscore=sel.save[up.up.game_seed].score
		
		if( c && ( tim_mod < c.born ) ) // do not allow juggling, and only count new when a creep gets in
		{
			if(oldscore<score)
			{
				sel.save[up.up.game_seed].score=score;
				sel.save[up.up.game_seed].score_fat=score_fat;
				sel.save[up.up.game_seed].score_age=score_age;
				sel.save[up.up.game_seed].score_lose=lose;
				
				if(up.up.game_seed<25) // save total score in mochi or other peoples bucket
				{
					up.score_total=0;
					for(i=0;i<25;i++)
					{
						up.score_total+=sel.save[i].score;
					}
					_root.signals.signal("ocw0","final",up);
				}
			}
			
			up.score=score; // save score where the signals can find it
			up.replay=map_to_str();
			up.up.select.save[up.up.game_seed].map=up.replay; // remember map layout for later
			
			_root.signals.signal("ocw0","high",up);
		}
		
		if( ( oldscore<up.levels[up.up.game_seed].winscore[2] ) && ( sel.save[up.up.game_seed].score>=up.levels[up.up.game_seed].winscore[2] ) )
		{
			up.pixls.add_text("ultimate");
		}
		else
		if( ( oldscore<up.levels[up.up.game_seed].winscore[1] ) && ( sel.save[up.up.game_seed].score>=up.levels[up.up.game_seed].winscore[1] ) )
		{
			up.pixls.add_text("extreme");
		}
		else
		if( ( oldscore<up.levels[up.up.game_seed].winscore[0] ) && ( sel.save[up.up.game_seed].score>=up.levels[up.up.game_seed].winscore[0] ) )
		{
			up.pixls.add_text("unlocked");
		}
		
		if(sel.save[up.up.game_seed].score>=up.levels[up.up.game_seed].winscore[0])
		{
			if(up.level.help)
			{
				if(!tfs.help.done_finish)
				{
					gfx.set_text_html(tfs.help,24,0xffffffff,up.level.help + "<br><b>Click FINISH to choose a new level.</b>");
					tfs.help.done_finish=true;
				}
			}
		}
		
		gfx.set_text_html(tfs.score,28,0xffffff,"<b><p align=\"right\"><font color=\"#00ff00\" >+"+score_fat+"</font></p><p align=\"right\"><font color=\"#ff0000\" >-"+score_age+"</font></p><p align=\"right\"><font color=\"#ff0000\" >-"+lose+"</font></p><p align=\"right\"><font color=\"#888888\" >="+score+"</font></p></b>");
		
		
		gfx.set_text_html(mcs.high.txt,24,0xffffffff,"<b><p align=\"right\"><font color=\"#ffffff\" >"+sel.save[up.up.game_seed].score+"</font></p></b>");		
		
	}
	
	function block_over(m)
	{
		if(m.block<0)
		{
			gfx.glow(m , 0xffffff, .8, 16, 16, 1, 3, false, false );
			
			if( m.block==-1 )
			{
				var n=up.level.name;
				if(n==undefined) { n="The level with no name."; }
				
				_root.poker.ShowFloat("Click to finish level #"+(up.up.game_seed)+" : "+n ,250);
			}
			else
			if( m.block==-2 )
			{
				_root.poker.ShowFloat("Click to submit and view high scores." ,250);
			}
			
			return;
		}
		_root.poker.ShowFloat(null,0);
		gfx.glow(m , 0xffffff, .8, 16, 16, 1, 3, false, false );
	}
	function block_out(m)
	{
		if(m.block<0)
		{
			_root.poker.ShowFloat(null,0);
			m.filters=null;
			return;
		}
		m.filters=null;
	}
	function block_press(m)
	{
		_root.poker.ShowFloat(null,0);
		
		if(m.block<0)
		{
			if( m.block==-2 )
			{
				_root.signals.signal("ocw0","high",up);
				up.up.high.setup();
				return;
			}
			up.up.state_next="select";
			return;
		}
		block_type=m.block;
		
		block_idx=block_flags[block_type].next; // make sure the next block to place is good
		block_flags[block_type].cycle++;
		
		show_next_blocks();
	}

	var mouse_click;
	var mouse_down;
	function onMouseDown()
	{
		if(_root.popup) { return; }
		
		check_change_block();
		mouse_down=true;
		mouse_click=true;
	}
	function onMouseUp()
	{
		if(_root.popup) { return; }
		
		mouse_down=false;
	}
	
	function block_blit(fx,fy,tx,ty) // copy 1 block data from and to a block x,y location
	{
		bms[0].copyPixels(bms.blocks , new flash.geom.Rectangle(fx*5,fy*5,5,5) , new flash.geom.Point(tx*5,ty*5) );
	}
	
	function block_merge(fx,fy,tx,ty) // copy 1 block data from and to a block x,y location
	{
		bms[0].copyPixels(bms.blocks , new flash.geom.Rectangle(fx*5,fy*5,5,5) , new flash.geom.Point(tx*5,ty*5) ,undefined,undefined,true );
	}

	function block_blit_over(fx,fy,tx,ty) // copy 1 block data from and to a block x,y location
	{
		bms[1].merge(bms.blocks , new flash.geom.Rectangle(fx*5,fy*5,5,5) , new flash.geom.Point(tx*5,ty*5) ,255,255,255,128 );
	}

	function plot_blit_over(fx,fy,tx,ty,flag) // copy 1 block data from and to a block x,y location
	{
	var f=(fx+tim)&3;
		bms[1].copyPixels(bms.plots , new flash.geom.Rectangle(fx*15,(fy+f)*15,15,15) , new flash.geom.Point(tx-7,ty-7) ,undefined,undefined,true );
		
		if(flag)
		{
			bms[1].copyPixels(bms.blocks , new flash.geom.Rectangle(5*10,5*0,5,5) , new flash.geom.Point(tx-2,ty-8) ,undefined,undefined,true );
		}
	}
	
	function show_block_blit(place,fx,fy,tx,ty) // copy 1 block data from and to a block x,y location
	{
		bms[place].copyPixels(bms.blocks , new flash.geom.Rectangle(fx*5,fy*5,5,5) , new flash.geom.Point(tx*5,ty*5) );
	}
	
	function show_block(place,block,x,y) // copy a full  block data from and to a block x,y location
	{
	var v=map_blocks[block];
	var bx,by;
	var tx,ty;
	var i;
	
		bx=v[0];
		by=v[1];
	
		for(i=0;i<v.length;i+=2)
		{
			ty=( y+v[i+1]-by );
			tx=( x+v[i]-bx );
			
			bms[place].copyPixels(bms.blocks , new flash.geom.Rectangle(v[i]*5,v[i+1]*5,5,5) , new flash.geom.Point(tx*5,ty*5) ,undefined,undefined,false );
		}
	}
	
	function show_next_blocks()
	{
	var i,j;
		
		for(i=0;i<6;i++)
		{
			bms[2+i].fillRect( new flash.geom.Rectangle(0,0,6*5,6*5) , 0x00000000); // clear
			
/*
			j=0;
			while( block_flags[i][j] ) { j++; } // find the first hole
			block_flags[i].next_idx=j; // remember
			block_flags[i].next=block_groups[i][j%4]; // remember the block this is
*/			

			block_flags[i].next=block_groups[i][(block_flags[i].cycle)%4]; // remember the block this is			
			show_block(2+i, block_flags[i].next ,2,2); // draw
		}
		
	}
	
	var pathing=false;
	var path_changed;
	var path_step=0;
	var path_step_max=1;
	
	function path_check()
	{
	var i,x,y,t,tt;
	var path;
	
	pathing=false; // kill 
	return;
	
		if(path_step==0)
		{
			path_changed=false;
		}
	
		tt=[];

		t=map[ creep_exit[1]*maxx + creep_exit[0] ];
		t[0]=0; // grow out from this target
	
		pathing=true;
//		while(changed)
		{
//			changed=false;
			
			for(x=1;x<maxx-1;x+=1)
			{
				if(((x)%path_step_max)!=path_step) { continue; }
					
				for(y=1;y<maxy-1;y+=1)
				{
					
					t=map[ y*maxx + x ];
					
					tt[0]=map[ (y-1)*maxx + x ];
					tt[1]=map[ (y+1)*maxx + x ];
					tt[2]=map[ y*maxx + x-1 ];
					tt[3]=map[ y*maxx + x+1 ];
					
					
					if( t["type"]=="wall" )
					{
					}
					else
					{
						if(t[0]!=0) // 0 means already at target
						{
							path=false;
							
							for(i=0;i<4;i++)
							{
								if( tt[i] )
								{
									if( tt[i][0] < t[0] ) // connected
									{
										path=true;
										if( t[0] != (tt[i][0]+1) )
										{
											t[0] = tt[i][0]+1;
											path_changed=true;
										}
									}
								}
							}
							
							if(!path) // not connected
							{
								if( t[0] != 0xffff )
								{
									path_changed=true;
									t[0]=0xffff;
								}
							}
						}
					}
					
				}
			}		
		}
		
		path_step++;
		if(path_step==path_step_max)
		{
			path_step=0;
			if(!path_changed) { pathing=false; } // finished path finding
		}
	}
	
	function draw_back()
	{
	var x,y,t;
			
		for(x=0;x<maxx;x+=1)
		{
			for(y=0;y<maxy;y+=1)
			{
				t=map[ y*maxx + x ];
				
				if( t["type"]=="wall" )
				{
					if( t["dx"] )
					{
						block_blit( t["dx"] , t["dy"] , x , y );
					}
					else
					if(t.wall=="black")
					{
						bms[0].fillRect( new flash.geom.Rectangle(x*5,y*5,5,5) , 0xff000000);
					}
					else
					{
						bms[0].fillRect( new flash.geom.Rectangle(x*5,y*5,5,5) , 0xff808080);
					}
				}
				else
				{

					if( ((x+y)&1) == 0 )
					{
						bms[0].fillRect( new flash.geom.Rectangle(x*5,y*5,5,5) , 0xff0c0c0c);
					}
					else
					{
						bms[0].fillRect( new flash.geom.Rectangle(x*5,y*5,5,5) , 0xff000000);
					}
					
//					bms[0].fillRect( new flash.geom.Rectangle(x*5,y*5,5,5) , 0xff000000 + t[0]*4 );

					if( t["type"]=="fart" )
					{
						block_merge( 9 , 0 , x , y );
					}
					else
					if( t["type"]=="food" )
					{
						block_merge( 9 , 1 , x , y );
					}
					else
					if( t["type"]=="enter" )
					{
						block_merge( 9 , 3 , x , y );
					}
					else
					if( t["type"]=="exit" )
					{
						block_merge( 9 , 2 , x , y );
					}
					else
					if( t["type"]=="portal_in" )
					{
						block_merge( 9 , 6+t.portal-1 , x , y );
					}
					else
					if( t["type"]=="portal_out" )
					{
						block_merge( 9 , 7+t.portal-1 , x , y );
					}
				}
				
			}
		}		
	}
	
	function just_add_block(x,y,bidx)
	{
	var t,tt=[];
	var bx,by,i,v;
	
		t=map[ y*maxx + x ];
		
		v=map_blocks[bidx];
		bx=v[0];
		by=v[1];
		
		for(i=0;i<v.length;i+=2)
		{
			t=map[ ( y+v[i+1]-by )*maxx + ( x+v[i]-bx ) ];
			if( t["type"]!="empty" ) { return; } // check is empty
		}
		
		for(i=0;i<v.length;i+=2) // apply to map
		{
			t=map[ ( y+v[i+1]-by )*maxx + ( x+v[i]-bx ) ];
			t["type"]="wall";
			t[0]=0xffff;
			t["dx"]=v[i];
			t["dy"]=v[i+1];
			t["mx"]=x;
			t["my"]=y;
			t["idx"]=bidx;
		}
		
		block_flags[block_type].total++;
	}
	function add_block(x,y,bidx)
	{
		tim_mod=tim; // mark now as last time modified
		tim_flag=true;
		
		just_add_block(x,y,bidx);
		path_check();
		draw_back();
		show_next_blocks();
		display_score();
	}
		
	function remove_block(x,y)
	{
	var t,tt=[];
	var bx,by,i,v;
	
		t=map[ y*maxx + x ];
		
		if( t["type"]=="empty" ) { return false; }
		
		if( !t["mx"] ) // not a linked block
		{
			return false;
		}
		
		tim_mod=tim; // mark now as last time modified
		tim_flag=true;
		
		x=t["mx"]; // choose handle point
		y=t["my"];
		
		v=map_blocks[ t["idx"] ];
		bx=v[0];
		by=v[1];
		
		for(i=0;i<v.length;i+=2)
		{
			t=map[ ( y+v[i+1]-by )*maxx + ( x+v[i]-bx ) ];
			
			tt[i/2]=map[ ( y+v[i+1]-by )*maxx + ( x+v[i]-bx ) ];
			
			tt[i/2]["type"]="empty";
			tt[i/2][0]=0xffff;
		}
		
		path_check();
		draw_back();
		
		
		var group = block_groups_reverse[ t["idx"] ]; // which group
		
		// step through placed blocks and flag the first one we find to removed
		
		block_flags[group].total--;
		
/*
		var j=0;
		for( j=0; true ; j++ )
		{
			if( block_flags[group][j] )
			{
				if( block_groups[group][j%4] == t.idx ) // safe to remove this one
				{
					block_flags[group][j]=false;
					block_flags[group].total--;
					break;
				}
			}
		}
*/
		// update next block
		show_next_blocks();
		display_score();
		
		return true;
	}
	
	function check_change_block()
	{
	var x,y,t;
	
		x=Math.floor(mcs.blocks._xmouse/5);
		y=Math.floor(mcs.blocks._ymouse/5);
		
		t=map_blocks_reverse[x];
		
		if(t)
		{
			if(t[y])
			{
				block_idx=t[y]-1;
			}
		}
	}
	
	function draw_over()
	{
	var x,y,t;
	
		bms[1].fillRect( new flash.geom.Rectangle(0,0,maxx*5,maxy*5) , 0x00000000);
		
		x=Math.floor(mcs[1]._xmouse/5);
		y=Math.floor(mcs[1]._ymouse/5);
		
		if(x<0) { x=0; }
		if(y<0) { y=0; }
		if(x>=maxx) { x=maxx-1; }
		if(y>=maxy) { y=maxy-1; }
		
		
		var bx,by,i,v;
		v=map_blocks[block_idx];
		bx=v[0];
		by=v[1];
		
		
//		bms[1].fillRect( new flash.geom.Rectangle(x*5,y*5,5,5) , 0xffffffff);
		
		var blocked=false;

		for(i=0;i<v.length;i+=2)
		{
			t=map[ ( y+v[i+1]-by )*maxx + ( x+v[i]-bx ) ];
			
			if( t["type"]!="empty" )
			{
				blocked=true;
			}
		}
		
		for(i=0;i<v.length;i+=2)
		{
			block_blit_over( v[i] , v[i+1] , x+v[i]-bx , y+v[i+1]-by );
		}
		
		if(block_idx==0) // spesh puzzle launch test
		{
			if(mouse_click)
			{
				mouse_click=false;
			}
		}
		else
		{
			if(!blocked)
			{
				if(mouse_click)
				{
					mouse_click=false;
					
					add_block(x,y,block_idx);
				}
			}
			else
			{
				if(mouse_click)
				{
					mouse_click=false;
					
					remove_block(x,y);
				}
			}
				}

	}
	
	function add_creep(x,y,t)
	{
		var c=[];
		
		c.type="plot";
		c.x=x;
		c.y=y;
		c.lost=0;
		c.age=0;
		c.idx=-1; // last cell we where on
		
		c.uids=[];
		c.fat=50;
		
		c.born=tim;
		
		if(tim_flag)
		{
			tim_flag=false;
			c.flag=true;
			
//			talker.c=c;
//			talker.bub.display(["Hello World!","Are we there yet?","Shall we play a game?","Please be gentle with me.","Help I'm trapped in a box."],25);
		}
		
		creeps.push(c);
	}
	
	function update_creeps()
	{
	var i,c,t,tt=[];
	var tx,ty;
	var x,y;
	var v,vx,vy;
	var portal;
	
		tx=creep_exit[0];ty=creep_exit[1];
		
		for(i=0;i<creeps.length;i++)
		{
			portal=0;
			
			c=creeps[i];
			
			c.flag=c.flag&&(c.born>tim_mod); // remove flag when map changes
						
			x=Math.floor(c["x"]/5);
			y=Math.floor(c["y"]/5);
			
			vx=tx-x;
			vy=ty-y;
			
			if( vx*vx > vy*vy )
			{
				vy=0;
				if(vx>=0) { vx=1; }
				else      { vx=-1; }
			}
			else
			{
				vx=0;
				if(vy>=0) { vy=1; }
				else      { vy=-1; }
			}
			
			var idx=y*maxx + x;
			if(idx!=c.idx) // moved to a new cell
			{
				c.idx=idx;
				c.age++; // only age when we move to a new cell
			}
			
			t=map[ y*maxx + x ];
			
			tt[0]=map[ (y-1)*maxx + x ];
			tt[1]=map[ (y+1)*maxx + x ];
			tt[2]=map[ y*maxx + x-1 ];
			tt[3]=map[ y*maxx + x+1 ];
			
			if(t[0]==0) //home
			{
				vx=0;
				vy=0;
				creeps.splice(i,1);
				i=i-1;
				
				score_fat=c.fat;
				score_age=c.age;
				display_score(c);
				
//				up.pixls.add_block(0xff00ff00,10+x*20,20+y*20,(c.fat-c.age)/20,(c.fat-c.age)/20);
				up.pixls.add_block(0x88ffff00,10+x*20,20+y*20,20,20);
				
				if(c.flag)
				{
					play_wikwikwik();
					talker.c=c;
					talker.bub.display(["Escape!","Freedom!","Jeronimo!","Stupendous!","SCORE!!","For The WIN!","INCOMING!","Never Surrender!","w0000t!","I'm heading in.","L8tr Guiz!","I'm outtie.","See ya! Wouldn't wanna be ya!","Go into the light.","I can see your house from here!","Whoopie!","Never give up!"],75);
				}
				else
				{
					play_shot();
				}
			}
			else
			if(t[0]!=0xffff) // flow
			{
				if(t["type"]=="food")
				{
					if(!c.uids[t.id])
					{
						c.uids[t.id]=true;
						c.fat+=50;
						
//						up.pixls.add_block(0xff00ff00,10+x*20,20+y*20,(c.fat-c.age)/20,(c.fat-c.age)/20);
						up.pixls.add_block(0x8800ff00,10+x*20,20+y*20,20,20);
						
						play_pop();
						
						if(c.flag)
						{
							talker.c=c;
							talker.bub.display(["Feed me somemore.","Drooool.","Munch.","Mmmmm Mama.","Ohhh yeaahhh.","Scrumdidilydoo.","Gobble Gobble.","Yum Yum","Hamana Hamana.","Ooh, gimme gimme.","Tastes like chicken.","Mmmm Soylent.","Tasties."],25);
						}
					}
				}
				else
				if(t["type"]=="fart")
				{
					if(!c.uids[t.id])
					{
						c.uids[t.id]=true;
						c.fat-=50;
						
//						up.pixls.add_block(0xffff0000,10+x*20,20+y*20,(c.fat-c.age)/20,(c.fat-c.age)/20);
						up.pixls.add_block(0x88ff0000,10+x*20,20+y*20,20,20);
						
						play_bounce();
						
						if(c.flag)
						{
							talker.c=c;
							talker.bub.display(["Oh No!","Dun wanna.","Yuck.","BURP!","Ewwww","Don't Like","Icky!","Meh.","Don't you make me.","Poo on you.","Aye Carumba.","Oochee","Please Stop!","Uh Oh.","Oh noes!","Oh Poop.","BLEARGH","I don't like this","Nasty.","I don't want to play any more."],25);
						}
					}
				}
				else
				if(t["type"]=="portal_in")
				{
					if(!c.uids[t.id])
					{
						c.uids[t.id]=true;
						portal=t.portal;
						
						play_shot();
						
						if(c.flag)
						{
							talker.c=c;
							talker.bub.display(["Wheeeee","Again! Again! Again!","Sweeeet!","I think I wet meself.","Woo Hoo!","Oh ho ho.","Good god, man. What was that?","AROOOOOOOBA!","You spin me right round, baby.","My word, what a ride.","I think I'm gonna puke.","It's like a rollercoaster.","I feel drunk.","Is that all?"],25);
						}
					}				
				}
				
				c["lost"]=0;
				
				if( vy==0 ) // x is best
				{
					if(tt[0]) if( tt[0][0] < t[0] ) { vy=-1; vx= 0; }
					if(tt[1]) if( tt[1][0] < t[0] ) { vy= 1; vx= 0; }
					if(tt[2]) if( tt[2][0] < t[0] ) { vy= 0; vx=-1; }
					if(tt[3]) if( tt[3][0] < t[0] ) { vy= 0; vx= 1; }
				}
				else // y is best
				{
					if(tt[3]) if( tt[3][0] < t[0] ) { vy= 0; vx= 1; }
					if(tt[2]) if( tt[2][0] < t[0] ) { vy= 0; vx=-1; }
					if(tt[1]) if( tt[1][0] < t[0] ) { vy= 1; vx= 0; }
					if(tt[0]) if( tt[0][0] < t[0] ) { vy=-1; vx= 0; }
				}
			}
			else // lost?
			{
				c["lost"]+=1;
				
				if(t["type"]=="wall") // kill the walls
				{
					var bdone=remove_block(x,y);
					
					if(bdone || c.flag)
					{
						talker.c=c;
						talker.bub.display(["Hulk SMASH!","I R DESTRUCTOR!","Lemme at em'.","BANZAI!","Comin' Thru.","Outta my way!","That won't stop me!","Well excuuuuse me, princess.","I Wanna Break Free.","Why don't I do this all the time?","This so easy.","Dont Like!"],50);
					}
				}
						
				if( c["lost"] > 50 ) // if we have been lost a while, break down walls
				{
				}
				else
				{
					vx=0;
					vy=0;
				}
			}
			
			if(vx==0) // head towards center of cell
			{
				v=(c["x"]%5)
				if(v<2) { vx= 1; }
				if(v>2) { vx=-1; }
			}
			if(vy==0) // head towards center of cell
			{
				v=(c["y"]%5)
				if(v<2) { vy= 1; }
				if(v>2) { vy=-1; }
			}
			
			if(portal!==0) //jump
			{
				up.pixls.add_block(0x88ffff00,10+x*20,20+y*20,20,20);
				
				c["x"]=5*teleportals[portal*4+2]+2;
				c["y"]=5*teleportals[portal*4+3]+2;
			}
			else
			{
				c["x"]+=vx;
				c["y"]+=vy;
			}
			
			idx=Math.floor( (c.fat-c.age)/20 );if(idx>24){idx=24;}if(idx<0){idx=0;}
			
			plot_blit_over(idx,0,c["x"],c["y"],c.flag);
//			bms[1].fillRect( new flash.geom.Rectangle(c["x"],c["y"],2,2) , rainbow_colors[ Math.floor(c["age"]/100)%18 ]);

			
			if( c.fat-c.age < 0) // starved to death
			{
				creeps.splice(i,1);
				i=i-1;
				up.pixls.add_block(0x88ff0000,10+x*20,20+y*20,20,20);
				
				if(c.flag)
				{
					talker.c=c;
					talker.bub.display(["I'll be back.","You'll never hear the last of me!","This is not the end!","Bored now.","Sometimes they come back.","I may be some time","Is this it?","Why you lil @#$!.","NOOOO!!","No, not like this!","What did I ever do to you?"],25);
				}
			}
		}
		
		if(talker.c) // follow the spokesperson
		{
			talker._x=talker.c.x*4;
			talker._y=talker.c.y*4;
		}
	}

	var tim=0;
	var tim_mod=0;
	var tim_flag;
	var tim_pop;

	function update()
	{
	var i;
	
		_root.bmc.check_loading();
				
				
		tim=tim+1;
/*
		if((tim%50)==0)
		{
			if( creeps.length<50 )
			{
				add_creep( creep_entrance[0]*5 +2, creep_entrance[1]*5 +2, "plot" );
			}
		}
*/		
		if(pathing)
		{
			path_check();
//			draw_back();
		}
		
		draw_over();
		
		update_creeps();
		
		pixls.update();
		
		talky.update();
		
	}
	
	var sfx_pop_idx;
	
	function play_pop()
	{
//		if(tim_pop+1 > tim) { return; } // wait for it		
		tim_pop=tim;
		
		var sfx=new Sound();
		sfx.attachSound("sfx_p"+sfx_pop_order[sfx_pop_idx]);
		sfx.start();
		
		sfx_pop_idx++;
		
		if(sfx_pop_idx>=sfx_pop_order.length)
		{
		sfx_pop_idx=0;
		}
	}
	function play_shot()
	{
//		if(tim_pop+1 > tim) { return; } // wait for it		
		tim_pop=tim;
		
		var sfx=new Sound();
		sfx.attachSound("sfx_shot");
		sfx.start();
	}
	
	function play_bounce()
	{
//		if(tim_pop+1 > tim) { return; } // wait for it		
		tim_pop=tim;
		
		var sfx=new Sound();
		sfx.attachSound("sfx_bounce");
		sfx.start();
	}
	
	function play_wikwikwik()
	{
//		if(tim_pop+1 > tim) { return; } // wait for it		
		tim_pop=tim;
		
		var sfx=new Sound();
		sfx.attachSound("sfx_wikwikwik");
		sfx.start();
	}
}