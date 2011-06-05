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
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

//kill mochi ads
#(
VERSION_MOCHIADS=nil
#)

class Loading
{
	var mcb:MovieClip;
	var mc:MovieClip;
//	var mcscale:MovieClip;
	var tf2:TextField;
	var tf3;
	var tf4;
	
	var mcanim;
	var mcmochi;
//	var mcelmyr;
	
	var dna;
	
	var server;
	var my_server;
	
#include "../brandead/brandead.inc"

	var done:Boolean=false;
	
	var loaded_percent:Number=0;
	var frame:Number=0;

	var mcsplash;
	var splash;
	var splash_count;
	var splash_link;
	
	var mcintro;
	var intro;
	var intro_count;
	
	var showloading;

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	
	function Loading(_showloading)
	{
		showloading=_showloading;
		
#(
if not VERSION_MOCHIADS then
#)
				_root.wethidemochiads=true;
#(
end
#)
		
		setup();

	}
	
	var defuck;
	
	function setup()
	{
	var s;
	
		var orset_root=function(a,b)
		{
			if(_root[a]==undefined) { _root[a]=b; }
		}
		server="www";
		if
			(
				(_root._url.indexOf("http://www.wetgenes.local/") == 0)
				||
				(_root._url.indexOf("http://wetgenes.local/") == 0)
				||
				(_root._url.indexOf("http://swf.wetgenes.local/") == 0)
				||
				(_root._url.indexOf("http://www.host.local/") == 0)
				||
				(_root._url.indexOf("http://host.local/") == 0)
				||
				(_root._url.indexOf("http://www.local.host/") == 0)
				||
				(_root._url.indexOf("http://local.host/") == 0)
				||
				(_root._url.indexOf("file:") == 0)			
			)
		{
			server="local";
			orset_root("host","swf.wetgenes.local");
		}
		else
		{
			orset_root("host","swf.wetgenes.com");
		}
		
		
		defuck=_root._highquality;

		done=false;

		mcb=gfx.create_clip(_root.mc_popup,null);
//		mcb=gfx.create_clip(_root,null);
		if( _root.scalar.oy==600 ) // our size
		{
			mc=mcb;
		}
		else
		{
			mcb._xscale=Math.floor(100 * (_root.scalar.oy/600));
			mcb._yscale=Math.floor(100 * (_root.scalar.oy/600));
			mc=gfx.create_clip(mcb,null);
		}
//			mcb.cacheAsBitmap=true;
			
//			mcscale=gfx.create_clip(_root,null);
//			mc=gfx.create_clip(mcscale,null);
//			MainStatic.choose_and_apply_scalar(this);
//			MainStatic.apply_800x600_scale(mc);
//			mc.cacheAsBitmap=true;

		if(!showloading)
		{
			mc._visible=false;
		}
		
		
		gfx.clear(mc);
		mc.style.fill=0xff000000;
		gfx.draw_box(mc,0,0,0,800,600);

		mc.dna=gfx.create_clip(mc,null);
		mc.dna._y=100;
		mc.dna._xscale=100*800/256;
		mc.dna._yscale=mc.dna._xscale;
		
		dna=new wetDNA2(mc.dna,"dna",0,0x0000ff,256,128);
		
		mcanim=gfx.create_clip(mc,null);
		
		tf2=gfx.create_text_html(mcanim,null,25,25,750,200);
//		gfx.dropshadow(mcanim,2, 45, 0x000000, 1, 4, 4, 2, 3);

		tf3=gfx.create_text_html(mcanim,null,200,250,400,300);
		
		tf4=gfx.create_text_html(mcanim,null,25,450,750,200);


#VERSION_URL=VERSION_URL or "http://"..VERSION_NAME..".WetGenes.com/"
		
		s="";
		s+="<p align=\"center\">";
		s+="This game is creator owned by real people who have worked very hard to provide the best gaming experience they can.<br><br>";
		s+="You can always find the latest version at<br>#(VERSION_URL)";
		s+="</p>";
		
		gfx.set_text_html(tf2,23,0xffffff,s);
		
		
		s="";
		
#VERSION_AUTH=VERSION_AUTH or "Shi+Kriss Daniels"
		s+="<p align='center'>#(VERSION_NAME) #(VERSION_NUMBER) (c) #(VERSION_AUTH) #(VERSION_STAMP)</p>";

#if		VERSION_BUILD=='4lfa' or VERSION_BUILD=='debug' then
		s+="<p align='center'>Please do not redistribute.</p>";
		s+="<p align='center'>This is an 4lfa build and mostly broken.</p>";
#elseif	VERSION_BUILD=='cc' or VERSION_BUILD=='release' then
		s+="<p align='center'>Distributed under the CC Attribution-NoDerivs 2.5 Licence.</p>";
		s+="<p align='center'>http://creativecommons.org/licenses/by-nd/2.5/</p>";
#else
		s+="<p align='center'>Please do not redistribute.</p>";
		s+="<p align='center'>This is an 4lfa build and mostly broken.</p>";
#end
		gfx.set_text_html(tf4,16,0xffffff,s)
				
				
				
		mcmochi=gfx.create_clip(mc,null,(800-(600*800/640))/2,(600-(440*600/480))/2,100*800/640,100*600/480);
		
		mcmochi.click=gfx.create_clip(mcmochi,null);

		
		waitfordisplay=true;
		
		mcmochi.dispad=gfx.create_clip(mcmochi,null);
		
		
		
		mc.onEnterFrame=delegate(update,null);
		mc.onEnterFrame();


		

		
		my_server=false;
		
// myserver check, uhm, probably not used anywhere anymore
		if
			(
				(_root._url.indexOf("http://wetdike.wetgenes.com") == 0)
				||
				(_root._url.indexOf("http://www.wetgenes.com") == 0)
				||
				(_root._url.indexOf("http://wetgenes.com") == 0)
			)
		{
			my_server=true;
		}
		
		

// clear settings to default
// they will then be set in the following check, with simple domain checks

		_root.kidsafe=false;
		
		
#if VERSION_BUILD=="cc" or VERSION_BUILD=="release" then -- a CC release so force these things

		if(server!="local") // only local test can have this forced from vars
		{
//			_root.wethidemochiads=false; // disabled, just allow hosts to turn off ads, Since they now wish to take more than 10secs I want this option.
			_root.skip_wetimport=false;
			_root.skip_wetlogin=false;
			_root.skip_wetscore=false;
		}
#end		
		

// check hosting servers, ignoring one or zero subdomains and requiring a .com/ or .net/ tail, so www.checkthisbit.com/

		var urlp=_root._url.split("/");
		urlp=urlp[2].split(".");
		urlp[0]=urlp[0].toLowerCase();
		urlp[1]=urlp[1].toLowerCase();
		urlp[2]=urlp[2].toLowerCase();
		
//dbg.print(urlp[0]);
//dbg.print(urlp[1]);
//dbg.print(urlp[2]);


		var test="";

		if((!urlp[3])&&(urlp[2]))
		{
			test=urlp[1];
			
		}
		else
		if((!urlp[2])&&(urlp[1]))
		{
			test=urlp[0];
			
		}
		
//		test="addictinggames";
		
		
		_root.hosted_domain_test=test;
		
		switch(test)
		{
			case "auntlee":
				_root.kidsafe=true;
				_root.skip_wetimport=true; // do not do my import stuff
				_root.wethidemochiads=true;
			break;
			
			case "mindjolt":
				_root.skip_wetimport=true; // do not do my import stuff
				_root.skip_wetlogin=true; // do not do any of my login
				_root.skip_wetscore=true; // do not do any of my score display or send stuff
			break;
			
//			default:
/*
			case "ungrounded": // hosted on newgrounds
				splash="splash_ng"; // so show ng splash for the tards
				splash_link="http://www.newgrounds.com/";				
			break;
			
			case "armorgames":
				splash="splash_ag"; // so show ag splash for the tards
				splash_link="http://armorgames.com/";
			break;
			
			case "kongregate":
				splash="splash_kg"; // so show kg splash for the tards
				splash_link="http://www.kongregate.com/";
			break;
*/

#if VERSION_INTRO=="addicting" then

			case "addictinggames":
				_root.wethidemochiads=true;
//				_root.skip_wetlogin=true; // do not do any of my login
//				_root.skip_wetscore=true; // do not do any of my score display or send stuff
			break;
#end					
		}
		
#if VERSION_INTRO=="addicting" then

		intro="intro_addicting"; // so show addicting intro
		intro_count=0;
#end					
			
					
		if((!_root.wethidemochiads)&&(!_root.wethideloadingmochiads))
		{
			mochi=true;
		}
		
		if(brandead_link!="") // simple branding?
		{
			splash=brandead_image;
			splash_link=brandead_link;
		}

		if(splash)
		{
			mcsplash=gfx.create_clip(mc,null,400,300,220,220);
			
			mcsplash.splash=gfx.add_clip(mcsplash,splash,null,-300/2,-250/2);
			
			mcsplash.onRelease=delegate(splashclick);
			
			splash_count=0;
		}
		else
		if((!_root.wethidemochiads)&&(!_root.wethideloadingmochiads))
		{
			mochi_show();
		}
	}

	function splashclick()
	{
		if(splash_link)
		{
			getURL(splash_link,"_blank");
		}
	}
	
	function update()
	{
	var s:String;


		_root.stop();
		
//		_root.scalar.apply(mcb);

		
// dbg.print("update");

		if(splash)
		{
			if(splash_count==25*5)
			{
				splash_count++;
				
				mcsplash._visible=false;
				splash=null;
				
				if((!_root.wethidemochiads)&&(!_root.wethideloadingmochiads))
				{
					mochi_show();
				}
			}
			else
			if(splash_count>25*4.5)
			{
				splash_count++;
				
				mcsplash._xscale*=0.75;
				mcsplash._yscale*=0.75;
				mcsplash._alpha*=0.75;
			}
			else
			if(splash_count<25*5)
			{
				splash_count++;
			}
		}
		else
		{
			frame++;
		}
		
		loaded_percent= Math.floor(_root.getBytesLoaded()*100 / _root.getBytesTotal());
//		loaded_percent+=0.1; if(loaded_percent>100) { loaded_percent=100; }

				
		if((!_root.wethidemochiads)&&(!_root.wethideloadingmochiads))
		{
			mcmochi._visible=true;
			
		}
		else
		{
			mcmochi._visible=false;
		}
		
		gfx.set_text_html(tf3,100,0xffffff,"<p align=\"center\"><b>"+Math.floor(loaded_percent)+"%</b></p>");
		
		dna.tint=Math.floor(256*loaded_percent/100);

#if VERSION_INTRO=="addicting" then
		if(intro && (!mochi) ) // after mochi
		{
			if(loaded_percent>=100)
			{
				if(intro_count==0) // setup
				{
					intro_show();
				}
				
//dbg.dump(mcintro.intro.instance9);
//dbg.print(mcintro.intro.instance9.AG_COUNT);
//				if(mcintro.intro.instance9.AG_COUNT==4)
//				{
//					intro=null; // just flag end
//				}
				
				intro_count++;
				
				if(intro_count>25*3.5)
				{
					intro=null; // just flag end
//					intro_hide();
				}
			}
		}
#end
		
		if( (loaded_percent>=100) && (!splash) && (!intro) && (!mochi) )
		{
			clean();
		}
		
	}
	
	
	function clean()
	{
//dbg.print("loaded");

		delete dna;
		
		if(showloading)
		{
			
			_root.swish.clean();
//		_root.swish=(new Swish({style:"slide_left",mc:mc})).setup();
			_root.swish=(new Swish({style:"sqr_plode",mc:mc})).setup();
		}

			mc.removeMovieClip(); mc=null;
			mcb.removeMovieClip(); mcb=null;
		
		Stage.removeListener(this);
		
		_root.gotoAndStop(2);		
		done=true;
		
		_root._highquality=defuck;
	}
	
	
	var mochi=false;
	var waitfordisplay;
	
	function mochi_started()
	{
		mochi=true;
		waitfordisplay=false;		
	}

	function mochi_finished()
	{
		mochi=false;
	}

	function mochi_show()
	{
		MochiAd.showInterLevelAd(
			{
			id:"#(VERSION_MOCHIADS)",
			res:"600x440",
			clip:mcmochi.dispad,
			ad_started:delegate(mochi_started),
			ad_finished:delegate(mochi_finished)
			});
	}
	
	function intro_show()
	{
#if VERSION_INTRO=="addicting" then
		mcintro=gfx.create_clip(mc,null,0,0,150,150);
		
		mcintro.intro=gfx.add_clip(mcintro,intro,null,0,0);
		
		intro_count=0;
#end
	}
	
	function intro_hide()
	{
#if VERSION_INTRO=="addicting" then
		mcintro._visible=false;
		intro=null;
#end
	}
	
	
	function click(s)
	{
		switch(s)
		{
			case "text":
			break;
		}
	}
	
}
