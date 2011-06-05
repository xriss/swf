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
/*+-----------------------------------------------------------------------------------------------------------------+*/

#GFX=GFX or "gfx"
#CLASSVERSION = CLASSVERSION or ""
#CLASSNAME = CLASSNAME or "Gizmo"..CLASSVERSION
class #(CLASSNAME)
{


#include "../wetsrc/Gizmo.base.inc.as"

	
	function #(CLASSNAME)(_up)
	{
		up=_up;
		setup();
	}
	


	function setup()
	{
		setup_base();
	}
	
	function clean()
	{
		clean_base();
	}

	function update()
	{	
		update_base();
	}
	
	function input(snapshot)	// called on mouse or button or keyboard interaction, pass in the replay class containing data
	{
		focus=input_base(snapshot); // filter down until it gets handled
		return focus;
	}
	
}
