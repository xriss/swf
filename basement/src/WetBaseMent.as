/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"




class WetBaseMent
{
	var state_last;
	var state;
	var state_next;

	var	setup_done;

	var mc;

	var choose;
	var zoo;
	var login;
	var menu;
	var play;
	var title;
	var over;
	var about;
	var code;
	var high;
	var swish;
	
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

		orset_root("wp_xspf","http://basement.wetgenes.com/swf/WetBaseMent.xspf");
		orset_root("wp_auto",0);
		orset_root("wp_shuffle",0);
		orset_root("wp_back",0xff000000);
		orset_root("wp_fore",0xffffffff);
		
		
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
		
		_root.basement=new WetBaseMent();
		_root.signals=new BetaSignals(_root.basement);
		_root.comms=new BetaComms(_root.basement);
		
		_root.wtf=new WTF("show_nowplaying");
	}



	function WetBaseMent()
	{
	var date=new Date();
	var i;
	var t;
	var tt;
	var lev;
	var idx;
	
		v=[];
		v.name='WetBasement';
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
		levels[ 1]=new WetBaseMentLevel_level_01();
		levels[ 3]=new WetBaseMentLevel_level_02();
		levels[ 2]=new WetBaseMentLevel_level_03();
		levels[ 4]=new WetBaseMentLevel_level_04();
		levels[ 5]=new WetBaseMentLevel_level_05();
		levels[ 7]=new WetBaseMentLevel_level_06();
		levels[ 6]=new WetBaseMentLevel_level_07();
		levels[ 8]=new WetBaseMentLevel_level_08();
		levels[ 9]=new WetBaseMentLevel_level_09();
		levels[10]=new WetBaseMentLevel_level_10();
		
		for(i=1;i<=10;i++) // pick the seeds for each level based around today
		{
			lev=levels[i];
			
			t=game_seed_start+(i-1);
			if(t>game_seed_today) { t=t-10; } // do not play into the future
			
			lev.game_seed=t;
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
		lev.name="Well Hello";
		tt=[];
		
tf_idle(tt,	25*1	,	0	,	"roton"			,	"Well hello down there!"	);
tf_idle(tt,	25*1	,	1	,	"confused"		,	"Uhm, hello?"	);
tf_idle(tt,	25*1	,	0	,	"confused"		,	"What are you doing in my basement?"	);
tf_idle(tt,	25*1	,	1	,	"indescribable"	,	"I'm not really sure."	);
tf_idle(tt,	25*1	,	0	,	"thoughtful"	,	"Are you a plumber? I think I called for a plumber. There are some really nasty wet patches."	);
tf_idle(tt,	25*1	,	1	,	"bird"			,	"Do I look like a gay Italian to you?"	);
tf_idle(tt,	25*1	,	0	,	"sad"			,	"I supose not, still, best to check with people isn't it?"	);
tf_idle(tt,	25*1	,	1	,	"idle"			,	"Yes, quite."	);
tf_idle(tt,	25*1	,	0	,	"devious"		,	"Anyhow while you are down there. Do you think you could possibly jump around on platforms and collect things for me instead?"	);
tf_idle(tt,	25*1	,	1	,	"happy"			,	"Oh sure, I'm really really good at that, that's not a problem. I'm just not much of a plumber."	);
tf_idle(tt,	25*1	,	0	,	"excited"		,	"Sweet! I've left a lot of meta down there, pick it all up for me and I promise to not lock you down there for the rest of your life."	);
tf_idle(tt,	25*1	,	1	,	"confused"		,	"Meta?"	);
tf_idle(tt,	25*1	,	0	,	"nerdy"			,	"The white shiny spinny things."	);
tf_idle(tt,	25*1	,	1	,	"hiphands"		,	"Gotcha, no problem, I'm right on it, don't you worry it will be done in no time."	);
tf_norm(tt,	25*1	,	0	,	"rotoff"		,	"Excellent!"	);
tf_norm(tt,	0		,	1	,	"start"			,	null	);

		lev.chat_start=tt;
		
		lev=levels[3];
		lev.name="Nowhere Pipes";
		tt=[];
			
tf_idle(tt,	25*1	,	0	,	"roton"			,	"I think these pipes were meant to go somewhere."	);
tf_idle(tt,	25*1	,	1	,	"confused"		,	"It's almost as if they were exclusively designed for jumping on."	);
tf_norm(tt,	25*1	,	0	,	"rotoff"		,	null	);
tf_norm(tt,	0		,	1	,	"start"			,	null	);

		lev.chat_start=tt;
		
		
		lev=levels[2];
		lev.name="Pidgin Jumps";
		tt=[];
			
tf_idle(tt,	25*1	,	0	,	"roton"			,	"Never give up, never surender!"	);
tf_idle(tt,	25*1	,	1	,	"confused"		,	"Uhm, Mkay."	);
tf_norm(tt,	25*1	,	0	,	"rotoff"		,	null	);
tf_norm(tt,	0		,	1	,	"start"			,	null	);

		lev.chat_start=tt;

		lev=levels[4];
		lev.name="My first bouncy";
		tt=[];
			
tf_idle(tt,	25*1	,	0	,	"roton"			,	"A nice little bouncy in the middle will do wonders for your height."	);
tf_idle(tt,	25*1	,	1	,	"confused"		,	"Are your sure its safe?"	);
tf_norm(tt,	25*1	,	0	,	"nerdy"			,	"Oh yes, almost certainly."	);
tf_norm(tt,	25*1	,	0	,	"rotoff"		,	"For me, anyway."	);
tf_norm(tt,	0		,	1	,	"start"			,	null	);

		lev.chat_start=tt;

		lev=levels[5];
		lev.name="Super fun-sucking";
		tt=[];
			
tf_idle(tt,	25*1	,	0	,	"roton"			,	"You might want to watch out for the super fun sucking pipes!"	);
tf_idle(tt,	25*1	,	1	,	"confused"		,	"Because they are super fun?"	);
tf_idle(tt,	25*1	,	0	,	"idle"			,	"No, because they are fun-sucking."	);
tf_idle(tt,	25*1	,	1	,	"confused"		,	"I feel so safe."	);
tf_norm(tt,	25*1	,	0	,	"rotoff"		,	"Excellent!"	);
tf_norm(tt,	0		,	1	,	"start"			,	null	);

		lev.chat_start=tt;

		lev=levels[7];
		lev.name="Easy Travels";
		tt=[];
			
tf_idle(tt,	25*1	,	0	,	"roton"			,	"GO!"	);
tf_idle(tt,	25*1	,	1	,	"idle"			,	"Gone!"	);
tf_norm(tt,	25*1	,	0	,	"rotoff"		,	"Excellent!"	);
tf_norm(tt,	0		,	1	,	"start"			,	null	);

		lev.chat_start=tt;

		lev=levels[6];
		lev.name="Bounce me Right";
		tt=[];
			
tf_idle(tt,	25*1	,	0	,	"roton"			,	"You are doing really well at this."	);
tf_idle(tt,	25*1	,	1	,	"idle"			,	"I am?"	);
tf_norm(tt,	25*1	,	0	,	"rotoff"		,	"Yes, I think I shall keep you."	);
tf_norm(tt,	0		,	1	,	"start"			,	null	);

		lev.chat_start=tt;

		lev=levels[8];
		lev.name="Bouncyatorium";
		tt=[];
			
tf_idle(tt,	25*1	,	0	,	"roton"			,	"Ah, you have found my sweet bouncyatorium! Where good times and happy days are had by all."	);
tf_idle(tt,	25*1	,	1	,	"confused"		,	"By all?"	);
tf_norm(tt,	25*1	,	0	,	"nerdy"			,	"Oh yes, some of my most memorable barfs happend right here."	);
tf_norm(tt,	25*1	,	0	,	"rotoff"		,	null	);
tf_norm(tt,	0		,	1	,	"start"			,	null	);

		lev.chat_start=tt;

		lev=levels[9];
		lev.name="Stairway to Ponyland";
		tt=[];
			
tf_idle(tt,	25*1	,	0	,	"roton"			,	"Bouncy stairway!"	);
tf_idle(tt,	25*1	,	1	,	"idle"			,	"Why does it have to be bouncy?."	);
tf_idle(tt,	25*1	,	0	,	"idle"			,	"Because I like bouncy things!"	);
tf_idle(tt,	25*1	,	1	,	"idle"			,	"Next time I get trapped in a basement it won't be this one."	);
tf_norm(tt,	25*1	,	0	,	"rotoff"		,	"Excellent!"	);
tf_norm(tt,	0		,	1	,	"start"			,	null	);

		lev.chat_start=tt;

		lev=levels[10];
		lev.name="Ws Clown";
		tt=[];
			
tf_idle(tt,	25*1	,	0	,	"idle"			,	"You know how I said about letting you go free and stuff?"	);
tf_idle(tt,	25*1	,	1	,	"idle"			,	"Yup!"	);
tf_idle(tt,	25*1	,	0	,	"idle"			,	"Well this is the last batch of meta so let me help you out."	);
tf_idle(tt,	25*1	,	1	,	"idle"			,	"Really?"	);
tf_idle(tt,	25*1	,	1	,	"idle"			,	"You?"	);
tf_idle(tt,	25*1	,	1	,	"idle"			,	"Help?"	);
tf_idle(tt,	25*1	,	0	,	"start"			,	"Yes, catch this."	);
tf_norm(tt,	0		,	1	,	"start"			,	null	);

		lev.chat_start=tt;
		
		tt=[];
		
tf_idle(tt,	25*1	,	0	,	"idle"			,	"OK! fine you win."	);
tf_idle(tt,	25*1	,	0	,	"idle"			,	"You may leave my basement!"	);
tf_idle(tt,	25*1	,	1	,	"idle"			,	"For really really real?"	);
tf_idle(tt,	25*1	,	0	,	"idle"			,	"Just go already,"	);
tf_idle(tt,	25*1	,	0	,	"idle"			,	"and do not come back."	);
tf_idle(tt,	25*1	,	1	,	"idle"			,	"Wheeeeeeee!"	);
tf_norm(tt,	0		,	0	,	"end"			,	null	);
tf_norm(tt,	0		,	1	,	"end"			,	null	);

		lev.chat_end=tt;
		
		
		tards=[];
		idx=1;
		
#if VERSION_SITE=="pepere" then

		t={}; t.name="Plomb Silencieux";	t.img1="vtard_blob";	t.idx=idx;	tards[idx++]=t;
		
#else		
		t={}; t.name="Rodger";				t.img1="vtard_rodger";	t.idx=idx;	tards[idx++]=t;
		t={}; t.name="Bonnie";				t.img1="vtard_bonnie";	t.idx=idx;	tards[idx++]=t;
		
//		t={}; t.name="Kriss";				t.img1="vtard_kriss";	t.idx=idx;	tards[idx++]=t;
		
		t={}; t.name="Blob Morley";			t.img1="vtard_morley";	t.idx=idx;	tards[idx++]=t;
		t={}; t.name="Plomb Silencieux";	t.img1="vtard_blob";	t.idx=idx;	tards[idx++]=t;
		t={}; t.name="Colon Mouseturd";		t.img1="vtard_colonel";	t.idx=idx;	tards[idx++]=t;
		t={}; t.name="Jonesy Dave";			t.img1="vtard_davey";	t.idx=idx;	tards[idx++]=t;
		
		t={}; t.name="Shi";					t.img1="vtard_shi";		t.idx=idx;	tards[idx++]=t;
		
		t={}; t.name="Italian Stalin";		t.img1="vtard_gay";		t.idx=idx;	tards[idx++]=t;
		t={}; t.name="Kolumbo";				t.img1="vtard_kolumbo";	t.idx=idx;	tards[idx++]=t;
		
		t={}; t.name="Polly";				t.img1="vtard_polly";	t.idx=idx;	tards[idx++]=t;
		t={}; t.name="Morf";				t.img1="vtard_morf";	t.idx=idx;	tards[idx++]=t;
#end
		
	}
	
	function setup()
	{
	
		
		state_last=null;
		state=null;
		state_next=null;

		login=new Login(this);
		play=new WetBaseMentPlay(this);
		title=new WetBaseMentTitle(this,"title_all",play);
		menu=title;
		choose=new WetBaseMentChoose(this);
		zoo=new WetBaseMentZoo(this);
		
		about=new PlayAbout(this);
		code=new PlayCode(this);
		high=new PlayHigh(this,"hide_last");
		
		over=new OverField( { up:this , mc:gfx.create_clip(mc,0x10008) } );
		over.setup();
		
		
		state_next="choose";
		state_next="title";
		state_next="login";
		
		
		{
		var cm;
		var cmi;
		var f;
		
			cm=MainStatic.get_base_context_menu(this);
			
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
		
		if( (!setup_done) && (_root.getBytesLoaded()==_root.getBytesTotal()) && (_root.loading.done) )
		{
			_root.gotoAndStop(2); // frame 1 is preload, frame 2 is everything loaded
			setup();
			setup_done=true;
		}
		


		if(!setup_done)
		{
//			_root.poker.update();
//			_root.wetplay.update();
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
//			if(update_time>=80) { dbg.print(update_time); }
			if(update_time>200) { update_time=200; }
			while(update_time>=40)
			{
//				_root.poker.update();
//				_root.wetplay.update();
				
				MainStatic.update_do(_root.updates);
		
				this[state].update();
								
				update_time-=40;
			}
//			over.update();
				
			old_time=new_time;
		}
	}
	
	function clean()
	{
	}

}
