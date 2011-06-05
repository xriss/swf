/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;
import com.wetgenes.dbg;
import com.wetgenes.wetDNA;
import com.dynamicflash.utils.Delegate;

// A Moist Klondike

class WetDike_import
{
	var mc:MovieClip;
	
	var sc:ScrollOn;
	var sc_tab;
	var sc_idx;
	
	var ad_idx;
	var lv_wonderful;

	function delegate(f,d)	{	return Delegate.create(this,f,d);	}
	
	
	// --- Main Entry Point
	static function main()
	{
		System.security.allowDomain("*");
		
		if(!_root.wetdike_import)
		{
			_root.wetdike_import=new WetDike_import();
		}
	}

	function WetDike_import()
	{
		setup();
	}
	
	function setup()
	{
		ad_idx=[];
		
		if(_root.mc_popup)
		{
			mc=gfx.create_clip(_root.mc_popup,null);
		}
		else
		{
			mc=gfx.create_clip(_root,null);
		}
		
		mc.style={	fill:0xffffffff,	out:0xffffffff,	text:0xffffffff	};
		
//		gfx.draw_box(mc,100,100,100,100);
		
		Mouse.addListener(this);
		
		mc.onEnterFrame=delegate(update,0);
		
// ask for advert details from server

		lv_wonderful=new LoadVars();
		lv_wonderful.onLoad = delegate(lv_wonderful_post,lv_wonderful);
		lv_wonderful.sendAndLoad('http://wetdike.wetgenes.com/swf/wonderful.php?id=1258',lv_wonderful,"POST");
		lv_wonderful.waiting=30*10;

// set up a poker if we need one

		if(!_root.poker)
		{
			_root.poker=new Poker(false);
		}
		
// if we are loaded alone, display anyway

		if(!_root.wetdike)
		{
			Stage.scaleMode="noScale";
			Stage.align="TL";
			setup_adverts(mc);
		}
	}
	
	function lv_wonderful_post()
	{
		lv_wonderful.waiting=0;
		
		update_adverts();
	}
	
	
	function onMouseDown()
	{
	}

	function update()
	{
		if(!_root.wetdike) // standalone, resize
		{
		var siz;
		var x=800;
		var y=600;
		
			mc._rotation=0;
			
			siz=Stage.width/x;
			if(siz*y>Stage.height)
			{
				siz=Stage.height/y;
			}
			
			mc._x=Math.floor((Stage.width-siz*x)/2);
			mc._y=Math.floor((Stage.height-siz*y)/2);
			mc._xscale=siz*100;
			mc._yscale=siz*100;
		}
		
		if(lv_wonderful.waiting>0) { lv_wonderful.waiting--; return; } // wait for timeout or advert;
		
		if(!sc) return; // wait till we have a scroll wossname working
		
		if(sc.next==null) // put a new item in?
		{
			if(sc_idx<sc_tab.length) // only if we have any left, no looping
			{
				sc.next=sc_tab[sc_idx];
				sc_idx++;
			}
		}
	}
	
	function clean()
	{
	}
	
	
	function setup_adverts(_mc)
	{
	var i,t,s;
	
//use fonts from main swf

		sc=new ScrollOn({mc:_mc});
		sc.setup();
//		sc.mc.swapDepths(_mc);
		sc.mc._y=14+142+4;
		sc.w=800;
		
		sc.mc._alpha=50;
		
		sc_tab=[];
		
		if( Number(_root.wetdike.v.stamp_number) < 20070101 )
		{
			sc_tab[sc_tab.length]={url:"http://WetDike.WetGenes.com",txt:"This version of WetDike is obsolete, high scores may not register, please ask the webhost to update or click here for new version.",target:"_blank"};
		}

		var rnums=[1,2,3,4,5];
		var rnum;

		while(rnums.length>0)
		{
			rnum=random(rnums.length);
			
			switch(rnums[rnum])
			{
				case 1:
					ad_idx[0]=sc_tab.length;
					sc_tab[ ad_idx[0] ]={url:"http://www.projectwonderful.com/advertisehere.php?id=1258&type=1",txt:"Your advert here, click to find out how.",target:"_blank"};
				break;
				
				case 2:
					ad_idx["wet"]=sc_tab.length;
					sc_tab[ ad_idx["wet"] ]={url:"http://www.wetgenes.com",txt:"Visit www.WetGenes.com for more of everything.",target:"_blank"};
				break;

				case 3:
					ad_idx["4lfa"]=sc_tab.length;
					sc_tab[ ad_idx["4lfa"] ]={url:"http://4lfa.com",txt:"Visit 4lfa.com for comic pictures in a web environment.",target:"_blank"};
				break;
				
				case 4:
					ad_idx[1]=sc_tab.length;
					sc_tab[ ad_idx[1] ]={url:"http://www.projectwonderful.com/advertisehere.php?id=1258&type=1",txt:"Your advert here, click to find out how.",target:"_blank"};
				break;
				
				case 5:
					ad_idx["twg"]=sc_tab.length;
					sc_tab[ ad_idx["twg"] ]={url:"http://www.topwebgames.com/in.asp?id=4965",txt:"If you like this game then please consider voting for it by clicking here.",target:"_blank"};
				break;
			}
			
			rnums.splice(rnum,1);
		}
		
		sc_idx=0;
		
		update_adverts();
		
		return;
	}
	
	function update_adverts()
	{
	
		if( ( ( lv_wonderful.url0 != "" ) && ( lv_wonderful.txt0 != "" ) ) && (lv_wonderful.txt0!="undefined") )
		{
			if(ad_idx[0]!=undefined)
			{
				sc_tab[ad_idx[0]]={url:lv_wonderful.url0,txt:lv_wonderful.txt0,target:"_blank"};
			}
		}
		
		if( ( ( lv_wonderful.url1 != "" ) && ( lv_wonderful.txt1 != "" ) ) && (lv_wonderful.txt1!="undefined") )
		{
			if(ad_idx[1]!=undefined)
			{
				sc_tab[ad_idx[1]]={url:lv_wonderful.url1,txt:lv_wonderful.txt1,target:"_blank"};
			}
		}
		
		if( ( ( lv_wonderful.url_wet != "" ) && ( lv_wonderful.txt_wet != "" ) ) && (lv_wonderful.txt_wet!="undefined") )
		{
			if(ad_idx["wet"]!=undefined)
			{
				sc_tab[ad_idx["wet"]]={url:lv_wonderful.url_wet,txt:lv_wonderful.txt_wet,target:"_blank"};
			}
		}
		
		if( ( ( lv_wonderful.url_4lfa != "" ) && ( lv_wonderful.txt_4lfa != "" ) ) && (lv_wonderful.txt_4lfa!="undefined") )
		{
			if(ad_idx["4lfa"]!=undefined)
			{
				sc_tab[ad_idx["4lfa"]]={url:lv_wonderful.url_4lfa,txt:lv_wonderful.txt_4lfa,target:"_blank"};
			}
		}
		
	}
	
}


