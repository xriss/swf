/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// lets handle some scores

class PlayAbout
{
	var up;
	
	var mcb;
	var mc;
	
	var mcs;
	var tfs;
	
	var done;
	var steady;
	

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function PlayAbout(_up)
	{
		up=_up;
	}
	
	function setbutt(m,n)
	{
		m.onRollOver=delegate(over,n);
		m.onRollOut=delegate(notover,n);
		m.onReleaseOutside=delegate(notover,n);
		m.onRelease=delegate(click,n);
	}
		
	function setup()
	{
	var i;
	var bounds;
	var mct;
	var s;
	
	
//		up.dikecomms.send_score_check();

//		show_ranks=false;
		
		_root.popup=this;
		
		mcs=new Array();
		tfs=new Array();
		
		mcb=gfx.create_clip(_root.mc_popup,null);
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
		mcb.cacheAsBitmap=true;
		
		
		gfx.dropshadow(mc,5, 45, 0x000000, 1, 20, 20, 2, 3);
//	    mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 20, 20, 2, 3) ];
		
//		mc.onRelease=delegate(onRelease,null);
		
		mc._y=0;
		
		mc.dx=0;
		mc._x=-800;
		
//		mc.onEnterFrame=delegate(update,null);

		done=false;
		steady=false;
		
		gfx.clear(mc);
		
		mc.style.out=0xff000000;
		mc.style.fill=0x80000000;
		gfx.draw_box(mc,0,100+16,0+16,600-32,600-32);
		
		tfs[0]=gfx.create_text_html(mc,null,150,50,500,500)
		
		s="";
		
		s+="<p align='center'><b>#(VERSION_NAME)</b> <font size='13'>#(VERSION_SITE)</font> v#(VERSION_NUMBER) <font size='13'>(c) #(VERSION_AUTH) #(VERSION_STAMP)<br>";
		
		s+="<a target='BOT' href='http://creativecommons.org/licenses/by-nd/2.5/'>Distributed under the CC Attribution-NoDerivs 2.5 Licence.</a>";

		s+="</font></p>";
		
		s+="<br>";
				
		s+="<p><a target='_blank' href='http://www.WetGenes.com'>Click here to visit <b>www.WetGenes.com</b> and play more free online games.</a></p>";
		
		
		tfs[0].multiline=true;
		tfs[0].wordWrap=true;
		tfs[0].html=true;
		tfs[0].selectable=false;
		
		gfx.set_text_html(tfs[0],22,0xffffff,s);


		
		
		mcs[0]=gfx.create_clip(mc,null,0,570-(220*800/640),100*800/640,100*800/640);
		setbutt(mcs[0],"wetcoma");

		mcs[2]=gfx.add_clip(mc,"auth_kriss",null,300,570-(220*800/640)-100,100,100);
		setbutt(mcs[2],"kriss");
		
		mcs[3]=gfx.add_clip(mc,"auth_shi",null,400,570-(220*800/640)-100,100,100);
		setbutt(mcs[3],"shi");

/*
		mcs[2]=gfx.create_clip(mc,null,(800-(468*800/640))/2,570-(60*800/640),100*800/640,100*800/640);
		mcs[2].onRollOver=delegate(over,"sitead");
		mcs[2].onRollOut=delegate(notover,"sitead");
		mcs[2].onReleaseOutside=delegate(notover,"sitead");
		mcs[2].onRelease=delegate(click,"sitead");
*/		
		_root.bmc.clear_loading();
		

		_root.bmc.remember( "wetcoma" , bmcache.create_url , 
		{
			url:"http://swf.wetgenes.com/wavys/wetcoma.png" ,
			bmpw:640 , bmph:220 , bmpt:false , 
			hx:0 , hy:0
		} );
		mcs[1]=null;
		
//		mcs[1]=gfx.add_clip(mcs[0],"comic",null);;
		
/*
		if(_root.wtf_import.sitead.img)
		{
			_root.bmc.remember( "sitead" , bmcache.create_url , 
			{
				url:_root.wtf_import.sitead.img ,
				bmpw:468 , bmph:60 , bmpt:false , 
				hx:0 , hy:0
			} );
//		mcs[3]=gfx.create_clip(mcs[2],null);;
//		mcs[3].loadMovie(_root.wtf_import.sitead.img);

		}
*/
//		mcs[3]=null;
		
		show_loaded();
		

/*		
		mc_topsub=gfx.create_clip(mc,null,100,100);
		tf_topsub=gfx.create_text_html(mc_topsub,null,0,0,600,75);
		mc_topsub.onRelease=delegate(click,"topsub");
*/
		
		thunk();
		
//		Mouse.addListener(this);
		
		update_do=delegate(update,null);
		MainStatic.update_add(_root.updates,update_do);
		_root.poker.clear_clicks();
	}
	
	var update_do;
	
	function clean()
	{
		if(_root.popup != this)
		{
			return;
		}
		
		MainStatic.update_remove(_root.updates,update_do);
		update_do=null;
		
		mcb.removeMovieClip();
		mc.removeMovieClip();
		_root.popup=null;
		
		Mouse.removeListener(this);
		
		_root.poker.clear_clicks();
	}

	
	function show_loaded()
	{
//dbg.print(mcs[1]);

		if(mcs[1]==null) // still need to load
		{
			if( _root.bmc.isloaded("wetcoma") ) //available
			{
				mcs[1]=_root.bmc.create( mcs[0] , "wetcoma" ,null ); // display
			}
		}

/*			
		if(mcs[3]==null) // still need to load
		{
			if( _root.bmc.isloaded("sitead") ) //available
			{
				mcs[3]=_root.bmc.create( mcs[2] , "sitead" ,null ); // display
			}
		}
*/
	}
	
	function thunk()
	{
	}
	
	
	function over(s)
	{
		switch(s)
		{
			case "wetcoma":
			_root.poker.ShowFloat(
"Read this whitarded comic and less of the same at <b>4lfa.com</b> : <font size='13'>Helping to make tomorrow seem more like yesterday.</font>"
			,25*10);
			break;
			
			case "kriss":
			_root.poker.ShowFloat(
"Kriss made teh top secret codes.<br>Click to see his site."
			,25*10);
			break;
			
			case "shi":
			_root.poker.ShowFloat(
"Shi hates you.<br>Click here to see why."
			,25*10);
			break;
			
/*
			case "sitead":
			_root.poker.ShowFloat(
_root.wtf_import.sitead.txt
			,25*10);
			break;
*/
		}
	}
	
	function notover(s)
	{
			_root.poker.ShowFloat(null,0);
	}
	
	function click(s)
	{
		switch(s)
		{
			case "wetcoma":
				getURL("http://4lfa.com","_blank");
			break;
			
			case "kriss":
				getURL("http://XIXs.com","_blank");
			break;
			
			case "shi":
				getURL("http://esyou.com","_blank");
			break;
			
/*
			case "sitead":
				if(_root.wtf_import.sitead.img)
				{
					getURL(_root.wtf_import.sitead.url,"_blank");
				}
			break;
*/
		}
	}
	
/*
	function onMouseUp()
	{
		if(_root.popup != this)
		{
			return;
		}

		if(steady)
		{
			done=true;
			mc.dx=_root.scalar.ox;
		}
	}
*/

	function update()
	{
	
		show_loaded();
		
		if((_root.popup == this)&&(_root.poker.anykey))
		{
			if(steady)
			{
				done=true;
				mc.dx=_root.scalar.ox;
			}
		}
		
		if( (_root.popup != this) || (_root.pause) )
		{
			return;
		}
		
		
		mc._x+=(mc.dx-mc._x)/4;

		if( (mc._x-mc.dx)*(mc._x-mc.dx) < (16*16) )
		{
			steady=true;
			if(done)
			{
				clean();
			}
		}
		else
		{
			steady=false;
		}
		
	}
		
	

}
