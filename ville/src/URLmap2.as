/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#(
local function dofile(filename)
  local f = assert(loadfile(filename))
  return f()
end

	dofile("art/urlmap.lua")
#)

class URLmap2
{
	var map;
	
	
	function URLmap2()
	{
		map=[];
		
// #(urlcache[1].base)		

#for i,v in ipairs(urlcache) do
#if v.xml and ( (i%2)==1 ) then
	map["#(v.url)"]='#(v.xml)';
#end
#end

	}
	
}