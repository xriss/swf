/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// cop/paste level codes

class PlayPaste
{
	var up;
	
	var mc;
	
	var mcs;
	var tfs;
	
	var done;
	var steady;
	
	var result;
	

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function PlayPaste(_up)
	{
		up=_up;
	}
	
	function setbutt(m,n)
	{
		m.onRollOver=delegate(over,n);
		m.onRollOut=delegate(notover,n);
		m.onReleaseOutside=delegate(notover,n);
		m.onRelease=delegate(click,n);
	}
		
	function setup(strin)
	{
	var i;
	var bounds;
	var mct;
	var s;
	
		result=strin;
		
		_root.popup=this;
		
		mcs=[];
		tfs=[];
			
		mc=gfx.create_clip(_root.mc_popup,null);
		mc.cacheAsBitmap=true;
		gfx.dropshadow(mc,5, 45, 0x000000, 1, 20, 20, 2, 3);
//	    mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 20, 20, 2, 3) ];
		
//		mc.onRelease=delegate(onRelease,null);
		
		mc._y=0;
		
		mc.dx=0;
		mc._x=-800;
		
//		mc.onEnterFrame=delegate(update,null);

		done=false;
		steady=false;
		
		gfx.clear(mc);
		
		mc.style.out=0xff000000;
		mc.style.fill=0x80000000;
		gfx.draw_box(mc,0,100+16,0+16,600-32,600-32);
		

		mcs[0]=gfx.create_clip(mc,null);
		tfs[0]=gfx.create_text_html(mcs[0],null,150,50,500,150);
		mcs[0].onRelease=delegate(onRelease,null);
		mcs[0].onReleaseOutside=delegate(onRelease,null);
		
		s="";
						
		s+="<p>Copy or paste level codes in the box below.<br>Then click here or press return/space to continue.<br>If you delete everything in the box you will clear the level.</p>";
				
		tfs[0].multiline=true;
		tfs[0].wordWrap=true;
		tfs[0].html=true;
		tfs[0].selectable=false;
		
		gfx.set_text_html(tfs[0],22,0xffffff,s);

		
		mc.style.out=0xff000000;
		mc.style.fill=0xff000080;
		gfx.draw_box(mc,0,200-4,200,400+8,200);
		
		tfs[1]=gfx.create_text_edit(mc,null,200,200,400,200);
		s=strin;
		tfs[1].multiline=true;
		tfs[1].wordWrap=true;
		tfs[1].html=false;
		tfs[1].selectable=true;
		tfs[1].editable=true;
		tfs[1].text=s;
		
	
		
		show_loaded();
		
		thunk();
		
//		Mouse.addListener(this);
		
		update_do=delegate(update,null);
		MainStatic.update_add(_root.updates,update_do);
		_root.poker.clear_clicks();
	}
	
	var update_do;
	
	function clean()
	{
		result=tfs[1].text;
		
		if(_root.popup != this)
		{
			return;
		}
		
		MainStatic.update_remove(_root.updates,update_do);
		update_do=null;
		
		mc.removeMovieClip();
		_root.popup=null;
		
//		Mouse.removeListener(this);
		
		_root.poker.clear_clicks();
	}

	
	function show_loaded()
	{
	}
	
	function thunk()
	{
	}
	
	function onRelease()
	{
		if(_root.popup != this)
		{
			return;
		}

		if(steady)
		{
//			if(!wf_loaded) // allow exit before load
			{
				done=true;
				mc.dx=_root.scalar.ox;
			}
		}
	}
	
	
	function over(s)
	{
		switch(s)
		{
		}
	}
	
	function notover(s)
	{
	}
	
	function click(s)
	{
	}
	
	function update()
	{
		
		if( ( Key.isDown(Key.ENTER) || Key.isDown(Key.SPACE) )  && (Selection.getCaretIndex()==-1) )
//		if((_root.popup == this)&&(_root.poker.anykey))
		{
			if(steady)
			{
				done=true;
				mc.dx=_root.scalar.ox;
			}
		}
		
		if( (_root.popup != this) || (_root.pause) )
		{
			return;
		}
		
		
		mc._x+=(mc.dx-mc._x)/4;

		if( (mc._x-mc.dx)*(mc._x-mc.dx) < (16*16) )
		{
			steady=true;
			if(done)
			{
				clean();
			}
		}
		else
		{
			steady=false;
		}
		
	}
		
	

}
