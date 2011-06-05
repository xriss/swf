/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class www_import
{
	// --- Main Entry Point
	static function main()
	{
		System.security.allowDomain( _root._url );
		System.security.allowDomain( _root._url.split("/")[2] );
		System.security.allowDomain("s3.wetgenes.com");
		System.security.allowDomain("www.wetgenes.com");
		System.security.allowDomain("swf.wetgenes.com");
		System.security.allowDomain("www.wetgenes.local");
		System.security.allowDomain("swf.wetgenes.local");

// this doesnt work on flahs seven... so we need the above too		
		System.security.allowDomain("*");
		
		System.security.loadPolicyFile("http://swf.wetgenes.com/crossdomain.xml");
		
		if(!_root.mc) { _root.mc=_root; }
		

		_root.gotoAndStop(1); // frame 1 is preload, frame 2 is everything loaded
		
		_root.www=_root.createEmptyMovieClip("mc"+1,1);
		
		_root.www.onEnterFrame=update;
		
		getURL("javascript:if(console){console.log(\"setup\");}");
	}

	static function update()
	{
	var score;
	var con;
	
		if(_root.score)
		{
			score=_root.score;
			
			_root.score=undefined;
			
			if(_root.wetcon) // open coms
			{
				con= new LocalConnection();	
				con.allowDomain=function(){return true;};
				
				con.send("_"+_root.wetcon, "score" , "final" , score);

		getURL("javascript:if(console){console.log(\"score"+score+"\");}");
				}
			
			
		}
	
	
	}
	
	
}


