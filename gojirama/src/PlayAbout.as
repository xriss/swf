/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// lets handle some scores

class PlayAbout
{
	var up;
	
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
			
		mc=gfx.create_clip(_root.mc_popup,null);
		mc.cacheAsBitmap=true;
		gfx.dropshadow(mc,5, 45, 0x000000, 1, 20, 20, 2, 3);
//	    mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 20, 20, 2, 3) ];
		
//		mc.onRelease=delegate(onRelease,null);
		
		mc._y=0;
		
		mc.dx=0;
		mc._x=-800;
		
		mc.onEnterFrame=delegate(update,null);

		done=false;
		steady=false;
		
		gfx.clear(mc);
		
		mc.style.out=0xff000000;
		mc.style.fill=0x80000000;
		gfx.draw_box(mc,0,100+16,0+16,600-32,600-32);
		
		tfs[0]=gfx.create_text_html(mc,null,150,50,500,500)
		
		s="";
		
		s+="<p align='center'><b>#(VERSION_NAME)</b> v#(VERSION_NUMBER) , <font size='13'>(c) #(VERSION_AUTH) #(VERSION_STAMP)<br>";
		
		s+="<a target='BOT' href='http://creativecommons.org/licenses/by-nd/2.5/'>Distributed under the CC Attribution-NoDerivs 2.5 Licence.</a>";

		s+="</font></p>";
		
		s+="<br>";
				
		s+="<p><a target='BOT' href='http://#(VERSION_NAME).WetGenes.com'>Click here to visit <b>www.WetGenes.com</b> for more <b>#(VERSION_NAME)</b> options and stats.</a></p>";
		
		s+="<br>";
		
		s+="<p><a target='BOT' href='http://4lfa.com'>Or just read this whittarded comic and less of the same at <b>4lfa.com</b> : <font size='13'>Helping to make tomorrow seem more like yesterday.</font></a></p>";
		
		tfs[0].multiline=true;
		tfs[0].wordWrap=true;
		tfs[0].html=true;
		tfs[0].selectable=false;
		
		gfx.set_text_html(tfs[0],22,0xffffff,s);


		
//		mcs[0]=gfx.create_clip(mc,null,100+16,600-16-(220*(600-32)/640),100*(600-32)/640,100*(600-32)/640);
		mcs[0]=gfx.create_clip(mc,null,0,550-(220*800/640),100*800/640,100*800/640);
/*		
		mcs[1]=gfx.create_clip(mcs[0],null);
		mcs[1].loadMovie("http://www.wetgenes.com/wavys/wetcoma.php");		
		mcs[0].onRelease=delegate(click,"wetcoma");
*/
		mcs[1]=gfx.add_clip(mcs[0],"png_about",null);		
		mcs[0].onRelease=delegate(click,"wet4lfa");


/*		
		mc_topsub=gfx.create_clip(mc,null,100,100);
		tf_topsub=gfx.create_text_html(mc_topsub,null,0,0,600,75);
		mc_topsub.onRelease=delegate(click,"topsub");
*/
		
		thunk();
		
		Mouse.addListener(this);
	}
	
	function thunk()
	{
	}
	
	
	function click(s)
	{
	dbg.print(s);
		switch(s)
		{
			case "wet4lfa":
				getURL("http://4lfa.com/","BOT");
			break;
			
			case "wetcoma":
				getURL("http://www.drunkduck.com/WetComa","BOT");
			break;
			
			case "top":
//				statechange();
			break;
		}
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
			mc.dx=_root.scalar.ox;
		}
	}

	function update()
	{
	
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
