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

#CLASSNAME = CLASSNAME or "XLT"

class #(CLASSNAME)
{

	static function str(s)
	{
		if(!_root.xlt)
		{
			XLT.setup("EN");
		}
		
	var	t=_root.xlt[s];
	
		if(t) return t;
		else return s;
	}

	static function setup(id)
	{
	var idx1=0;
	var idx2=0;
	var p1,p2;
	
	var	h,l,i;
	
		h=lines[0].split('&');
		
		for(i=0;i<h.length;i++)
		{
			if(h[i]=='EN')
			{
				idx1=i;
			}
			if(h[i]==id)
			{
				idx2=i;
			}
		}
		
		_root.xlt=[];
			
		for(i=0;i<lines.length;i++)
		{
			l=lines[i].split('&');
			
			p1=l[idx1];
			p2=l[idx2];
			
			if((!p2)||(p2==""))
			{
				p2=p1;
			}
			
			_root.xlt[p1]=p2;
		}
	}
	
#(

-----------------------------------------------------------------------------
--
-- split a csv line into a table
--
-----------------------------------------------------------------------------
local function parse_csv_line(s)
    s = s..','          -- ending comma
    local t = {}     -- table to collect fields
    local fieldstart = 1
    repeat
      if string.find(s, '^"', fieldstart) then    -- quoted field?
        local a, c
        local i  = fieldstart
        repeat
          a, i, c = string.find(s, '"("?)', i+1)  -- find closing quote
        until c ~= '"'    -- repeat if quote is followed by quote
        if not i then error('unmatched "') end
        table.insert(t, (string.gsub(string.sub(s, fieldstart+1, i-1), '""', '"')) )
        fieldstart = string.find(s, ',', i) + 1
      else                -- unquoted; find next comma
        local nexti = string.find(s, ',', fieldstart)
        table.insert(t, string.sub(s, fieldstart, nexti-1) )
        fieldstart = nexti+1
      end
    until fieldstart > string.len(s)
    return t
  end
  
#)

	static var lines=[
#for line in io.lines("src/xlate.csv") do 
#(

tab=parse_csv_line(line)
line="&"

for i,v in ipairs(tab) do line=line..v.."&" end

line=line:gsub('"', '\\"')

#)
	"#(line)",
#end
	""
	];	

}