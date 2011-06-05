/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#if TRON=='xray' then	
import com.blitzagency.xray.util.XrayLoader;
#end


class recoil
{
//	var scores:pung_scores;

	static var STATE_NONE      :Number =   0;
	static var STATE_TITLE     :Number =   1;
	static var STATE_GAME      :Number =   2;

	var state_last		:Number;
	var state			:Number;
	var state_next		:Number;

	var title			:recoil_title;
	var game			:recoil_game;
	var replay			:Replay;
	var trans			:Trans;
	var scores			:Scores;


	var opt_sound			:Boolean	=true;
	var opt_transitions		:Boolean	=true;
	var opt_name			:String		="Me";

	
	// --- Main Entry Point
	static function main()
	{

		_root.click_idx=0;
		_root.click_name='click0';
 
		_root.newdepth=1;
		_root.main=new recoil();
		_root.main.setup();
		_root.onEnterFrame=function()
		{
			_root.main.update();
		}
	}

	function opt_update()
	{
		var s:Sound = new Sound();
		
		if(opt_sound)
		{
			s.setVolume(100)
		}
		else
		{
			s.setVolume(0)
		}
		
	}

	function setup()
	{
#if TRON=='xray' then	
		var listener:Object = new Object();
		listener.xrayLoadComplete = function(){
		_global.com.blitzagency.xray.Xray.initConnections();
				XrayLoader.trace("Xray has loaded...");
		}
		XrayLoader.addEventListener("xrayLoadComplete", listener);
		XrayLoader.loadConnector("ConnectorOnly.swf", _root);
		
		trace("XRAY setup.");
#end
		
		state_last=STATE_NONE;
		state=STATE_NONE;

		var t=gfx.add_clip(_root,"layout");
		t.gotoAndStop(1);
			
		title	=new recoil_title(this);
		scores	=new Scores(this,title.delegate(title.thunk_scores));
		game	=new recoil_game(this);
		replay	=new Replay();
		trans	=new Trans();
		
		
//		title.state=recoil_title.STATE_OPTIONS;
//		title.state=recoil_title.STATE_SCORES;
		title.state=recoil_title.STATE_SPLASH;
//		title.state=recoil_title.STATE_WIN;
//		title.state=recoil_title.STATE_LOSE;
		state_next=recoil.STATE_TITLE;
//		state_next=STATE_GAME;

//		_root.mousedown=0;
//		_root.mouseup=0;
		Mouse.addListener(this);

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
		replay.premouse_x=_root._xmouse-400;	// use center of root as zero
		replay.premouse_y=_root._ymouse-300;
		
		if(state_next!=STATE_NONE)
		{
			_root[_root.click_name]=null;
			_root.click_idx++;
			if(_root.click_idx>4) { _root.clickfuncs_idx=0; }
			_root.click_name="click"+_root.click_idx;
			_root[_root.click_name]=null;
			
			switch(state)	// clean
			{
				case STATE_TITLE:		trans.out(title);		title.clean();		break;
				case STATE_GAME:		trans.out(game);		game.clean();		break;
			}

			state_last=state;	// change master state
			state=state_next;
			state_next=STATE_NONE;
			
			switch(state)	// setup
			{
				case STATE_TITLE:		title.setup();		break;
				case STATE_GAME:		game.setup();		break;
			}
		}
			switch(state)	// update
			{
				case STATE_TITLE:		title.update();		break;
				case STATE_GAME:		game.update();		break;
			}
	}
	
	function clean()
	{
	}
}


