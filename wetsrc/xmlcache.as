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


// an xml cache manager,

class xmlcache
{

	function delegate(f,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,i);	}

	function xmlcache()
	{
	}

	
// load from cache if we can, otherwise start the load from the url

	static function load(xml)
	{
		var dat
		var i;
	
//		dat=_root.urlmap.map[xml.url]; // do we have preloaded xml string?

		dat=_root.urlmap.lookup(xml.url);
		
		if(dat)
		{
//dbg.print(xml.url);

			xml.parseXML(dat);
			xml.onLoad("swf");
			return xml;
		}
		else
		{
//dbg.print("BAD : "+xml.url);
			xml.load(xml.url);
			return xml;
		}	
	}

}
