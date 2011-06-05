/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.dynamicflash.utils.Delegate;

import com.wetgenes.gfx;
import com.wetgenes.dbg;
import com.wetgenes.wetDNA;

import Loading;
import SwingPlay;
//import MovieClip;


//import wetDNAPlay;


class Swing
{
//	var scores:pung_scores;

	static var STATE_NONE      :Number =   0;
	static var STATE_MENU      :Number =   1;
	static var STATE_PLAY      :Number =   2;

	var state_last		:Number;
	var state			:Number;
	var state_next		:Number;

	var mc;

	var replay;
	
	var loading;
	var play;

	var wtf;
	
	function delegate(f:Function)
	{
		return Delegate.create(this,f);
	}

	
	// --- Main Entry Point
	static function main()
	{

		_root.click_name='click0';
 
		_root.newdepth=1;
		
		_root.WET=new Swing();
		
		_root.WET.setup();
		_root.onEnterFrame=_root.WET.delegate(_root.WET.update);
	}

	function setup()
	{		

		state_last=STATE_NONE;
		state=STATE_NONE;

		mc=gfx.create_clip(_root,null); // master, everything else hangs off of this
		
		replay=new Replay(this);
		
		play=new SwingPlay(this);

		wtf=new WTF();
		
		state_next=STATE_PLAY;
		
	
		Mouse.addListener(this);
		Stage.addListener(this);

		
		loading=new Loading(this);
	}
	
	function onMouseDown()
	{
		replay.prekey_on(Replay.KEY_MBUTTON);
	}
	
	function onMouseUp()
	{
		replay.prekey_off(Replay.KEY_MBUTTON);
	}

	function update()
	{
		onResize();

//	dbg.print("ping");

// check we finished loading before continuing

		replay.premouse_x=mc._xmouse-400;	// use center of layout as zero
		replay.premouse_y=mc._ymouse-300;

		if(!loading.done)
		{
			return;
		}

		if(state_next!=STATE_NONE)
		{
			switch(state)	// clean
			{
				case STATE_PLAY:		play.clean();		break;
			}

			state_last=state;	// change master state
			state=state_next;
			state_next=STATE_NONE;
			
			if(_root.click_name=='click0')	{	_root.click_name='click1';	}
			else							{	_root.click_name='click0';	}

			switch(state)	// setup
			{
				case STATE_PLAY:		play.setup();		break;
			}
		}
			switch(state)	// update
			{
				case STATE_PLAY:		play.update();		break;
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
		var y=600;
		
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


