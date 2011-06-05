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

#include "src/opts.as"
#GFX=GFX or "gfx"
#CLASSNAME = CLASSNAME or "ScrollOn"
class #(CLASSNAME)
{

	var mc;
//	var mct;	
	var tf;
//	var tf_shadow;
	
	var up; // WetDikePlay

	var show;	
	var next;
	
	var x;
	var w;
	var h;
	var tw;
	var fntsiz;
	var fntcol;
	
	var rot;
	
	var xp;

	function delegate(f)	{	return com.dynamicflash.utils.Delegate.create(this,f);	}

	function #(CLASSNAME)(_up,_rot)
	{
		up=_up;
		
		rot=0;
		if(typeof(_rot)=="number")
		{
			rot=_rot;
		}
	}

	function setup()
	{
		mc=#(GFX).create_clip(up.mc,null);
//		mct=#(GFX).create_clip(mc,null);
		
		#(GFX).dropshadow(mc,2, 45, 0x000000, 1, 4, 4, 2, 3);
	    mc.filters = [ new flash.filters.DropShadowFilter(2, 45, 0x000000, 1, 4, 4, 2, 3) ];

		tf=#(GFX).create_text_html(mc,null,0,0,4096,64);
		tf._rotation=rot;
		mc.cacheAsBitmap=true;


		show=null;
		next=null;
		
		x=0;
		w=800;
		h=32;
		fntsiz=24;
		fntcol=0xffffff;
		
		xp=-1;
		
//		mc.onEnterFrame=delegate(update)


		if(rot==-90)
		{
			#(GFX).setscroll(mc,0, 0, h, w);
		}
		else
		{
			#(GFX).setscroll(mc,0, 0, w, h);
		}
//		mc.scrollRect=new Rectangle(0, 0, w, h);
		mc._visible=false;
		
//		mc.cacheAsBitmap=true;

	}

	function clean()
	{
//		mct.removeMovieClip();
		mc.removeMovieClip();
	}
	

	var lastdown;
	
	function update()
	{

//		tf.textWidth;

		if(show!=null) // we are scrolling something
		{
			if(lastdown>0) { lastdown--; }
		
			x+=xp;
			
			if(x<-8-tw)
			{
				mc._visible=false;
				show=null;
			}
			else
			{
				mc._visible=true;
				if(rot==-90)
				{
					#(GFX).setscroll(mc,0, x-w, h, w);
				}
				else
				{
					#(GFX).setscroll(mc,-x, 0, w, h);
				}
//				mc.scrollRect=new Rectangle(-x, 0, w, h);
//				dbg.print(mct.scrollRect.toString() + " XXXXX " + x);
			}
			

			if((!_root.popup)&&(!_root.login)) // disable clicks while logon or popup
			{
				if(_root.poker.poke_down)
				{
					if( (mc._xmouse>=0) && (mc._xmouse<w) && (mc._ymouse>=0) && (mc._ymouse<h) )
					{
						lastdown=60;
					}
				}
				
				if(_root.poker.poke_up)
				{
					if(lastdown>0) //timelout on clicks
					{
						if( (mc._xmouse>=0) && (mc._xmouse<w) && (mc._ymouse>=0) && (mc._ymouse<h) )
						{
							if(mc._visible)
							{
								if(show.url)
								{
									if(show.target)
									{
										getURL(show.url,show.target);
									}
									else
									{
										getURL(show.url);
									}
								}
							}
						}
					}
				}
			}

		}
		else
		{
			mc._visible=false;
			
			lastdown=0;
			
			if(next) // next text to display
			{
				show=next;
				next=null;
				
				
				#(GFX).set_text_html(tf,fntsiz,fntcol,show.txt);
				
				x=w;
				tw=tf.textWidth;
			}
		}

	}
	
}
