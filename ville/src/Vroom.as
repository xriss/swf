/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vroom
{
	var up;
	
	var mc;

	var bounds;
	var tards;
	var objs;
	var poker;
	
	var talky;
	
	var xml;
	
	var state;
	
	var loading;
	
	function Vroom(_up)
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


	function setup(url)
	{
	var m;
	var vt;
	
		state="loading";
	
		mc=gfx.create_clip(up.mc,null);
		_root.replay.reset();
		
		bounds=new Vbounds(this);
		bounds.setup();
		
		talky=new Talky( this ); //{ mc:gfx.create_clip(mc,null) , up:this } );
		talky.setup();
		
		poker=new Vpoker(bounds);
		poker.setup();
		
		tards=[];
		objs=[];
		
//dbg.print("room load "+url);
		loading="Loading XML";
		xml=new XML();
		xml.url=url;
		xml.onLoad=delegate(loaded_xml,xml);
		xmlcache.load(xml);
		
	}
	
	function clean()
	{
	var i;
		for(i=0;i<objs.length;i++)
		{
			objs[i].clean();
		}
		for(i=0;i<tards.length;i++)
		{
			tards[i].clean();
		}
		talky.clean();
		poker.clean();
		bounds.clean();
		mc.removeMovieClip();
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
/*
			
			var pat=add_vtard("http://data.wetgenes.com/game/s/ville/test/vtard/me.xml");
			
			add_vtard("http://data.wetgenes.com/game/s/ville/test/vtard/shi.xml");
			
			bounds.focus=add_vtard("http://data.wetgenes.com/game/s/ville/test/vtard/kriss.xml").mc;
			
			pat.brain=new Vbrain_bogtard(pat);
			pat.brain.setup();
			pat.tx=pat.px=300;
			pat.tz=pat.pz=300;
*/
//			bounds.focus=add_vtard("http://data.wetgenes.com/game/s/ville/test/vtard/kriss.xml").mc;
			
			state="ready";
		}
		else
		{
dbg.print("failed to load "+xml.url);
		}
	}
	
	function add_vtard(url,xmlopts)
	{
	var vt;
		vt=new Vtard(bounds);
		tards.push(vt);
		vt.setup("http://data.wetgenes.com/game/s/ville/test/vtard/me.png");
		vt.load_xml(url);
//		bounds.insert_mc(vt.mc,true);
		vt.talk=talky.create(vt.mc,0,-30);
		return vt;
	}
	
	function add_vobj(url,xmlopts)
	{
	var vo;
		vo=new Vobj(bounds);
		objs.push(vo);
		vo.setup(url,xmlopts);
		return vo;
	}
	
	function add_vtv(url,xmlopts)
	{
	var vo;
		vo=new Vtv(bounds);
		objs.push(vo);
		vo.setup(url,xmlopts);
		return vo;
	}
	
	function add_vclock(url,xmlopts)
	{
	var vo;
		vo=new Vclock(bounds);
		objs.push(vo);
		vo.setup(url,xmlopts);
		return vo;
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
				case "back":
//dbg.print(d+":"+e.nodeType+":"+e.nodeName+":"+e.attributes.src);
					bounds.loadback(e.attributes.src);
				break;

				case "vobj": // these are now controled server side
//					add_vobj(null,e);
				break;

				case "vtv":
					add_vtv(null,e);
				break;
				
				case "vclock":
					add_vclock(null,e);
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
	

	var tick_time=0;
	function update()
	{
	var i;
	
		tick_time=tick_time+1;
	
		_root.bmc.check_loading();
	
		_root.replay.apply_keys_to_prekey();		
		_root.replay.update();
		
		for(i=0;i<objs.length;i++)
		{
			objs[i].update();
			
/*
			if( objs[i].nodes["1"].y )
			{
				dbg.print( i + " : " + objs[i].nodes["1"].y );
			}
			else
			{
				dbg.print( i );
			}
*/
		}
		
		for(i=0;i<tards.length;i++)
		{
			tards[i].update();
		}
		
		bounds.update();
		
		talky.update();		
		poker.update();
		
//		dbg.print("plops");
		
	}
}