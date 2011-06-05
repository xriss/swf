/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/


// Collection of talky thingies


class Minion
{
	var up;
	
	var mc;

	var page1;
	
	var pagex,pagey;
	
	var nam;

	var anim;	// name of animation
	
	var frame;	// frame to display, can be fractions or out of range it will wrap/pingpong
	
	var frame_fixed; // the actual integer frame to display

	var xml;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

		
	function Minion(_up)
	{
		up=_up;
	}
	
	function setup(_nam,hx,hy)
	{		
		mc=gfx.create_clip(up.mc,null);
		mc._x=-hx; // place rotation/handle point
		mc._y=-hy;
		
		mc.hx=-hx; // place rotation/handle point
		mc.hy=-hy;
		
		if(_nam)
		{
			setsoul(_nam);
		}
		
		display("idle",0);
		
	}
	
	function load_xml(url)
	{
		xml=new XML();
		xml.url=url;
		xml.onLoad=delegate(loaded_xml,xml);
		xmlcache.load(xml);
	}

	function loaded_xml(suc)
	{
	var vt;
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
	
	function parse_xml(e,d)
	{
	var ec;
	var children;
	
		children=false;
		
		if(e.nodeType==1)
		{
//dbg.print(d+":"+e.nodeType+":"+e.nodeName);

			switch(e.nodeName)
			{
				case "img":
					setsoul(e.attributes.src)
				break;

				default:
					children=true;
				break;
			}
			if( children )
			{
				for( ec=e.firstChild ; ec ; ec=ec.nextSibling )
				{
					parse_xml(ec,d+1);
				}
			}
		}
		
	}
	
	function loaded_img(it,nam)
	{
	var x;
	var y;
	
//dbg.print("loadedimg "+nam);

		for(y=0;y<6;y++)
		{
			for(x=0;x<8;x++)
			{
				_root.bmc.bmp_chop( "minion_"+nam , "minion_"+nam+"_"+y+"_"+x , x*100,y*100 , 100,100 );
			}
		}
		
		_root.bmc.forget( "minion_"+nam);
	}
	

	function setsoul(_nam)
	{
		nam=_nam;
		
		var mapnam=_root.urlmap.lookup(nam);
		
		if( mapnam || (nam.substring(0,5)!="http:")) // local swf
		{
			if(mapnam)
			{
				nam=mapnam;
			}
			
	
			if(_root.bmc.available)
			{
				if(!_root.bmc.checkloading("minion_"+nam)) // only set up the bitmaps once
				{
//dbg.print("Loading "+nam);
	
					_root.bmc.remember( "minion_"+nam , bmcache.create_img , //this is safe as it only works once
					{
						url:nam ,
						bmpw:800 , bmph:600 , bmpt:true ,
						hx:0 , hy:0 ,
						onload:delegate(loaded_img,nam)
					} );
				}
			}
			else
			{
				page1=gfx.add_clip(mc, nam ,1);
				page1.cacheAsBitmap=true;
				page1._visible=true;
			}
		}
		else
		{

			if(_root.bmc.available)
			{
				if(!_root.bmc.checkloading("minion_"+nam)) // only set up the bitmaps once
				{
//dbg.print("Loading "+nam);

					_root.bmc.remember( "minion_"+nam , bmcache.create_url , //this is safe as it only works once
					{
						url:nam ,
						bmpw:800 , bmph:600 , bmpt:true ,
						hx:0 , hy:0 ,
						onload:delegate(loaded_img,nam)
					} );
				}
			}
			else
			{
				page1=gfx.create_clip(mc, 1);
				page1.mc=gfx.create_clip(page1, 1);
				page1.mc.loadMovie(nam);
				page1.cacheAsBitmap=true;
				page1._visible=true;
			}
		}
	}
	
	function clean()
	{
		mc.removeMovieClip();
		mc=null;
	}
	
	
	function pick(page,x,y)
	{
		pagex=x;
		pagey=y;
		
		if(_root.bmc.available)
		{
			var idstr="minion_"+nam+"_"+y+"_"+x;
			if(!_root.bmc.getbmp(idstr)) // revert to me if not available
			{
				idstr="minion_"+"data_test_vtard_me_png"+"_"+y+"_"+x;
			}
			_root.bmc.create(mc,idstr,1);
		}
		else
		{
			page1._visible=false;
			
			page._visible=true;
			page.scrollRect=new flash.geom.Rectangle(x*100, y*100, 100, 100);
		}
	}
	var dance_frames=[ 0,4, 1,4, 1,5, 4,5, 6,4, 3,5 ];
	
	function breath(_frame) // make the idle frames more animated
	{
	var s;
		s=((frame%8)-4)/4;
		if(s<0) { s=-s; }
		mc._xscale=100+(4*s);
		mc._yscale=104-(4*s);
		mc._x=mc.hx*mc._xscale/100;
		mc._y=mc.hy*mc._yscale/100;
	}
	
	function display(_anim,_frame)
	{
		anim=_anim;
		frame=_frame;
		frame_fixed=Math.floor(frame);
		
		switch(anim)
		{
			default:
			case "idle":
				frame_fixed=frame_fixed%6; if(frame_fixed>3) { frame_fixed=6-frame_fixed; }
				pick(page1,frame_fixed,3);
			break;
			
			case "left":
				frame_fixed=frame_fixed%8;
				pick(page1,frame_fixed,1);
			break;
			
			case "right":
				frame_fixed=frame_fixed%8;
				pick(page1,frame_fixed,0);
			break;
			
			case "out":
				frame_fixed=(frame_fixed%4);
				pick(page1,frame_fixed,2);
			break;
			case "in":
				frame_fixed=4+(frame_fixed%4);
				pick(page1,frame_fixed,2);
			break;
			
			case "splat":			pick(page1,4,3);					break;
			case "idle_right":		pick(page1,5,3);breath(_frame);		break;
			case "idle_back":		pick(page1,6,3);breath(_frame);		break;
			case "idle_left":		pick(page1,7,3);breath(_frame);		break;

			case "teapot":			pick(page1,0,4);breath(_frame);		break;
			case "angry":			pick(page1,1,4);breath(_frame);		break;
			case "confused":		pick(page1,2,4);breath(_frame);		break;
			case "determind":		pick(page1,3,4);breath(_frame);		break;
			case "devious":			pick(page1,4,4);breath(_frame);		break;
			case "embarrassed":		pick(page1,5,4);breath(_frame);		break;
			case "energetic":		pick(page1,6,4);breath(_frame);		break;
			case "excited":			pick(page1,7,4);breath(_frame);		break;
			
// i seem to have replaced happy with the finger
			case "happy":			pick(page1,7,4);breath(_frame);		break;
			
			case "bird":			pick(page1,0,5);breath(_frame);		break;
			case "indescribable":	pick(page1,1,5);breath(_frame);		break;
			case "nerdy":			pick(page1,2,5);breath(_frame);		break;
			case "sad":				pick(page1,3,5);breath(_frame);		break;
			case "scared":			pick(page1,4,5);breath(_frame);		break;
			case "sleepy":			pick(page1,5,5);breath(_frame);		break;
			case "thoughtful":		pick(page1,6,5);breath(_frame);		break;
			case "working":			pick(page1,7,5);breath(_frame);		break;
			
			case "dance":
				frame_fixed=frame_fixed%6;
				pick(page1, dance_frames[ frame_fixed*2+0 ] , dance_frames[ frame_fixed*2+1] );
				breath(_frame);
			break;
		}
		
	}
	
	function update()
	{
	
	}
	
}
