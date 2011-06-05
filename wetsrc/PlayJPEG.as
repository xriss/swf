/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


#GFX=GFX or "gfx"

class PlayJPEG
{
	var up;
	
	var mcbs;
	var mcb;
	var mc;
	
	var mcs;
	var tfs;
	
	var done;
	var steady;
	
	var pause;

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function PlayJPEG(_up)
	{
		up=_up;
	}
	
	function setup()
	{
	var i;
	var bounds;
	var mct;
	var s;
	
		pause=false;
		
		if(_root.popup_jpeg) { return; }
		
		build_jpeg_start();
	
		_root.popup_jpeg=this;
		
		mcs=new Array();
			
		mcbs=#(GFX).create_clip(up.mc,16384+1024);
		mcb=#(GFX).create_clip(mcbs);
		if( ( ( _root.scalar.ox==640 ) || ( _root.scalar.ox==960 ) ) && ( _root.scalar.oy==480 ) )// our size
		{
			mc=mcb;
		}
		else
		{
			if( _root.scalar.ox <= 400 )
			{
				mcb._xscale=Math.floor(100 * (_root.scalar.ox/640));
				mcb._yscale=Math.floor(100 * (_root.scalar.ox/640));
				
			}
			else
			{
				mcb._xscale=Math.floor(100 * (_root.scalar.oy/480));
				mcb._yscale=Math.floor(100 * (_root.scalar.oy/480));
			}
			
			
			mc=#(GFX).create_clip(mcb,null);
		}
		
		mcb.cacheAsBitmap=true;

		
		#(GFX).dropshadow(mcb,5, 45, 0x000000, 1, 20, 20, 2, 3);
//	    mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 20, 20, 2, 3) ];
		
		
		mc._y=0;
		
		mc.dx=0;
		mc._x=-800;
		
		mc.onEnterFrame=delegate(update,null);

		done=false;
		steady=false;
		
		#(GFX).clear(mc);
				
		mcs[0]=#(GFX).create_clip(mc,null);
		
		mcs[1]=#(GFX).create_clip(mc,null);
		
		add_bmp_mc();
		
		mcs[3]=#(GFX).create_clip(mcs[1],null);
		#(GFX).clear(mcs[3]);
		mcs[3].style.out=0xffffffff;
		mcs[3].style.fill=0xffffffff;
		#(GFX).draw_box(mcs[3],0,(640-400)/2,20,400,20);
		
		new_butt("cam","<p align='center'>WebCam</p>",120,450,100,20);
		new_butt("pause","<p align='center'>Pause</p>",270,450,100,20);
		new_butt("close","<p align='center'>Close</p>",420,450,100,20);
		
		Mouse.addListener(this);

		_root.scalar.apply(mcbs);
	}
	
	function add_bmp_mc()
	{
		mcs[2]=#(GFX).create_clip(mcs[1],null);
		mcs[2].attachBitmap(bmp,0,"auto",true);
		
		mcs[2]._x=(640-400)/2;
		mcs[2]._y=(480-400)/2;
		
		var ww=bmp.width;
		if(bmp.height>bmp.width) ww=bmp.height;
		
		mcs[2]._xscale=Math.floor(100*(400/ww));
		mcs[2]._yscale=Math.floor(100*(400/ww));
		
		ww=mcs[2]._xscale*bmp.width/100;
		mcs[2]._x=(640-ww)/2;
	}
	
	function clean()
	{
		if(_root.popup_jpeg != this)
		{
			return;
		}
		_root.main.fast_update=false;
		
		_root.popup_jpeg=null;
		
		mc.removeMovieClip();
		mcb.removeMovieClip();
		
		Mouse.removeListener(this);
	}
	
	

	function onRelease()
	{

		if(steady)
		{
//			if(!wf_loaded) // allow exit before load
			{
				done=true;
				mc.dx=_root.scalar.ox;
			}
		}
	}

	function finish()
	{
		done=true;
		mc.dx=_root.scalar.ox;
	}

	function update()
	{
		_root.scalar.apply(mcbs);
	
		mc._x+=(mc.dx-mc._x)/4;

		if( (mc._x-mc.dx)*(mc._x-mc.dx) < (16*16) )
		{
			steady=true;
			if(encoding==0)
			{
				clean();
			}
		}
		else
		{
			steady=false;
		}
		
		if(steady)
		{
			if(!pause)
			{
				build_jpeg_update();
			}
		}
		
	}
		
	
	var bmp;
	var jpeg;
	var encoding=0;
	
	var encode_count;
	var encode_total;
	var encode_percent;
	function build_jpeg_start()
	{
		encode_count=0;
		encode_total=0;
		encode_percent=0;
	
		var m=new flash.geom.Matrix();
		m.translate(-_root.scalar.dx,-_root.scalar.dy);
		var w=Stage.width-(_root.scalar.dx*2);
		var h=Stage.height-(_root.scalar.dy*2);
		
		if(mc.vid) // special webcam
		{
			bmp=new flash.display.BitmapData(640,480,false,0x00000000);
			bmp.draw(mc.vid.video);
		}
		else
		{
		
//		w=Math.ceil(w/8)*8;
//		h=Math.ceil(h/8)*8;
			bmp=new flash.display.BitmapData(w,h,false,0x00000000);
			bmp.draw(_root,m);
			
			var bmpt=new flash.display.BitmapData(w/8,h/8,false,0x00000000);
			var mt=new flash.geom.Matrix();
			mt.scale(1/8,1/8);
			bmpt.draw(bmp,mt);
			
			var badcapture=true;
			var x,y;
			
			for(y=0;y<bmpt.height;y++)
			{
				for(x=0;x<bmpt.width;x++)
				{
					if( bmp.getPixel32(x,y)&0xffffff != 0x000000) { badcapture=false; break; }
				}
				if( badcapture==false) { break; }
			}
			
	//_root.talk.chat_status("grabbed screen");
			if(badcapture) // try a chat only grab
			{
	//_root.talk.chat_status("trying regrab");
				var mct=_root.talk.mc;
				
				if(mct)
				{
					var old_opts_vids=false;
					
					if(_root.talk.wetv) // hide?
					{
						old_opts_vids=_root.talk.opts.vids;
						_root.talk.opts.vids=false;
						_root.talk.resize_chat_force();
	//_root.talk.chat_status("hidden youtube");
					}
					
					bmp=new flash.display.BitmapData(400,600,false,0x00000000);
					bmp.draw(mct);
					
					if(old_opts_vids)
					{
						_root.talk.opts.vids=old_opts_vids;
						_root.talk.resize_chat_force();
	//_root.talk.chat_status("showing youtube");
					}
				}
			}
		}
		
		encode_total=Math.floor( (bmp.width/8)*(bmp.height/8) );
		
		if(!jpeg) { jpeg=new JPEG(); }
		
		jpeg.encode_start(bmp,75);
		
		encoding=1;
	}
	function build_jpeg_update()
	{
		if( encoding==0 )
		{
			_root.main.fast_update=false;
			return;
		}
		_root.main.fast_update=true;
		
		var a=jpeg.encode_update_count(40);
//		var a=jpeg.byteout;
		
		if(!a)
		{
		encode_count+=40;
		
			encode_percent=Math.floor(100*encode_count/encode_total)
			
		#(GFX).clear(mcs[3]);
		mcs[3].style.out=0xffffffff;
		mcs[3].style.fill=0x40ffffff;
		#(GFX).draw_box(mcs[3],0,(640-400)/2,20,400,20);

//		#(GFX).clear(mcs[3]);
		mcs[3].style.out=0xffffffff;
		mcs[3].style.fill=0xffffffff;
		#(GFX).draw_box(mcs[3],0,(640-400)/2,(20),4*encode_percent,20);
		
//dbg2.print("encoding "+ encode_percent + " : "+jpeg.byteout.length);
		}
		else
		{
//dbg2.print("done "+a.length);
			encoding=0;
			var lv=new LoadVars();
			lv.jpeg=Clown.bytes_to_pak(a);
			lv.onLoad = delegate(jpeg_post,lv);
			lv.sendAndLoad("http://"+_root.host+"/swf/jpeg.php",lv,"POST");

		}
		
	}
	
	function jpeg_post(succ,lv)
	{
//dbg2.print(lv.hosted);
		if(lv.hosted)
		{
			_root.sock.chat(lv.hosted);
		}
	}
	
	function butt_over(b)
	{
		b._alpha=100;
	}
	function butt_out(b)
	{
		b._alpha=75;
	}
	function butt_up(b)
	{
	}
	
	function butt_press(b)
	{
		switch(b.id)
		{
			case "cam":
				pause=true;
				
				if(mc.vid)
				{
					build_jpeg_start();
					add_bmp_mc();
					#(GFX).set_text_html(b.tf,16,0xffffff,"<p align='center'>WebCam</p>");
					mc.vid.removeMovieClip();
					mc.vid=undefined;
					pause=false;
				}
				else // show cam
				{
					#(GFX).create_clip(mcs[2],0); // clear old bitmap

					mc.vid=#(GFX).add_clip(mc,"vid_640x480",undefined,80,70,75,75);
					mc.cam=Camera.get();
//					mc.cam.setQuality(0,100);
					mc.cam.setMode(640,480,15,true);
					mc.vid.video.attachVideo(mc.cam);
					
					#(GFX).set_text_html(b.tf,16,0xffffff,"<p align='center'>Capture</p>");
//					#(GFX).set_text_html(b.tf,16,0xffffff,"<p align='center'>"+mc.cam.width+"</p>");
				}
		
			break;
			case "pause":
				pause=!pause;
				
				if(mc.vid)
				{
					pause=true;
				}
				
				if(pause)
				{
					#(GFX).set_text_html(b.tf,16,0xffffff,"<p align='center'>Continue</p>");
				}
				else
				{
					#(GFX).set_text_html(b.tf,16,0xffffff,"<p align='center'>Pause</p>");
				}
			break;
			case "close":
				clean();
			break;
		}
	}
	
	function new_butt(id,s,x,y,w,h)
	{
	var b;
	
		b=#(GFX).create_clip(mc);
		b.id=id;
		
		b.onRollOver=delegate(butt_over,b);
		b.onRollOut=delegate(butt_out,b);
		b.onReleaseOutside=delegate(butt_out,b);
		b.onRelease=delegate(butt_press,b);
		
		b._x=x;
		b._y=y;
		b.tf=#(GFX).create_text_html(b,null,0,0,w,h+4);
		#(GFX).clear(b);
		b.style.fill=0x80000000;
		b.style.out=0x80ffffff;
		#(GFX).draw_box(b,3,-4,-4,w+8,h+8);
		#(GFX).set_text_html(b.tf,16,0xffffff,s);
		
		b._alpha=75;
		
		b.cacheAsBitmap=true;
		
		return b;
	}
	
}
