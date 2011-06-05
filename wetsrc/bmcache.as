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

class bmcache
{
	var aa; // an array of bmc_items
	var aa_check;
	
	var aa_loading; // an array of movieclip loadint (loadhere) place holders

	var mc;
	
	var available;

	function delegate(f,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,i);	}

// setup basic info

	function bmcache()
	{
		aa=new Array();
		aa_check=new Array();
		aa_loading=new Array();

// crate an invisible mc for building bmps in
		mc=create(_root,null,null);
		mc._visible=false;
		
		available=flash.display.BitmapData?true:false; // running flash8+?
		
//		System.security.allowDomain("*");
		
	}

	function clear_loading()
	{
		check_loading(); // last chance to finish off
		
		aa_loading=new Array();
	}
	
	function check_loading() // check all items that should be loading, return 1 when complete
	{
	var i;
	var m;
	var t;
	var l;
	var tot;
	var lol;
	
		tot=0;
		lol=0;
		
		for(i=0;i<aa_loading.length;i++)
		{
			m=aa_loading[i];

			if(m.bmp_mc)
			{
				t=m.bmp_mc.loadhere.getBytesTotal();
				if(Math.floor(t)==0) { t=1024*16; }
				l=m.bmp_mc.loadhere.getBytesLoaded();

//dbg.print(l + " / " + t);

//dbg.print(m.bmp_mc.loadhere._width);
				
				if((l>=t)&&(m.bmp_mc.loadhere._width>0)) // this one is loaded, finish it off
				{
				
//dbg.print(m.idstr);
					m.loaded_mc();
				}
				else
				{
					tot+=t;
					lol+=l;
				}
			}
		}
		
		if(tot) return lol/tot; // amount done
		else return 1; 			// all done
	}
	
	function isloading(idstr)
	{
		if(aa[idstr]) { return true; }
		
		return false;
	}
	
	function checkloading(idstr)
	{
		if(aa[idstr]) { return true; }
		if(aa_check[idstr]) { return true; }
		
		return false;
	}
	
	
	function isloaded(idstr)
	{
	var t,l,m;
	
		m=aa[idstr];

		if(!m) { return 0; }
		
		if(m.bmp_mc)
		{
			l=m.bmp_mc.loadhere.getBytesLoaded();
			t=m.bmp_mc.loadhere.getBytesTotal();
			if(Math.floor(t)==0) { t=1024*16; }
			
//dbg.print(m.bmp_mc.loadhere._width);

			if((l>=t)&&(m.bmp_mc.loadhere._width>0)) // this one is loaded, finish it off
			{
//dbg.print("isloaded "+m.idstr);
				m.loaded_mc();
			}
		}
		return m.bmp?1:0;
	}
	
	function remember(idstr,callback,cb_data)
	{	
		if(aa[idstr]==null) // only create once
		{
			aa[idstr]=new bmcache_item(this,idstr,callback,cb_data);
			
			aa[idstr].bmp_mc=callback(mc,idstr,null,cb_data,aa[idstr]);
			
			if(!aa[idstr].bmp) // we may have already built it so it doesnt need to be in the list of loading imgs
			{
				aa_loading[aa_loading.length]=aa[idstr];
			}
		}
		else
		{
//			if(aa[idstr].bmp) // if its already loaded call the call back now
			{
				if(cb_data.onload)
				{
					cb_data.onload(aa[idstr]);
				}
			}
			//else this is bad???
		}
	}
	
	function forget(idstr)
	{	
		aa[idstr]=null;
		aa_check[idstr]=true;
	}

// get the bitmap associated with this id
	function getbmp(idstr)
	{	
		return aa[idstr].bmp;
	}

	// create a moviclip in hte given mc

	function create(_mc,idstr,depth,px,py,sx,sy,rot)
	{	
	var r;
		
	
		if(_mc.newdepth==undefined)	{	_mc.newdepth=0;	}
		if(depth==null)		{	depth=++_mc.newdepth;	}
		
		if((idstr==null)||(aa[idstr]==null))
		{
			r=_mc.createEmptyMovieClip("mc"+depth,depth);
			r.newdepth=0;
		}
		else
		{
			r=aa[idstr].create(_mc,idstr,depth);
		}
		r.newdepth=0;
		
		if(px!=null) { r._x=px; }
		if(py!=null) { r._y=py; }
		if(sx!=null) { r._xscale=sx; }
		if(sy!=null) { r._yscale=sy; }
		if(rot!=null) { r._rotation=rot; }

		return r;
	}


// generic callback work
	
	static function create_generic(mc,idstr,depth,cb_data,item)
	{
	var r;
	var px,py,sx,sy,rot;
	var hx,hy;
	
		r.idstr=idstr;
	
		hx=cb_data["hx"]?cb_data["hx"]:0; // handle
		hy=cb_data["hy"]?cb_data["hy"]:0;
		
		px=cb_data["px"]?cb_data["px"]:0; // starting position,scale,rot
		py=cb_data["py"]?cb_data["py"]:0;
		sx=cb_data["sx"]?cb_data["sx"]:100;
		sy=cb_data["sy"]?cb_data["sy"]:100;
		rot=cb_data["rot"]?cb_data["rot"]:0;
		
		r=item.up.create(mc,null,null,px,py,sx,sy,rot); // make empty mc
		
		r.createEmptyMovieClip("loadhere",0);
		r.loadhere._x=hx;
		r.loadhere._y=hy;
		
		return r;
	}
	
// just create an empty bitmap

	static function create_null(mc,idstr,depth,cb_data,item)
	{
	var r;
		
		r=create_generic(mc,idstr,depth,cb_data,item);
		
// proccess imediatly

		item.bmp_mc=r;
		
//		item.waitforit=0;
		item.call_loaded_mc=true;
		item.loaded_mc();
		
		
		return null;
	}
	
	
// load an image from library using library name

	static function create_img(mc,idstr,depth,cb_data,item)
	{
	var r,t;
		
		r=create_generic(mc,idstr,depth,cb_data,item);
		
		t=gfx.add_clip(r.loadhere,cb_data["url"],null);
		
//		dbg.print(cb_data["url"]+" "+t);

// proccess imediatly

		item.bmp_mc=r;
		
//		item.waitforit=0;
		item.call_loaded_mc=true;
		item.loaded_mc();
		
		
		return null;
	}
	
// load an image from library using library name as base for two jpegs

	static function create_jp4g(mc,idstr,depth,cb_data,item)
	{
	var r,t;
		
	var hx,hy;
		hx=cb_data["hx"]?cb_data["hx"]:0; // handle
		hy=cb_data["hy"]?cb_data["hy"]:0;
		
		r=create_generic(mc,idstr,depth,cb_data,item);

		r.createEmptyMovieClip("loadhere2",1); // get alpha
		r.loadhere2._x=hx;
		r.loadhere2._y=hy;
		
		t=gfx.add_clip(r.loadhere,cb_data["url"]+".rgb",null);
		t=gfx.add_clip(r.loadhere2,cb_data["url"]+".a",null);
		
//		dbg.print(cb_data["url"]+" "+t);

// proccess imediatly

		item.bmp_mc=r;
		
//		item.waitforit=0;
		item.call_loaded_mc=true;
		item.loaded_mc();
		
		return null;
	}

	// load an image "http:/balh.com/poop.png" and so on, full url only

	static function create_url(mc,idstr,depth,cb_data,item)
	{
	var r;
		
		r=create_generic(mc,idstr,depth,cb_data,item);

//allow to load...?
//dbg.print(cb_data["url"].split("/")[2]);
//		System.security.allowDomain( cb_data["url"].split("/")[2] );

// bounce through google.wetgenes.com ?
//		var s=cb_data["url"].split("http://").join("http://google.wetgenes.com/img/x/")
		
		r.loadhere.loadMovie(cb_data["url"]);
		
		return r;
	}

	
// chop a part out of a bmp into a new bmp	
	function bmp_chop(from,to,px,py,sx,sy)
	{	
		if(aa[to]==null) // only create once
		{
			if(aa[from])
			{
				aa[to]=new bmcache_item(this,to,null,null);
				aa[to].chop(aa[from] , px,py,sx,sy)
			}
		}
		
	}
	
// copy a bitmap area to another bitmap area
	function bmp_blit(from,to,fx,fy,sx,sy,tx,ty)
	{	
		if( aa[to].bmp &&  aa[from].bmp )
		{
			aa[to].bmp.copyPixels(aa[from].bmp , new flash.geom.Rectangle(fx,fy,sx,sy) , new flash.geom.Point(tx,ty) );
		}
	}
	
// clear a bitmap area to a set color

	function bmp_fill(to,fx,fy,sx,sy,argb)
	{	
		if( aa[to].bmp )
		{
			aa[to].bmp.fillRect( new flash.geom.Rectangle(fx,fy,sx,sy) , argb );
		}
	}
}
