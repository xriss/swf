/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;
import com.wetgenes.dbg;
import com.wetgenes.wetDNA;

import wetDNAPlay;


class WetDNA
{
//	var scores:pung_scores;

	static var STATE_NONE      :Number =   0;
	static var STATE_PLAY      :Number =   1;

	var state_last		:Number;
	var state			:Number;
	var state_next		:Number;

	var	setup_done=false;

	var mc:MovieClip;
	
	var dnaPlay:WetDNAPlay;
	
	
	// --- Main Entry Point
	static function main()
	{

//		_root.click_idx=0;
//		_root.click_name='click0';
 
		_root.newdepth=1;
		_root.wetDNA=new WetDNA();
		_root.onEnterFrame=function()
		{
			_root.wetDNA.update();
		}
	}

	function setup()
	{
		state_last=STATE_NONE;
		state=STATE_NONE;

// create master layout mc, I will do smart positioning and scaling
		mc=gfx.create_clip(_root,null);

		
		dnaPlay=new WetDNAPlay(this);

		state_next=STATE_PLAY;
		
	
//		Mouse.addListener(this);
		Stage.addListener(this);
	}
	
	function onMouseDown()
	{
//		replay.prekey_on(Replay.KEY_MBUTTON);
	}
	
	function onMouseUp()
	{
//		replay.prekey_off(Replay.KEY_MBUTTON);
	}

	function update()
	{
		if(!setup_done)
		{
			setup();
			setup_done=true;
			
			dbg.print("done setup");
		}
		

// always do a layout thunk
		onResize();

		if(state_next!=STATE_NONE)
		{
			switch(state)	// clean
			{
				case STATE_PLAY:		dnaPlay.clean();		break;
			}

			state_last=state;	// change master state
			state=state_next;
			state_next=STATE_NONE;
			

			switch(state)	// setup
			{
				case STATE_PLAY:		dnaPlay.setup();		break;
			}
		}
			switch(state)	// update
			{
				case STATE_PLAY:		dnaPlay.update();		break;
			}
	}
	
	function clean()
	{
	}
	
//think about layout stuff
	function onResize()
	{
		thunk();
	}
	
	function thunk()
	{
		var siz;
		var x=800;
		var y=300;
		
		Stage.scaleMode="noScale";
		Stage.align="TL";

		
//		if(Stage.width>=Stage.height) // normal
		{
			mc._rotation=0;
			
			siz=Stage.width/x;

			if(_root.maxw)
			{
				if(siz*x>_root.maxw)
				{
					siz=_root.maxw/x;
				}
			}
			
			if(_root.maxh)
			{
				if(siz*y>_root.maxh)
				{
					siz=_root.maxh/y;
				}
			}

			if(siz*y>Stage.height)
			{
				siz=Stage.height/y;
			}
			
			mc._x=Math.floor((Stage.width-siz*x)/2);
			mc._y=Math.floor((Stage.height-siz*y)/2);
			mc._xscale=siz*100;
			mc._yscale=siz*100;
		}
/*
		else // rotates 90deg
		{
			mc._rotation=90;

			siz=Stage.height/x;
			if(siz*y>Stage.width)
			{
				siz=Stage.width/y;
			}
			
			mc._x=Stage.width-Math.floor((Stage.width-siz*y)/2);
			mc._y=Math.floor((Stage.height-siz*x)/2);
			mc._xscale=siz*100;
			mc._yscale=siz*100;
		}
*/
	}
	
}


