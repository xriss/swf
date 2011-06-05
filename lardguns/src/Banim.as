/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;


class Banim
{
	
	var layout:MovieClip;
	var mc:MovieClip;
	var mcm:MovieClip;
	
	var anim:String;
	var frame:Number;

// --- Main Entry Point
	static function main()
	{
		_root.newdepth=1;
		_root.banim=new Banim();
		_root.banim.setup();
		_root.onEnterFrame=function()
		{
			_root.banim.update();
		}
	}

	function setup()
	{

		anim=_root.anim;
		
		layout=gfx.create_clip(_root,null);
		mcm=gfx.create_clip(_root,null);
		mcm._visible=false;
		layout.setMask(mcm);
		mcm.style={	fill:0xffffffff,	out:0xffffffff,	text:0xffffffff	};
		gfx.draw_box(mcm,undefined,0,0,400,100)

		switch(anim)
		{
			case 'guns_win':
				guns_win_setup();
			break;
			case 'truth_win':
				truth_win_setup();
			break;
			case 'lard_win':
				lard_win_setup();
			break;
			case 'lies_win':
				lies_win_setup();
			break;
			case 'love_win':
				love_win_setup();
			break;
		}
	}

	function update()
	{
		switch(anim)
		{
			case 'guns_win':
				guns_win_update();
			break;
			case 'truth_win':
				truth_win_update();
			break;
			case 'lard_win':
				lard_win_update();
			break;
			case 'lies_win':
				lies_win_update();
			break;
			case 'love_win':
				love_win_update();
			break;
		}
	}
	
	function clean()
	{
	}

	function guns_win_setup()
	{
		mc=gfx.add_clip(layout,'gunsanim',null);
		mc.gotoAndStop(0);
		frame=0;
	}
	function guns_win_update()
	{
	var n;	
		frame++;
		if(frame>=(30*5)) { frame=0; }
		n=Math.floor(frame/30);
		mc._y=-n*100;
	}

	function truth_win_setup()
	{
		mc=gfx.add_clip(layout,'truthanim',null);
		mc.gotoAndStop(0);
		frame=0;
	}
	function truth_win_update()
	{
	var n;	
		frame++;
		if(frame>=(30*5)) { frame=0; }
		n=Math.floor(frame/30);
		mc._y=-n*100;
	}

	function lard_win_setup()
	{
		mc=gfx.add_clip(layout,'lardanim',null);
		mc.gotoAndStop(0);
		frame=0;
	}
	function lard_win_update()
	{
	var n;	
		frame++;
		if(frame>=(30*5)) { frame=0; }
		n=Math.floor(frame/30);
		mc._y=-n*100;
	}

	function lies_win_setup()
	{
		mc=gfx.add_clip(layout,'liesanim',null);
		mc.gotoAndStop(0);
		frame=0;
	}
	function lies_win_update()
	{
	var n;	
		frame++;
		if(frame>=(30*5)) { frame=0; }
		n=Math.floor(frame/30);
		mc._y=-n*100;
	}

	function love_win_setup()
	{
		mc=gfx.add_clip(layout,'loveanim',null);
		mc.gotoAndStop(0);
		frame=0;
	}
	function love_win_update()
	{
	var n;	
		frame++;
		if(frame>=(30*5)) { frame=0; }
		n=Math.floor(frame/30);
		mc._y=-n*100;
	}
	
}


