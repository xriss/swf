/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
// This file made available under the terms of The MIT License : http://www.opensource.org/licenses/mit-license.php
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
/*+-----------------------------------------------------------------------------------------------------------------+*/


// Collection of talky thingies


class Talky
{
	var up;
	
	var w,h;
	
	var mc;
	
	var bubs;
		
	var topdepth=1024;
	var topmc;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

		
	function Talky(_up)
	{
		up=_up;
		
		w=800;
		h=600;
	}
	
	function setup()
	{
		bubs=[];
		
		mc=gfx.create_clip(up.mc,null);
		
		topmc=gfx.create_clip(mc,topdepth);
		
	}
	
	function clean()
	{
	var i;
	
		for(i=0;i<bubs.length;i++)
		{
			bubs[i].clean();
		}
		mc.removeMovieClip();
		mc=null;
		bubs=null;
	}
	
	
	function create(_orig,_x,_y,_offorg)
	{
	var r;
	
		if(_offorg==undefined)
		{
			_offorg="local";
		}
	
		r=new TalkyBub(this,_orig,_x,_y,_offorg);
		
		bubs[bubs.length]=r;
				
		return r;
	}
	
	var last=null;
	
	function update()
	{
	var i;
	
	
		if(up.old_time!=undefined)
		{
			if(last!=up.old_time)
			{
				last=up.old_time;
			}
			else
			{
				return;
			}
		}
		
		for(i=0;i<bubs.length;i++)
		{
			if(bubs[i].update()) // update returns true to delete and remove
			{
				bubs[i].clean();
				bubs.splice(i,1);
				i--;
			}
		}
		
	}
	
}
