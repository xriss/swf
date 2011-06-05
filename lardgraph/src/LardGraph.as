/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;
import com.dynamicflash.utils.Delegate;
import com.wetgenes.dbg;


class LardGraph
{

	var state_last;
	var state;
	var state_next;

	var mc;
	
	var graphtest;
	
	// --- Main Entry Point
	static function main()
	{
//		dbg.print( "root" );
		_root.lardgraph=new LardGraph();
	}

	function delegate(f,d)	{	return Delegate.create(this,f,d);	}
	
	function LardGraph()
	{
		setup();
	}
	
	function setup()
	{
//		dbg.print( "lardgraph setup " );
	
		state_last=null;
		state=null;

// create master layout mc, I will do smart positioning and scaling
		Stage.scaleMode="noScale";
		Stage.align="TL";
		mc=gfx.create_clip(_root,null);
		
		
		mc.onEnterFrame=delegate(update);


// grab input
		Mouse.addListener(this);
		Stage.addListener(this);
		
		
		graphtest=new GraphTest(this);
		
		graphtest.setup();

	}
	
	function onMouseDown()
	{
	}
	
	function onMouseUp()
	{
	}

	function update()
	{
		graphtest.update();
	}
	
	function clean()
	{
	}
	
//think about layout stuff
	function onResize()
	{
		var siz;
		var x=800;
		var y=600;
		
		mc._rotation=0;
		
		siz=Stage.width/x;
		if(siz*y>Stage.height)
		{
			siz=Stage.height/y;
		}
		
		mc._x=Math.floor((Stage.width-siz*x)/2);
		mc._y=Math.floor((Stage.height-siz*y)/2);
		mc._xscale=siz*100;
		mc._yscale=siz*100;
	}
	
	function do_str(str)
	{
		switch(str)
		{
			default:
			break;
		}
	}		
}


