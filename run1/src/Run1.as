/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"




class #(VERSION_NAME)
{
	var state_last;
	var state;
	var state_next;

	var	setup_done;

	var mc;

	var choose;
	var zoo;
	var play;
	var title;
	var over;
	var about;
	var code;
	var high;
	
	var game_seed;
	
	var game_seed_today; // today, use today-9 rather than today+1 when we move into the future
	var game_seed_start; // the day to start level 1 on, +9 for level 10 
	
	var levels;
	var tards;
	
	var level_idx=1;
	var tard_idx=1;
	
	var old_time;
	var update_time;
	
	var v;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	static function main()
	{
		if(_root.kongregateServices!=undefined)
		{
			_root.kongregateServices.connect();
			_root.wethidemochiads=true; // kong disables them anyway
		}
		
		var orset_root=function(a,b)
		{
			if(_root[a]==undefined) { _root[a]=b; }
		}
		orset_root("host","swf.wetgenes.com");
		
//		_root._highquality=2;

//		_root.wethidemochiads=true;
		
		_root.gotoAndStop(1); // frame 1 is preload, frame 2 is everything loaded
		
// overide only basic wetplay settings

//		orset_root("wp_xspf","http://basement.wetgenes.com/swf/WetBaseMent.xspf");
		orset_root("wp_auto",0);
		orset_root("wp_shuffle",0);
		orset_root("wp_back",0xff000000);
		orset_root("wp_fore",0xffffffff);
		
		orset_root("lockfps",false);
				
		_root.cacheAsBitmap=false;		
		_root.newdepth=1;
		
		_root.mc_popup=gfx.create_clip(_root,16383);
		_root.popup=null;	// put a popup class in here to halt normal operation
		_root.updates=MainStatic.update_setup();	// a table of update functions
		
		_root.bmc=new bmcache();
		
		_root.replay=new Replay();
		
		_root.scalar=new Scalar(800,600);
		_root.poker=new Poker(false);
		_root.loading=new Loading(true);
		_root.wetplay=new WetPlayIcon();
		_root.login=new Login(true);
		
		_root.run1=new  Run1();
//		_root.signals=new BetaSignals(_root.run1);
		_root.comms=new BetaComms(_root.run1);
		
		_root.wtf=new WTF("show_nowplaying");
	}



	function #(VERSION_NAME)()
	{
	var date=new Date();
	var i;
	var t;
	var tt;
	var lev;
	var idx;
	
		v=[];
		v.name='#(VERSION_NAME)';
		v.site='#(VERSION_SITE)';
		v.number='#(VERSION_NUMBER)';
		v.stamp='#(VERSION_STAMP)';
		v.stamp_number='#(VERSION_STAMPNUMBER)';
		
		setup_done=false;
		
		game_seed=Math.floor(((date.getTime()/1000))/(24*60*60))&0xffff;
		game_seed_today=game_seed; // remember today
		game_seed_start=game_seed - (game_seed%10) ; // and the 1st seed for the 10 levels
		
		
		mc=gfx.create_clip(_root,null);
		mc.onEnterFrame=delegate(update);
		mc.scrollRect=new flash.geom.Rectangle(0, 0, _root.scalar.ox, _root.scalar.oy);
		
		
		levels=[];
		levels[ 1]=new Run1Level_level_01();
		
		for(i=1;i<=1;i++) // pick the seeds for each level based around today
		{
			lev=levels[i];
/*			
			t=game_seed_start+(i-1);
			if(t>game_seed_today) { t=t-10; } // do not play into the future
			
			lev.game_seed=t;
*/			
			lev.game_seed=game_seed_today;
		}
		
		var	tf=function(_t,tim,id,anim,txt)
		{
		var ti={};
			ti.tim=tim+(txt.length*2);
			ti.id=id;
			ti.txt=txt;
			ti.anim=anim;
			
			_t[_t.length]=ti;
		};
		
		var tf_norm=function(_t,tim,id,anim,txt) // just display
		{
			tf(_t,tim,id,anim,txt);
		}
		
		var tf_idle=function(_t,tim,id,anim,txt) // go back to idle anim after
		{
			tf(_t,tim,id,anim,txt);
			tf(_t,0,id,"idle",null);
		}

		
		lev=levels[1];
		lev.name="There is no mute!";
		lev.chat_start=null;
		
		
		tards=[];
		idx=1;
		
		t={}; t.name="Shi";				t.img1="vtard_shi";	t.idx=idx;	tards[idx++]=t;
		
	}
	
	function setup()
	{
	
		
		state_last=null;
		state=null;
		state_next=null;

		play=new Run1Play(this);
		title=new Run1Title(this,"title_all",play);
		
		about=new PlayAbout(this);
		code=new PlayCode(this);
		high=new PlayHigh(this,"hide_last");
		
		over=new OverField( { up:this , mc:gfx.create_clip(mc,0x10008) } );
		over.setup();
		
		
		state_next="play";
//		state_next="title";
		
		
		{
		var cm;
		var cmi;
		var f;
		
			cm=MainStatic.get_base_context_menu(this);

			f=function()
			{
				if(!_root.popup)
				{
					this.state_next="title";
					this.title.state_next="title_all";
				}
			};
			cmi = new ContextMenuItem("Quit to Main Menu.", delegate(f) );
			cm.customItems.push(cmi);
			
			f=function()
			{
			var i;
				if(_root.lockfps)
				{
					_root.lockfps=false;
				}
				else
				{
					_root.lockfps=true;
				}
				
				var m=_root.menu.customItems;
				for(i=0;i<m.length;i++)
				{
					if(m[i].id=="lockfps")
					{
						if(_root.lockfps)
						{
							cmi.caption="FPS is *locked* (faster game but jerky on old computers)";
						}
						else
						{
							cmi.caption="FPS is unlocked (slower game but smoother on old computers)";
						}
					}
				}
			};
			cmi = new ContextMenuItem("FPS is unlocked (slower game but smoother on old computers)", delegate(f) );
			cmi.id="lockfps";
			cm.customItems.push(cmi);
			
/*
			f=function()
			{
				if( (this.state=="play") && (this.play.gamemode=="race") && (!_root.popup) )
				{
					this.state_next=this.state;
				}
			};
			cmi = new ContextMenuItem("Restart this level.", delegate(f) );
			cmi.id="restart";
			cmi.visible=false;
			cm.customItems.push(cmi);
*/			
			_root.menu=cm;
		}

// ask for advert details from server

#if VERSION_WONDERFUL then

		_root.wonderfulls=null;
		
		lv_wonderful=new LoadVars();
		lv_wonderful.onLoad = delegate(lv_wonderful_post,lv_wonderful);
		lv_wonderful.sendAndLoad('http://swf.wetgenes.com/swf/wonderful.php?id=#(VERSION_WONDERFUL)',lv_wonderful,"POST");
		
#end

	}
	
	var lv_wonderful;
	
	function lv_wonderful_post()
	{
	var i;
	
		_root.wonderfulls=[];
	
		for(i=0;i<10;i++)
		{
			if( ( lv_wonderful["txt"+i] ) || ( lv_wonderful["jpg"+i] ) || ( lv_wonderful["url"+i] ) )
			{
				_root.wonderfulls[i]={ url:lv_wonderful["url"+i] , txt:lv_wonderful["txt"+i] , img:lv_wonderful["jpg"+i] , target:"_blank" };
			}
			else
			{
				break;
			}
		}
	}
	

	function update()
	{		
		var d=new Date();
		var new_time=d.getTime();
		
		MainStatic.choose_and_apply_scalar(this);
		
		if( (!setup_done) && (_root.getBytesLoaded()==_root.getBytesTotal()) && (_root.loading.done) && (!_root.wetplay.first_time))
//		if( (!setup_done) && (_root.getBytesLoaded()==_root.getBytesTotal()) )
		{
			_root.gotoAndStop(2); // frame 1 is preload, frame 2 is everything loaded
			setup();
			setup_done=true;
		}
		


		if(!setup_done)
		{
			MainStatic.update_do(_root.updates);
			return;
		}	
		
		
		if(state_next!=null)
		{
			if(state) { this[state].clean(); }
			
			state_last=state;	// change master state
			state=state_next;
			state_next=null;
			
			if(state)
			{
				this[state].setup();
			}
			
			new_time=d.getTime();
			old_time=new_time;
			update_time=0;
		}
		if(state)
		{
			update_time=Math.floor(update_time*3/4);
			update_time+=new_time-old_time;
			if(update_time>200) { update_time=200; }
			
			if(!_root.lockfps)
			{
				update_time=40;
				
				MainStatic.update_do(_root.updates);
		
				this[state].update();
								
				update_time-=40;
			}
			else
			{
				while(update_time>=40)
				{				
					MainStatic.update_do(_root.updates);
			
					this[state].update();
									
					update_time-=40;
				}
			}
			over.update();
				
			old_time=new_time;
		}
	}
	
	function clean()
	{
	}

}
