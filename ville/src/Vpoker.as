/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


//
// a 3d poker thing, follows the floor or highlights any objects under the mouse.
//

class Vpoker
{
	var up;
	
	var mc;
	var mcmenu;
	var menu;

	var xs;
	var ys;
	var zs;
	
	var x3;
	var y3;
	var z3;
	
	var over;
	
	var state;
	
	var menuwait=0;
	
	var items;
	var selected;
	
	
	var style="tick";
//	var maxmove=100;
	
	function Vpoker(_up)
	{
		up=_up;
	}

	function setup()
	{

		mc=gfx.create_clip(up.mc,65536);
		mc.ptr=gfx.create_clip(mc);
//		mc.hud=gfx.create_clip(mc);
		mcmenu=gfx.create_clip(up.up.mc,65537);
		
		draw_floor(40,0,40);
		
		over=null;
		state=null;
		
		Mouse.addListener(this);
	}
	
	function draw_floor(_xs,_ys,_zs)
	{
	var zs4;
	
		xs=_xs;
		ys=_ys;
		zs=_zs;

		zs4=zs/4;
		
		gfx.clear(mc.ptr);
		
/*
		mc.ptr.lineStyle(undefined,undefined);
		mc.ptr.moveTo(0,0);
		mc.ptr.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);
		mc.ptr.lineTo(0+xs,0);
		mc.ptr.lineTo(0+xs+zs4,0-zs4);
		mc.ptr.lineTo(0+zs4,0-zs4);
		mc.ptr.lineTo(0,0);
		mc.ptr.endFill();
*/		
		gfx.draw_fcirc4(mc.ptr,1, 0+xs,0, 0+xs+zs4,0-zs4, 0+zs4,0-zs4, 0,0 );
		
		mc.ptr._alpha=50;
	}
	
	function clean()
	{
		mc.removeMovieClip();
		Mouse.removeListener(this);
	}

	function onMouseDown()
	{
		if( up.up.mc._xmouse >=800) { return; }
		
		if(over)
		{			
			if(state!="menuclick")
			{
				menu=over.getmenu(this); // the selected object provides the first menu
				state="menuwait";
				menuwait=5;
			}
		}
		else // click on floor
		{
//			state="move";
		}
		
	}
	function onMouseUp()
	{
		if( up.up.mc._xmouse >=800) { return; }
		
		if( (state=="menu") || (state=="menuclick") )
		{
			clickmenu();
		}
		else
		if( (state=="menuwait") )
		{		
			if( menu.menuclick )
			{
				mcmenu._x=up.up.mc._xmouse;
				mcmenu._y=up.up.mc._ymouse;
				state="menu";
				menu.menuclick(this,menu.items[0]);
			}
			else
			{
				state=null;
			}
		}
		else
		{
			state="moved";
		}
	}
	
	function update()
	{
	var x,y,z;
	
	var key=_root.replay.key;
	var keys;
	var cc=up.focus.cc;
	x=0;
	y=0;
	z=0;

// keys are bad for network issues, so just use the pointer

		/*
		if(key&Replay.KEYM_LEFT)
		{
			x=-40;
		}
		if(key&Replay.KEYM_RIGHT)
		{
			x= 40;
		}
		if(key&Replay.KEYM_UP)
		{
			z= 40;
		}
		if(key&Replay.KEYM_DOWN)
		{
			z=-40;
		}
		*/
		
		if((x==0)&&(z==0)) // use mouse
		{
			x=up.mc._xmouse;
			y=up.mc._ymouse;
			
			x-=up.x2;
			y-=up.y2;
			
			x+=y;
			z=(-y*4);
			y=0;
			
			x-=20;
			z-=20;
			
			keys=false;
		}
		else
		{
			x+=cc.dx-20;
			z+=cc.dz-20;
			y =cc.dy;

			keys=true;
		}
		
		if(x<up.x3_min)		{ x=up.x3_min; }
		if(y<up.y3_min)		{ y=up.y3_min; }
		if(z<up.z3_min)		{ z=up.z3_min; }
		
		if(x>up.x3_max-40)	{ x=up.x3_max-40; }
		if(y>up.y3_max  )	{ y=up.y3_max; }
		if(z>up.z3_max-40)	{ z=up.z3_max-40; }
		
		if(style=="hexsqr") // hex snap
		{
			x+=20;
			x=Math.floor(x/40);
			y=Math.floor(y/10);
			z=Math.floor(z/20);
			
			if(x%2==1) // make even
			{
				z=z-(z%2)
			}
			else // make odd
			{
				z=z+1-(z%2)
			}
			x*=40;
			y*=10;
			z*=20;
		}
		else
		{
			x=Math.floor(x/10)*10;
			y=Math.floor(y/10)*10;
			z=Math.floor(z/10)*10;
		}
		
		
		x3=x;
		y3=y;
		z3=z;
		
		mc.ptr._x=up.x2+x3+(z/4);
		mc.ptr._y=up.y2+y3-(z/4);
		
		switch(state)
		{
			case "move":
			case "moved":
/*			
				cc.tx=x3+20;
				cc.ty=y3;
				cc.tz=z3+20;
				cc.idle_type="idle";
*/		
				cc.vcobj.send_msg_prop( "xyz" , (x3+20)+":"+y3+":"+(z3+20) );
				state=null;
			break;
		
			case "menuwait":
				menuwait--;
				if(menuwait<=0)
				{
					showmenu();
				}
			break;
			
			case "menu":
				updatemenu();
			break;
			
			case "menuclick":
				updatemenu();
			break;
			
			default:
			
/*
				if(keys)
				{
					cc.tx=x3+20;
					cc.ty=y3;
					cc.tz=z3+20;
					cc.idle_type="idle";
				}
				else
*/
//				{				

					if(style=="hexsqr")
					{
					}
					else
					{
						if(over)
						{
							if(up.over!=over)
							{
								over.filters=null;
								over.title._visible=false; // hide name of avatar or whatever
							}
						}
						
						if(up.over)
						{
							over=up.over;
							
							if( over==up.focus )
							{
								gfx.glow(over , 0x88ff88, .8, 16, 16, 1, 3, false, false );
							}
							else
							{
								gfx.glow(over , 0xffffff, .8, 16, 16, 1, 3, false, false );
							}
							mc.ptr._visible=false;
							over.title._visible=true; // hide name of avatar or whatever
							
	/*
							if( over.cc.type_name=="vtard" )
							{
								if( over.cc.vcobj.owner )
								{
									_root.poker.ShowFloat(over.cc.vcobj.owner,1);
								}
							}
	*/
						}
						else
						{
							over=null;
							
							mc.ptr._visible=true;
						}
					}
//				}
				
			break;
		}
	}
	
	function showmenu(_menu)
	{
	var i;
	var r;
	var rr;
	var t;
	
		over.title._visible=false;

		if(_menu)
		{
			menu=_menu;
		}
		
		if((state=="menu")||(state=="menuclick"))
		{
			for(i=0;i<items.length;i++)
			{
				items[i].removeMovieClip();
			}
			state="menuclick"; // submenus
		}
		else
		{
			state="menu";
			mcmenu._x=up.up.mc._xmouse;
			mcmenu._y=up.up.mc._ymouse;
		}
		

				
		items=[];
		
		for(i=0;i<menu.items.length;i++)
		{
			add_item(menu.items[i]);
		}
		
		mcmenu.top=gfx.create_clip(mcmenu,0xffff); // top level
		
		r=360/items.length;
		rr=0;
		
		for(i=0;i<items.length;i++)
		{
			t=items[i];
			t.r=rr*Math.PI/180;
			t.rmin=t.r-(r/2)*(Math.PI/180);
			t.rmax=t.r+(r/2)*(Math.PI/180);
			
			t.rx= Math.sin(t.r);
			t.ry=-Math.cos(t.r);
			
			rr+=r;
		}
		
		updatemenu();
	}
	
	function updatemenu()
	{
	var i,r,t;
	var choose;
	
		r=Math.atan2(mcmenu._xmouse,-mcmenu._ymouse);
		if(r<0) { r+=Math.PI*2; }
		
		choose=null;
		for(i=0;i<items.length;i++)
		{
			t=items[i];
			
			if(choose==null)
			{
				if(r<t.rmax)
				{
					choose=t;
				}
			}
			
			t._x+=(t.rx*60 - t._x)*0.5;
			t._y+=(t.ry*60 - t._y)*0.5;
			t._xscale+=(60 - t._xscale)*0.5;
			t._yscale+=(60 - t._yscale)*0.5;
			t._alpha+=(60 - t._alpha)*0.5;
		}
		if(choose==null) { choose=items[0]; }
		
		choose._x=0;
		choose._y=0;
		choose._xscale=100;
		choose._yscale=100;
		choose._alpha=100;
		
		choose.swapDepths(0xffff); // bring to top
		
		selected=choose; // remember
	}
	
	function clickmenu()
	{
	
		if( menu.menuclick )
		{
			menu.menuclick(this,selected.it);
		}
		else
		{
			hidemenu();
		}
	}
	
	function hidemenu()
	{
	var i;
		for(i=0;i<items.length;i++)
		{
			items[i].removeMovieClip();
		}
		items=[];
		state=null;
		selected=null;
	}
	
	function add_item(it)
	{
	var m;
	
		m=gfx.create_clip(mcmenu,null);
		m.tf=gfx.create_text_html(m,null,0,0,200,100);
		gfx.set_text_html(m.tf,24,0xffffff,it.txt);
		m.w=m.tf.textWidth;
		m.h=m.tf.textHeight;
		m.tf._x=-m.w/2;
		m.tf._y=-m.h/2;
		
		gfx.clear(m);
		m.style.fill=0xff000000;
		gfx.draw_rounded_rectangle(m,10,10,0,-m.w/2-10-2,-m.h/2-10-2,m.w+20+6+4,m.h+20+6);
		
		m.it=it; // uplink
		
		items.push(m);
	}
	
}