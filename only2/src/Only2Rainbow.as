/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#file_names={"rainbow"}


class Only2Rainbow
{
	var up; // Main
	var mc;
	var mcs;
	
	var over;
	var vid;
	
	var loader;
	var vid_ready;	
	var vid_id;
	var vid_id_queue;
	var vid_pos_queue;
	
	var oldState;


	
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


	function Only2Rainbow(_up)
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

		_root.signals.signal("#(VERSION_NAME)","end",this);

		anim=0;
	
		file_name="#(file_names[1])";
		file_lines=#(file_names[1])_lines;
		
		
		mc=gfx.create_clip(up.mc,null);
		
		mc.vid=gfx.create_clip(mc,null);
		vid=gfx.create_clip(mc.vid,null);
		mc.vid.onRelease=delegate(click,m);
		
// loader object doesnt even work for this so why are we using it?
		loader={};
		loader.mcloader = new MovieClipLoader();
		vid_ready=false;
		show_youtube();
		oldState=0;
		
/*
		gfx.clear(mc);
		mc.style.fill=0xff000000;
		gfx.draw_box(mc,0,0,0,640,480);
*/
		
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
		hide_youtube();
		
		_root.poker.ShowFloat(null,0);

		Mouse.removeListener(this);
		
		mc.removeMovieClip(); mc=null;	
	}
	
	function hide_youtube()
	{
		vid.mute();
		vid.stopVideo();
		vid.clearVideo();
		vid.loadVideoById("00000000000",0,"small");
		vid.mute();
		vid.stopVideo();
		vid.clearVideo();
		vid.destroy();
		loader.mcloader.unLoadClip(vid);
	}
	function show_youtube()
	{
		loader.mcloader.loadClip("http://www.youtube.com/apiplayer?disablekb=1&hd=0", vid);
	}
	
	function onRelease() // steal mouse clicks
	{
		if( vid.getPlayerState()==1 ) // playing
		{
			getURL(vid.getVideoUrl()+"#t="+Math.floor(vid.getCurrentTime()),"_blank"); // send them to youtube at the current point in the video
			vid.pauseVideo();
		}
		else // start playing again
		{
			vid.playVideo();
		}
	}

// youtube is loader
// my chat is loaded
// so lets set things up
	function onReady()
	{
		vid.addEventListener("onStateChange", delegate(onStateChange) );
		vid.addEventListener("onError", delegate(onError) );
		
		vid.setSize(640,480);
		
		if(_root.server_json.vid) // chat told us what to play
		{
			play_vid(_root.server_json.vid,0);
		}
		else
		{
			play_vid("FuX5_OWObA0",0);
		}
		
		vid.setVolume(100);
	}
	
//Returns the state of the player. Possible values are unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5). 
	function onStateChange(newState)
	{
//dbg.print("New player state: "+ newState);

		if( (newState==0) && (oldState==1) ) // check if we ended 
		{
			if(vid_id_queue) // have one ready for when this ends
			{
				play_vid(vid_id_queue,vid_pos_queue);
			}
			oldState=0;
		}
		
		if(newState==1) // remember we started
		{
			oldState=1;
		}
	}

// error?
	function onError(errorCode)
	{
//dbg.print("An error occurred: "+ errorCode);
	}
	
	function play_vid(id,pos)
	{
		vid_id_queue=id; // loop
		vid_id=id;

		oldState=0;
		vid.stopVideo();
		vid.clearVideo();
		
		vid.loadVideoById(id,pos,"small");
		
		oldState=0;
			
	}
	
	function queue_vid(id,pos)
	{
		vid_id_queue=id;
		vid_pos_queue=pos;
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
						switch(me.under[1])
						{
							case "url":
							getURL("http://only2.wetgenes.com/","_blank");
							break;
							
							case "scores":
								up.high.setup();
							break;
							
							default:
							getURL("http://www.youtube.com/watch?v="+vid_id,"_blank");
//								anim=4;
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
	var part=Math.floor(anim);
	
		f=anim-part;
		s=MainStatic.spine(f);
		
		switch( part )
		{
			case 0:
			break;
		}
		if(!vid_ready) // wait for youtube to load
		{
		    if(vid.isPlayerLoaded())
			{
				vid_ready=true;
				onReady();
		    }
			else
			{
				return;
			}
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
