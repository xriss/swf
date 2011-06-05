

/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class WetBaseMentTitle
{
	var up;
	var mc;
	
	var mcs;
	
	var types;
	var it;
	var over;
	var launches;
	var poke_wait;
	
	var done_load;
	
	var wave_frame=0;
	
static	var mcnames=["back","end2","puz2","end1","puz1","code2","shop2","code1","shop1","me1","me2","me3","dia1","dia2","dia3","dia4","dia5"];
	
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
		
		mc=gfx.create_clip(up.mc,null);
		
		mcs=new Array()
		
		for(i=0;i<mcnames.length;i++)
		{
		var pmc;
		
			pmc=mc;
			
			switch( mcnames[i] )
			{
				case "shop1":
				case "shop2":
					if(!mcs[ "shop" ])
					{
						mcs[ "shop" ]=gfx.create_clip(pmc,null);
					}
					pmc=mcs[ "shop" ];
				break;
				
				case "code1":
				case "code2":
					if(!mcs[ "code" ])
					{
						mcs[ "code" ]=gfx.create_clip(pmc,null);
					}
					pmc=mcs[ "code" ];
				break;
				
				case "puz1":
				case "puz2":
					if(!mcs[ "puz" ])
					{
						mcs[ "puz" ]=gfx.create_clip(pmc,null);
					}
					pmc=mcs[ "puz" ];
				break;
				
				case "end1":
				case "end2":
					if(!mcs[ "end" ])
					{
						mcs[ "end" ]=gfx.create_clip(pmc,null);
					}
					pmc=mcs[ "end" ];
				break;
				
				case "me1":
				case "me2":
				case "me3":
					if(!mcs[ "me" ])
					{
						mcs[ "me" ]=gfx.create_clip(pmc,null);
					}
					pmc=mcs[ "me" ];
				break;
			}

			mcs[i]=gfx.add_clip(pmc,"swf_splash",null);
			mcs[i].gotoAndStop(i+1);
			
			mcs[i].cacheAsBitmap=true;
			
			mcs[i].id=mcnames[i];
			
			mcs[ mcnames[i] ]=mcs[i];
		}
		
		mcs[ "puz" ].onRelease=delegate(click,"puz");
		mcs[ "end" ].onRelease=delegate(click,"end");
		mcs[ "shop" ].onRelease=delegate(click,"shop");
		mcs[ "code" ].onRelease=delegate(click,"code");
		
		
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

		
		for(i=0;i<5;i++)
		{
			it[i]=new FieldItem(this);
			it[i].setup(types[i]);
			it[i].mc._visible=false;
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

	function click(ids)
	{
		switch(ids)
		{
			case "shop":
				getURL("http://link.WetGenes.com/link/#(VERSION_NAME).shop","_bank");
			break;
			case "code":
				up.code.setup();
			break;
			
			case "puz":
				up.play.gamemode="puzzle";
				up.state_next="play";
			break;
			case "end":
				up.play.gamemode="endurance";
				up.state_next="play";
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
		
		
/*
		if(done_load)
		{
			_root.bmc.create(mc,"kriss"+frame_i+"0",100,400,400);
			frame_i++;
			if(frame_i>=8) { frame_i=0; }
		}
*/
		
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
		
		if( mcs[ "puz" ].hitTest( _root._xmouse, _root._ymouse, true) )
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
		
		if( mcs[ "end" ].hitTest( _root._xmouse, _root._ymouse, true) )
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
		
		var shooter=-1;
		
		if( mcs[ "dia1" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			shooter=3;
		}
		if( mcs[ "dia2" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			shooter=2;
		}
		if( mcs[ "dia3" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			shooter=0;
		}
		if( mcs[ "dia4" ].hitTest( _root._xmouse, _root._ymouse, true) )
		{
			shooter=1;
		}
		if( mcs[ "dia5" ].hitTest( _root._xmouse, _root._ymouse, true) )
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
	
}