/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
// This file made available under the terms of The MIT License : http://www.opensource.org/licenses/mit-license.php
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#GFX=GFX or "gfx"
#CLASSNAME = CLASSNAME or "Poker"

class #(CLASSNAME)
{

	var mc;
	
	var mcg;
	
	var mcb0;
	var mcb1;
	
	var mcg0;
	var mcg1;
	
	var poke_last;
	var poke_down;
	var poke_up;
	var poke_now;
	var poke_now_now;
	var poke_down_now;
	var poke_up_now;
	var x,y;
	
	var dx,dy;
	var lx,ly;
	
	var hand;
	
	var float;
	var float_time;
	var float_str;
	var mc_floaterz;
	var mc_floater;
	var tf_floater;
	
	var clicks;
	
	var do_anykey;
	var anykey;
	
	var update_do;
	
	var size;
	var scale;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

		
	function #(CLASSNAME)(_hand)
	{
		
		hand=_hand;
		if( System.capabilities.version.split(" ")[0]=="WII" ) // always turn off hand on the wii
		{
			hand=false;
		}
		
// this just confuses the morons and makes them think the game is slow (flash is slow but this makes them think it and whine)
// whine whine whine like the little bitches they are
// so we turn it off

		hand=false;

		
#if CLASSNAME == "Poker" then
		mc=#(GFX).create_clip(_root,16384+32);
		float=true;
#else
		mc=#(GFX).create_clip(_root,16384+32+2);
		float=false;
#end

		if(float)
		{
			mc_floater=#(GFX).create_clip(_root,16384+32+1);
			#(GFX).clear(mc_floater);
			mc_floater.w=200;
			mc_floater.h=80;
			mc_floaterz=#(GFX).create_clip(mc_floater,null);
			mc_floaterz._x=100;
			mc_floaterz._y=40;
			tf_floater=#(GFX).create_text_html(mc_floaterz,null,-100,0,200,200);
			
			float_str="";
			float_time=-100;
//			ShowFloat("<p align=\"center\">Poopy head To teh max of the poop ness oh yeah.</p>",25*5);
		}
		
		
//		mc.onEnterFrame=delegate(update,null);
			
		if(hand)
		{			
			mcb0=#(GFX).create_clip(mc,null);
			mcb1=#(GFX).create_clip(mcb0,null);
			mcg=#(GFX).create_clip(mcb1,null);
			
			mcg0=#(GFX).add_clip(mcg,'poke0',null);
			mcg1=#(GFX).add_clip(mcg,'poke1',null);
			
			mcg0._x=-19;
			mcg0._y=-19;
			
			mcg1._x=-(19+8);
			mcg1._y=-(19+8);
			
			mcg._xscale=75;
			mcg._yscale=75;
		}
		
		onMouseUp();
		
		Mouse.addListener(this);
		Key.addListener(this);
		
		lx=0;
		ly=0;
		
		size=1; // user set
		scale=1; // our scalar result
		
		poke_last=false;
		poke_down=false;
		poke_up=false;
		poke_now=false;
		
		clear_clicks();
		
#if CLASSNAME == "Poker" then
		update_do=delegate(update,null);
		MainStatic.update_add(_root.updates#(CLASSVERSION),update_do);
#end
		
	}
	
	function clean()
	{
#if CLASSNAME == "Poker" then
		MainStatic.update_remove(_root.updates,update_do);
		update_do=null;
#end
	}
	
	function ShowFloat(str,tim)
	{
		if((str!=null)&&(float_str!=str))
		{
			float_str=str;
			
			#(GFX).clear(mc_floaterz);
			mc_floaterz.style.out=0xffffffff;
			mc_floaterz.style.fill=0xffcccccc;
			
			#(GFX).set_text_html(tf_floater,16,0x000000,"<p align=\"center\">"+str+"</p>");
			
			mc_floater.h=tf_floater.textHeight+6;

			#(GFX).draw_box(mc_floaterz,4,-100,-mc_floater.h/2,200,mc_floater.h);		
			tf_floater._y=-mc_floater.h/2;
			mc_floaterz._y=mc_floater.h/2;
		}
		
		if(tim==0)
		{
			if(float_time>tim)
			{
				float_time=tim;
			}
		}
		else
		{
			float_time=tim;
		}
	}
	
	function onKeyDown()
	{
		do_anykey=true;
	}
	
// create smover movement?
	function onMouseMove()
	{
//		_root.main.update();
//		updateAfterEvent();
	}
	
	function onMouseDown()
	{
		
		if(hand)
		{
			Mouse.hide();
			mcg0._visible=false;
			mcg1._visible=true;
		}
		
		poke_now_now=true;
		poke_down_now=true;
		
		if(clicks.length<16) // maximum number of moves to remember
		{
			clicks[clicks.length]={click:1,x:_root._xmouse,y:_root._ymouse};
		}
		
//		dbg.print("down");
	}
	
	function onMouseUp()
	{
		do_anykey=true;
		
		if(hand)
		{
			Mouse.hide();
			mcg0._visible=true;
			mcg1._visible=false;
		}
		
		poke_now_now=false;
		poke_up_now=true;
		
		if(clicks.length<16) // maximum number of moves to remember
		{
			clicks[clicks.length]={click:-1,x:_root._xmouse,y:_root._ymouse};
		}
		
//		dbg.print("up");
	}
	
	function clear_clicks()
	{
		do_anykey=false;
		anykey=false;
		
		poke_last=false;
		poke_down=false;
		poke_up=false;
		poke_now=false;
		
		clicks=[];
	}
	
	function update()
	{
	var rot_dest;
	
		if(do_anykey)
		{
			anykey=true;
		}
		else
		{
			anykey=false;
		}
		
		do_anykey=false;
	
		x=_root._xmouse;
		y=_root._ymouse;
		
		poke_last=poke_now;
		poke_down=poke_down_now;
		poke_up=poke_up_now;
		poke_now=poke_now_now;
		
		poke_down_now=false;
		poke_up_now=false;
	
		dx=x-lx;
		dy=y-ly;
		
		lx=x;
		ly=y;
			
			
		if(hand)
		{
		var a;
		var s;
				
			mc._x=x;
			mc._y=y;
			
			scale=_root.scalar.sx*size/100;
			mc._xscale=100*scale;
			mc._yscale=mc._xscale;
			
			#(GFX).dropshadow(mc,2, 45, 0x000000, 1, 4*scale, 4*scale, 2, 3);
			
			if( (dx==0) && (dy==0) )
			{
				mcb0._rotation=0;
				mcb0._xscale=100;
				mcb0._yscale=100;
				mcb1._rotation=0;				
			}
			else
			{
				a=180*Math.atan2(dy,-dx)/Math.PI;
				s=Math.sqrt(dy*dy+dx*dx)
				
				s=s/1.5;
				if(s>400) { s=400; }

//dbg.print(dy+","+dx+":"+a);

				mcb0._rotation=-a;
				mcb0._xscale=100+(s);
				mcb0._yscale=100-(s/5);
				mcb1._rotation=a;
			}


		
			
			if(dx> 32) { dx= 32; }
			if(dx<-32) { dx=-32; }
			
			rot_dest=dx;
			
			
			mcg._rotation+=(rot_dest-mcg._rotation)/4;
		}
		
/*
		if(Math.abs(rot_dest-mcg._rotation)<1)
		{
			mcg._rotation=rot_dest;
		}
*/		


// place floater

		if((float)&&(float_time>=-10))
		{
		var sx,sy;
		var px,py;
		var dx,dy;
		var nx,ny;
		var mx,my;
		var s,ss,ssx,ssy;
		var fx,fy;
		var qx,qy;
		
		
			if(float_time>0)
			{
				float_time--;
				mc_floater._visible=true;
				mc_floaterz._xscale=100;
				mc_floaterz._yscale=100;
			}
			else
			{
				float_time--;
				
				mc_floaterz._xscale=100+float_time*10;
				mc_floaterz._yscale=mc_floaterz._xscale;
				
				if(float_time==-10)
				{
					mc_floater._visible=false;
				}
			}
		
			sx=mc_floater.w;
			sy=mc_floater.h;
			
			mx=Stage.width;
			my=Stage.height;
			
			dx=x-(mx/2);
			dy=y-(my/2);
			
			ssx=dx*dx;
			qx=dx<0?-dx:dx;
			
			ssy=dy*dy;
			qy=dy<0?-dy:dy;
			
			ss=ssx+ssy;
			s=Math.sqrt(ss);
			if(s==0) {s=1; dx=0; dy=1;}
			
			nx=dx/s;
			ny=dy/s;
			
			fx=-nx*sx*1.75;
			fy=-ny*sy*1.75;
			
			if(qx/2>qy)	// left-right
			{
				if(dx<0) // left
				{
					px=x;
					py=y+fy-(sy/2);
					px+=50;
				}
				else // right
				{
					px=x-sx;
					py=y+fy-(sy/2);
					px-=50;
				}
			}
			else
			if(qx<qy/2)	// top/bot
			{
				if(dy<0) // top
				{
					px=x+fx-(sx/2);
					py=y;
					py+=50;
				}
				else // bottom
				{
					px=x+fx-(sx/2);
					py=y-sy;
					py-=50;
				}
			}
			else			// corner
			{
				if(dx<0) // left
				{
					if(dy<0) // top
					{
						px=x;
						py=y;
						px+=50;
						py+=50;
					}
					else // bottom
					{
						px=x;
						py=y-sy;
						px+=50;
						py-=50;
					}
				}
				else // right
				{
					if(dy<0) // top
					{
						px=x-sx;
						py=y;
						px-=50;
						py+=50;
					}
					else // bottom
					{
						px=x-sx;
						py=y-sy;
						px-=50;
						py-=50;
					}
				}
			}
			
			mc_floater._x=mc_floater._x*0.75 + px*0.25;
			mc_floater._y=mc_floater._y*0.75 + py*0.25;
			
			mc_floater._visible=true;
		}
		else
		{
			mc_floater._visible=false;
		}

	}
	
	function snapshot()
	{		
	var ret;
	
		ret={};
		
		ret.key=poke_now?1:0;
		ret.key_on=poke_down?1:0;
		ret.key_off=poke_up?1:0;
		
		ret.x=x;
		ret.y=y;

		ret.frame=0;
		
		return ret;
	}

	
}
