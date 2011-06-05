/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2010
//
// This file made available under the terms of The MIT License : http://www.opensource.org/licenses/mit-license.php
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class  RunPlay
{
	var up;
	
//	var talky;
	
	var level;

	var mcp0x;
	var mcp1x;
	
	var mcp_base;
	var mcp;
	var mcp1;
	var mcp2;
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
	
	var player;
	var tards;
	
	var start_x=100;
	var start_y=40;
	
	var focus;
	
	var col;

	var tfd;
	var txd;
	
	var pickups;
	var items;
	var items_by_id;
	
	var mobs; // mobile monster items

	
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
	var say;
//	var idat_class;
	
	var parts;
	
	function  RunPlay(_up)
	{
	var t,tt;
	
		gamemode="race"; // or story
		gameskill="easy"; // or hard
		
		up=_up;
		
//		idat_class=new PlayItem_dat();
//		_root.idat=idat_class.dat;
		
		focus=new RunFocus(this);
		
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

		
	function setup(level_id,door_id)
	{
	var i;
		focus.setup();
	
		up.dat.get_room(level_id); // set the level
		
		level=up.dat.room.level;//new Run1Level_level_00();//up.levels[up.level_idx];
//		chat=level.chat_start;

		up.game_seed=level.game_seed; // we worked out the right seed for each level at the start
		rnd_seed(up.game_seed);
		
		frame=0;
		score=0;
//		mute=0;
		
//		dribble_vol=-1; // flag start sound

		mobs=[];
		items=[];
		items_by_id=[];
		
// p10 ++ are below the player and items
		mcp1x=gfx.create_clip(up.mc,null,0,0); // bottom left of image is at 0,0

// this contins the player and all objects
		mc=gfx.create_clip(up.mc,null);

// less than p10 are above the player and items
		mcp0x=gfx.create_clip(up.mc,null,0,0); // bottom left of image is at 0,0
		
		for(i=9;i>=0;i--)
		{
			if(up.dat.room.p[i].name)
			{
				mcp1x[i]=gfx.create_clip(mcp1x, null ,0,0); // bottom left of image is at 0,0
				create_paralax(i,mcp1x[i]);
			}
		}
		for(i=20;i>=10;i--)
		{
			if(up.dat.room.p[i].name)
			{
				mcp1x[i]=gfx.create_clip(mcp1x, null ,0,0); // bottom left of image is at 0,0
				create_paralax(i,mcp1x[i]);
			}
		}
		
		
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
		
					
//		imc=gfx.create_clip(mc,null);

		tards=[];

		
// process collision data
		
		setcols(level.col);


		
		
	//	chat_idx=-1;
//		chat_tim=0;
		
		
		_root.replay.apply_keys_to_prekey();
		_root.replay.update();
//		_root.replay.reset();
		Mouse.addListener(this);
		Key.addListener(this);

		tards[0]=new Vtard2d(this);
		tards[0].setup("vtard_protagonist");
		tards[0].px=5*20+10;
		tards[0].py=-5*20;
		
		player=tards[0];
		player.hold=new RunItem(this,0,0,"nothing");;
		focus.set(player,1);

		if(items_by_id[door_id])
		{
			tards[0].px=items_by_id[door_id].x;
			tards[0].py=items_by_id[door_id].y-1;
		}
					
		
		
		
		state="start";
		
//		up.high.setup("rank");
		
		say=new PlayChat(up);
		say.setup("top");
		
		chat=new PlayChat(up);
		chat.setup("bottom");
		
		update();
		
//_root.wetplay.PlaySFX("sfx_001",3,0,1);
		
		parts=new RunParts(this);
		
	}
	
// take a snapshot of this level so we can scroll it off for a level transition?
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
		parts.clean();
		
//		_root.wetplay.PlaySFX(null,3);
	
//		_root.signals.signal("#(VERSION_NAME)","end",this);
		
		for(i=0;i<_root.menu.customItems.length;i++)
		{
			if(_root.menu.customItems[i].id=="restart")
			{
				_root.menu.customItems[i].visible=false;
			}
		}
			
//		tards[0].mc._visible=false;
//		build_snapbmp();
		
		chat.clean();
		say.clean();

//		talky.clean();
		tards[0].clean();
//		tards[1].clean();
		mcp_base.removeMovieClip();
		mc.removeMovieClip();
		mco.removeMovieClip();
		snapmc.removeMovieClip();
		
		Mouse.removeListener(this);
		Key.removeListener(this);
		
		focus.clean();
	}

	
	function onMouseDown() // clear focus on mouse click
	{
		Selection.setFocus(null);
	}
	
	function onKeyDown()
	{
	var k=String.fromCharCode(Key.getAscii());
	var c=Key.getCode();
	
		if(!Selection.getFocus()) // ignore key when a textbox has focus
		{
			_root.replay.apply_key_on_to_prekey(c,k);
		}
		
		if(c==Key.ESCAPE)
		{
			up.change_room(up.next_room,up.next_door); // reload
		}
	}
	
	function onKeyUp()
	{
	var k=String.fromCharCode(Key.getAscii());
	var c=Key.getCode();
	
		if(!Selection.getFocus()) // ignore key when a textbox has focus
		{
			_root.replay.apply_key_off_to_prekey(c,k);		
		}
	}

		
var wibble;
var wiblur;

	function update()
	{
	var s;
	var i;
				
		_root.signals.signal("#(VERSION_NAME)","update",this);
		
		frame++;
		

		say.update();
		chat.update();
		
		
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
		

		if(say.mc._visible)
		{
			show_height-=say.show_height;
			mc._y=say.show_height;
		}
		else
		{
			mc._y=0;
		}

		
		focus.update();
		var sx=(focus.px-(show_width/2));
		var sy=(focus.py-50-(show_height/2));
		
		var nsx,nsy;
		var lpw=level.pw;
		var lph=level.ph;
		
		var scroll_position=function(w,h)
		{
			nsx=Math.floor((w-show_width)*sx/(lpw+1-show_width));
			nsy=Math.floor((h-show_height)*(sy+show_height)/(lph+1-show_height))-show_height;
			
			if(nsx<0)					{nsx=0;}
			if(nsy>-show_height)		{nsy=-show_height;}

			if(nsx>(w-show_width))		{nsx=(w-show_width);}
			if(nsy<-(h))				{nsy=-(h);}
		}
		
		scroll_position(level.pw,level.ph);
		mc.scrollRect=new flash.geom.Rectangle(nsx, nsy, 640,show_height);


	
		for(i=10;i<20;i++)
		{
			if(mcp1x[i])
			{
				scroll_position( up.dat.room.p[i].w , up.dat.room.p[i].h );
				mcp1x[i].scrollRect=new flash.geom.Rectangle(nsx, nsy+up.dat.room.p[i].h, 640,show_height);
				if(say.mc._visible)
				{
					mcp1x[i]._y=say.show_height;
				}
				else
				{
					mcp1x[i]._y=0;
				}
			}
			else
			{
				break;
			}
		}
		for(i=9;i>=0;i--)
		{
			if(mcp0x[i])
			{
				scroll_position( up.dat.room.p[i].w , up.dat.room.p[i].h );
				mcp0x[i].scrollRect=new flash.geom.Rectangle(nsx, nsy+up.dat.room.p[i].h, 640,show_height);
				if(say.mc._visible)
				{
					mcp0x[i]._y=say.show_height;
				}
				else
				{
					mcp0x[i]._y=0;
				}
			}
			else
			{
				break;
			}
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
		
		for(i=0;i<mobs.length;i++)
		{
			if(mobs[i].update())
			{
				mobs[i].clean();
				mobs.splice(i,1);
				i--;
			}
		}
		
		player.hold.update_held();
		if(player.hold.d.name=="nothing")
		{
			player.hold.mc._visible=false;
		}
		else
		{
			player.hold.mc._visible=true;
		}
		
		parts.update();
	}
	
	function create_paralax(idx,m)
	{
		var name=up.dat.room.p[idx].name;
		var w=up.dat.room.p[idx].w;
		var h=up.dat.room.p[idx].h;
		
		_root.bmc.remember( name , bmcache.create_jp4g ,
		{
			url:name ,
			bmpw:w , bmph:h , bmpt:true ,
			hx:0 , hy:0 ,
			onload:null
		} );
		
		m.attachBitmap( _root.bmc.getbmp(name) , 0 );
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
				var id=dat[(x)+(y)*w];
				
				if(id>=16) // id must be 16+
				{
					var d=up.dat.get_item_in_room(id);
					
					if(d)
					if(!d.item_skip) // do not create item?
					{
					
//dbg.print( d.type+" "+d.hex );

						items_by_id[id]=make_item(x*20+10 , (-y*20)-2 , d.id); // this is a local id

					}

				}
				
			}
		}
		
	}
	
	
	function make_item(_x,_y,id)
	{
		var it=new RunItem(this,_x,_y,id); // this is an absolute id
		
		it.idx=items.length;
		items[items.length]=it;
		
		return it;
	}
	
	function getcol(x,y,w)
	{
		y=-y-1;
		if(x<0) return 1;
		if(x>=level.cw) return 1;
		if(y<0) return 1;
		if(y>=level.ch) return 0;
		if(w==1) return col[1][x+y*level.cw];
		return col[0][x+y*level.cw];
	}
	
}



