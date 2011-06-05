/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// lets handle some communications

class WetDikeComms
{
	var up;

	var state;

	
	var lardphp;
	
// global stuff to pass across to php

	var php;
//	var name;
//	var S;

// base game data

	var pack_code;	// 52 char string describing pack
	var pack_seed;	// 16bit pack seed if this pack is one of them, or null

	var start_time;	// time started playing pack

	var game_time;	// only counts while game loop runs, so sleeps when not in foreground...
	
	var score;	// game score and moves
	var moves;
	
	var away_cards;
	
	var replay_str;	// string validating the score...
	
// update vars

	var timestamp; // last time we updated, do once a minute if higher score than before

	var lv_score; // to submit a score
	
	
	var sent_score; // last score we sent, dont bother sending again unless we did better or finished a game
	
var str_numst:Array=['1st','2nd','3rd','4th','5th','6th','7th','8th','9th','10th'];



	var sending_scores;
	var get_high_after_sending;
	

	function delegate(f,d)
	{
		return com.dynamicflash.utils.Delegate.create(this,f,d);
	}
	
	function WetDikeComms(_up)
	{
		up=_up;
		
		state="none";
		

		setup();
//		thunk();
	}

// rethink all global comms settings, eg rebuild on major state changes
	function thunk()
	{

// default settings
	
//		name="Me";
//		S="0";	
		php='http://'+_root.host+'/swf/wetdike.php';

// check root vars

//		if(_root.loading.server=='www')	{ php='http://wetdike.wetgenes.com/swf/wetdike.php'; }
		
// check login vars to override
		
//		if(_root.login.session!=null) { S=_root.login.session; }
//		if(_root.login.login!=null) { name=_root.login.login; }
		
// pull in game status

		pack_code=up.dikeplay.pack_code;
		pack_seed=up.dikeplay.seed;
		start_time=Math.floor(up.dikeplay.start_time/1000);
		game_time=Math.floor(up.dikeplay.game_time/1000);
		
		score=up.dikeplay.table.score_max;
		moves=up.dikeplay.table.moves;
		
		away_cards=
		up.dikeplay.table.stacks[2].cards.length+
		up.dikeplay.table.stacks[3].cards.length+
		up.dikeplay.table.stacks[4].cards.length+
		up.dikeplay.table.stacks[5].cards.length;
		
		replay_str=up.dikeplay.table.create_playback_str();
		
	}
	
	function setup()
	{
		var date=new Date();
		
		sending_scores=false;
		get_high_after_sending=false;
		
		thunk();
		
		sent_score=0;
		timestamp=date.getTime();
	}
	
	function clean()
	{
		send_score();
	}
	
	function update()
	{
//		dbg.print(name+" : "+_root.login.login);
		
		var date=new Date();
			
		if( ( date.getTime() - timestamp ) > 1000*60 ) // check and send every 60 secs if better score
		{
			send_score_check();			
		}
	}

// check if the score is higher than it was, if so send it
	function send_score_check()
	{
		var date=new Date();
		
		timestamp=date.getTime();
		
		thunk();

//dbg.print(sent_score+"<"+score);

		if(sent_score<score)
		{
			send_score();
		}
	}

// send current score to the server
	function send_score()
	{
		if(_root.audit)	{ return; }
		
		var date=new Date();
		
		timestamp=date.getTime();
		

// send data to kong

		if(_root.kongregateStats!=undefined)
		{
			_root.kongregateStats.submit("GameSeed",pack_seed); // so kong knows which day the following score/time is for, should it choose to use it
			
			_root.kongregateStats.submit("HighScore",score);
			
			if(away_cards==52) // finished, submit time
			{
				_root.kongregateStats.submit("FinishedTime",game_time);
			}
		}
		
		sending_scores=true;
		get_high_after_sending=false;
		
			
		thunk();
		
		sent_score=score;

		lv_score=new LoadVars();
		
		lv_score.S=_root.Login_Session;
		lv_score.name=_root.Login_Name;
		
		lv_score.pack_code=pack_code;
		lv_score.pack_seed=pack_seed;
		lv_score.start_time=start_time;
		lv_score.game_time=game_time;
		lv_score.away_cards=away_cards;
		lv_score.score=score;
		lv_score.moves=moves;
		
		lv_score.replay_str=replay_str;
		
		lv_score.timestamp=timestamp;
				
		fbsig.copy_fb_sigs(_root,lv_score);
		lv_score.game="wetdike";
		
		lv_score.onLoad = delegate(send_score_post,lv_score);
		lv_score.sendAndLoad(php+"?cmd=submit",lv_score,"POST");
		
		
		up.dikeplay.table.new_status="Sending Score";
	}
	
	function send_score_post(success,lv)
	{
		if(_root.audit)	{ return; }
		
		sending_scores=false;
		
		up.dikeplay.table.new_status="Sent Score";
		
		if(get_high_after_sending) // read high scores again if we are displaying high scores.
		{
			get_high_after_sending=false;
			get_high();
		}
		
	}
	
	
	var lv_audit; // to submit an audit
	var lv_audit_got;
	
// send an audit responce or audit request
	function send_audit(a_scoreid,a_score,replay_str)
	{
		lv_audit=new LoadVars();
		lv_audit_got=null;
		
		lv_audit.S=_root.Login_Session;
		
		lv_audit.replay_id=a_scoreid;
		lv_audit.replay_str=replay_str;
		lv_audit.score=a_score;
		
//		dbg.print("ID "+a_scoreid+" SCORE "+a_score);
		
		fbsig.copy_fb_sigs(_root,lv_audit);
		lv_audit.game="wetdike";
		
		lv_audit.onLoad = delegate(send_audit_post,lv_audit);
		lv_audit.sendAndLoad(php+"?cmd=audit",lv_audit,"POST");
		
	}

	function send_audit_post(success,lv)
	{
		var i;
		var high;
		var rank;
		
		if(lv!=lv_audit) { return; }
		if(!success) { return; }
		
		lv_audit_got=lv;
/*
		dbg.print("audit_recv");
		
		dbg.print("replay_id="+lv.replay_id);
		dbg.print("seed="+lv.seed);
		dbg.print("replay_str="+lv.replay_str);
		
		if(lv.replay_str.length<6)
		{
			send_audit(lv.replay_id,0);
		}
*/
		
	}


	var lv_high;

	function get_high()
	{
// clear shown scores
		up.dikescores.high=up.dikescores.new_reset_scores();
		
	
		if(sending_scores)
		{
			get_high_after_sending=true;
			return;
		}
		
		
		thunk();
		
		lv_high=new LoadVars();
		
		lv_high.S=_root.Login_Session;
		lv_high.name=_root.Login_Name;
		
		lv_high.pack_code=pack_code;
		lv_high.pack_seed=pack_seed;
		
		lv_high.min=1;
		lv_high.max=10;		
		
		fbsig.copy_fb_sigs(_root,lv_high);
		lv_high.game="wetdike";
		
		lv_high.onLoad = delegate(get_high_post,lv_high);
		lv_high.sendAndLoad(php+"?cmd=high",lv_high,"POST");
		
		
		up.dikeplay.table.new_status="Fetching Scores";
		
		
	}
	function get_high_post(success,lv)
	{
		var i;
		var high;
		var rank;
		
//		if(lv!=lv_high) { return; }
		
		high=new Array();
	
		for(i=1;i<=10;i++)
		{
			if(lv['name'+i]!=undefined)
			{
				high[i-1]=lv['score'+i] + ";" + lv['name'+i] ;
			}
			else
			{
				high[i-1]="0;...";
			}
			
//			dbg.print(high[i-1]);
		}
	
		rank=new Array();
		
		for(i=1;i<=10;i++)
		{
			if(lv['rname'+i]!=undefined)
			{
				rank[i-1]=lv['rscore'+i] + ";" + lv['rname'+i] ;
			}
			else
			{
				rank[i-1]="0;...";
			}
			
//			dbg.print(high[i-1]);
		}
		
		up.dikescores.high=high;
		up.dikescores.rank=rank;
		up.dikescores.thunk();
		
		up.dikeplay.table.new_status="Fetched Scores";
	}

	
	var lv_stats;
	
	function get_stats()
	{
		thunk();
		

		lv_stats=new LoadVars();
		
		lv_stats.S=_root.Login_Session;
		lv_stats.name=_root.Login_Name;
		
		lv_stats.pack_code=pack_code;
		lv_stats.pack_seed=pack_seed;
				
		fbsig.copy_fb_sigs(_root,lv_stats);
		lv_stats.game="wetdike";
		
		lv_stats.onLoad = delegate(get_stats_post,lv_stats);
		lv_stats.sendAndLoad(php+"?cmd=stats",lv_stats,"POST");
		
		
		up.dikeplay.table.new_status="Fetching Stats";
		
		
	}
	function get_stats_post(success,lv)
	{
	
//		if(lv!=lv_high) { return; }
		
		up.dikestats.stats=lv;
		up.dikestats.thunk();
		
		up.dikeplay.table.new_status="Fetched Stats";
	}

	}