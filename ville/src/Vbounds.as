/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vbounds
{
	var up;
	
	var mc;

	var mcs; // all mcs here need a _z pos which is used to sort them for display

	var x2;
	var y2;
	var x2_min;
	var y2_min;
	var x2_max;
	var y2_max;
	
	var scale;
	
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
	
	var focus;
	
	var over;
	
	var back;

	var xml;
	
	var room;
	
	
	var dx,dy;
	
	function Vbounds(_up)
	{
		up=_up;
		room=up;
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

		mc=gfx.create_clip(up.mc,null);

		
		dx=0;
		dy=0;
		
//2d origin and bounds
		
		x2=10;
		y2=190;
		
		x2_min=0;
		y2_min=0-300;
		x2_max=920;
		y2_max=200;

// room view default zoom

		scale=100;
		
//3d origin	and bounds

		x3=0;
		y3=0;
		z3=0;
		
		x3_min=0;
		y3_min=-40*10;
		z3_min=0;
		
		x3_max=40*10;
		y3_max=0;
		z3_max=40*10;

		mc._x=0;
		mc._y=0;
		
		mcs=[];
		
		over=null;
		back=null;
		
	}
	
	function clean()
	{
		mc.removeMovieClip();
	}
	
	
	function mirror_bounce(vobj)
	{
		if( vobj.px < x3_min )
		{
			vobj.px = x3_min - ( vobj.px - x3_min ) ;
			if( vobj.tx < x3_min )
			{
				vobj.tx = x3_min - ( vobj.tx - x3_min ) ;
			}
		}
		
		if( vobj.px > x3_max )
		{
			vobj.px = x3_max - ( vobj.px - x3_max ) ;
			if( vobj.tx > x3_max )
			{
				vobj.tx = x3_max - ( vobj.tx - x3_max ) ;
			}
		}
		
		if( vobj.pz < z3_min )
		{
			vobj.pz = z3_min - ( vobj.pz - z3_min ) ;
			if( vobj.tz < z3_min )
			{
				vobj.tz = z3_min - ( vobj.tz - z3_min ) ;
			}
		}
		
		if( vobj.pz > z3_max )
		{
			vobj.pz = z3_max - ( vobj.pz - z3_max ) ;
			if( vobj.tz > z3_max )
			{
				vobj.tz = z3_max - ( vobj.tz - z3_max ) ;
			}
		}
	}
	
	
// insert a new mc into our list of active mcs
// remember _z is needed for sorting

	function insert_mc(m,clickable)
	{
//	dbg.print("insert "+m.cc.type_name );
	
		if(clickable)
		{
			m.onRollOver=delegate(mcs_over,m);
			m.onRollOut=delegate(mcs_out,m);
			m.onReleaseOutside=delegate(mcs_out,m);
			m.onRelease=delegate(mcs_press,m);
		}
		
		mcs.push(m);
	}
	
	function remove_mc(m)
	{
	var i;
	
//	dbg.print("remove "+m.cc.type_name );

		for(i=0;i<mcs.length;i++)
		{
			if(m==mcs[i])
			{
				mcs.splice(i,1);
				return;
			}
		}
	}
	
	function mcs_over(m)
	{
		over=m;
	}
	
	function mcs_out(m)
	{
		over=null;
	}
	
	function mcs_press(m)
	{
	}
	
	function loadback(url)
	{
		xml=new XML();
		xml.url=url;
		xml.onLoad=delegate(loaded_xml,xml);
		xmlcache.load(xml);
	}
	
	function loadbackimg(url)
	{
	var m;
	var nam;
	
		if(back)
		{
			remove_mc(back);
			back.removeMovieClip();
			back=null;
		}

		nam=_root.urlmap.lookup(url);
	
		if(nam) // local
		{
			m=gfx.add_clip(mc,nam,null);
		}
		else // external
		{
			m=gfx.create_clip(mc,null);
			m.mc=gfx.create_clip(m,null);
			m.mc.loadMovie(url);
		}
		
//		m._alpha=50;
		
		m.cacheAsBitmap=true;
		m.cc={dx:0,dy:0,dz:0xffff,sx:0,sy:0,sz:0,type_name:"back"} // place at back (all these items are sorted (slowly) by the _z draw pos)
		insert_mc(m,false);
		back=m;
	}

	function loaded_xml(suc)
	{
	var frm=suc;
	
		if(frm!="swf")
		{
			frm=frm?"url":"failed";
		}		
//dbg.print("loaded "+frm+" "+xml.url);

		if(suc) //loaded
		{
			parse_xml(xml,0);
		}
	}
	
	function parse_xml(e,d,flavour)
	{
	var ec;
	var children;
	
		children=false;
		
		if(e.nodeType==1)
		{
//dbg.print(d+":"+e.nodeType+":"+e.nodeName);

			switch(e.nodeName)
			{
				case "xy":		//2d origin and bounds
		
					x2=Math.floor(e.attributes.x_org);
					y2=Math.floor(e.attributes.y_org);
					
					x2_min=Math.floor(e.attributes.x_min);
					y2_min=Math.floor(e.attributes.y_min);
					
					x2_max=Math.floor(e.attributes.x_max);
					y2_max=Math.floor(e.attributes.y_max);
			
					if(e.attributes.scale) // optional room view scale
					{
						scale=Math.floor(e.attributes.scale);
					}
				break;
				
				case "area":
					children=true;
					flavour="e.attributes.name";
				break;
				
				
				case "xyz":		//3d origin	and bounds

					if(!flavour)
					{
						x3=Math.floor(e.attributes.x_org);
						y3=Math.floor(e.attributes.y_org);
						z3=Math.floor(e.attributes.z_org);
						
						x3_min=Math.floor(e.attributes.x_min);
						y3_min=Math.floor(e.attributes.y_min);
						z3_min=Math.floor(e.attributes.z_min);
						
						x3_max=Math.floor(e.attributes.x_max);
						y3_max=Math.floor(e.attributes.y_max);
						z3_max=Math.floor(e.attributes.z_max);
					}
					
				break;
				
				case "img":
					loadbackimg(e.attributes.src);
				break;

				default:
					children=true;
				break;
			}
			if( children )
			{
				for( ec=e.firstChild ; ec ; ec=ec.nextSibling )
				{
					parse_xml(ec,d+1,flavour);
				}
			}
		}
		
	}

	function sort_full()
	{
	var i;

		
		for(i=0;mcs[i];i++)
		{
			sort_inc();
			sort_dec();
		}
		
//		for(i=0;i<mcs.length;i++)
//		{
//			dbg.print(mcs[i].cc.type_name + " : " + mcs[i].getDepth() );
//		}
	}
	
	function sort_inc()
	{
	var i,t;
	var c0,c1;
	
		for(i=1;i<mcs.length;i++)
		{
			c0=mcs[i-1].cc;
			c1=mcs[i  ].cc;
			
			if(!c0) // item deleted
			{
				mcs.splice(i-1,1);
//				i=i-1; // try again
				continue;
			}
			if(!c1) // item deleted
			{
				mcs.splice(i,1);
//				i=i-1; // try again
				continue;
			}
			
			if( c1.dz+c1.sz+c1.dy+c1.sy < c0.dz+c0.dy+c0.sy ) // then swap
			{
				t=mcs[i-1]; mcs[i-1]=mcs[i]; mcs[i]=t;
			}
			else
			if( c0.dz+c0.sz+c0.dy+c0.sy < c1.dz+c1.dy+c1.sy ) // then already sorted
			{
			}
			else // on same z level
			{
				if( c1.dx+c1.sx > c0.dx+c0.sx )
				{
					t=mcs[i-1]; mcs[i-1]=mcs[i]; mcs[i]=t; // swap
				}
			}
						
			if( mcs[i].getDepth() > mcs[i-1].getDepth() )
			{
				mcs[i].swapDepths(mcs[i-1]);
			}
		}
		
	}
	
	

	function sort_dec()
	{
	var i,t;
	var c0,c1;
	
		for(i=mcs.length-1;i>0;i--)
		{
			c0=mcs[i-1].cc;
			c1=mcs[i  ].cc;
			
			if(!c0) // item deleted
			{
				mcs.splice(i-1,1);
				continue;
			}
			if(!c1) // item deleted
			{
				mcs.splice(i,1);
				continue;
			}
			
			if( c1.dz+c1.sz+c1.dy+c1.sy < c0.dz+c0.dy+c0.sy ) // then swap
			{
				t=mcs[i-1]; mcs[i-1]=mcs[i]; mcs[i]=t;
			}
			else
			if( c0.dz+c0.sz+c0.dy+c0.sy < c1.dz+c1.dy+c1.sy ) // then already sorted
			{
			}
			else // on same z level
			{
				if( c1.dx+c1.sx > c0.dx+c0.sx )
				{
					t=mcs[i-1]; mcs[i-1]=mcs[i]; mcs[i]=t; // swap
				}
			}
						
			if( mcs[i].getDepth() > mcs[i-1].getDepth() )
			{
				mcs[i].swapDepths(mcs[i-1]);
			}
		}
	}
	
	var tog=0;
	function update()
	{
		tog=((tog+1)&1);
		if(tog==0)	{ sort_inc(); }
		else		{ sort_dec(); }

		if(focus)
		{
		var x,y
		var s=scale/100;
		

// scroll while aiming at focus

			x=-focus._x*s+400;
			y=-focus._y*s+300;
			
			if(x>-x2_min*s) { x=-x2_min*s; }
			if(y>-y2_min*s) { y=-y2_min*s; }
			
			if(x<-x2_max*s+800) { x=-x2_max*s+800; }
			if(y<-y2_max*s+600) { y=-y2_max*s+600; }
			
			dx=dx+(x-dx)*0.125;
			dy=dy+(y-dy)*0.125;
			
			mc._xscale=scale;
			mc._yscale=scale;
			
// or center into screen if room is to small
			
			if( x2_max*s-x2_min*s < 800 ) dx=-x2_min*s+((800-(x2_max*s-x2_min*s))/2);
			if( y2_max*s-y2_min*s < 600 ) dy=-y2_min*s+((600-(y2_max*s-y2_min*s))/2);
			
			mc.scrollRect=new flash.geom.Rectangle(-dx, -dy, 800,600);
			
//			dbg.print(y2_max-y2_min);
		}
		
	}	
}