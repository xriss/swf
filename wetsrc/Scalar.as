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

#GFX=GFX or "gfx"
#CLASSNAME = CLASSNAME or "Scalar"
class #(CLASSNAME)
{
	var mc;
	
	var bx,by;
	
	var ox,oy;	// wanted viewsize / work area
	var vx,vy;	// actual viewsize / work area
	var fake;
	var chatshrink;
	
	var dx,dy;	// x,y pos
	var sx,sy;	// x,y siz
	var rot;	// rotation
	
	var scale;	// for non full stretch, use -= (_+) keys to shrink or enlarge by 10%
//	var pixel; // flag pixel mode
		
	var bmap;
	
	var tf_stats;
	
	var t_old;
	var t_new;
	var t_ms;
	var t_samples;
	var t_fps;
	
	var need_chat_pop;
	
//	var playj;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	
	function #(CLASSNAME)(_ox,_oy,_fake,_chatshrink)
	{
//		playj=new PlayJPEG(this);
		
		fake=_fake;
		chatshrink=_chatshrink;
		
		ox=_ox;
		oy=_oy;
		
		
		mc=#(GFX).create_clip(_root,null);
		mc.onEnterFrame=delegate(update);
		
		tf_stats=#(GFX).create_text_html(mc,null,0,0,ox,32);
//		#(GFX).dropshadow(tf_stats,2, 45, 0x000000, 1, 4, 4, 2, 3);
//	    tf_stats.filters = [ new flash.filters.DropShadowFilter(2, 45, 0x000000, 1, 4, 4, 2, 3) ];
		
		
		scale=1;
//		pixel=false;
		
		if(scale>_root.maxs)
		{
			scale=_root.maxs;
		}
		
		update();
		
		Key.addListener(this);
		
// init frame timer
		t_old=getTimer();
		t_new=t_old;
		t_ms=0;
		t_samples=0;
		
		if(fake)
		{			
			dx=0;
			dy=0;
			sx=ox;
			sy=oy;
			rot=0;
			
			ox=bx;
			oy=by;
			
			return;
		}
	}
	
	function update()
	{
/*
		if(Key.isDown(123)) // screenshot on f12
		{
			playj.setup();
		}
*/

		if(fake)
		{
			return;
		}
		
		var siz;
		
		Stage.scaleMode="noScale";
		Stage.align="TL";

		rot=0;
		
		if(_root.scale=="fixed")
		{
			siz=1;
		}
		else
		{
			siz=Stage.width/ox;

			if(_root.maxw)	// 
			{
				if(siz*ox>_root.maxw)
				{
					siz=_root.maxw/ox;
				}
			}
			
			if(_root.maxh)
			{
				if(siz*oy>_root.maxh)
				{
					siz=_root.maxh/oy;
				}
			}

			if(siz*oy>Stage.height)
			{
				siz=Stage.height/oy;
			}
		}
		
// simple key controlled shrinking

//		if(!pixel)
		{
			siz*=scale;
		}

		dx=Math.floor((Stage.width-siz*ox)/2);
		dy=Math.floor((Stage.height-siz*oy)/2);
		
		need_chat_pop=false;
		if(dx<0) { dx=0; need_chat_pop=true; }
		if(dy<0) { dy=0; }
		
		vx=Math.floor(ox*siz);
		vy=Math.floor(oy*siz);
		sx=siz*100;
		sy=siz*100;
		
			t_samples++;			
			if(t_samples>=20)
			{
				t_old=t_new;
				t_new=getTimer();
				t_ms=(t_new-t_old)/t_samples;
				t_fps=Math.floor(1000/t_ms);
				
				
				if( (dx>=16) || (dy>=16) ) // display debug
				{
				var s;
					s=" "+Math.floor(t_ms)+"ms : "+ Math.floor(1000/t_ms) +"fps"+" : "+Math.floor(_root.code_time/t_samples)+"ms";
					#(GFX).set_text_html(tf_stats,13,0xffffff,s)
				}
				
				t_samples=0;
				_root.code_time=0;
			}
				
		if( (dx>=16) || (dy>=16) ) // display debug
		{
			tf_stats._visible=true;
		}
		else
		{
			tf_stats._visible=false;
		}
		
		
	}
	
	function apply(tomc,half)
	{
		if(_root.scale=="no")
		{
			tomc._rotation=rot;			
			tomc._x=0;
			tomc._y=0;
			tomc._xscale=100;
			tomc._yscale=100;
			
//			tomc._visible=true;
//			bmmc._visible=false;
			
			return;
		}
		
/*
		if(bmmc && pixel && (scale<1) ) // s goes way too slow to be used :/
		{
		var bx,by;
		var m;
		
			m=new flash.geom.Matrix();
			m.scale(scale,scale)
		
			bx=Math.floor(ox*scale);
			by=Math.floor(oy*scale);

			if( (!bmmc._pixelmc) || (bx!=bmap.width) || (by!=bmap.height) )	// set up the pixeld view
			{
				if(bmap) { bmap.dispose(); bmap=null; }
				if(bmmc._pixelmc) { bmmc._pixelmc.removeMovieClip(); bmmc._pixelmc=null; }
				
				bmap = new flash.display.BitmapData(bx,by, false, 0x000000);

				bmmc._pixelmc=#(GFX).create_clip(bmmc,null);
				bmmc._pixelmc.attachBitmap(bmap,1);
			}
			
			tomc._visible=false;
			bmmc._visible=true;
			
			tomc._rotation=rot;
			tomc._x=dx;
			tomc._y=dy;
			tomc._xscale=sx;
			tomc._yscale=sy;
			
			bmmc._rotation=rot;
			bmmc._x=dx;
			bmmc._y=dy;
			bmmc._xscale=sx/scale;
			bmmc._yscale=sy/scale;
			
			bmap.draw(tomc,m);
		}
		else
*/
		if(half)
		{
			tomc._rotation=rot;			
			tomc._x=Math.floor(dx/2);
			tomc._y=Math.floor( (dy/2) + (Stage.height/4) );
			tomc._xscale=Math.floor(sx/2);
			tomc._yscale=Math.floor(sy/2);
		}
		else
		{
			tomc._rotation=rot;			
			tomc._x=dx;
			tomc._y=dy;
			tomc._xscale=sx;
			tomc._yscale=sy;
			
//			tomc._visible=true;
//			bmmc._visible=false;
		}
	}
	
	function onKeyDown()
	{
	}
	
	function onKeyUp()
	{
	var k;
	var c;
	
		c=Key.getCode();
		k=String.fromCharCode(Key.getAscii());
		
//		dbg.print(k);
		
/*
		if( ( k == "p" ) || ( k == "P" ) )
		{
			pixel=!pixel;
		}
		else
*/
		if(Selection.getCaretIndex()==-1) // only work when not in a text box
		{
			if( ( k == "+" ) || (  k == "=" ) )
			{
				scale*=1.1;
				if(scale>1) { scale=1; }
			}
			else
			if( ( k == "_" ) || (  k == "-" ) )
			{
				scale/=1.1;
				if(scale<0.1) { scale=0.1; }
			}
/*
			else
			if( c==27 ) //esc?
			{
				if(scale<1) { scale=1; }
				else { scale=0.1; }
			}
*/
		}
		
		if(scale>_root.maxs)
		{
			scale=_root.maxs;
		}
			
//		dbg.print(scale);
	}
	
//	function getviewrect()
//	{	
//		return new flash.geom.Rectangle(dx, dy, sx/100, sy/100);
//		return new flash.geom.Rectangle(0, 0, Stage.width, Stage.height);
//	}

}
