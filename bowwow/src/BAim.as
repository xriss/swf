/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class BAim
{
	var mc:MovieClip;

	var up;
	
	var fx,fy;
	var tx,ty;
	
	static var MAXLEN      :Number =   300;
	
	static var STATE_NONE      :Number =   0;
	static var STATE_HOLD      :Number =   1;
	static var STATE_WAIT      :Number =   2;
	var state;
	
	
	var power;
	var angle;
	var shoot;
	
	var gizmo;
	var gizmo_zoom;
	var gizmo_buttons;
	var gizmo_button_shoot;
	var gizmo_button_boom;
	var gizmo_button_move;
	
	var gizmo_text_scroll;
	var gizmo_text_scroll_knob;
	var gizmo_text_list;
	
	var typehere;
	var gizmo_shot;
	var gizmo_showhide;
	var gizmo_options;
	
	var tf_pow;
	var tf_ang;
	
	var shotargs;


	function delegate(f,d) { return com.dynamicflash.utils.Delegate.create(this,f,d); }


	function BAim(_up)
	{
	var g,gp;
	var tf,s;
	var m;
	
		up=_up;
		mc=gfx.create_clip(up.mc,null);
		
		mc._x=400;
		mc._y=300;
		
		mc.style=	{	fill:0xffffffff,	out:0xffffffff,	text:0xffffffff		};

// master gizmo
		gizmo=new Gizmo(this);
		gizmo.top=gizmo;
		g=gizmo;
		g.set_area(-400,-300,800,600);

//top child
		gp=gizmo;

// button container
		g=gp.child(new Gizmo(gp))
		g.set_area(0,0,800,600);
		g.mc.style={	fill:0x40ffffff,	out:0xffffffff,	text:0xffffffff		};
		
		g.active=false;
		gizmo_buttons=g;

//child
		gp=g;
		
// buttons
		g=gp.child(new GizmoButt(gp))
		g.set_area(125,425,150,150);
		g.mc.style={	fill:0x40ffffff,	out:0xffffffff,	text:0xffffffff		};
		g.mc_base=gfx.add_clip(g.mc,"butt_base",null,75,75,150,150);
		g.mc_over=gfx.add_clip(g.mc,"butt_over",null,75,75,150,150);
		g.mc_down=gfx.add_clip(g.mc,"butt_down",null,75,75,150,150);

		gfx.add_clip(g.mc_base,"shoot",null,0,0,90,90);
		gfx.add_clip(g.mc_over,"shoot",null,0,0,90,90);
		gfx.add_clip(g.mc_down,"shoot",null,0,0,85,85);
		
		g.id="shoot";
		g.onClick=delegate(onClick,g);
		gizmo_button_shoot=g;
		
		g=gp.child(new GizmoButt(gp))
		g.set_area(325,425,150,150);
		g.mc.style={	fill:0x40ffffff,	out:0xffffffff,	text:0xffffffff		};
		g.mc_base=gfx.add_clip(g.mc,"butt_base",null,75,75,150,150);
		g.mc_over=gfx.add_clip(g.mc,"butt_over",null,75,75,150,150);
		g.mc_down=gfx.add_clip(g.mc,"butt_down",null,75,75,150,150);

		gfx.add_clip(g.mc_base,"boom",null,0,0,90,90);
		gfx.add_clip(g.mc_over,"boom",null,0,0,90,90);
		gfx.add_clip(g.mc_down,"boom",null,0,0,85,85);

		g.id="boom";
		g.onClick=delegate(onClick,g);
		gizmo_button_boom=g;
		
		g=gp.child(new GizmoButt(gp))
		g.set_area(525,425,150,150);
		g.mc.style={	fill:0x40ffffff,	out:0xffffffff,	text:0xffffffff		};
		g.mc_base=gfx.add_clip(g.mc,"butt_base",null,75,75,150,150);
		g.mc_over=gfx.add_clip(g.mc,"butt_over",null,75,75,150,150);
		g.mc_down=gfx.add_clip(g.mc,"butt_down",null,75,75,150,150);
		
		gfx.add_clip(g.mc_base,"move",null,0,0,90,90);
		gfx.add_clip(g.mc_over,"move",null,0,0,90,90);
		gfx.add_clip(g.mc_down,"move",null,0,0,85,85);
		
		g.id="move";
		g.onClick=delegate(onClick,g);
		gizmo_button_move=g;




		var foreground=0xffffff;
		var background=0x000000;
		var ss=20;
		var gmc;
		var w,h;
		
		
//top child
		gp=gizmo;
// slider container		
		g=gp.child(new Gizmo(gp))
		g.set_area(10,15,220,ss);
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_boxen(g.mc,0,0,g.w,g.h);
		
//child
		gp=g;
// slider knob
		g=gp.child(new GizmoKnob(gp));
		g.set_area((gp.w-ss*3)*0.25,0,ss*3,ss);
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss*3,ss);
		g.mc_base=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss*3,ss);
		g.mc_over=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss*3,ss);
		g.mc_down=gmc;
				
		g.mc.tf=gfx.create_text(g.mc,100,10,2,ss*3,ss);
		g.mc.tf.setNewTextFormat(gfx.create_text_format(ss-9,0xff000000+foreground,"bold"));
		g.mc.tf.text="ZOOM";
		g.mc.tf.selectable=false;
		
		gizmo_zoom=g;
		
		
		
		gp=gizmo;
		g=gp.child(new Gizmo(gp))
		g.set_area(10,15+ss*1,180,ss*2);
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_boxen(g.mc,0,0,g.w,g.h);
		
		typehere=gfx.create_text_edit(g.mc,null,ss*0.25,ss*0.25,w-ss*1.5,ss*1.5);
		typehere.setNewTextFormat(gfx.create_text_format(ss+2,0xff000000+foreground));
		typehere.text="";
		
		typehere.onEnterKeyHasBeenPressed=delegate(onClick,typehere);
		
		
		gp=gizmo;
		g=gp.child(new GizmoButt(gp))
		g.set_area(10+180,15+ss,ss*1,ss*2);

		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,ss,ss*2);
		g.mc_base=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,ss,ss*2);
		g.mc_over=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xcc000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,ss,ss*2);
		g.mc_down=gmc;

		g.mc.tf=gfx.create_text(g.mc,100,ss-1,0,ss*2,ss);
		g.mc.tf.setNewTextFormat(gfx.create_text_format(ss-9,0xff000000+foreground,"bold"));
		g.mc.tf.text="SHOT";
		g.mc.tf._rotation=90;
		g.mc.tf.selectable=false;
		
		g.onClick=delegate(onClick,g);
		
		g.id="shot";
		gizmo_shot=g;
				
		
		
		
		gp=gizmo;
		g=gp.child(new Gizmo(gp))
		g.set_area(10,15+ss*1,180,ss*2);
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_boxen(g.mc,0,0,g.w,g.h);
		
		typehere=gfx.create_text_edit(g.mc,null,ss*0.25,ss*0.25,g.w-ss*0.5,ss*1.5);
		typehere.setNewTextFormat(gfx.create_text_format(ss+2,0xff000000+foreground));
		typehere.text="";
		
		typehere.onEnterKeyHasBeenPressed=delegate(onClick,gizmo_shot);
		
		
		gp=gizmo;
		g=gp.child(new GizmoButt(gp))
		g.set_area(10+180+ss,15+ss,ss*1,ss*2);

		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,ss,ss*2);
		g.mc_base=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,ss,ss*2);
		g.mc_over=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xcc000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,ss,ss*2);
		g.mc_down=gmc;

		g.mc.tf=gfx.create_text(g.mc,100,ss-1,0,ss*2,ss);
		g.mc.tf.setNewTextFormat(gfx.create_text_format(ss-9,0xff000000+foreground,"bold"));
		g.mc.tf.text="LOGS";
		g.mc.tf._rotation=90;
		g.mc.tf.selectable=false;
		
		g.onClick=delegate(onClick,g);
		g.id="showhide";
		gizmo_showhide=g;

		gp=gizmo;
		g=gp.child(new Gizmo(gp))
		g.set_area(10,15+ss*1,180,ss*2);
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_boxen(g.mc,0,0,g.w,g.h);
		
		typehere=gfx.create_text_edit(g.mc,null,ss*0.25,ss*0.25,g.w-ss*0.5,ss*1.5);
		typehere.setNewTextFormat(gfx.create_text_format(ss+2,0xff000000+foreground));
		typehere.text="";
		
		typehere.onEnterKeyHasBeenPressed=delegate(onClick,gizmo_shot);
		
		
		gp=gizmo;
		g=gp.child(new GizmoButt(gp))
		g.set_area(10+180+ss*2,15,ss*1,ss*3);

		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,ss,ss*3);
		g.mc_base=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,ss,ss*3);
		g.mc_over=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xcc000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,ss,ss*3);
		g.mc_down=gmc;

		g.mc.tf=gfx.create_text(g.mc,100,ss-1,0,ss*3,ss);
		g.mc.tf.setNewTextFormat(gfx.create_text_format(ss-9,0xff000000+foreground,"bold"));
		g.mc.tf.text="OPTIONS";
		g.mc.tf._rotation=90;
		g.mc.tf.selectable=false;
		
		g.onClick=delegate(onClick,g);
		g.id="options";
		gizmo_options=g;
		
		w=200;
		h=400;
		
		gp=gizmo;
// scroll slider container
		g=gp.child(new Gizmo(gp));
		g.set_area(10+w,15+ss*3,ss,h/2);
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_boxen(g.mc,0,0,g.w,g.h);
	
		gizmo_text_scroll=g;
		
		gp=g;
// scroll slider knob
		g=gp.child(new GizmoKnob(gp));
		g.set_area(0,gp.h-ss*4,ss,ss*4);
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss,ss*4);
		g.mc_base=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss,ss*4);
		g.mc_over=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss,ss*4);
		g.mc_down=gmc;
		
		gizmo_text_scroll_knob=g;

		gp=gizmo;
//a TF scroll area
		g=gp.child(new GizmoText(gp));
		g.set_area(10,15+ss*3,w-ss*1,h/2);
		g.str="<p></p>";
		g.tf_fmt.size=ss-2;
		g.tf_fmt.color=0xff000000+foreground;
		g.vgizmo=gizmo_text_scroll_knob;
		
		gizmo_text_list=g;

		
		
		
		gizmo_text_scroll.active=false;
		gizmo_text_list.active=false;


		
				
		gizmo.update();
		
		s="";
		s+="<p align=\"right\">";
		s+="0%"
		s+="</p>";
		tf=gfx.create_text_html(mc,null,0,0,200,50);
		gfx.set_text_html(tf,32,0xffffff,s);		
		tf_pow=tf;
		
		s="";
		s+="<p align=\"left\">";
		s+="0"
		s+="</p>";
		tf=gfx.create_text_html(mc,null,0,0,200,50);
		gfx.set_text_html(tf,32,0xffffff,s);		
		tf_ang=tf;
		
		
		
	}

	function setup()
	{
		state=STATE_NONE;
	}
	
	function clean()
	{
	}
	
	function doshot(s)
	{
	var aa;
	var r;
	var ang,pow,dir;
	
		aa=s.split(" ");
		
		pow=aa[0].split("%")[0];
		ang=aa[1].split("e")[0].split("w")[0];
		dir=aa[1].substr(-1,1);
		
		pow=Math.floor(pow);
		ang=Math.floor(ang);
		dir=dir.toLowerCase()=="e"?"e":"w";
		
		pow=isNaN(pow)?100:pow;
		ang=isNaN(ang)?90:ang;
				
		if(pow>100) {pow=100; }
		if(pow<0) 	{pow=0; }
		
		if(ang>90) 	{ang=90; }
		if(ang<-90) {ang=-90; }
		
		r=pow+" "+ang+dir;
	
		shotargs=r;
		typehere.text=r;
		Selection.setFocus(typehere);
		Selection.setSelection(0,typehere.text.length);
		
		if( (state==STATE_HOLD) || (state==STATE_NONE) )
		{
			state=STATE_WAIT;
			
			power=pow/100;
			angle=(dir=="e")?-ang:ang-180;
			shoot=true;
			
			_root.wetplay.PlaySFX("sfx_whoosh",3);
		}
	}

	function onClick(g)
	{
	
		switch(g.id)
		{
			case "showhide":
			
				if(gizmo_text_scroll.active)
				{
					if(up.showoptions)
					{
						up.showoptions=false;
						up.buildlogs();
					}
					else
					{
						up.showoptions=false;
						gizmo_text_scroll.active=false;
						gizmo_text_list.active=false;
					}
				}
				else
				{
					up.showoptions=false;
					gizmo_text_scroll.active=true;
					gizmo_text_list.active=true;
					up.buildlogs();
				}
				
				
			break;
			
			case "options":
			
				if(gizmo_text_scroll.active)
				{
					if(up.showoptions)
					{
						up.showoptions=false;
						gizmo_text_scroll.active=false;
						gizmo_text_list.active=false;
					}
					else
					{
						up.showoptions=true;
						up.buildlogs();
					}
				}
				else
				{
					up.showoptions=true;
					gizmo_text_scroll.active=true;
					gizmo_text_list.active=true;
					up.buildlogs();
				}
				
				
			break;
			
			case "shot":
			
				doshot(typehere.text);
//				Selection.setFocus(typehere);
//				Selection.setSelection(0,typehere.text.length);
//				typehere.text="";
			break;
			
/*
			up.back.blinks=new Array(); // kill all old links
			gizmo_buttons.active=false;

			if(up.id="slowsnap")
			{
				up.focus.time=1000;	// set focus
			}
			
			if(g.id=="shoot")
			{
				up.shooter.shot_type="arrow";
			}
			else
			if(g.id=="boom")
			{
				up.shooter.shot_type="boom";
			}
			else
			if(g.id=="move")
			{
				up.shooter.shot_type="move";
			}
*/
		}
	}
	
	function update()
	{
	var dshot=false;
	
		mc.clear();
		
		var snapshot=_root.poker.snapshot();		
//		mc.localToGlobal(snapshot);
		gizmo.mc.globalToLocal(snapshot);
		gizmo.focus=gizmo.input(snapshot);
		if(snapshot.key_off&1) { gizmo.focus=null; } // remove old focus on mouse up
		gizmo.update();

// if input has not been gobbled by a gizmo, do what we want with it

		if( (!gizmo_buttons.active) && (!gizmo.focus) )
		{
			if(_root.poker.poke_now)
			{
//			dbg.print("mouse on");
				
				if(state==STATE_NONE)
				{
					if(up.id!="slowsnap")
					{
						up.do_slowsnap();
						up.focus.time=1000;	// set focus
					}
				}
				
				if	(								 //ignore clicks in chat box / offscreen
						(mc._xmouse<300)
						&&
						(mc._xmouse>-300)
						&&
						(mc._ymouse<200)
						&&
						(mc._ymouse>-200)
					)
				{
					if(state==STATE_NONE)
					{
						state=STATE_HOLD;
						
						fx=mc._xmouse;
						fy=mc._ymouse;
					}
				}
			}
				
			if(_root.poker.poke_up)
			{
//			dbg.print("mouse off");
				
				if(state==STATE_HOLD)
				{
					if( ( (fx-tx)*(fx-tx) + (fy-ty)*(fy-ty) ) >= 256 )
					{
						dshot=true;
					}
					else
					{
						state=STATE_NONE; // cancel shot
					}
				}
			}
		}
		
		tf_pow._visible=false;
		tf_ang._visible=false;
					
		if(state==STATE_HOLD) // mouse dragging
		{
		
			tx=mc._xmouse;
			ty=mc._ymouse;
		
			var px,py,pp;
			var pt,pcx,pcy,ppc;
			var ps,pa,pl;
			
			px=tx-fx;
			py=ty-fy;
			
			pp=Math.sqrt(px*px+py*py);
			if(pp>MAXLEN)
			{
				px=px*MAXLEN/pp;
				py=py*MAXLEN/pp;
				pp=MAXLEN;
			}
			else
			if(pp<1)
			{
				px=-1;
				py=0;
				pp=1;
			}
			
// save settings
			power=pp/MAXLEN;
			angle = Math.round((Math.atan2(-py,-px)*180/Math.PI));
			
// draw			
			pa=(pp<32?pp/2:16);
			pl=(pp<32?pp/8:4);
			pt=(px<0?-pp:pp);
			
/*
			pcx=(pt+px)/2;
			pcy=(0+py)/2;
			ppc=Math.sqrt(pcx*pcx+pcy*pcy);
			pcx=pcx*pp/ppc;
			pcy=pcy*pp/ppc;
*/
			
			mc.style= {			fill:0x40ffffff,	out:0xffffffff,	text:0xffffffff		};
			
			mc.lineStyle(pl,mc.style.out&0xffffff,((mc.style.out>>24)&0xff)*100/255);
			mc.moveTo(fx,fy);
			mc.lineTo(fx+px,fy+py);

			mc.moveTo(fx,fy);
			mc.lineTo(fx+(py*-pa/pp)+(px*pa/pp),fy+(px*pa/pp)+(py*pa/pp));

			mc.moveTo(fx,fy);
			mc.lineTo(fx+(py*pa/pp)+(px*pa/pp),fy+(px*-pa/pp)+(py*pa/pp));
			
			mc.lineStyle(undefined,undefined,undefined);
			mc.moveTo(fx,fy);
			mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);
			mc.lineTo(fx+pt,fy);
			mc.curveTo(fx+pt,fy+py*0.75,fx+px,fy+py);
			mc.lineTo(fx,fy);
			mc.endFill();
			
			tf_pow._x=fx-225;
			tf_pow._y=fy-50;
			tf_ang._x=fx+25;
			tf_ang._y=fy-50;
			
			var leftright;
			var dang=angle;
			
			if((angle<90)&&(angle>-90))
			{
				leftright="e";
			}
			else
			{
				leftright="w";
			}
			
			if(dang>90) { dang=180-dang; }
			else
			if(dang<-90) { dang=-180-dang; }
//			else
//			if(dang<0) { dang=-dang; }
			dang=-dang;
			
			gfx.set_text_html(tf_pow,32,0xffffff, "<p align=\"right\">" + Math.floor(power*100) + "%</p>" );
			gfx.set_text_html(tf_ang,32,0xffffff, "<p align=\"left\">" + Math.floor(dang) + leftright + "</p>" );
			
			tf_pow._visible=true;
			tf_ang._visible=true;
			
			
			if(dshot)
			{
			
				doshot( Math.floor(power*100) +" "+ Math.floor(dang) + leftright);
			}
		}
	}
	
	function draw_boxen( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss,y+ss);
		mc.lineTo(x+w-ss,y+ss);
		mc.lineTo(x+w-ss,y+h-ss);
		mc.lineTo(x+ss,y+h-ss);
		mc.lineTo(x+ss,y+ss);
		
		mc.moveTo(x+ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+ss*2);
		
		mc.endFill();
	}
	
	function draw_puck( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss*3,y+ss*3);
		mc.lineTo(x+w-ss*3,y+ss*3);
		mc.lineTo(x+w-ss*3,y+h-ss*3);
		mc.lineTo(x+ss*3,y+h-ss*3);
		mc.lineTo(x+ss*3,y+ss*3);
		
		mc.endFill();
	}

	function draw_box( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss*1,y+ss*1);
		mc.lineTo(x+w-ss*1,y+ss*1);
		mc.lineTo(x+w-ss*1,y+h-ss*1);
		mc.lineTo(x+ss*1,y+h-ss*1);
		mc.lineTo(x+ss*1,y+ss*1);
		
		mc.endFill();
	}
}
