/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#DOTICKER=false

// WTF scroller

#GFX="gfx2"

class WTF_import
{
	var mc:MovieClip;
	var mc_scalar:MovieClip;
	
	var up;
	
	var sock;
	var talk;

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	
	var position_sc;
	var dowetdike;
	
	var poker2;
	
	var standalone;
	
	var con;
	
	var playj;
	
	// --- Main Entry Point
	static function main()
	{
	
		System.security.allowDomain( _root._url );
		System.security.allowDomain( _root._url.split("/")[2] );
		System.security.allowDomain("s3.wetgenes.com");
		System.security.allowDomain("www.wetgenes.com");
		System.security.allowDomain("swf.wetgenes.com");
		System.security.allowDomain("data.wetgenes.com");
		System.security.allowDomain("www.wetgenes.local");
		System.security.allowDomain("swf.wetgenes.local");
		System.security.allowDomain("data.wetgenes.local");

// this doesnt work on flahs seven... so we need the above too		
		System.security.allowDomain("*");
		
		System.security.loadPolicyFile("http://swf.wetgenes.com/crossdomain.xml");
		System.security.loadPolicyFile("http://data.wetgenes.com/crossdomain.xml");
		System.security.loadPolicyFile("http://wet.appspot.com/crossdomain.xml");
		

//		System.security.loadPolicyFile("http://swf.wetgenes.local/crossdomain.xml");
//		System.security.loadPolicyFile("http://data.wetgenes.local/crossdomain.xml");
		
//
		
		if(!_root.mc) { _root.mc=_root; }
		
		if(!_root.wtf_import)
		{
			_root.wtf_import=new WTF_import();
		}
		

	}
	
	var score=0;
	
	var seed=0;
	var game="unknown";
	var score_last=0;
	var sent_stamp=0;
	var score_name="spew";
	
	function send_spesh(nam,num) // send a score event to my chat
	{
		if(_root.sock) // talk to my chat client
		{
		var gmsg={ gcmd:"signal" , stype:"score", sgame:game , sseed:seed, snam:nam, snum:num}
		
			_root.sock.gmsg( gmsg , undefined);
		}
	}
	
	function send_score()
	{
	var date=new Date();
	
		score_last=score;
		sent_stamp=date.getTime();
		
		send_spesh(score_name,score);
	}
	
	function send_score_check()
	{
		if(score>score_last)
		{
			send_score();
		}
	}
	
	function send_score_wait_and_check()
	{
	var date=new Date();
	
		if( ( date.getTime() - sent_stamp ) > 1000*15 ) // send new score no more than once every 15secs
		{
			send_score_check();
		}
	}

	
	function con_score(nam,dat)
	{
	var date=new Date();

//	#(DBG).print("import ->" + nam + " : " + dat);

		if(game=="unknown") // send 0 first always
		{
			score=0;
			game=_root.gamename;
			score_name="score";
			send_score();
			sent_stamp=0;
		}

		switch(nam)
		{
			case "update": // an ongoing score, 0 probably indicates a start :)
			
				score=Math.floor(dat);
				game=_root.gamename;
				score_name="score";
				if(score==0)
				{
					send_score();
					sent_stamp=0; // but do not wait
				}
				else
				{
					send_score_wait_and_check();
				}
			break;
			
			case "final": // the final score of a game
				score=Math.floor(dat);
				game=_root.gamename;
				score_name="final";
				send_score();
			break;
		}
	}

	function WTF_import()
	{
		setup();
	}
	
	function setup()
	{
		if(_root.wetcon) // open coms
		{
			con= new LocalConnection();	
			con.allowDomain=function(){return true;};
			
			con.score=delegate(con_score,0);
			
			con.connect("_"+_root.wetcon); // this may randomly block, hurrarararararara need to pick a random com port to prevent this most of the time...
		}


// set up a poker or scalar if we need one		
		standalone=false;
		if(!_root.scalar)
		{
			if(_root.dozxmode) // special specy mode
			{
//				standalone=true;
				_root.scalar=new Scalar2(100*320/800,100*240/600,true);
			}
			else
			{
				standalone=true;
				_root.scalar=new Scalar2(400,600);
			}
		}
		
		
		
		up=null;
		
		if(_root.signals.up) { up=_root.signals.up; }
			
		if(_root.wtf.mc_import)
		{
			mc=#(GFX).create_clip(_root.wtf.mc_import,null);
		}
		else
		if(_root.wetdike.mc_import)
		{
			mc=#(GFX).create_clip(_root.wetdike.mc_import,null);
		}
		else
		{
			mc=#(GFX).create_clip(_root,16384+32-3);
		}
		
		mc_scalar=#(GFX).create_clip(mc,16384);

		
		mc.style={	fill:0xffffffff,	out:0xffffffff,	text:0xffffffff	};
		
		mc.onEnterFrame=delegate(update,0);
		

		poker2=new Poker2(false);

		if(!_root.poker)
		{
			_root.poker=poker2;
		}
		
		
// if we are loaded alone, display anyway

		if((!_root.wtf)&&(!_root.dozxmode))
		{
			Stage.scaleMode="noScale";
			Stage.align="TL";
		}
				
		sock=new WetSpewSock(this,standalone);
		_root.sock=sock;
		
		talk=new WetSpewTalk(this);
		_root.talk=talk;
		
		_root.talk.setup();
		_root.talk.mc._x=800;
		
		
		playj=new PlayJPEG(this);
		
		
/*		
		mc.vid=#(GFX).add_clip(mc,"vid_320x240");
		mc.cam=Camera.get();
		mc.vid.video.attachVideo(mc.cam);
*/
	}

	function update()
	{
		if(Key.isDown(123)) // screenshot on f12
		{
			playj.setup();
		}

		if( game!="unknown" )
		{
			send_score_wait_and_check();
		}
		
		_root.scalar.apply(_root.talk.mc_scalar);
		_root.scalar.apply(mc_scalar);
		
		poker2.update();
		
		_root.sock.update();
		_root.talk.update(poker2.snapshot());


//		build_jpeg_update();
	}
	
	function clean()
	{
	}
	
	
}


