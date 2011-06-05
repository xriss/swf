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

#DEFAULT_FONT=DEFAULT_FONT or "Bitstream Vera Sans"


#CLASSNAME = CLASSNAME or "dbg"
class #(CLASSNAME)
{
	
	static function chat(s) // send to my chat if it exists
	{
		_root.talk.chat_status(s);
	}
	
	static function print(s)
	{
		
/*
 * 	var a;	
		a=(""+s).split('"');
		s=a.join("'");
		getURL("javascript:if(console){console.log(\""+s+"\");}");
*/
		trace(s);

		print_tf(s);
	}
	
	static function dump(a)
	{
	var idx;
		for(idx in a)
		{
			print(""+idx+" = "+a[idx]);
		}
	}
	
	static function create_text_format(fntsiz,fntcol,boldit)
	{
		var t;
		
		t=new TextFormat();
		
		t.font="#(DEFAULT_FONT)";
		t.color=fntcol&0xffffff;
		t.size=fntsiz;
		t.bold=boldit?true:false;
		
		return t;
	}
	
	static function create_tf()
	{
	var t;
		if(!_root.dbg_mc)
		{
			_root.createTextField( "tf"+66666 , 66666 , 0 , 0 , Stage.width , Stage.height );
			t=_root["tf"+66666];
			t.type="dynamic";
			t.embedFonts=true;
			t.html=false;
			t.multiline=true;
			t.selectable=false;
			t.wordWrap=false;
//			t.cacheAsBitmap=true;
		
			t.setNewTextFormat(create_text_format(16,0xffffffff));
			
			_root.dbg_tf=t;
		}
	}
	
	
	static function clear_tf()
	{
	var t;
		t=_root.dbg_tf;
		t.text="";
	}
	
	
	static function print_tf(s)
	{
	var t;
	
		if(!_root.dbg_tf) { create_tf(); }
		
		t=_root.dbg_tf;
		
		t._width=Stage.width;
		t._height=Stage.height;
		
		t.text+=s+"\n";
		
		t.scroll=t.maxscroll;
	}
	
}
