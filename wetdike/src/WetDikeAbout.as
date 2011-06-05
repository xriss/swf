/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// lets handle some scores

class WetDikeAbout
{
	var mc;
	var mcs;
	var tfs;
	
	var up; // WetDike
	
	
	var done;
	var steady;

	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	

// state to use, set before changing master state to this
	var state;



	function WetDikeAbout(_up)
	{
		up=_up;
		
	}
	

	function setup()
	{
	var i;
	var box;
	var mct;
	var fmt;
	
		up.dikecomms.send_score_check();
		
		_root.popup=this;
		
		mcs=new Array();
		tfs=new Array();
			
		mc=gfx.create_clip(_root.mc_popup,null);
		mc.cacheAsBitmap=true;
	    mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 20, 20, 2, 3) ];
		mc._y=0;
		
		mc.dx=0;
		mc._x=800;
				
		fmt=new TextFormat();
		fmt.font="Bitstream Vera Sans";
		fmt.size=24;
		fmt.color=0x00ffffff;
		fmt.bold=false;
		fmt.align="center";
		
		for(i=1;i<=2;i++)
		{
			mcs[i]=gfx.add_clip(mc,'aboutback',null);
			mcs[i].gotoAndStop(i+1);
			

			if( (i>=2) && (i<=2) )
			{
				box = mcs[i].getBounds(mc);
				
				mcs[i].removeMovieClip();
				mcs[i]=gfx.create_text_edit(mc,null,box.xMin,box.yMin,box.xMax-box.xMin,box.yMax-box.yMin);
				mcs[i].setNewTextFormat(fmt);
			}

		}
		thunk();
		
		mc.onEnterFrame=delegate(update,null);

		done=false;
		steady=false;



//		var i;
		var s;
		var tfi;
		var a:Array;
		
		
		mc.style=new Array();


		_root[_root.click_name]=delegate(click_str);
		
		Mouse.addListener(this);
	}
	
	function thunk()
	{
	var s;
	var t;
			
		s="";
		
		s+="<p align='center'><b>#(VERSION_NAME)</b> v#(VERSION_NUMBER) , <font size='14'>(c) Shi+Kriss Daniels #(VERSION_STAMP)<br>";
		
#if VERSION_SITE=='generic' then
		s+="<a target='BOT' href='http://creativecommons.org/licenses/by-nd/2.5/'>Distributed under the CC Attribution-NoDerivs 2.5 Licence.</a>";
#else
		s+="<a target='BOT' href='http://creativecommons.org/licenses/by-nd/2.5/'>Distributed under the CC Attribution-NoDerivs 2.5 Licence.</a>";
#end

		s+="</font></p>";
		
		s+="<br>";
		
		s+="<p>This version of <b>WetDike</b> is brought to you by the kindness of strange people.</p>";
		
//		s+="<br>";
		
		s+="<p align='left'><img src='kriss'><br><br><a target='BOT' href='http://XIXs.com'><b>Kriss</b></a> is responsible for code and some bad art."
		+"<a target='BOT' href=\"http://xixs.deviantart.com\"><b>   .  <img src=\"daicon\" id=\"daicon1\" width=\"1\" height=\"1\" hspace=\"0\" vspace=\"0\"></b></a>"
		+"<a target='BOT' href=\"http://xixs.livejournal.com\"><b>   .  <img src=\"ljicon\" id=\"ljicon1\" width=\"1\" height=\"1\" hspace=\"0\" vspace=\"0\"></b></a>"
		+"</p>";
		s+="<p align='left'><img src='shi'><br><br><a target='BOT' href='http://esyou.com'><b>Shi</b></a> is responsible for all the good art."
		+"<a target='BOT' href=\"http://turnheron.deviantart.com\"><b>  .   <img src=\"daicon\" id=\"daicon2\" width=\"1\" height=\"1\" hspace=\"0\" vspace=\"0\"></b></a>"
		+"<a target='BOT' href=\"http://turnheron.livejournal.com\"><b>   .  <img src=\"ljicon\" id=\"ljicon2\" width=\"1\" height=\"1\" hspace=\"0\" vspace=\"0\"></b></a>"
		+"</p>";
		

		s+="<br>";
		
		s+="<p><a target='BOT' href='http://WetDike.WetGenes.com'>Click here to visit <b>www.WetGenes.com</b> for more <b>WetDike</b> options and stats.</a></p>";
				
#if VERSION_SITE=='myphoto' then
		s+="<p><b>This pack of cards is generated from user supplied photos, click here to create your own.<b></p>";
#else
		s+="<p>One day we might even be able to offer you a real pack of cards exactly like the one featured in this game.</p>";
#end
		
		mcs[2].multiline=true;
		mcs[2].wordWrap=true;
		mcs[2].html=true;
		mcs[2].selectable=false;
		
		gfx.set_text_html(mcs[2],23,0xffffff,s);
		
		
		
		mcs[2].daicon1._xscale=100;
		mcs[2].daicon1._yscale=100;
		mcs[2].daicon1._x=355-5-60;
		mcs[2].daicon1._y-=28;
		
		mcs[2].ljicon1._xscale=100;
		mcs[2].ljicon1._yscale=100;
		mcs[2].ljicon1._x=mcs[2].daicon1._x+40;
		mcs[2].ljicon1._y-=28;
		
		mcs[2].daicon2._xscale=100;
		mcs[2].daicon2._yscale=100;
		mcs[2].daicon2._x=330-10-150;
		mcs[2].daicon2._y-=28;
		
		mcs[2].ljicon2._xscale=100;
		mcs[2].ljicon2._yscale=100;
		mcs[2].ljicon2._x=mcs[2].daicon2._x+40;
		mcs[2].ljicon2._y-=28;


	}
	
	
	function clean()
	{
		if(_root.popup != this)
		{
			return;
		}
		
		mc.removeMovieClip();
		
		_root.popup=null;
		
		Mouse.removeListener(this);
	}

	function onMouseUp()
	{		
		if(_root.popup != this)
		{
			return;
		}

		if(steady)
		{
			done=true;
			mc.dx=-800;
		}
	}

	function click_str(id:String)
	{
		var a:Array;
		
		a=id.split('_');
		
		trace(a);
		
		switch(a[0])
		{
			case "none":
			break;
		}
	}


	function update()
	{
	var t;
	
			
		if(_root.popup != this)
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
