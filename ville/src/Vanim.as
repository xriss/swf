/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vanim
{
	var up;
	
	var mc;

	var pages;
	var page_base;
	
	var type;
	
	var x_siz;
	var y_siz;
	var imgurl;
	
	var x_off;
	var y_off;
	
	var x_min; // hit area
	var y_min;
	
	var x_max;
	var y_max;
	
	function Vanim(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}


	function setup(xml)
	{
	var m;
	var vt;
	
		mc=gfx.create_clip(up.mc,null);
		
		pages=[];
		page_base="base";

// hitarea is too big by default, set it to something smaller...
		up.mc.hitArea=gfx.create_clip(up.mc,0xffff);
		up.mc.hitArea._visible=false;
//		gfx.clear(up.mc.hitArea);
//		gfx.draw_box(up.mc.hitArea,0,-35,-50,50,50);
		x_min=-35;
		x_max=15;
		y_min=-50;
		y_max=0;
		gfx.clear(up.mc.hitArea);
		gfx.draw_box(up.mc.hitArea,0,x_min,y_min,x_max-x_min,y_max-y_min);
		
		type="";
		x_siz=100;
		y_siz=100;
		
		x_off=0;
		y_off=0;
		
		parse_xml(xml,0);
		
	}
	
	function clean()
	{
//		mc.removeMovieClip();
	}
	
	function parse_xml(e,d,flavour)
	{
	var ec;
	var children;
	var i;
	
		children=false;
		
		if(e.nodeType==1)
		{
//dbg.print(d+":"+e.nodeType+":"+e.nodeName);

			switch(e.nodeName)
			{
				case "anim":
					flavour="anim";
					children=true;
					type=e.attributes.type;
				break;
				
				case "xy":
					i=e.attributes.x_off; if(i) { x_off=Math.floor(i); }
					i=e.attributes.y_off; if(i) { y_off=Math.floor(i); }
					
					i=e.attributes.x_siz; if(i) { x_siz=Math.floor(i); }
					i=e.attributes.y_siz; if(i) { y_siz=Math.floor(i); }
					
					i=e.attributes.x_min; if(i) { x_min=Math.floor(i); }
					i=e.attributes.y_min; if(i) { y_min=Math.floor(i); }
					
					i=e.attributes.x_max; if(i) { x_max=Math.floor(i); }
					i=e.attributes.y_max; if(i) { y_max=Math.floor(i); }
				break;
				
				case "img":
					children=true;
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
				if(e.nodeName=="img")
				{
//dbg.print(d+":"+e.nodeType+":"+e.nodeName+" "+type);

					switch(type)
					{
						case "rot4x4":
							load_img_rot4x4(e.attributes.name,e.attributes.src);
						break;
						
						case "door4x1":
							load_img_door4x1(e.attributes.name,e.attributes.src);
						break;
						
						case "static":
							load_img_static(e.attributes.name,e.attributes.src);
						break;
					}
				}
				else
				if(e.nodeName=="anim")
				{
					gfx.clear(up.mc.hitArea);
					gfx.draw_box(up.mc.hitArea,0,x_min,y_min,x_max-x_min,y_max-y_min);
				}
			}
		}
		
	}	
	
	function load_img_static(name,url)
	{
	var c,aa,i;
	
		if(!name) { name="base"; }
		
//dbg.print(name+" : "+x_siz+" : "+y_siz);

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
		
		_root.bmc.remember( "anim_"+url , c , //this is safe as it only works once
		{
			url:url ,
			bmpw:x_siz , bmph:y_siz , bmpt:true ,
			hx:x_off , hy:y_off 
		} );
		
		aa=name.split(",");
		for(i=0;i<aa.length;i++)
		{
			pages[ aa[i] ]="anim_"+url;
		}
	}
	
	function load_img_rot4x4(name,url)
	{
	var c,aa,i;
		
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
		
		if(!_root.bmc.isloaded("anim_"+url+"_"+0+"_"+0)) // only set up the bitmaps once
		{
			_root.bmc.remember( "anim_"+url , c , //this is safe as it only works once
			{
				url:url ,
				bmpw:400 , bmph:400 , bmpt:true ,
				hx:0 , hy:0 ,
				onload:delegate(loaded_img_rot4x4,url)
			} );
		}
		
		aa=name.split(",");
		for(i=0;i<aa.length;i++)
		{
			pages[ aa[i] ]="anim_"+url;
		}
		
		mc._x=x_off;
		mc._y=y_off;
	}

	function loaded_img_rot4x4(it,url)
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

//
// Door loader, 4 main rotations 
//
	function load_img_door4x1(name,url)
	{
	var c,aa,i;
		
//dbg.print("loadingimg "+url);

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
		
		if(!_root.bmc.isloaded("anim_"+url+"_"+0+"_"+0)) // only set up the bitmaps once
		{
			_root.bmc.remember( "anim_"+url , c , //this is safe as it only works once
			{
				url:url ,
				bmpw:500 , bmph:125 , bmpt:true ,
				hx:0 , hy:0 ,
				onload:delegate(loaded_img_door4x1,url)
			} );
		}
		
		aa=name.split(",");
		for(i=0;i<aa.length;i++)
		{
			pages[ aa[i] ]="anim_"+url;
		}
		
		mc._x=x_off;
		mc._y=y_off;
	}

	function loaded_img_door4x1(it,url)
	{
	var x;
	var y;
	
//dbg.print("loadedimg "+url);

		for(y=0;y<1;y++)
		{
			for(x=0;x<4;x++)
			{
				_root.bmc.bmp_chop( "anim_"+url , "anim_"+url+"_"+y+"_"+x , x*125,y*125 , 125,125 );
			}
		}
		
		_root.bmc.forget( "anim_"+url);
	}
	
	
	
//
// Display a given page name and number
//	
	var old_pick;
	
	function pick(page,x,y)
	{
	var new_pick;
	
//dbg.print(pages[page]);

		switch(type)
		{
			case "static":
				new_pick=pages[page];
				if(old_pick!=new_pick)
				{
					_root.bmc.create(mc,new_pick,1);
					old_pick=new_pick;
				}
			break;
			
			case "rot4x4":
				new_pick=pages[page]+"_"+y+"_"+x;
				if(old_pick!=new_pick)
				{
					_root.bmc.create(mc,new_pick,1);
					old_pick=new_pick;
				}
			break;
			
			case "door4x1":
				new_pick=pages[page]+"_"+y+"_"+x;
				if(old_pick!=new_pick)
				{
					_root.bmc.create(mc,new_pick,1);
					old_pick=new_pick;
				}
			break;
		}
		
	}
	function pick_rot(rot)
	{
	var xx,yy,rr;
	
		rr=rot*16/360;
		rr=Math.round(rr)%16;
		if(rr<0) { rr+=16; }
		pick(page_base,rr%4,Math.floor(rr/4));
	}

	function pick_door(rot)
	{
		pick(page_base,Math.floor(rot/90)%4,0);
	}
	
	function update()
	{
		switch(type)
		{
			case "static":
				pick(page_base,0,0);
			break;
			
			case "rot4x4":
				pick_rot(up.ry);
			break;
			
			case "door4x1":
				pick_door(up.ry);
			break;
		}
	}
}