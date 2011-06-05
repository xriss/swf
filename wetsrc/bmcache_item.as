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


// a bitmap cache manager, build hard cached copies of scalled, resized, built from components etc etc bmps

class bmcache_item
{
	var up;
	
	var idstr;
	var callback;
	var cb_data;
	
	var bmp_mc;
	var bmp;
	
//	var waitforit;
	
	function delegate(f,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,i);	}

// setup basic info

	function bmcache_item(_up,_idstr,_callback,_cb_data)
	{
		up=_up;
		idstr=_idstr;
		callback=_callback;
		cb_data=_cb_data;
		
//		waitforit=10;
	}

// called when an mc is loaded, if bmp is null then build it in here (it should be null)

	function loaded_mc()
	{

		if(!bmp)
		{
		var bmpw,bmph,bmpt;
		
			{
				bmpw=cb_data["bmpw"]?cb_data["bmpw"]:100;
				bmph=cb_data["bmph"]?cb_data["bmph"]:100;
				bmpt=cb_data["bmpt"]?cb_data["bmpt"]:true;
			
				bmp=new flash.display.BitmapData(bmpw,bmph,bmpt,0x00000000);
				
				bmp.draw(bmp_mc.loadhere);

				if(bmp_mc.loadhere2) // merge in alpha
				{
					var bmp2=new flash.display.BitmapData(bmpw,bmph,bmpt,0x00000000); // alpha part
					bmp2.draw(bmp_mc.loadhere2);
					bmp.copyChannel(bmp2, new flash.geom.Rectangle(0,0, bmpw,bmph), new flash.geom.Point(0,0), 2, 8); // copy green to alpha
				}
				
				bmp_mc.removeMovieClip();
				bmp_mc=null;
			}
		}
		if(cb_data.onload)
		{
			cb_data.onload(this);
		}
	}

	function chop(from , px,py,sx,sy)
	{
	var bmpt;
		
		cb_data=from.cb_data; // use from
		
		bmpt=cb_data["bmpt"]?cb_data["bmpt"]:true;
			
		bmp=new flash.display.BitmapData(sx,sy,bmpt,0x00000000);
		
		bmp.copyPixels(from.bmp , new flash.geom.Rectangle(px,py,sx,sy) , new flash.geom.Point(0,0) );
	}
	
// create an mc, return the cached bitmap, or build a new mc using the callback 

	function create(mc,idstr,depth)
	{
	var r;
	var hx,hy;
	var px,py,sx,sy,rot;
	
		if(bmp)
		{

			hx=cb_data["hx"]?cb_data["hx"]:0; // handle
			hy=cb_data["hy"]?cb_data["hy"]:0;
		
			px=cb_data["px"]?cb_data["px"]:0; // starting position,scale,rot
			py=cb_data["py"]?cb_data["py"]:0;
			sx=cb_data["sx"]?cb_data["sx"]:100;
			sy=cb_data["sy"]?cb_data["sy"]:100;
			rot=cb_data["rot"]?cb_data["rot"]:0;
		
			r=up.create(mc,null,depth);
			
			r.createEmptyMovieClip("loadhere",0);
			r.loadhere.attachBitmap(bmp,0,"auto",true);
			r.loadhere._x=hx;
			r.loadhere._y=hy;
			
			r._x=px;
			r._y=py;
			r._xscale=sx;
			r._yscale=sy;
			r._rotation=rot;
			
		}
		else
		{
			r=callback(mc,idstr,depth,cb_data,this);
		}
		
		return r;
	}
	
}
