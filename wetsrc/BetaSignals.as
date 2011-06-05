/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// disable mochi so it doesnt spam my games with bad medals
#VERSION_MOCHISCORES=nil



// track events and tell people that care about them

class BetaSignals
{
	var up;
	var mc;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function BetaSignals(_up)
	{
		up=_up;
		
		
#if VERSION_MOCHISCORES then

			mochi.MochiServices.connect("#(VERSION_MOCHIADS)");
			mochi.MochiScores.setBoardID("#(VERSION_MOCHISCORES)");
#end

		if(_root.nonoba$apicodeas2)
		{
			_root._noobclip=gfx.create_clip(_root,null);
			NonobaAPI.Init(_root._noobclip);
			NonobaAPI.GetUsername(delegate(noob_name));
		}
		
		awarded=[];

	}
	
	function setup()
	{
	}

	function clean()
	{
	}
	
	var name;
	
	var ranksys; // ranking system, max or add
	
	var base;
	
	var game;
	
	var seed;
	
	var start_time;
		
	var score;
	var moves;
	var time;
	
	var total;
	
	var replay_str;

	var state;
	var awarded;
	
	function set_score_check(new_score,new_replay,new_moves) // only when higher
	{
		if(new_score>score)
		{
			score=new_score;
			if(new_replay)	{	replay_str=new_replay;	}
			if(new_moves)	{	moves=new_moves;		}
		}
	}
	
// handle basic score sending events

	var score_name;
	var score_last;
	var sent_stamp;
	
	function mochi_score_sent()
	{
	}
	
// this score is ment to be comparable without taking into acount day seed
// it isnt so precise but it mostly compares

	function send_start() // send a start of game signal to anyone that wants one
	{
		if(_root.audit)	{ return; }
		
		if(_root.sock) // talk to my chat client
		{
		var gmsg={ gcmd:"signal" , stype:"start", sgame:game , sseed:seed }
		
			_root.sock.gmsg( gmsg , undefined);
		}

		if((_root._url.toLowerCase().indexOf("gamegarage")>=0)&&(_root.game_id)&&(_root.user_id))
		{
		var	lv = new LoadVars();
			lv.game_id = _root.game_id;
			lv.user_id = _root.user_id;
			lv.sendAndLoad("http://www.gamegarage.co.uk/scripts/tracking.php", lv, "POST");
		}

	}
	
	function send_final(nam,num) // send a final end of game type score only,
	{
		if(_root.audit)	{ return; }
		
//dbg.print(nam+"=="+num);
	
		if(_root.sock) // talk to my chat client
		{
		var gmsg={ gcmd:"signal" , stype:"final", sgame:game , sseed:seed, snam:nam, snum:num}
		
			_root.sock.gmsg( gmsg , undefined);
		}
		
		if((_root._url.toLowerCase().indexOf("gamegarage")>=0)&&(_root.game_id)&&(_root.user_id))
		{
		var	lv = new LoadVars();
			lv.game_id = _root.game_id;
			lv.user_id = _root.user_id;
			lv.score = num; //Your score variable
			lv.alg = _root.game_id + _root.user_id + num + "a83l9xj"; //Insert score again
			lv.sendAndLoad("http://www.gamegarage.co.uk/scripts/score.php", lv, "POST");
		}
		
		if(_root.com_mindjolt_api)
		{
			var mindjolt = new LocalConnection();
			
			mindjolt.send( _root.com_mindjolt_api, "submitScore", num);
		}
		
		if(_root.kongregateServices!=undefined)
		{
if(game!="wetdike") // not to chage mode for wetdike, since kong has a badge attached to it...
{
			_root.kongregateScores.setMode(nam);
}
			_root.kongregateScores.submit(num);
		}
		
#if VERSION_MOCHISCORES then

		mochi.MochiScores.submit(num,_root.Login_Name,this,"mochi_score_sent");

#end

		if(_root.nonoba$apicodeas2)
		{
			NonobaAPI.SubmitScore(nam,num,delegate(noob_score));
		}
	}
	
	function send_spesh(nam,num) // send a score event to kong , pepere ,  hallpass
	{
		if(_root.audit)	{ return; }
		
		if(_root.sock) // talk to my chat client
		{
		var gmsg={ gcmd:"signal" , stype:"score", sgame:game , sseed:seed, snam:nam, snum:num}
		
			_root.sock.gmsg( gmsg , undefined);
		}
		
		if(_root.kongregateServices!=undefined)
		{
if(game!="wetdike") // not to chage mode for wetdike, since kong has a badge attached to it...
{
			_root.kongregateScores.setMode(nam);
}
			_root.kongregateScores.submit(num);
		}
		
		if(_root.HPScoreService!=undefined)
		{
			_root.HPScoreService.postScore(num,nam);
		}
		
		if(_root.pepere!=undefined)
		{
		var record;
		var date=new Date();
		
			record=new LoadVars();
		    record.params = _root.pepere;
		    record.score = score;
		    record.sendAndLoad("record.php",record,"POST");
		}		
		
		if(_root.nonoba$apicodeas2)
		{
			NonobaAPI.SubmitScore(nam,num,delegate(noob_score));
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
	
		if( ( date.getTime() - sent_stamp ) > 1000*60 ) // send new score no more than once every 60secs
		{
			send_score_check();
		}
	}
	
	function noob_name(state,username)
	{
		if(username)
		{
			name=username;
		}
	}
	function noob_score(state)
	{
	}
	
	function submit_award(nam,num) // num is 1 if the server has already awarded this award, 0 or undefined otherwise
	{
		if(awarded[nam]) { return; } // safe to call repeatedly without spaming server
		if(_root.audit)	{ return; }
		
		awarded[nam]=true;
		
		if(_root.sock) // talk to my chat client
		{
		var gmsg={ gcmd:"signal" , stype:"feat", sgame:game , sseed:seed, snam:nam, snum:num}
		
			_root.sock.gmsg( gmsg , undefined);
		}
		
		if(_root.nonoba$apicodeas2)
		{
			var noobnam=nam.split("_").join("");
			NonobaAPI.AwardAchievement(noobnam,delegate(noob_award));
		}
	}
	
	function noob_award(state)
	{
	}

	function submit_rank(nam,num)
	{
		if(_root.audit)	{ return; }
		
		if(_root.nonoba$apicodeas2)
		{
			var noobnam=nam.split("_").join("");
			NonobaAPI.SubmitScore(noobnam,Math.floor(num),delegate(noob_rank));
		}
	}
	function noob_rank(state)
	{
	}
	
// snapshot game state into comms
	
	function signal(_base,event,t,num)
	{
	var date;
	
		base=_base;
	
		switch(base)
		{
			case "diamonds":
			if(up.play.gamecomms) { break; } // do not submit anyscores in multiplayer mode
			switch(event)
			{
				case "start":

					state="start";
					
					date=new Date();

					seed=up.game_seed;
					
					game="diamonds.puz.3"; // puzzle game name/mode/skill
					score_name="Puzzle";
					ranksys="add";
					
					if(up.play.gamemode=="endurance")
					{
						game="diamonds.end.3"; // endurance game name/mode/skill
						score_name="Endurance";
						ranksys="max";
					}
					
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.datas=this;
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;
				
				case "update":
				
					state="update";
					
					time++;
					set_score_check(up.play.hud.points);
					moves=0;
					
					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();
					
				break;
				
				case "high":
				
					state="high";
					
					set_score_check(up.play.hud.points);
					moves=0;
					
					_root.comms.send_score_check();
					send_score_check();
					
				break;
				
				case "won":
				
					state="won";
					
					set_score_check(up.play.hud.points);
					moves=0;
					
					_root.comms.send_score();
					send_score();
					
				break;
				
				case "end":
				
					if(state=="won") // we just sent a won signal so don't bother sending an end
					{
						state="end";
						
						set_score_check(up.play.hud.points);
						moves=0;
						
						send_final("high",score);
					}
					else
					{
						state="end";
						
						set_score_check(up.play.hud.points);
						moves=0;
					
						_root.comms.send_score();
						send_score();
						send_final("high",score);
					}
					
					if(score>50000) // endurance mode submissions
					{
						submit_award("bronze")
					}
					
					if(score>100000)
					{
						submit_award("silver")
					}
					
					if(score>200000)
					{
						submit_award("gold")
					}
					
				break;
			}
			break;
			
			case "adventisland":
			switch(event)
			{
				case "start":

					state="start";
					
					date=new Date();

					seed=up.game_seed;
					
					game="adventisland";
					score_name="Advent";
					ranksys="max";
					
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.datas=this;
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;
				
				case "update":
				
					state="update";
					
					time++;
					set_score_check(up.isplay.advent.score);
					moves=0;
					
					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();
					
				break;
				
				case "high":
				
					state="high";
					
					set_score_check(up.isplay.advent.score);
					moves=0;
					
					_root.comms.send_score_check();
					send_score_check();
					
				break;
				
				case "won":
				
					state="won";
					
					set_score_check(up.isplay.advent.score);
					moves=0;
					
					_root.comms.send_score();
					send_score();
					
				break;
				
				case "end":
				
					if(state=="won") // we just sent a won signal so don't bother sending an end
					{
						state="end";
						
						set_score_check(up.isplay.advent.score);
						moves=0;
						
						send_final("high",score);
					}
					else
					{
						state="end";
						
						set_score_check(up.isplay.advent.score);
						moves=0;
					
						_root.comms.send_score();
						send_score();
						
						send_final("high",score);
					}
					
				break;
			}
			break;
			
			
			case "batwsball":
			switch(event)
			{
				case "start":

					state="start";
					
					date=new Date();

					seed=up.game_seed;
					
					game="batwsball";
					score_name="Endurance";
					ranksys="max";
					
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.datas=this;
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;
				
				case "update":
				
					state="update";
					
					time++;
					score= Math.floor( (up.play.tims + (up.play.timf/25)) * 100 ) ;
					moves=0;
					
					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();
					
				break;
								
				case "end":
				
					state="end";
					
					score= Math.floor( (up.play.tims + (up.play.timf/25)) * 100 ) ;
					moves=0;
				
					_root.comms.send_score();
					send_score();
					
					if(score>400) // no final score unless you hit it once...
					{
						send_final("high",score);
						
						if(score>6000) // last 1 minute
						{
							submit_award("bronze")
						}
						
						if(score>12000) // last 2 minute
						{
							submit_award("silver")
						}
						
						if(score>18000) // last 3 minute
						{
							submit_award("gold")
						}
					}
					
				break;
			}
			break;
			
			case "gojirama":
			switch(event)
			{
				case "set":
					game="gojirama";
					score_name="Endurance";
					ranksys="max";
					seed=up.game_seed;
					_root.comms.datas=this;
				break;
				
				case "start":

					state="start";
					
					date=new Date();

					seed=up.game_seed;
					
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.datas=this;
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;
				
				case "update":
				
					state="update";
					
					time++;
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();
					
				break;
								
				case "high":
				
					state="high";
					
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score_check();
					send_score_check();
					
				break;
				
				case "end":
				
					state="end";
					
					set_score_check(up.play.score);
					moves=0;
				
					_root.comms.send_score();
					send_score();
					
					send_final("high",score);
					
				break;
			}
			break;
			
			case "romzom":
			switch(event)
			{
				case "start":

					state="start";
					
					date=new Date();

					seed=up.game_seed;
					
					game="romzom";
					score_name="RomZom";
					ranksys="max";
					
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.datas=this;
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;
				
				case "update":
				
					state="update";
					
					time++;
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();
					
				break;
								
				case "end":
				
					state="end";
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score();
					send_score();
					
					send_final("high",score);
					
				break;
			}
			break;
			
			case "ASUE1":
			switch(event)
			{
				case "set":
					game="ASUE1";
					score_name="ASUE1";
					ranksys="max";
					seed=up.game_seed;
					_root.comms.datas=this;
				break;
				
				case "start":

					state="start";
										
					seed=up.game_seed;
					date=new Date();
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.datas=this;
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;
				
				case "update":
				
					state="update";
					
					time++;
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();
					
				break;
								
				case "end":
				
					state="end";
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score();
					send_score();
					
					send_final("high",score);
					
				break;
			}
			break;
			
			case "EsTension":
			case "estension":
			switch(event)
			{
				case "set":
					game="estension";
					score_name="EsTension";
					ranksys="max";
					seed=up.game_seed;
					_root.comms.datas=this;
				break;
				
				case "start":

					state="start";
										
					seed=up.game_seed;
					date=new Date();
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.datas=this;
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;

				case "update":
				
					state="update";
					time++;
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();
					
				break;

				case "high":
				
					state="update";
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score_check();
					send_score_check();
					
				break;

				case "end":
				
					state="end";
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score();
					send_score();
					
					send_final("high",score);
					
				break;
			}
			break;
			
			case "BowWow":
			case "bowwow":
			switch(event)
			{
				case "set":
					game="bowwow";
					score_name="BowWow";
					ranksys="add";
					seed=up.game_seed;
					_root.comms.datas=this;
				break;
				
				case "start":

					state="start";
										
					seed=up.game_seed;
					date=new Date();
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.datas=this;
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;

				case "update":
				
					time++;
					state="update";
					set_score_check( up.play.score , up.play.get_replay_str() , up.play.get_replay_moves() );
					
					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();
					
				break;

				case "high":
				
					state="update";
					set_score_check( up.play.score , up.play.get_replay_str() , up.play.get_replay_moves() );
					
					_root.comms.send_score_check();
					send_score_check();
					
				break;

				case "won":
				
					state="won";
					
					set_score_check(up.play.score, up.play.get_replay_str() , up.play.get_replay_moves());
					
					_root.comms.send_score();
					send_score();
					
					send_final("high",score);
					
				break;
				
				case "end":
				
					if(state!="won") // if we just sent a won signal don't bother sending an end nothing should have changed
					{
						state="end";
						
						set_score_check(up.play.score, up.play.get_replay_str() , up.play.get_replay_moves());
						
						_root.comms.send_score();
						send_score();
						
						send_final("high",score);
					}
					
				break;
			}
			break;
			
			case "WetBasement":
			case "WetBaseMent":
			switch(event)
			{
				case "set":
					if(up.play.gameskill=="hard")
					{
						game="basement.4"; // hard
					}
					else
					{
						game="basement.2"; // easy
					}
					score_name="Race";
					ranksys="add";
					seed=up.game_seed;
					_root.comms.datas=this;
				break;
				
				case "start":

					state="start";					
					date=new Date();					
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;
				
				case "update":
				
					state="update";
					
					time++;
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();
					
				break;
				
				case "high":
				
					state="high";
					
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score_check();
					send_score_check();
					
				break;
				
				case "won":
				
					state="won";
					
					set_score_check(up.play.score);
					moves=0;
					total=up.play.get_rank_score(score);
					
					_root.comms.send_score();
					send_score();
					
					if(up.play.gameskill=="hard")
					{
						send_final("TotalHard",total);
					}
					else
					{
						send_final("Total",total);
					}
					
				break;
				
				case "end":
				
					if(state!="won") // if we just sent a won signal don't bother sending an end nothing should have changed
					{
						state="end";
						
						set_score_check(up.play.score);
						moves=0;
						
						_root.comms.send_score();
						send_score();
											
						if(up.play.gameskill=="hard")
						{
							send_final("TotalHard",total);
						}
						else
						{
							send_final("Total",total);
						}
					}
					
				break;
			}
			break;
			
			case "Mute":
			case "mute":
			switch(event)
			{
				case "set":
					game="mute"; // easy
					score_name="Smash";
					ranksys="max";
					seed=up.game_seed;
					_root.comms.datas=this;
				break;
				
				case "start":

					state="start";					
					date=new Date();					
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;
				
				case "update":
				
					state="update";
					
					time++;
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();
					
				break;
				
				case "high":
				
					state="high";
					
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score_check();
					send_score_check();
					
				break;
				
				case "won":
				
					state="won";
					
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score();
					send_score();
					
				break;
				
				case "end":
				
					if(state!="won") // if we just sent a won signal don't bother sending an end nothing should have changed
					{
						state="end";
						
						set_score_check(up.play.score);
						moves=0;
						
						_root.comms.send_score();
						send_score();
						
						send_final("high",score);
					}
					else
					{
						send_final("high",score);
					}
					
				break;
			}
			break;
			
			case "WetDike":
			case "wetdike":
			switch(event)
			{
				case "set":
					game="wetdike"; // easy
					score_name="Puzzle";
					ranksys="add";
					seed=up.dikeplay.seed;
					_root.comms.datas=this;
				break;
				
				case "start":

					state="start";					
					date=new Date();					
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;
				
				case "update":
				
					state="update";
					
					time=Math.floor(up.dikeplay.game_time/1000);
					set_score_check( up.dikeplay.table.score , up.dikeplay.table.create_playback_str() );
					moves=up.dikeplay.table.moves;
//					replay_str=up.dikeplay.table.create_playback_str();

					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();
					
				break;
				
				case "high":
				
					state="high";
					
					set_score_check( up.dikeplay.table.score , up.dikeplay.table.create_playback_str() );
					moves=up.dikeplay.table.moves;
					
					_root.comms.send_score_check();
					send_score_check();
					
				break;
				
				case "won":
				
					state="won";
					
					set_score_check( up.dikeplay.table.score , up.dikeplay.table.create_playback_str() );
					moves=up.dikeplay.table.moves;
					
					_root.comms.send_score();
					send_score();
					
				break;
				
				case "end":
				
					if(state!="won") // if we just sent a won signal don't bother sending an end nothing should have changed
					{
						state="end";
						
						set_score_check( up.dikeplay.table.score , up.dikeplay.table.create_playback_str() );
						moves=0;
						
						_root.comms.send_score();
						send_score();
						
						send_final("high",score);
					}
					else
					{
						send_final("high",score);
					}
					
				break;
			}
			break;
			
			case "WetCell":
			case "wetcell":
			switch(event)
			{
				case "set":
					game="wetcell"; // easy
					score_name="Puzzle";
					ranksys="add";
					seed=up.game_seed;
					_root.comms.datas=this;
				break;
				
				case "start":

					state="start";					
					date=new Date();					
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;
				
				case "update":
				
					state="update";
					
					time=Math.floor(up.play.game_time/1000);
					set_score_check( up.play.table.score , up.play.table.create_playback_str() );
					moves=up.play.table.moves;
//					replay_str=up.play.table.create_playback_str();

					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();
					
				break;
				
				case "high":
				
					state="high";
					
					set_score_check( up.play.table.score , up.play.table.create_playback_str() );
					moves=up.play.table.moves;
					
					_root.comms.send_score_check();
					send_score_check();
					
				break;
				
				case "won":
				
					state="won";
					
					set_score_check( up.play.table.score , up.play.table.create_playback_str() );
					moves=up.play.table.moves;
					
					_root.comms.send_score();
					send_score();
					
				break;
				
				case "end":
				
					if(state!="won") // if we just sent a won signal don't bother sending an end nothing should have changed
					{
						state="end";
						
						set_score_check( up.play.table.score , up.play.table.create_playback_str() );
						moves=0;
						
						_root.comms.send_score();
						send_score();
						
						send_final("high",score);
					}
					else
					{
						send_final("high",score);
					}
					
				break;
			}
			break;
			
			case "ASUE2":
			case "asue2":
			switch(event)
			{
				case "set":
					game="ASUE2";
					score_name="ASUE2";
					ranksys="max";
					seed=up.game_seed;
					_root.comms.datas=this;
				break;
				
				case "start":

					state="start";
										
					seed=up.game_seed;
					date=new Date();
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.datas=this;
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;
				
				case "update":
				
					state="update";
					
					time++;
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();

				break;
								
				case "end":
				
					state="end";
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score();
					send_score();
					
					send_final("high",score);
					
				break;
			}
			break;
			
			
			case "Take1":
			case "take1":
			switch(event)
			{
				case "set":
					game="take1";
					score_name="take1";
					ranksys="max";
					seed=up.game_seed;
					_root.comms.datas=this;
				break;
				
				case "start":

					state="start";
										
					seed=up.game_seed;
					date=new Date();
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.datas=this;
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;
				
				case "update":
				
					state="update";
					
					time++;
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();

				break;
								
				case "end":
				
					state="end";
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score();
					send_score();
					
					send_final("high",score);
					
				break;
			}
			break;
			
			case "PixlCoop":
			case "pixlcoop":
			switch(event)
			{
				case "set":
					game="pixlcoop";
					score_name="pixlcoop";
					ranksys="max";
					seed=up.game_seed;
					_root.comms.datas=this;
				break;
				
				case "start":

					state="start";
										
					seed=up.game_seed;
					date=new Date();
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.datas=this;
//					_root.comms.send_score();
//					send_score();
//					send_start();
					
				break;
				
				case "update":
				
					state="update";					
					time++;

				break;
								
				case "end":
				
					state="end";
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score();
					send_score();
					
					send_final("high",score);
					
				break;
			}
			break;
			
			case "rgbtd0":
			switch(event)
			{
				case "start":

					state="start";
					
					date=new Date();

					seed=up.game_seed;
					
					game="rgbtd0"; // puzzle game name/mode/skill
					score_name="rgbtd0";
					ranksys="add";
					
					start_time=date.getTime();
					time=0;
					score=0;
					moves=0;
					replay_str="";
				
					_root.comms.datas=this;
					_root.comms.send_score();
					send_score();
					send_start();
					
				break;
				
				case "update":
				
					state="update";
					
					time++;
					set_score_check(up.play.score,up.play.replay);
					moves=0;
					
					_root.comms.send_score_wait_and_check();
					send_score_wait_and_check();
					
				break;
				
				case "high":

					state="high";
					
					set_score_check(up.play.score,up.play.replay);
					moves=0;
					
					_root.comms.send_score_check();
					send_score_check();
					
				break;
				
				case "final":
				
					send_final("high",up.play.score_total);
				
				break;

				case "end":
				
					state="end";
					
					set_score_check(up.play.score,up.play.replay);
					moves=0;
				
					_root.comms.send_score();
					send_score();
					
				break;
				
				case "award-bronze":
					submit_award("bronze")
				break;
				case "award-silver":
					submit_award("silver")
				break;
				case "award-gold":
					submit_award("gold")
				break;
			}
			break;
			
			case "pief":
			switch(event)
			{
				case "set":
					game="pief";
					score_name="pief";
					ranksys="max";
					seed=up.game_seed;
					_root.comms.datas=this;
					time=0;
					score=0;
					moves=0;
					replay_str="";
				break;
				
				case "won":
				case "end":
				
					state="end";
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score();
					send_score();
					
					send_final("high",score);
					
					if(score==100)
					{
						submit_award("moonstar");
					}
				break;
			}
			break;
			
			case "Only1":
			case "only1":
			switch(event)
			{
				case "set":
					game="only1";
					score_name="only1";
					ranksys="max";
					seed=up.game_seed;
					_root.comms.datas=this;
					time=0;
					score=0;
					moves=0;
					replay_str="";
				break;
				
				case "won":
				case "end":
				
					state="end";
					set_score_check(up.play.score);
					moves=0;
					
					_root.comms.send_score();
					send_score();
					
					send_final("high",score);
					
				break;
			}
			break;
		}
	}
	
	
}
