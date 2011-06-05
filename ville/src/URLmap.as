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

class URLmap
{
	var map;
	
// 32k data limits hits again
	
	var xml;
	var xml_count=0;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	
	function URLmap()
	{
		map=[];
		
		xml=[];
//		xml[1]=new URLmap1;
//		xml[2]=new URLmap2;
		
// #(urlcache[1].base)		

#for i,v in ipairs(urlcache) do
#if v.xml then
#else
	map["#(v.url)"]='#(v.name)'; // embeded bitmaps
#end
#end

	
		state="waiting"
	}

	var dxml;
	var state="waiting";
	var server_loaded=false;
// load urlmap from server
	
	function loadcheck()
	{
		if(state=="waiting")
		{
			loadcheck_xmldata(); // hit up the server
		}
		
		return state;
	}
	
	function loadcheck_xmldata()
	{
		if(!_root.server_data.swf_dat) { return; } // wait till server tells us where
			
		System.security.allowDomain( _root.server_data.swf_urlbase );
		System.security.allowDomain( _root.server_data.swf_urlbase.split("/")[2] );
		
		
		dxml=new XML();
		dxml.url=_root.server_data.swf_dat;
		dxml.onData=delegate(loadcheck_xmldata_ondata,dxml);
		dxml.load(dxml.url);
		
		state="loading XML pre-cache.";
	}
	
	function loadcheck_xmldata_ondata(s)
	{
		state="failed xml dat load";
		
		if(s) // we got signal
		{
			var i;
			var aa=s.split("\n");
			
			xml=[]
			xml[1]={};
			xml[1].map=[];
			xml_count=1;
			
			for(i=0;i<aa.length;i++)
			{
				var aaa=aa[i].split("=");
				var url=aaa[0];
				var dat=unescape(aaa[1]);
				
				xml[1].map[url]=dat;
				
//				dbg.print(url);
			}
			
			state="ready";
		}
	}
	
	function lookup(s)
	{
		var base="http://data.wetgenes.com";
		var newbase=_root.server_data.swf_urlbase;
		
		var i;
		
//dbg.print(s);
		if( map[s] )
		{
			return map[s];
		}
		for(i=1 ; i <= xml_count ; i++ )
		{
			if( xml[i].map[s] )
			{
				return xml[i].map[s];
			}
		}

// try again with newbase replaced with base since data may move around

		s=s.split(newbase).join(base);
		
//dbg.print(s);
		
		if( map[s] )
		{
			return map[s];
		}
		for(i=1 ; i <= xml_count ; i++ )
		{
			if( xml[i].map[s] )
			{
				return xml[i].map[s];
			}
		}
		
//dbg.print("notfound : "+s);

		return undefined;
	}

}