/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#if TRON=='xray' then	
import com.blitzagency.xray.util.XrayLoader;
#end

import com.wetgenes.dbg;

class WetBio
{
//	var scores:pung_scores;

	static var STATE_NONE      :Number =   0;
	static var STATE_VIEW      :Number =   1;

	var state_last		:Number;
	var state			:Number;
	var state_next		:Number;
	
	var layout:MovieClip;

	var view:WetBioView;
	
	// --- Main Entry Point
	static function main()
	{

		_root.click_idx=0;
		_root.click_name='click0';
 
		_root.newdepth=1;
		_root.wetbio=new WetBio();
		_root.wetbio.setup();
		_root.onEnterFrame=function()
		{
			_root.wetbio.update();
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


#if VERSION_SITE=='tagworld' then

//dbg.print('test');

var xmlParamDoc = null;

// xmlParams string received  via flashvars...
//_root.extXmlParamsPath="properties.xml";

if (_root.extXmlParamsPath != null && typeof(_root.extXmlParamsPath) != 'undefined') {		
//dbg.print('testcall');
	xmlParamDoc = new XML();
	xmlParamDoc.ignoreWhite = true;
	xmlParamDoc.onLoad=function(sucess)
	{
//dbg.print('testcallback');
		if(sucess)
		{
			for (var aa in xmlParamDoc.firstChild.attributes) {
				_root[aa] = xmlParamDoc.firstChild.attributes[aa];
//				dbg.print(aa+'='+_root[aa]);
			}
			_root.wetbio.view.opts.check_root();
			_root.wetbio.view.clean();
			_root.wetbio.view.setup();
		}
	};
	xmlParamDoc.load(_root.extXmlParamsPath);
}	

var xmlParamDoc2 = null;

if (_root.xmlParams != null && typeof(_root.xmlParams) != 'undefined') {		
	xmlParamDoc2 = new XML();
	xmlParamDoc2.ignoreWhite = true;
	xmlParamDoc2.parseXML(_root.xmlParams);				
	for (var a in xmlParamDoc2.firstChild.attributes) {
		_root[a] = xmlParamDoc2.firstChild.attributes[a];
	}
}	


var wrapper = _root.createEmptyMovieClip("wrapper", -1);
if (_root.wrapperPath != null && typeof(_root.wrapperPath) != 'undefined')
	loadMovie(_root.wrapperPath, wrapper); // wrapperPath string received  via flashvars...
else 
	loadMovie("flashWrapper.swf", wrapper);

	
#end
		
		state_last=STATE_NONE;
		state=STATE_NONE;

// create master layout mc, I will do smart positioning and scaling
		Stage.scaleMode="noScale";
		Stage.align="TL";
		layout=gfx.create_clip(_root,null);

		view=new WetBioView(this);
		
		state_next=STATE_VIEW;
		
		Mouse.addListener(this);
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
//		replay.premouse_x=_root._xmouse-400;	// use center of root as zero
//		replay.premouse_y=_root._ymouse-300;
		
		if(state_next!=STATE_NONE)
		{
			_root[_root.click_name]=null;
			_root.click_idx++;
			if(_root.click_idx>4) { _root.clickfuncs_idx=0; }
			_root.click_name="click"+_root.click_idx;
			_root[_root.click_name]=null;
			
			switch(state)	// clean
			{
				case STATE_VIEW:		view.clean();		break;
			}

			state_last=state;	// change master state
			state=state_next;
			state_next=STATE_NONE;
			
// always do a layout thunk on state change
			onResize();

			switch(state)	// setup
			{
#if VERSION_SITE=='bunchball' then
// wait for server before displaying anything
#else
				case STATE_VIEW:		view.setup();		break;
#end
			}
		}
			switch(state)	// update
			{
				case STATE_VIEW:		view.update();		break;
			}
	}
	
	function clean()
	{
	}
	
//think about layout stuff
	function onResize()
	{
		var siz;
		var x=600;
		var y=200;
		var stage_height=Stage.height;
		
#if VERSION_SITE=='tagworld' then
		stage_height-=20;
#end		
		if(Stage.width>=stage_height) // normal
		{
			layout._rotation=0;
			
			siz=Stage.width/x;
			if(siz*y>stage_height)
			{
				siz=stage_height/y;
			}
			
			layout._x=Math.floor((Stage.width-siz*x)/2);
			layout._y=Math.floor((stage_height-siz*y)/2);
			layout._xscale=siz*100;
			layout._yscale=siz*100;
		}
		else // rotates 90deg
		{
			layout._rotation=90;

			siz=stage_height/x;
			if(siz*y>Stage.width)
			{
				siz=Stage.width/y;
			}
			
			layout._x=Stage.width-Math.floor((Stage.width-siz*y)/2);
			layout._y=Math.floor((stage_height-siz*x)/2);
			layout._xscale=siz*100;
			layout._yscale=siz*100;
		}
	}
	
}


