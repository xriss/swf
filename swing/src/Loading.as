/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.dynamicflash.utils.Delegate;


import com.wetgenes.gfx;

class Loading
{
	var up;
	
	var mc:MovieClip;
	var tf:TextField;

	var done:Boolean=false;
	
	var loaded_percent:Number=0;
	var frame:Number=0;
	var lyrics:Array=
[
"Loadin', loadin', loadin'",
"Rawcode!",
"Loadin', loadin', loadin'",
"Rawcode!",
"Though the pipes are swollen",
"Keep them bitties loadin'",
"Rawcode!",
"All the things I'm missin',",
"Good lookin, love, and clickin',",
"Are waiting at the end of my load",
"Move 'em on, head 'em up",
"Head 'em up, move 'em on",
"Move 'em on, head 'em up",
"Rawcode",
"Count 'em out, load 'em in,",
"Load 'em in, count 'em out,",
"Count 'em out, load 'em in",
"Rawcode!"];

	function delegate(f:Function)
	{
		return Delegate.create(this,f);
	}

	function Loading(_up)
	{
		up=_up;

		setup();
	}
	
	function setup()
	{
		done=false;

		mc=gfx.create_clip(up.mc,null);
		tf=gfx.create_text_html(mc,null,0,(600-200)/2,800,200);

		mc.onEnterFrame=delegate(update);
	}

	function update()
	{
	var s:String;

		_root.stop();
		
		frame++;
		loaded_percent= Math.floor(_root.getBytesLoaded()*100 / _root.getBytesTotal());
//		loaded_percent+=0.1;

		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"40\" color=\"#ffffff\">";
		s+="<p align=\"center\">";
		s+=lyrics[(Math.floor(frame/30))%lyrics.length];
		s+="</p>";
		s+="<p align=\"center\">";
		s+=Math.floor(loaded_percent)+'%';
		s+="</p>";
		s+="</font>";
		tf.htmlText=s;
		

		if(loaded_percent>=100)
		{
			clean();
		}
		
	}
	
	function clean()
	{
		mc.removeMovieClip(); mc=null;
		_root.gotoAndStop(2);
		done=true;
	}
}
