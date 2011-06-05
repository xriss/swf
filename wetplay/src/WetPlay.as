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
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class WetPlay
{

	var v;

	var state_last;
	var state;
	var state_next;

	var	setup_done=false;

	var mc;
	
	var mc_popup;
	var mc_import;

	var wetplayMP3:WetPlayMP3;
	var wetplayGFX:WetPlayGFX;
	
	// --- Main Entry Point
	static function main()
	{
		System.security.allowDomain("*");
		System.security.allowInsecureDomain("*");
		
 
		_root.newdepth=1;
		_root.poker=new Poker(false);
		_root.wetplay=new WetPlay();
		_root.onEnterFrame=function()
		{
			_root.wetplay.update();
		}
		
		_root.wetplay.setup();
	}

	function setup()
	{
		_root.gotoAndStop(1);
			
		v=[];
		v.name='#(VERSION_NAME)';
		v.number='#(VERSION_NUMBER)';
		v.stamp='#(VERSION_STAMP)';
		v.stamp_number='#(VERSION_STAMPNUMBER)';

//		_root.login.again=true;
		
		state_last=null;
		state=null;

// create master layout mc, I will do smart positioning and scaling
		Stage.scaleMode="noScale";
		Stage.align="TL";
		mc=gfx.create_clip(_root,null);

		wetplayGFX=new WetPlayGFX(this);
		wetplayMP3=new WetPlayMP3(this);

		state_next="play";
		
//		Mouse.addListener(this);
		Stage.addListener(this);

// create popup space

		mc_popup=gfx.create_clip(mc,16383);
		_root.mc_popup=mc_popup;
		_root.popup=null;	// put a popup class in here to halt normal operation
		
// load version check in

		mc_import=gfx.create_clip(mc_popup,null);
		
		if(_root.loading.server=="www")
		{
//			mc_import.loadMovie("http://www.wetgenes.com/swf/WetPlay_import.swf");
		}
		else
		{
//			mc_import.loadMovie("http://www.wetgenes.local/swf/WetPlay_import.swf");
		}

#if VERSION_MOCHIBOT then

		__com_mochibot__("#(VERSION_MOCHIBOT)", _root, 10301);

//
// public stats
//
// http://www.mochibot.com/shared/?key=b976e67c29ef6efa6deeb3039bf71dc1
// 
		
#end

		setup_done=true;
	}

	function update()
	{
		if(state_next!=null)
		{
			switch(state)	// clean
			{
				case "play":		wetplayMP3.clean();		break;
			}

			state_last=state;	// change master state
			state=state_next;
			state_next=null;
			
// always do a layout thunk on state change poo poo
			onResize();

			switch(state)	// setup
			{
				case "play":		wetplayMP3.setup();		break;
			}
		}
		
		_root.poker.update();
		switch(state)	// update
		{
			case "play":		wetplayMP3.update();	break;
		}
	}
	
	function clean()
	{
	}
	
//think about layout stuff
	function onResize()
	{
		return; // no funky resizing for this one
	}
	
	function do_str(str)
	{
		switch(str)
		{
			default:
			break;
		}
	}		

// MochiBot.com -- Version 5
// Tested with with Flash 5-8, ActionScript 1 and 2
function __com_mochibot__(swfid, mc, lv)
{
	var x,g,s,fv,sb,u,res,mb,mbc;
	
	mb = '__mochibot__';
	mbc = "mochibot.com";
	g = _global ? _global : _level0._root;
	if (g[mb + swfid]) return g[mb + swfid];
	s = System.security;
	x = mc._root['getSWFVersion'];
	fv = x ? mc.getSWFVersion() : (_global ? 6 : 5);
	if (!s) s = {};
	sb = s['sandboxType'];
	if (sb == "localWithFile") return null;
	x = s['allowDomain'];
	if (x) s.allowDomain(mbc);
	x = s['allowInsecureDomain'];
	if (x) s.allowInsecureDomain(mbc);
	u = "http://" + mbc + "/my/core.swf?mv=5&fv=" + fv + "&v=" + escape(getVersion()) + "&swfid=" + escape(swfid) + "&l=" + lv + "&f=" + mc + (sb ? "&sb=" + sb : "");
	lv = (fv > 6) ? mc.getNextHighestDepth() : g[mb + "level"] ? g[mb + "level"] + 1 : lv;
	g[mb + "level"] = lv;
/*
	if (fv == 5)
	{
		res = "_level" + lv;
		if (!eval(res)) loadMovieNum(u, lv);
	}
	else
	{
*/
		res = mc.createEmptyMovieClip(mb + swfid, lv);
		res.loadMovie(u);
//	}
	return res;
}
	
}


