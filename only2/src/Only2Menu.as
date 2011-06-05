/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#file_names={"title"}


class Only2Menu
{
	var up; // Main
	var mc;
	var mcs;
	
	var over;
				
	var show_menu=false;
	
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	
// ser
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function Only2Menu(_up)
	{
		up=_up;
		
	}
			
	function makeclick(m)
	{
		m.onRelease=delegate(click,m);
		m.onRollOver=delegate(hover_on,m);
		m.onRollOut=delegate(hover_off,m);
		m.onReleaseOutside=delegate(hover_off,m);
		m.tabEnabled=false;
		m.useHandCursor=true;
	}
	
	var mcs_max;
	var file_name;
	var file_lines;
	
	
	function setup()
	{	
	
	var i;
	var line;
	var lin;
	var box;
	var nmc;
	var smc;
	var pidx;
//	var pmc;
	var under;
	var dash;
	var s;
	var dx,dy;
	var m;
	
	var v1,v2,v3,vd;
	var r;


		anim=0;
	
		file_name="#(file_names[1])";
		file_lines=#(file_names[1])_lines;
		
		
		mc=gfx.create_clip(up.mc,null);
		
		gfx.clear(mc);
		mc.style.fill=0xff000000;
		gfx.draw_box(mc,0,0,0,640,480);
		
		mcs=new Array();
		
//		mcs[-1]=gfx.add_clip(mc,"menu_back",null,0,0);
		
		mcs_max=file_lines.length-1;
		for(i=0;i<mcs_max;i++)
		{
			line=file_lines[i];
			lin=line.split(",");
			
			if(lin[0]=="") { lin[0]=null; }
			if(lin[1]=="") { lin[1]=null; }
			if(lin[2]=="") { lin[2]=null; }
			
			under=lin[0].split("_");
			dash=under[1].split("-");
			
			mcs[i]=gfx.create_clip(mc,null);
			mcs[i].mc=gfx.add_clip(mcs[i],file_name,null,0,0);
			mcs[i].mc.gotoAndStop(i+1);
			mcs[i].active=true;
			mcs[i].mc.cacheAsBitmap=true;
			
			box=mcs[i].mc.getBounds(mc);
			
			switch(under[0])
			{
			}
					
			box.x=(box.xMin+box.xMax)/2;
			box.y=(box.yMin+box.yMax)/2;
			box.w=(box.xMax-box.xMin);
			box.h=(box.yMax-box.yMin);
			box.s= box.w/640; if( (box.h/480) >  box.s ) { box.s=box.h/480; }
			
			mcs[i].box=box;
			
			if(lin[0]=="back_3")
			{
				mcs[i]._x=320;
				mcs[i]._y=480;
				mcs[i].mc._x=-320;
				mcs[i].mc._y=-480;
				mcs[i].onRelease=delegate(click,m);
			}
			
			m=mcs[i];

//dbg.print(under[0]);
			switch(under[0])
			{
				case "do":
					makeclick(mcs[i]);
				break;
			}
				
			mcs[i].idx=i;
			mcs[i].nam=lin[0];
			mcs[i].flavour=lin[2];
			
			mcs[i].under=under;
			mcs[i].dash=dash;
			
//			mcs[i]._visible=false; // everything off by default
			
			mcs[lin[0]]=mcs[i]; // swing both ways?
			
		}
		
		update_display();
				
		Mouse.addListener(this);
		
		update();
	}
	
	
	function clean()
	{		
		_root.poker.ShowFloat(null,0);

		Mouse.removeListener(this);
		
		mc.removeMovieClip(); mc=null;
		
		_root.signals.signal("#(VERSION_NAME)","set",this);
		_root.signals.signal("#(VERSION_NAME)","start",this);
	}
	
	function onMouseDown()
	{
		if(_root.popup) return;
		
	}
	function onMouseUp()
	{
		if(_root.popup) return;
	}
	
	
	function update_display()
	{
	var i;
	var m;
	
		
		for(i=0;i<mcs_max;i++)
		{
			m=mcs[i];
			switch(m.under[0])
			{
				case "back":
				break;
				
				default:
					do_this(m,"off");
				break;
			}
			
		}
	}
	
	function do_this(me,act)
	{
		switch(me.under[0])
		{
//			case "back":
//			break;
				
//			case "do":
			default:

				switch(act)
				{
					case "off" :
						me._alpha=50;
						gfx.clear_filters(me);
						_root.poker.ShowFloat(null,0);
					break;
					case "on" :
						me._alpha=100;
					break;
					case "click" :
						gfx.clear_filters(me);
						switch(me.under[0])
						{
							default:
								anim=4;
//								up.state_next="play";
							break;
						}
					break;
				}
			break;

		}
	}
	
	function hover_off(me)
	{
		if(_root.popup) return;
		
		if(over==me)
		{
			do_this(me,"off");
			over=null;
		}
	}
	
	function hover_on(me)
	{
		if(_root.popup) return;
		
		if(over!=me)
		{
			do_this(me,"on");
			over=me;
		}
	}

	function click(me)
	{
		if(_root.popup) return;
		
		do_this(me,"click");
		
	}


	var anim=0;
	
	function update()
	{
	var f,s;
	var m,m1,m2;
	
		m1=mcs.back_2;
		m2=mcs.back_3;
	
	var part=Math.floor(anim);
	
		f=anim-part;
		s=MainStatic.spine(f);

		if(!m1.mask)
		{
			m1.mask=gfx.create_clip(mc,null);
			m1.mask.visible=false;
			m1.cacheAsBitmap = true;
			m1.mask.cacheAsBitmap = true;
			m1.setMask(m1.mask);
		}
		
		switch( part )
		{
			case 0:
				m=m1.mask;
				gfx.clear(m);
				gfx.draw_box_xgrad(m,0,-640+(1280*s),0,640,480,0xffffffff,0x00000000);
				gfx.draw_box(m,0,-1280+(1280*s),0,640,480);

				m1._x=0;//-640+(640*s);
				m2._y=480+480;
				anim+=0.005;
			break;
			case 1:
//				m1.mask.clear();
				m1._x=0;
				m2._y=480+480;
				anim+=0.02;
			break;
			case 2:
				m1._x=0;
				m2._y=20+480+480-(480*s);
				anim+=0.01;
				m2._rotation=(m1._xmouse-320)/8;
			break;
			case 3:
				m1._x=0;
				m2._y=20+480;
				m2._rotation=(m1._xmouse-320)/8;
			break;
			case 4:
				mcs.back_1._alpha=100-(s*100);
				mcs.back_2._alpha=100-(s*100);
				mcs.back_3._alpha=100-(s*100);
				anim+=0.02;
			break;
			case 5:
				mcs.back_1._alpha=0;
				mcs.back_2._alpha=0;
				mcs.back_3._alpha=0;
				up.state_next="play";
				if(!_root.swish) // do not cancel old swish
				{
					_root.swish.clean();
					_root.swish=(new Swish({style:"fade",mc:mc})).setup();
				}
				
			break;
		}
	}
	
	
	
	
#for i,v in ipairs(file_names) do
	static var #(v)_lines=[
#for line in io.lines("art/bitmaps/"..v..".txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""
	];	
#end

}
