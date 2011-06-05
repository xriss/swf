/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;
import com.wetgenes.dbg;
import com.wetgenes.wetDNA;

// A Moist Klondike

class Feats
{
//	var scores:pung_scores;

	var v;

	var state_last;
	var state;
	var state_next;

	var	setup_done=false;

	var mc:MovieClip;
	var mcm:MovieClip;
	var mco:MovieClip;
	

	static function main()
	{
		_root.cacheAsBitmap=true;


		System.security.allowDomain("www.wetgenes.com");
		System.security.allowDomain("www.wetgenes.local");
		System.security.allowInsecureDomain("www.wetgenes.com");
		System.security.allowInsecureDomain("www.wetgenes.local");

		_root.newdepth=1;
		_root.poker=new Poker(false);
		_root.feats=new Feats();
		_root.onEnterFrame=function()
		{
			_root.feats.update();
		}
		

	}

	function setup()
	{
		v=[];
		v.name='#(VERSION_NAME)';
		v.site='#(VERSION_SITE)';
		v.number='#(VERSION_NUMBER)';
		v.stamp='#(VERSION_STAMP)';
		v.stamp_number='#(VERSION_STAMPNUMBER)';

		
		state_last=null;
		state=null;

// create master layout mc, I will do smart positioning and scaling
		Stage.scaleMode="noScale";
		Stage.align="TL";
		mc=gfx.create_clip(_root,null);
				
		state_next="view";
		
		Stage.addListener(this);
	}
	
	function update()
	{
			
		onResize();
		
		if(state_next!=null)
		{
			switch(state)	// clean
			{
//				case "play":		featsplay.clean();		break;
			}
			
			state_last=state;	// change master state
			state=state_next;
			state_next=null;
			
// always do a layout thunk on state change
			onResize();

			switch(state)	// setup
			{
//				case STATE_PLAY:		dikeplay.setup(game_seed);		break;
			}
		}
			switch(state)	// update
			{
//				case STATE_PLAY:		dikeplay.update();		break;
			}
	}
	
	function clean()
	{
	}
	
//think about layout stuff
	function onResize()
	{
		var siz;
		var x=400;
		var y=400;
		
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

		mcm._x=mc._x;
		mcm._y=mc._y;
		mcm._xscale=mc._xscale;
		mcm._yscale=mc._yscale;
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


