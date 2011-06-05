/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// A collection of stacks of cards making up the game LIES!!!!

#CLASSNAME = CLASSNAME or "WetVPlay"

#GFX=GFX or "gfx"

class #(CLASSNAME)
{
	var info; // external

	var up; // main class

	var mc;
	var vid;
	var vid2;
	var over;
	
	var loader;
	var vid_ready;
	var spew_ready;
	
	var sent_info;
	var vid_id;
	var vid_id_queue;
	var vid_pos_queue;
	
	var oldState;
	
	var version;

	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function #(CLASSNAME)(_up)
	{
		up=_up;
		
version='X192342X_WETV_VERSION_STRING_X192342X=2010.12.28.23.59.59=X192342X_WETV_VERSION_STRING_X192342X';

	}
			
			
	var nojoin=false;
	
	var screensize_x;
	var screensize_y;

	function setup(_nojoin,_screensize)
	{	
	var i;
	var j;
	
		info=[]; // externally available info, kept up to date
		info.vid="";
		info.title="";
		info.len=0; // vid length
		info.lock=0; // vid time lock
		info.pos=0; // how far through video we are
	
		screensize_x=640;
		screensize_y=480;
		
		if(_screensize)
		{
			var aa=_screensize.split("x"); // probably 800x600 (4:3) or 1067x600 (16:9)
			
			screensize_x=Math.floor(aa[0]);
			screensize_y=Math.floor(aa[1]);
		}
		nojoin=_nojoin;
		
//		screensize_x*=0.25;
//		screensize_y*=0.25;
			
		mc=#(GFX).create_clip(up.mc,null);
		mc.vid=#(GFX).create_clip(mc,null);
		vid=#(GFX).create_clip(mc.vid,null);
		over=#(GFX).create_clip(mc,null);
		vid2=#(GFX).create_clip(mc,null);
		
//		mc.vid._xscale=400;
//		mc.vid._yscale=400;
		
		over.onRelease=delegate(onRelease);
		
		over.hitArea=#(GFX).create_clip(mc,null);
		#(GFX).clear(over.hitArea);
		#(GFX).draw_box(over.hitArea,0,0,0,screensize_x,screensize_y);
		over.hitArea._visible=false;
		

// loader object doesnt even work for this so why are we using it?
		loader={};

//		loader.mcloader.loadClip("http://www.youtube.com/v/FBxJqcX8ErU", mc);

		loader.mcloader = new MovieClipLoader();
		
		show_youtube();
		
		oldState=0;
		
	}
	
	function clean()
	{
		hide_youtube();
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
//		vid=undefined;
	}
	function show_youtube()
	{
	
/*
		if(true)
		{
			_root.channel="vidyavidya";
			_root.autoPlay="true";
			loadMovie("http://cdn.livestream.com/chromelessPlayer/wrappers/JSPlayer.swf?channel=vidyavidya&autoPlay=true",vid._target);
		}
		else
*/
	
		if(_root.spew_opts.vids_hq)
		{
			loader.mcloader.loadClip("http://www.youtube.com/apiplayer?disablekb=1", vid);
		}
		else
		{
			loader.mcloader.loadClip("http://www.youtube.com/apiplayer?disablekb=1&hd=0", vid);
		}
		vid_ready=false;
		spew_ready=false;
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
		
		vid.setVolume(100);
		vid.setSize(screensize_x,screensize_y);

// request all gmsgs to be set to gmsgback

		_root.sock.gmsg( null , delegate(gmsgback,null) );
			
// join normal tv room

//		if(!nojoin)
//		{
//			_root.sock.chat("/join public.tv");
//		}

// request all msgs
		_root.sock.gmsg( null , delegate(gmsgback,null) );
			
// send ready msg to server so it tells us what to play now and next
		gmsgsend({gcmd:"wetv",wetv:"ready"});
		
		sent_info=true;
		vid_id=null;

	}
	
//Returns the state of the player. Possible values are unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5). 
	function onStateChange(newState)
	{
//dbg.print("New player state: "+ newState);

		if( (newState==0) && (oldState==1) ) // check if we ended 
		{
			gmsgsend({gcmd:"wetv",wetv:"info",video:vid_id,length:0});
			
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

// signal an error with a length of 0		
		gmsgsend({gcmd:"wetv",wetv:"info",video:vid_id,length:0});
		sent_info=true;
	}

var swishnames=
[
"sqr_shrink",
"sqr_rollup",
"sqr_plode"
];	
				
	function play_vid(id,pos)
	{
	var n=swishnames[rnd()%(swishnames.length-1)];
	
//		_root.swish.clean();
//		_root.swish=(new Swish( { style:n , mc:vid })).setup();
	
		vid_id_queue=null; // kill queue
		vid_id=id;

		oldState=0;
		vid.stopVideo();
		vid.clearVideo();
		
		if(_root.spew_opts.vids_hq)
		{
			vid.loadVideoById(id,pos,"hd720");
		}
		else
		{
			vid.loadVideoById(id,pos,"small");
		}
		
		oldState=0;
		sent_info=false; // send info when we get it
			
		info.id=id;
		info.pos=pos;
//		info.title=id;
//		info.lock=0;
		info.len=0;
	}
	
	function queue_vid(id,pos)
	{
		vid_id_queue=id;
		vid_pos_queue=pos;
	}

	function update()
	{
	var i;
	
//dbg.print("TV");

		if(!vid_ready) // wait for youtube to load
		{
		    if(vid.isPlayerLoaded())
			{
				vid_ready=true;
		    }
			else
			{
				return;
			}
		}
		if(!spew_ready) // wait for chat to load
		{
		    if(_root.sock.connected)
			{
				spew_ready=true;
				onReady();
		    }
			else
			{
				return;
			}
		}
				
		var len=vid.getDuration();
		var pos=vid.getCurrentTime();
		
		if(!sent_info) // send msg with video length or error after it starts
		{
			if(len > 0)
			{
// send the length of the video
				gmsgsend({gcmd:"wetv",wetv:"info",video:vid_id,length:len});
				sent_info=true;
			}
		}
				
		if(pos>0)
		{
			info.pos=pos;
		}
		if(len>0)
		{
			info.len=len;
		}
	
//		_root.signals.signal("WetV","update",this);
				
	}

	function do_str(str)
	{
		switch(str)
		{
			default:
				up.do_str(str)
			break;
		}
	}
	
	function got_play_msg(msg)
	{
	var aa;
	
		aa=msg.play.split(",");
		
		if(aa[0] && aa[1])
		{
//dbg.print(aa[0]+" : "+aa[1]);

			var id=aa[0];
			var pos=Math.floor(aa[1]);
			var dur=vid.getDuration();
			
			if	(
					(oldState==1)  // video is playing
					&&
					(
						( dur>0 && dur<10 ) // its a blip vid, just play it all and wait for it to end before starting the next one
					)
				)
			{
				queue_vid(id,pos)
			}
			else
			{
				play_vid(id,pos)
			}
		}
	}
	
	function got_title_msg(msg) // the name of the video
	{
			info.title=msg.title;
	}
	
	function got_lock_msg(msg) // also sends video length?
	{
			info.lock=msg.lock;
	}
	
	
	function gmsgsend(msg)
	{
	var idx;
	var s;
	
		if(_root.sock)
		{
			_root.sock.gmsg( msg , delegate(gmsgback,msg) );
			
//dbg.print("msgsend : "+msg.wetv);

		}
	}
	
	function gmsgback(msg,sentmsg)
	{
	var idx;
	var s;
	var a,i,aa,j;
		
		if(!sentmsg) // incoming
		{
//dbg.print("msgrecv : ***");
//dbg.dump(msg);

			switch(msg.gcmd)
			{
				case "wetv":
					switch(msg.wetv)
					{
						case "play":
							got_play_msg(msg);
						break;
						case "title":
							got_title_msg(msg);
						break;
						case "lock":
							got_lock_msg(msg);
						break;
					}
				break;
			}
		}
		else
		{	
//dbg.print("msgrecv : "+sentmsg.gcmd);
//dbg.dump(msg);

			switch(sentmsg.gcmd)
			{
				case "wetv":
				break;
			}
		}
	}
	
}
