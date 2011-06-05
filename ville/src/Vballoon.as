/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class Vballoon
{
	var up;
	
	var type_name="vballoon";
	
	var pages;
	var page_base;
	var points;
	var points_old;
	
	var mc;
	var dx,dy,dz; // draw position
	var sx,sy,sz;
	
	var style;
	
	var loading;	
	
	var owner; // our vtard , or pot
	
	var node; // the node in the pot if we have one
	
	var vcobj; // the controlling comms object, if it has one?
	
	var string_len=75;
	
	var state;
	
	var room;
	function Vballoon(_up)
	{
		up=_up;
		room=up.room;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function setup(nam)
	{
		state=null;
		
		dx=0;
		dy=0;
		dz=0;
		sx=0;
		sy=0;
		sz=0;
	
		set_random_points();
		pages=[];
		page_base="base";
		
		mc=gfx.create_clip(up.mc,null);
		mc.cc=this;
		up.insert_mc(mc,false);
		
		mc.tf=gfx.create_text_html(mc,2,-100,-120,200,30);
		mc.tf._visible=false;
		
		mc._xscale=40;
		mc._yscale=40;
		
		load_img_4x4("abc","http://data.wetgenes.com/game/s/ville/test/balloon/ballwrite.png");
		load_img_4x4("xyz","http://data.wetgenes.com/game/s/ville/test/balloon/ballwrite1.png");
		
		load_img_4x4("ball","http://data.wetgenes.com/game/s/ville/test/balloon/ball.png");
		load_img_4x4("items1","http://data.wetgenes.com/game/s/ville/test/balloon/items1.png");
		load_img_4x4("items2","http://data.wetgenes.com/game/s/ville/test/balloon/items2.png");
		load_img_4x4("godloons","http://data.wetgenes.com/game/s/ville/test/balloon/godloons.png");
		load_img_4x4("zeegrind","http://data.wetgenes.com/game/s/ville/test/balloon/zeegrind.png");
		
		style=null;
		
		set_style(null);
		
		update();
	}
	
	function set_random_points()
	{
		var x,y,z;
		x=(up.rnd()-32767)*16/32768;
		y=(up.rnd()-32767)*16/32768;
		z=(up.rnd()-32767)*16/32768;
		points=[0,0,0,x,y,z,x,y,z];
		points_old=[0,0,0,x,y,z,x,y,z];
	}
	
	function clean()
	{
		mc.cc=null;
		mc.removeMovieClip();
	}
	
	function load_img_4x4(name,url)
	{
	var c,aa,i;
		
//dbg.print("loadimg "+url);

		if(!name) { name="base"; }
		
	var imgnam=_root.urlmap.lookup(url);
		if( imgnam ) // local swf
		{
			url=imgnam;
			c=bmcache.create_img;
		}
		else
		{
			c=bmcache.create_url;
		}
		
		if(!_root.bmc.checkloading("anim_"+url)) // only set up the bitmaps once
		{
			_root.bmc.remember( "anim_"+url , c , //this is safe as it only works once
			{
				url:url ,
				bmpw:400 , bmph:400 , bmpt:true ,
				hx:0 , hy:0 ,
				onload:delegate(loaded_img_4x4,url)
			} );
		}
		
		aa=name.split(",");
		for(i=0;i<aa.length;i++)
		{
			pages[ aa[i] ]="anim_"+url;
		}
		
	}

	function loaded_img_4x4(it,url)
	{
	var x;
	var y;
	
//dbg.print("loadedimg "+url);

		for(y=0;y<4;y++)
		{
			for(x=0;x<4;x++)
			{
				_root.bmc.bmp_chop( "anim_"+url , "anim_"+url+"_"+y+"_"+x , x*100,y*100 , 100,100 );
			}
		}
		
		_root.bmc.forget( "anim_"+url);
	}

	var pick_x=0;
	var pick_y=0;
	function pick(page,x,y)
	{
		pick_x=x;
		pick_y=y;
		_root.bmc.create(mc,pages[page]+"_"+y+"_"+x,1,-50,-90);
	}
	
	
//
// Vcobj props ave changeds, update the vobj with new settings
//
	function update_vcobj(props)
	{
		if(!props) { props=vcobj.props; } // if no changes passed in use main props
	}
	
	
// define pos_balloon as an x,y array
#include "art/pos/balloon.as"
	
	function set_title(s)
	{
		if(s!="")
		{
			gfx.set_text_html(mc.tf,20,0xffffff,"<p align=\"center\">"+s+"</p>");
		
			mc.tf._visible=true;
		}
		else
		{
			mc.tf._visible=false;
		}
	}
	
	function set_style(name,id,size,string,title)
	{
	var idd;
	
		if( title )
		{
			set_title(title);
		}
		else
		{
			set_title("");
		}
	
		if( string ) // check optional string length
		{
			string_len=Math.floor(string);
		}
	
		if( (!name) || (name=="") || (name=="-") || (name=="0") )
		{
			style=null;
			mc._visible=false;
			owner.mc.clear();

			set_random_points();
			return;
		}
		
		if(name=="float") // the last balloon set should float off of screen
		{
			set_float(true);
			return;
		}
		
		set_float(false);
		
		if(name=="godloons")
		{
			mc._visible=true;
			
			idd=id%16;
			style="godloons";
			
			pick(style , idd%4 , Math.floor(idd/4) );
			
			mc._xscale=size;
			mc._yscale=size;
		}
		else
		if(name=="items1")
		{
			mc._visible=true;
			
			idd=id%16;
			style="items1";
			
			pick(style , idd%4 , Math.floor(idd/4) );
			
			mc._xscale=size;
			mc._yscale=size;
		}
		else
		if(name=="items2")
		{
			mc._visible=true;
			
			idd=id%16;
			style="items2";
			
			pick(style , idd%4 , Math.floor(idd/4) );
			
			mc._xscale=size;
			mc._yscale=size;
		}
		else
		if(name=="zeegrind")
		{
			mc._visible=true;
			
			idd=id%16;
			style="zeegrind";
			
			pick(style , idd%4 , Math.floor(idd/4) );
			
			mc._xscale=size;
			mc._yscale=size;
		}
		else
		if(name=="abc")
		{
			mc._visible=true;
			
			idd=id%26;
			
			if(idd>=16)
			{
				idd-=16;
				style="xyz";
			}
			else
			{
				style="abc";
			}
		
			pick(style , idd%4 , Math.floor(idd/4) );
			
			mc._xscale=size;
			mc._yscale=size;
		}
		else
		{
			mc._visible=true;
			
			idd=id%20;
			
			if(idd>=16)
			{
				idd-=16;
				style="items1";
			}
			else
			{
				style="ball";
			}
		
			pick(style , idd%4 , Math.floor(idd/4) );
			
			mc._xscale=size;
			mc._yscale=size;
		}
	}
	
	function set_bonk(dest)
	{
	var i;
	var xx=0;
	
		if(points[3]<dest.dx)
		{
			xx=20;
		}
		else
		{
			xx=-20;
		}
	
		points[3]=dest.dx + 0 ;
		points[4]=dest.dy - 80 ;
		points[5]=dest.dz;
		
		points[6]=dest.dx + xx ;
		points[7]=dest.dy - 80 ;
		points[8]=dest.dz;
		
		state="bonk";
		
		_root.wetplay.wetplayMP3.PlaySFX("sfx_beep1",0,undefined,1);
	}
	
	function set_float(b)
	{
		if(b)
		{
			state="float";
		}
		else
		{
			state=null;
		}
	}
	
	function jiggle(n) // 1==full jiggle 0==no jiggle
	{
	var i;
	var xx=0;
	var dest={}
	
		dest.dx=points[0];
		dest.dy=points[1];
		dest.dz=points[2];
		
		if( n!=0 )
		{
			dest.dx=points[3] - points[0];
			dest.dy=points[4] - points[1];
			dest.dz=points[5] - points[2];
			
			dest.dx*=n;
			dest.dy*=n;
			dest.dz*=n;
			
			dest.dx+=points[0];
			dest.dy+=points[1];
			dest.dz+=points[2];
		}
		
		
		points[3]=dest.dx;
		points[4]=dest.dy;
		points[5]=dest.dz;
		
		points[6]+=20;
	}
	
	function update()
	{
	var i;
	var tmp=[];
	var x,y,z,s;
	var len=string_len;			// string length
	var mul=0.5;		// string pull
	var con=1;			// continual velocity
	var upd=-0.04*mc._xscale;		// boyancy
	var vel=[];
	
		var p1={};
		var p2={};
		var targ;
		
		if(!style) { return; }
	
		if(style=="godloons")
		{
			if((pick_x==2) && ((up.rnd()&0xc000)!=0) ) // a god is doing a god thing
			{
				p1.x=0;
				p1.y=-40;
				p2.x=400;
				p2.y=0;
				
				mc.localToGlobal(p1);
				up.up.up.pixls.mc.globalToLocal(p1);
				
//				dbg.print(owner.victim_name);
				
				targ=up.up.up.comms.vcobjs[up.up.up.comms.names[owner.victim_name.toLowerCase()]];
				if( targ )
				{
					p2.x=0;
					p2.y=-60;
					targ.vobj.mc.localToGlobal(p2);
					up.up.up.pixls.mc.globalToLocal(p2);
				}
				
				up.up.up.pixls.add_line(
					0xff000000 | ( ((up.rnd()&0xff)|0x80) << (8*(up.rnd()%3)) ) | ( ((up.rnd()&0xff)|0x80) << (8*(up.rnd()%3)) ),
					20,
					p1.x,p1.y,
					p2.x,p2.y);
//					p2.x+((up.rnd()-32768)/1024),p2.y+((up.rnd()-32768)/1024));
			}
		}
		
		
		vel=[];
		vel[0]=points[0]-points_old[0];
		vel[1]=points[1]-points_old[1];
		vel[2]=points[2]-points_old[2];
		vel[3]=points[3]-points_old[3];
		vel[4]=points[4]-points_old[4];
		vel[5]=points[5]-points_old[5];
		vel[6]=points[6]-points_old[6];
		vel[7]=points[7]-points_old[7];
		vel[8]=points[8]-points_old[8];
		
		points_old=points;
		
		points=[];
			
		var idx;
			
		if(node) // in pot
		{
			p1.x=node.x+(node.z/4);
			p1.y=node.y-(node.z/4);
			
//		dbg.print(owner.type);			
//		dbg.print( p1.x + " " +p1.y );
		}
		else // held
		{
			idx = owner.minion.pagex*2 + owner.minion.pagey*2*8 ;
			p1.x=pos_balloon[idx+0];
			p1.y=pos_balloon[idx+1];
//		dbg.print( idx );
		}
		
		p2.x=0;
		p2.y=0;
		
		owner.mc.localToGlobal(p1);
		owner.mc.localToGlobal(p2);
		up.mc.globalToLocal(p1);
		up.mc.globalToLocal(p2);
		
		if(state=="float") // balloon is floating away
		{
			points[0]=points_old[0]+vel[0]*con*0.5;
			points[1]=points_old[1]+vel[1]*con*0.5-(upd*0.1);
			points[2]=points_old[2]+vel[2]*con*0.5;
		
//dbg.print( points[1] );
			
			if(points[1] < -600) // offscreen
			{
				state=null;
				style=null;
				mc._visible=false;
				owner.mc.clear();

				set_random_points();
				return;
			}
		}
		else
		{
			points[0]=owner.dx + (p1.x-p2.x) ;
			points[1]=owner.dy + (p1.y-p2.y) ;
			points[2]=owner.dz;
		}
		
//		dbg.print( points[0] + " " +points[1] );
		
		points[3]=points_old[3]+vel[3]*con*0.5;
		points[4]=points_old[4]+vel[4]*con*0.5-(upd*0.1);
		points[5]=points_old[5]+vel[5]*con*0.5;
		
		points[6]=points_old[6]+vel[6]*con;
		points[7]=points_old[7]+vel[7]*con+upd;
		points[8]=points_old[8]+vel[8]*con;
		
		if(state=="float") // balloon is floating away
		{
// point 0
			x=points[0]-points[3];
			y=points[1]-points[4];
			z=points[2]-points[5];
			
			s=Math.sqrt(x*x+y*y+z*z);
			if(s>len)
			{
				s=len/s;
				
				x=x+(x*s-x)*mul;
				y=y+(y*s-y)*mul;
				z=z+(z*s-z)*mul;
			}
			
			points[0]=points[3]+x;
			points[1]=points[4]+y;
			points[2]=points[5]+z;
		}
		
// point 1
		x=points[3]-points[0];
		y=points[4]-points[1];
		z=points[5]-points[2];
		
		s=Math.sqrt(x*x+y*y+z*z);
		if(s>len)
		{
			s=len/s;
			
			x=x+(x*s-x)*mul;
			y=y+(y*s-y)*mul;
			z=z+(z*s-z)*mul;
		}
		
		points[3]=points[0]+x;
		points[4]=points[1]+y;
		points[5]=points[2]+z;
	
// point 2
		x=points[6]-points[3];
		y=points[7]-points[4];
		z=points[8]-points[5];
		
		s=Math.sqrt(x*x+y*y+z*z);
		if(s>len)
		{
			s=len/s;
			
			x=x+(x*s-x)*mul;
			y=y+(y*s-y)*mul;
			z=z+(z*s-z)*mul;
		}
		
		var tx,ty,tz;
		
		tx=points[6]-x;
		ty=points[7]-y;
		tz=points[8]-z;

		points[6]=points[3]+x;
		points[7]=points[4]+y;
		points[8]=points[5]+z;
		
		points[3]=tx;
		points[4]=ty;
		points[5]=tz;
		
		if(state=="bonk")
		{
			for(i=3;i<9;i++)
			{
				points[i]=points_old[i];
			}
			state=null;
		}
		
		dx=points[3];//owner.dx;
		dy=points[4];//owner.dy-100;
		dz=points[5];//owner.dz;
		
		mc._x=up.x2+dx+(dz/4);
		mc._y=up.y2+dy-(dz/4);
		mc._z=dz;
			
		mc._rotation=Math.atan2(points[6]-points[3],points[4]-points[7])*(180/Math.PI);
		
		p2.x=mc._x;
		p2.y=mc._y;
		
// draw a string
		
		p1.x=up.x2+points[0]+(points[2]/4);
		p1.y=up.y2+points[1]-(points[2]/4);

			
		up.mc.localToGlobal(p1);
		up.mc.localToGlobal(p2);
		mc.globalToLocal(p1);
		mc.globalToLocal(p2);
		
		mc.clear();
		mc.lineStyle(3*mc._xscale/100,0xffffff,100);
		mc.moveTo(p1.x,p1.y);
		mc.lineTo(p2.x,p2.y);
		
		
//		dbg.print( mc._x + " " + mc._y );

		
	}	
}
