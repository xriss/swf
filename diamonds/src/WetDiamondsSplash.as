

/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class WetDiamondsSplash
{
	var up;
	var mc;
	var mc_back;
	
	var mcs;
	
	var types;
	var it;
	var over;
	var launches;
	var poke_wait;
	
	var done_load;
	
	var wave_frame=0;
	
	var style=null;
	
static	var mcnames=["back","end2","puz2","end1","puz1","code2","shop2","code1","shop1","me1","me2","me3","dia1","dia2","dia3","dia4","dia5","ws2","ws1","about2","about1","digg","stum"];
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}

	function WetDiamondsSplash(_up)
	{
		up=_up;
	}

	function setup()
	{
	var i;
	var t;
	var tp;
	

/*
		_root.bmc.clear_loading();
		_root.bmc.remember( "kriss" , bmcache.create_url , 
		{
			url:"http://i123.photobucket.com/albums/o289/sxixs/kriss.png" ,
			bmpw:800 , bmph:600 ,
			hx:-50 , hy:-50
		} );
		done_load=false;
*/
		
		mc_back=gfx.create_clip(up.mc,null);
		gfx.clear(mc_back);
		mc_back.style.fill=0xff444488;
		gfx.draw_box(mc_back,0,0,0,800,600);
		mc_back.cacheAsBitmap=true;
		
		mc=gfx.create_clip(up.mc,null);
		
		mcs=new Array()
		
		for(i=0;i<interface_lines.length;i++)
		{
		var lin=interface_lines[i];
		var args=lin.split(",");
		var nam=args[0]
		var nams=nam.split("_");
		var m;
		
			m=gfx.add_clip(mc,"swf_interface",null);
			m.gotoAndStop(i+1);
			
			m._visible=false;
			
			m.nam=nam;
			m.nams=nams;
			
			if(style=="start")
			{
				switch(nams[0])
				{
					case "back":
						m._visible=true;
					break;
					case "mode":
						m._visible=true;
						if( (nam=="mode_puzzle") || (nam=="mode_endurance") || (nam=="mode_ws") )
						{
							make_button(m);
						}
					break;
				}
			}
			else
			{
				switch(nams[0])
				{
					case "back":
					case "backtitle":
					case "solid":
						m._visible=true;
					break;
					case "button":
						m._visible=true;
						make_button(m);
					break;
				}
			}
			
			m.cacheAsBitmap=true;
			
			mcs[ i ]=m;
			mcs[ nam ]=m;
		}
		
// disable ws, nobody used it...

		mcs[ "mode_ws" ]._alpha=80;
		mcs[ "mode_puzzle" ]._alpha=80;
		mcs[ "mode_endurance" ]._alpha=80;
		
		
		if(style=="start")
		{
		}
		else
		{
			types=new Array("fire","earth","air","water","ether");
			for(i=0;i<5;i++)
			{
				types[ types[i] ]=i;
			}
			
			over=new Object();
			over.up=up;
			over.mc=gfx.create_clip(mc,null);
			launches=new Array();
			it=new Array()

			over.tf=gfx.create_text_html(over.mc,null,10,10,200,50);
			
			over.bounces=0;
			over.bounces_max=0;
			
			for(i=0;i<5;i++)
			{
				it[i]=new FieldItem(this);
				it[i].setup(types[i]);
				it[i].mc._visible=false;
			}
			
			if(_root.pbem_id) // pbm setup
			{
				mcs[ "puz" ]._visible=false;
				mcs[ "end" ]._visible=false;
			}
		}
		
		
		poke_wait=0;
	}
	
	function clean()
	{		
		while(launches.length)
		{
			launches[0].clean();
			launches.splice(0,1);
		}
		
		mc.removeMovieClip();
	}
	
	function make_button(m)
	{		
		m.nam_alt=m.nams[0]+"2_"+m.nams[1];
		m.onRelease=delegate(click,m);
		m.onRollOver=delegate(hover_on,m);
		m.onRollOut=delegate(hover_off,m);
		m.onReleaseOutside=delegate(hover_off,m);
	}
	
	function do_lobby_close()
	{
		if(_root.swish) { _root.swish.clean(); _root.swish=null; }
		_root.swish=new Swish({style:"fade",mc:mc_back});
		_root.swish.setup();
		if(mc._visible==false) { mc._visible=true; }
	}

	function hover_on(m)
	{
		if( m.nam=="mode_puzzle" || m.nam=="mode_endurance" || m.nam=="mode_ws" )
		{
			m._alpha=100;
		}
		mcs[ m.nam_alt ]._visible=true;
		
		switch(m.nam)
		{
			case "button_about":
				_root.poker.ShowFloat("Did you know this game was made by real people?",25*10);
			break;
			case "button_logout":
				_root.poker.ShowFloat("Change your name? change your options?",25*10);
			break;
			case "button_shop":
				_root.poker.ShowFloat("You too can consume junk and support this game, it's like two things for the price of one :)",25*10);
			break;
			case "button_code":
				_root.poker.ShowFloat("Get the codes to place this game on your blog, profile or website.",25*10);
			break;
			case "mode_puzzle":
				_root.poker.ShowFloat("The daily puzzle, a new challenge every day. Play todays game or any in the last 10 days to increase your rank. Moves can only be made whilst the diamonds are at rest.",25*10);
			break;
			case "mode_endurance":
				_root.poker.ShowFloat("Diamonds fall randomly from above, just last as long as you can. Moves can and should be made while the diamonds are falling. The moment you stop, diamonds will freeze and the timer will count down.",25*10);
			break;
			case "mode_ws":
				_root.poker.ShowFloat("A Ws mode for profesional players to compete in. Please remember that you will need a friend to play this game against.",25*10);
			break;
		}
	}
	
	function hover_off(m)
	{
		_root.poker.ShowFloat(null,0);
		
		if( m.nam=="mode_puzzle" || m.nam=="mode_endurance" )
		{
			m._alpha=80;
		}
		mcs[ m.nam_alt ]._visible=false;
	}
	
	function click(m)
	{
	var link_url="diamonds.wetgenes.com";
	var link_desc1="WetDiamonds:+Swap+diamonds+to+match+three+or+more.";
	var link_desc2="+Play+multiplayer,+daily+puzzle+or+endurance+modes.";
	
		if(_root.popup) return;
		
		_root.poker.ShowFloat(null,0);
		
		switch(m.nam)
		{
			case "button_more":
				getURL("http://games.wetgenes.com/","_bank");
			break;
			case "button_shop":
				getURL("http://link.wetgenes.com/link/#(VERSION_NAME).shop","_bank");
			break;
			case "button_code":
				up.code.setup();
			break;
			case "button_about":
				up.about.setup();
			break;
			case "button_logout":
				up.do_str("logoff");
			break;
			
			case "mode_ws":
			
				if(_root.swish) { _root.swish.clean(); _root.swish=null; }
				_root.swish=new Swish({style:"sqr_plode",mc:mc});
				_root.swish.setup();

				up.lobby.setup();
				mc._visible=false;
			break;
			
			case "button_play":
				style="start";
				up.state_next="menu";
				if(_root.swish) { _root.swish.clean(); _root.swish=null; }
				_root.swish=new Swish({style:"slide_left",mc:mc});
				_root.swish.setup();
			break;
			
			case "mode_puzzle":
				style=null;
				up.play.gamemode="puzzle";
				up.state_next="play";
				if(_root.swish) { _root.swish.clean(); _root.swish=null; }
				_root.swish=new Swish({style:"slide_left",mc:mc});
				_root.swish.setup();
			break;
			case "mode_endurance":
				style=null;
				up.play.gamemode="endurance";
				up.state_next="play";
				if(_root.swish) { _root.swish.clean(); _root.swish=null; }
				_root.swish=new Swish({style:"slide_left",mc:mc});
				_root.swish.setup();
			break;
			
			case "digg":
				getURL("http://digg.com/submit?phase=2&url="+link_url+"&title="+link_desc1+"&bodytext="+link_desc1+link_desc2+"&topic=playable_web_games","_blank");
			break;
			case "stum":
				getURL("http://www.stumbleupon.com/submit?url=http://"+link_url+"&title="+link_desc1+link_desc2,"_blank");
			break;
		}
	}
	
	var frame_i;
	
	function update()
	{
	var i;
	
/*
		if(!done_load)
		{
		var pct;
		
			pct=100*_root.bmc.check_loading();
			
			if(pct==100) // all loaded
			{
			var x,y;
			
			
				for(x=0;x<8;x++)
				{
					for(y=0;y<6;y++)
					{
						_root.bmc.chop("kriss",("kriss"+x)+y,x*100,y*100,100,100);
					}
				}
				
				frame_i=0;
				
				done_load=true;
			}
		}
*/
		
		if(_root.popup) return;		
		
		if(mc._visible==false) { mc._visible=true; }
		
/*
		if(done_load)
		{
			_root.bmc.create(mc,"kriss"+frame_i+"0",100,400,400);
			frame_i++;
			if(frame_i>=8) { frame_i=0; }
		}
*/
/*
		
		if( mcs[ "digg" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{			
			_root.poker.ShowFloat("If you like this game, please tell your friends on Digg!",10);
		}
		if( mcs[ "stum" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{			
			_root.poker.ShowFloat("If you like this game, please tell your friends on StumbleUpon!",10);
		}
		
		
		if( mcs[ "about" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			mcs[ "about1" ]._visible=false;
			mcs[ "about2" ]._visible=true;
			
			_root.poker.ShowFloat("Did you know this game was made by real people?",10);
			
		}
		else
		{
			mcs[ "about1" ]._visible=true;
			mcs[ "about2" ]._visible=false;
		}
		
		if( mcs[ "ws" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			mcs[ "ws1" ]._visible=false;
			mcs[ "ws2" ]._visible=true;
			
			if(_root.pbem_id) // pbm setup
			{
				_root.poker.ShowFloat("A PBEM game is active and waiting! Click here to play the game.",10);
			}
			else
			{
				_root.poker.ShowFloat("Setup or join a multiplayer game.<br>This is BETA! I think it's working but please report any problems in a helpful fashion.",10);
			}
			
		}
		else
		{
			mcs[ "ws1" ]._visible=true;
			mcs[ "ws2" ]._visible=false;
		}
		
		if( mcs[ "shop" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			mcs[ "shop1" ]._visible=false;
			mcs[ "shop2" ]._visible=true;
			
			_root.poker.ShowFloat("You too can consume junk and support this game, it's like two things for the price of one :)",10);
		}
		else
		{
			mcs[ "shop1" ]._visible=true;
			mcs[ "shop2" ]._visible=false;
		}
		
		if( mcs[ "code" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			mcs[ "code1" ]._visible=false;
			mcs[ "code2" ]._visible=true;
			
			_root.poker.ShowFloat("Get the codes to place this game on your blog, profile or website.",10);
		}
		else
		{
			mcs[ "code1" ]._visible=true;
			mcs[ "code2" ]._visible=false;
		}
		
		if( mcs[ "puz" ].hitTest( _root._xmouse, _root._ymouse, true) && mcs[ "puz" ]._visible )
		{
			mcs[ "puz1" ]._visible=false;
			mcs[ "puz2" ]._visible=true;
			
			_root.poker.ShowFloat("The daily puzzle, a new challenge every day. Play todays game or any in the last 10 days to increase your rank. Moves can only be made whilst the diamonds are at rest.",10);
		}
		else
		{
			mcs[ "puz1" ]._visible=true;
			mcs[ "puz2" ]._visible=false;
		}
		
		if( mcs[ "end" ].hitTest( _root._xmouse, _root._ymouse, true)  && mcs[ "end" ]._visible )
		{
			mcs[ "end1" ]._visible=false;
			mcs[ "end2" ]._visible=true;
			
			_root.poker.ShowFloat("Diamonds fall randomly from above, just last as long as you can. Moves can and should be made while the diamonds are falling. The moment you stop, diamonds will freeze and the timer will count down.",10);
		}
		else
		{
			mcs[ "end1" ]._visible=true;
			mcs[ "end2" ]._visible=false;
		}
		
		
		mcs[ "me1" ]._visible=false;
		mcs[ "me2" ]._visible=false;
		mcs[ "me3" ]._visible=false;

		if( mcs[ "me" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			wave_frame++;
			switch(Math.floor(wave_frame/16)%2)
			{
				case 0:
					mcs[ "me2" ]._visible=true;
				break;
				case 1:
					mcs[ "me3" ]._visible=true;
				break;
			}
		}
		else
		{
			mcs[ "me1" ]._visible=true;
		}
*/
		
		for(i=0;i<launches.length;i++)
		{
			if(launches[i].update_launch())
			{
				launches[i].clean();
				launches.splice(i,1);
				i--;
//				dbg.print("killed launch");
//				launches.length--;
			}
		}
		if( over.bounces_max < over.bounces ) // spot and remember max
		{
			 over.bounces_max = over.bounces ;
		}
		gfx.set_text_html(over.tf,16,0xffffff,"bounces : "+over.bounces_max+" / "+over.bounces);
		
		var shooter=-1;
		
		if( mcs[ "solid_water" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			shooter=3;
		}
		if( mcs[ "solid_air" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			shooter=2;
		}
		if( mcs[ "solid_fire" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			shooter=0;
		}
		if( mcs[ "solid_earth" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			shooter=1;
		}
		if( mcs[ "solid_ether" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			shooter=4;
		}
		
		if(_root.poker.poke_now || shooter>=0 )
		{
		var l;
		var t;
			if(poke_wait<=0)
			{
				poke_wait=1;
				if(shooter>=0)
				{
					l=it[shooter];
					l.setxy(mc._xmouse,mc._ymouse);
				}
				else
				{
					l=it[rnd()%5];
					l.setxy(mc._xmouse,mc._ymouse);
				}
				t=l.launch( ((rnd()&255)-128)/8 , ((rnd()&255)-512)/8 );
				t.mc._xscale=50;
				t.mc._yscale=50;
				t.mc._rotation=rnd()%360;
				var fr=rnd()%20;
				for(i=0;i<fr;i++)
				{
					t.nextframe();
				}
			}
		}
		if(poke_wait>0)
		{
			poke_wait--;
		}
		
	}
	
	static var interface_lines=[
#for line in io.lines("art/interface.txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""
	];
}