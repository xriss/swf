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



class RunItem
{
	var up;
	
	var mc;
	
	var x,y;
	var px,py;
	
	var type;
	
	var active;
	
	var engine; // the engine this item belons to
	
	var tard;
	var sheet; // an animation
	
	var other;
	
	var id;
	var d;
	
	var escount;
	
	var flavour;
	
	var pickup_wait;
	
	var xscore;

	var finalx,finaly;
	
	var idx;
	
	var overcount;
	
	var vars;
	
	var treasure;
	var inputs;
	
	var items;
	
	var callback; // set to callback function
	
	var fizix_state="none";
	
//	var door_wait=15;
	
static var time_signpost=0;
		
		
	function get_dx()
	{
		if(!up.focus.force) {	return x-up.player.px; }
		
		if(this==up.focus.force) { return 0; }
		
		return 999999;
	}
	function get_dy()
	{
		if(!up.focus.force) {	return y-up.player.py;	}
		
		if(this==up.focus.force) { return 0; }
		
		return 999999;
	}
	
	function get_mc_dx()
	{
		return mc._x-up.player.px;
	}
	function get_mc_dy()
	{
		return mc._y-up.player.py;
	}
	
	function RunItem(_up,_x,_y,_id)
	{
		vars={}; // this moves from item to item and contains state vars
		
		up=_up;
		
		xscore=1;
		
		setup(_x,_y,_id);
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}

	function check_mc()
	{
		if(!mc) { mc=gfx.create_clip(up.mc,null); }
		mc._x=x;
		mc._y=y;
	}
	
	function set_img(s)
	{
		check_mc();

		mc.mc=gfx.add_clip(mc,s,100,0,0);
		mc.mc._x=-mc.mc._width/2;
		mc.mc._y=-mc.mc._height;
	}
	
	function set_img_xy(_x,_y)
	{
		mc.mc._x=_x;
		mc.mc._y=_y;
	}
		
// setup a give id, can be called multiple times
	function setup_id(_id)
	{
		if(typeof(_id)=="object")
		{
			vars=_id;
			id=_id.name;
//dbg.print("Object:"+id);
		}
		else
		{
			id=_id;
		}
		d=up.up.dat.get_item(id);
		if(d.callback)
		{
			callback=d.callback;
			callback("init",this); // can adjust defaults for d here
		}
		
		vars.name=d.name;
		type=d.type;

		var img;
		var tardname;
		var hold;
		var time_start;
		var i,v;
		
		if(type=="sign") { img="object_sign"}
		if(type=="door") { img="object_door"}
		if(d.img) { img=d.img; }
		
		if(d.tard) { tardname=d.tard; }
		if(d.hold) { hold=d.hold; }
		

		if(d.sheet) // use a sprite sheet
		{
			check_mc();
			sheet=new SpriteSheet(this);
			sheet.setup_str(d.sheet);
		}
		else
		{
			sheet.clean();
		}
		if(img && (img!="null") ) // simple static image
		{
			check_mc();
		
			mc.mc=gfx.add_clip(mc,img,100,0,0);
			mc.mc._x=-mc.mc._width/2;
			mc.mc._y=-mc.mc._height;
		}
		else
		{
			mc.mc.removeMovieClip();
//				mc=null;
		}
		
		
		if(tard)
		{
			tard.clean();
			tard=null;
		}
		if(tardname)
		{
			tard=new Vtard2d(up);
			tard.item=this;
			tard.setup("vtard_"+tardname);
			tard.px=x;
			tard.py=y-1;
			
			if(hold)
			{
				tard.hold=new RunItem(up,0,0,hold);
			}
			
			if(d.brain)
			{
				tard.brain=new Vtard2d_brain(tard,d.brain);
			}
		}
		
		if(d.time_start)
		{
			check_mc();
			
			mc.time=gfx.create_clip(mc,1000,-50,-mc.mc._height-18);
			mc.time.tf=gfx.create_text_html(mc.time,null,0,0,100,50);
			gfx.glow(mc.time , 0x000000, 1, 4, 4, 1, 1, false, false );
			time_setup();
		}
		else
		{
			mc.time.removeMovieClip();
			mc.time=null;
		}
		
		if(vars.stack) // stackable item
		{
			check_mc();
			
			mc.stack=gfx.create_clip(mc,1000,-50,-mc.mc._height-18);
			mc.stack.tf=gfx.create_text_html(mc.stack,null,0,0,100,50);
			gfx.glow(mc.stack , 0x000000, 1, 4, 4, 1, 1, false, false );
			stack_setup();
		}
		else
		{
			mc.stack.removeMovieClip();
			mc.stack=null;
		}
		
		treasure.clean();
		if(d.treasure) // this is a door displaying treasure scrumped
		{
			if( up.up.vars[d.treasure] )
			{
				var t=up.up.vars[d.treasure];
				if(t.name!="nothing") // do not display nothing
				{
					check_mc();
					
					treasure=new RunItem(up,x,y-mc.mc._height-18,up.up.vars[d.treasure]);
					
					var t_points=treasure.d.getscore(treasure);
					if(t_points!=0) // do not display 0
					{
						mc.score=gfx.create_clip(mc,1000,-50,-mc.mc._height-20);
						mc.score.tf=gfx.create_text_html(mc.score,null,0,0,100,50);
						gfx.glow(mc.score , 0x000000, 1, 4, 4, 1, 1, false, false );
						gfx.set_text_html(mc.score.tf,16,0xffffff,"<p align=\"center\"><b>"+t_points+"</b></p>");
					}
				}
			}
		}
		
		if(d.inputs>0) // how many be inputs to this tool ?
		{
//			if(!vars.inputs) { vars.inputs=[]; }
			if(!inputs) { inputs=[]; }
			
			check_mc(); // need a container mc
			
			for(i=0;i<d.inputs;i++)
			{
//				v=vars.inputs[i];
//				if(!v) { v="nothing"; }

				v="nothing";
				
				inputs[i]=new RunItem(up,x,y-mc.mc._height,v);
			}
			inputs_position_all();
		}
		
		if( up.player.hold==this)
		{
				if( d.fizix )
				{
					up.player.fizix=up.player["fizix_"+d.fizix];
				}
				else
				{
					up.player.fizix=up.player.fizix_base;
				}
		}
		
		hold_setup();

		setup_engine();
		
		if(callback) { callback("setup",this); }
	}
	
	function setup(_x,_y,_id)
	{
		x=_x;
		y=_y;
		
		px=x;
		py=y;
		
		setup_id(_id);
	}
	
	function clean()
	{
	var i;
		if(engine) // find and remove us from an engines list of active items
		{
			var t=engine.vars.items;
			
			for(i=0;i<t.length;i++)
			{
				if(t[i]==this)
				{
					t.splice(i,1);
					i--;
				}
			}
		}
			
		treasure.clean();
		
		tard.hold.clean();
		
		tard.clean();
		tard=null;
			
		mc.removeMovieClip();
		mc=null;
		
		if(callback) { callback("clean",this); }
	}
	
	function launch(s)
	{
		up.parts.launch(x,y,s);
	}
	
	function check_sign()
	{
		return up.player.overchat!=this;
	}
	
	function show_sign()
	{
	var	dx=get_dx();

		if(d.sfx)
		{
			_root.sfx(d.sfx);
		}
			
		if(up.player.overchat!=this)
		{
			time_signpost=up.frame;
			up.player.overchat=this;
			up.chat.show( d.sign(this, (50-dx)/100) );
			return true;
		}
		else
		{
			up.chat.show( d.sign(this, (50-dx)/100) ); // change chat?
		}
		return false;
	}
	function hide_sign()
	{
		if(up.player.overchat==this)
		{
			if(up.chat.seen_count>25) // only after it has been displayed?
//			if(time_signpost+(50*1) < up.frame)
			{
				up.player.overchat=null;
				up.chat.hide();
				return true;
			}
		}
		return false;
	}
	
	function stand_check()
	{
		return up.player.overitem!=this;
	}
	
	function stand_on()
	{
		if(up.player.overitem!=this)
		{
			overcount=0;
			up.player.overitem=this;
			return true;
		}
		else
		{
			overcount++;
		}
		return false;
	}
	function stand_off()
	{
		if(up.player.overitem==this)
		{
			up.player.overitem=null;
			return true;
		}
		return false;
	}

	function update_say()
	{
	if(!d.say) {return;}
	var dx,dy,ss,s;

		dx=get_dx();
		dy=get_dy();
		
		if((((dx*dx)+(dy*dy))<(50*50))&&(!up.player.ignore_items))
		{
			up.player.oversay=this;
			up.say.show( d.say(this, (50-dx)/100) );
		}
		else
		{
			if(up.player.oversay==this)
			{
				if(up.say.seen_count>25) // only after it has been displayed?
				{
					up.say.hide();
				}
			}
		}
	}
	
	function update_sign()
	{
	var dx,dy,ss,s;

		dx=get_dx();
		dy=get_dy();
		
		if((((dx*dx)+(dy*dy))<(50*50))&&(!up.player.ignore_items))
		{
			stand_on();
			show_sign();
		}
		else
		{
			stand_off();
			hide_sign();
		}
	}

	function update_door()
	{
	var dx,dy,ss,s;

		dx=get_dx();
		dy=get_dy();
		
		if((((dx*dx)+(dy*dy))<(25*25))&&(!up.player.ignore_items))
		{
			stand_on();
//			if(overcount>door_wait)
//			{
				show_sign();
//			}
		}
		else
		{
			stand_off();
			hide_sign();
		}
	}
	
	function inputs_position_all()
	{
		return;
		
	var i,v,w;
		w=0;
		for(i in inputs)
		{
			v=inputs[i];
			w+=v.mc._width;
		}
		w=(-w/2);
		for(i in inputs)
		{
			v=inputs[i];
			v.px=x+i*50;
			v.update();
		}
	}
	
	function time_display()
	{
		var txt=0;
		if( vars.time>=0 )	{ txt=Math.floor(vars.time); }
		else
		if( vars.time<=0 )	{ txt=0; }
		else				{ txt=d.time_start; }
		txt=txt+"%";
//		txt=d.time_start+"%";
		if( mc.time.txt != txt)
		{
			mc.time.txt=txt;
			gfx.set_text_html(mc.time.tf,16,0xffffff,"<p align=\"center\"><b>"+txt+"</b></p>");
		}
	}

	function time_update()
	{
		if(d.time_start)
		{
			if(idx!=d.time_refresh_idx)
			{
				vars.time+=d.time_update;
				time_display();
			}
		}
	}
	function time_setup()
	{
		if(d.time_start)
		{
			if( (typeof(vars.time)!="number") || (idx==d.time_refresh_idx) )
			{
				vars.time=d.time_start;
			}
			time_display();
		}
	}
	
	function stack_display()
	{
		var txt=0;
		txt=vars.stack;
		if( mc.stack.txt != txt)
		{
			mc.stack.txt=txt;
			gfx.set_text_html(mc.stack.tf,16,0xffffff,"<p align=\"center\"><b>"+txt+"</b></p>");
		}
	}
	
	function stack_setup()
	{
		if(vars.stack)
		{
			stack_display();
		}
	}
	
	function update_tool()
	{
	var dx,dy,ss,s;
	
		dx=get_dx();
		dy=get_dy();
		
		if((((dx*dx)+(dy*dy))<(25*25))&&(!up.player.ignore_items))
		{
			if( stand_check() )
			{
				stand_on();
				show_sign();
				
				var id1="nothing";
				var id2=up.player.hold.d.name;
				var id3;
				
				if(d.inputs>0) // a combine tool
				{
					id1=inputs[0].d.name;
					id3=up.up.dat.combine_get(id1,id2);
					
					
//dbg.chat(id1+"+"+id2+"="+id3);

					if(id3) //it combined
					{
						inputs[0].setup_id("nothing");
						up.player.hold.setup_id(id3);
						up.player.checkhold();
						
_root.sock.chat("/me has created "+up.player.hold.d.html);
_root.signals.submit_award("join_"+up.player.hold.d.name);

						launch("confetti");
						if(d.sfx) { d.sfx(); }


					}
					else
					{
						if( (id1=="nothing") && (id2!="nothing") )
						{
							inputs[0].setup_id(id2);
							up.player.hold.setup_id("nothing");
						}
						else
						if( (id1!="nothing") && (id2=="nothing") )
						{
							inputs[0].setup_id("nothing");
							up.player.hold.setup_id(id1);
							up.player.checkhold();
						}
					}
					
				}
				else // an active tool
				{
					id1=d.tool;
					
					id3=up.up.dat.combine_get(id1,id2);
//dbg.chat(id1+"+"+id2+"="+id3);
					if(id3) //it combined
					{
						up.player.hold.setup_id(id3);
						up.player.checkhold();
						
_root.sock.chat("/me has created "+up.player.hold.d.html);
_root.signals.submit_award("tool_"+up.player.hold.d.name);

						launch("confetti");
						if(d.sfx) { d.sfx(); }
					}
				}
				

			}
//dbg.print(id);
		}
		else
		{
			stand_off();
			hide_sign();
		}
	}

	function update_item()
	{
	var dx,dy,ss,s;
	
		dx=get_dx();
		dy=get_dy();
		
		if((((dx*dx)+(dy*dy))<(25*25))&&(!up.player.ignore_items))
		{
			if( stand_check() )
			{
				stand_on();
				show_sign();
								
				var idt=id;
				
				var t=up.player.hold.vars;
				
				if((t.name==vars.name)&&(t.stack>0)&&(vars.stack>0)) // stackables
				{
					_root.sfx("drop");

					t.stack+=vars.stack;
					up.player.hold.setup_id(t);
					up.player.checkhold();
					setup_id({name:"nothing"});
				}
				else
				{
					if( (t.name=="nothing") && (vars.name=="nothing") ) // nothing to do
					{
					}
					else
					{
						_root.sfx("drop");
						
						up.player.hold.vars=vars; // copy state vars across
						vars=t;

						setup_id(up.player.hold.id);
						up.player.hold.setup_id(idt);
						
						t=up.player.hold.vars;
						
						up.player.checkhold();
						
					}
				}
			}
//dbg.print(id);
		}
		else
		{
			stand_off();
			hide_sign();
		}
	}
	
	function update_loot()
	{
	var dx,dy,ss,s;
	
		dx=get_dx();
		dy=get_dy();
		
		if((((dx*dx)+(dy*dy))<(25*25))&&(!up.player.ignore_items))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	function update_spesh()
	{
	var dx,dy,ss,s;
	
		dx=get_dx();
		dy=get_dy();
		
		if((((dx*dx)+(dy*dy))<(50*50)))
		{
			if(up.player.overspesh!=this)
			{
				d.spesh(this,"on");
				
				up.player.overspesh=this;
			}
		}
		else
		{
			if(up.player.overspesh==this)
			{
				d.spesh(this,"off");
				up.player.overspesh=null;
			}
		}
	}
	
	function setup_engine()
	{
		if(type=="engine")
		{
			if(vars.time<=0) { vars.time=1; } 				// trigger on setup
			if(vars.items==undefined) { vars.items=[]; }
		}
	}
	
	function update_engine()
	{
		vars.time+=d.e_rate;
		
		if(vars.time>=1)
		{
			vars.time=0;
			
			if(vars.items.length<d.e_max)
			{
				var it=new RunItem(up,px,py,d.flavour); // this is an absolute id
				
				it.engine=this;
				
				vars.items[vars.items.length]=it;
				up.mobs[up.mobs.length]=it;
				
			}
		}
		
	}
	

	function update()
	{
		if(callback) // very custom
		{
			return callback("update",this);
		}
		
		switch(type)
		{
			case "engine":
				update_engine();
			break;

			case "spesh":
				update_spesh();
			break;

			case "tool":
				update_tool();
			break;

			case "sign":
				update_say();
				update_sign();
			break;
			
			case "item":
				update_item();
			break;
			
			case "loot":
				return update_loot();
			break;
			
			case "door":
				update_door();
			break;
			
			case "tard":
				update_say();
				if(tard)
				{
					tard.update({});
				}
				update_sign();
			break;
			
			case "mob":
				if(tard)
				{
					tard.update({});
				}
			break;
			
			case "custom":
			break;
		}
				
		return false;
	}
	
	function update_held()
	{
		time_update();
	}
	
	function jump()
	{
		if(d.jump)
		{
			return d.jump(this);
		}
		else
		{
			if((type=="door"))//&&(overcount>door_wait)) // must stand on dooor for a little while
			{
				up.up.change_room(d.room,d.door);
				return true;
			}
		}
	}
	
	function getcol(x,y)
	{
		return up.getcol(x,y,1);
	}
	
	function fizix_move()
	{
	var	vv=Math.floor((Math.sqrt(mc.vx*mc.vx+mc.vy*mc.vy))/20)*2+1;
		
	var vvx=mc.vx;
	var vvy=mc.vy;
	
	var ncx;
	var ncy;
	
		
		if(vv>0)
		{
		var vs;
		var vcx,vcy;
		var vpx,vpy;
		var tcx,tcy;
		var lcx,lcy;
		
		var first_col;
		var lid,nid;
		
		
			vvx=mc.vx/vv;
			vvy=mc.vy/vv;
		

//dbg.clear_tf();
//dbg.print("vv :"+vv);
//dbg.print("vvx :"+vvx);
//dbg.print("vvy :"+vvy);

			while(vv>0)
			{
				if(vvy<0) // we are jumping up for some reason
				{
					if(fizix_state!="air") // jumpinging
					{
					}
					fizix_state="air"; // mark state as in air
				}
						
				lcx=Math.floor((mc._x)/20);
				lcy=Math.floor((mc._y)/20);
				lid=getcol(lcx,lcy); // last type
				
				ncx=Math.floor((mc._x+vvx)/20);
				ncy=Math.floor((mc._y+vvy)/20);
					
//dbg.print("lcx :"+lcx);
//dbg.print("lcy :"+lcy);

				if(lcx!=ncx)// x cell move
				{
//					dbgframe("xcell<br>");
			
					nid=getcol(ncx,lcy); // next type
//dbg.print("id :"+lid+" - "+nid);
										
					if( ( (lid==0) && (nid!=0) ) || (nid==1) ) // hit edge
					{
						if(getcol(ncx,lcy-1)==0) // step up
						{
							mc._x+=vvx;
							mc._y=(lcy-1)*20+19;
							
							lcx=Math.floor((mc._x)/20);
							lcy=Math.floor((mc._y)/20);
							lid=getcol(lcx,lcy); // last type
							
							ncx=Math.floor((mc._x+vvx)/20);
							ncy=Math.floor((mc._y+vvy)/20);
						}
						else
						{
							if(vvx>0) // right edge
							{
								mc._x=lcx*20+19;
							}
							else
							if(vvx<0) // left edge
							{
								mc._x=lcx*20;
							}
							
							vvx=0;
							mc.vx=0;
//							if(state=="bounce") { state="jump"; }
						}
					}
					else
					{
						if(getcol(ncx,lcy+1)==0) // fall down
						{
							if(fizix_state!="air") // jumpinging
							{
							}
							fizix_state="air"; // mark state as in air
						}
						mc._x+=vvx;
					}
				}
				else
				{
					mc._x+=vvx;
				}
				
				
				if(lcy!=ncy) // y cell move
				{
					
					lcx=Math.floor((mc._x)/20);
					lid=getcol(lcx,lcy); // last type
					nid=getcol(lcx,ncy); // next type
					
//					dbgframe("ycell "+lcx+","+lcy+" : "+lid+"<br>");
//					dbgframe("ycell "+ncx+","+ncy+" : "+nid+"<br>");
					
					if(vvy<=0) // upwards always allowed
					{
						mc._y+=vvy;
					}
					else
					{
						if( ( (lid==0) && (nid!=0) ) || (nid==1) ) // hit edge
						{
							mc._y=lcy*20+19;
							mc.vy=0;
							vvy=0;
							
							if(fizix_state!="floor") // landing
							{
							}
							fizix_state="floor";

//							_root.wetplay.PlaySFX("sfx_step",0);
										
							mc.atrest=true;
							xscore=1;
						}
						else
						{
							mc._y+=vvy;
						}
					}
				}
				else
				{
					mc._y+=vvy;
				}
				
				vv--;
			}
		}
	}

	
	var hold_state;
	var hold_anim=0;

	function hold_setup()
	{
		hold_state="none";
	}
	
	function hold_update(tard,key,press,release) // fire
	{
		if(d.flavour!="weapon") { return;}
		
		if(!key)
		{
			if(tard.vx<0)
			{
				mc.hxs=-1;
			}
			else
			if(tard.vx>0)
			{
				mc.hxs=1;
			}
		}
		
		if(key && (hold_state=="none") )
		{
			hold_state="fire";
			hold_anim=0;
			
			mc.hxf=mc.hx;
			mc.hyf=mc.hy;
			mc.hxd=d.w_dx*mc.hxs;
			mc.hyd=d.w_dy;
			mc._xscale=mc.hxs*100;
		}
		
		
		if(hold_state=="none")
		{
			mc._xscale=mc.hxs*100;
			return;
		}
		
		
		
		if(hold_state=="fire")
		{
		var i;
		var f,s,s2;
		var part=Math.floor(hold_anim);
		
			f=hold_anim-part;
			s=MainStatic.spine(f);
			
			s2=MainStatic.spine(f*0.5)*2;
	
			switch(part)
			{
				case 0:
					mc._x=mc.hxf+mc.hxd*s2;
					mc._y=mc.hyf+mc.hyd*s2;
					hold_anim+=d.w_1;
				break;
				case 1:
					mc._x=(mc.hxf*(1-s))+(mc.hx*(s))+mc.hxd*(1-s);
					mc._y=(mc.hyf*(1-s))+(mc.hy*(s))+mc.hyd*(1-s);
					hold_anim+=d.w_2;
				break;
				case 2:
					mc._x=mc.hx;
					mc._y=mc.hy;
					hold_state="none";
				break;
			}
				
			var check=function(it,v)
			{
			var dx,dy,dd;
			
				if(v.hold==it) { return; }
				
				dx=it.mc._x-v.px;
				dy=it.mc._y-v.py;
				
				dd=(dx*dx)+(dy*dy);
				
/*
dbg.clear_tf();
dbg.print("anim :"+hold_anim);
dbg.print("dx :"+mc._x+" "+v.px);
dbg.print("dy :"+mc._y+" "+v.py);
dbg.print("dd :"+dd);
*/

				if(dd<100*100)
				{
					if(v.react.state=="none")
					{
						v.react.launch_dam(this,25*it.mc.hxs,-25);
					}
				}
			}
			if(part==0) // only attack part of animation
			{
				check(this,up.player);
				
				for(i=0;i<up.mobs.length;i++)
				{
					check(this,up.mobs[i].tard);
				}
			}
		}
	}
	
	
	
	function hold_setpos(_x,_y) // set position to this
	{
		mc.hx=_x;
		mc.hy=_y;
		
		if(hold_state=="none")
		{
			mc._x=mc.hx;
			mc._y=mc.hy;
		}
		
	}
	
	
	
}
