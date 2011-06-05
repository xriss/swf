/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// lets handle some basic communications

class BetaComms
{
	var up; // the main class
	
	var php; // where to communicate
	
	var datas; // suplied datas

	
	
	var sending_scores;
	var get_high_after_sending;
	var get_high_after_sending_cmd;
	var get_high_after_sending_filter;
	var get_high_after_sending_callback;
	
	function delegate(f,d)		{	return com.dynamicflash.utils.Delegate.create(this,f,d);		}
	function delegate2(f,d1,d2)	{	return com.dynamicflash.utils.Delegate.create(this,f,d1,d2);	}
	
	
	function BetaComms(_up)
	{
		up=_up;

		php='http://'+_root.host+'/swf/beta.php';
		
		sending_scores=false;
		get_high_after_sending=false;
	}
	
	
// check if the score is higher than it was last sent, if so send it
	function send_score_check()
	{
		if(sent_score<datas.score)
		{
			send_score();
		}
	}
	
// check if the score is higher than it was, if so send it
// but do not resend more than once every 60 secs

	function send_score_wait_and_check()
	{
	var date=new Date();
			
		if( ( date.getTime() - sent_stamp ) > 1000*60 ) // send new score no more than once every 60secs
		{
			send_score_check();
		}
	}

	
// snapshot current score and time
// as the time we last sent a score to the server
// also return the time stamp

var sent_score;		// game score that was last sent to server, used to see when we should send again
var sent_stamp;		// last time we sent a score
	
	function reset_sent_stamp()
	{
		var date=new Date();
		sent_stamp=date.getTime();
		sent_score=datas.score;
		
		return sent_stamp;
	}

	
// send current score to the server

var lv_score;

	function send_score()
	{
//dbg.print("+send_score");	
		if(_root.audit)	{ return; }

		if(_root.skip_wetscore) { return; }


		lv_score=new LoadVars();
		
		lv_score.S=_root.Login_Session;
		lv_score.name=_root.Login_Name;
		
		lv_score.game=datas.game;
		lv_score.host=datas.host;
		lv_score.seed=datas.seed;
		
		lv_score.state=datas.state;
		
		lv_score.score=datas.score;
		lv_score.moves=datas.moves;
		lv_score.time=datas.time;
		
		lv_score.start_time=datas.start_time;
		
		lv_score.replay_str=datas.replay_str;

		lv_score.timestamp=reset_sent_stamp();
		
		fbsig.copy_fb_sigs(_root,lv_score);
		
		lv_score.onLoad = delegate(send_score_post,lv_score);
		lv_score.sendAndLoad(php+"?cmd=submit",lv_score,"POST");
		
		sending_scores=true;
	}
	
	function send_score_post(success,lv)
	{
//dbg.print("+send_score_post");	

		sending_scores=false;
		
		if(success)
		{
			if(lv.score!=0) // let the user know that their score has been sent, ok
			{
				_root.talk.chat_status("Sent Score: "+lv.score);
			}
		}
		
	if(get_high_after_sending)
		{
			get_high(get_high_after_sending_cmd,get_high_after_sending_filter,get_high_after_sending_callback);
			get_high_after_sending=false;
		}
		
//		dbg.dump(lv_score);
	}
	
	var lv_high;

	function get_high(cmd,filter,callback)
	{
//dbg.print("+get_high");	

// clear shown scores
//		up.dikescores.high=up.dikescores.new_reset_scores();
		
		if(_root.skip_wetscore) { return; }

	
		if(sending_scores)
		{
			get_high_after_sending_cmd=cmd;
			get_high_after_sending_filter=filter;
			get_high_after_sending_callback=callback;
			get_high_after_sending=true;
			return;
		}
		
		lv_high=new LoadVars();
		
		lv_high.S=_root.Login_Session;
		lv_high.name=_root.Login_Name;
		
		lv_high.game=datas.game;
		lv_high.host=datas.host;
		lv_high.seed=datas.seed;
		
		lv_high.state=datas.state;
		
		lv_high.filter=filter;
		lv_high.min=1;
		lv_high.max=10;		
		
		fbsig.copy_fb_sigs(_root,lv_high);
		
		lv_high.onLoad = delegate2(get_high_post,lv_high,callback);
		lv_high.sendAndLoad(php+"?cmd="+cmd,lv_high,"POST");
		
	}
	
	function get_high_post(success,lv,callback)
	{
//dbg.print("+get_high_post");	
	
		var i;
		var high;
		var got;
		
//		if(!success) { return; }
		
		high=new Array();
	
		got=false;
		
		for(i=1;i<=10;i++)
		{
			if(lv['name'+i]!=undefined)
			{
				high[i-1]=lv['score'+i] + ";" + lv['name'+i] + ";" + lv['seed'+i] ;
				got=true;
			}
			else
			{
				high[i-1]="0;...";
			}
		}

		if(got) // only callback when we actually got some data
		{
			callback(high);
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
		
		lv_audit.onLoad = delegate(send_audit_post,lv_audit);
		lv_audit.sendAndLoad(php+"?cmd=audit",lv_audit,"POST");

		
	}

	function send_audit_post(success,lv)
	{

		var i;
		var high;
		var rank;
		
//		dbg.print("audit?");
		
		if(lv!=lv_audit) { return; }
		if(!success) { return; }
		
		lv_audit_got=lv;
/*		
		dbg.print("audit_recv");
		
		dbg.print("replay_id="+lv.replay_id);
		dbg.print("seed="+lv.seed);
		dbg.print("replay_str="+lv.replay_str);
*/		
		if(lv.replay_str.length<6)
		{
			send_audit(lv.replay_id,0);
		}
		
	}

	var lv_pbem; // to submit a pbem request
	
// request a new pbem game
	function send_pbemstart(game,em1,em2)
	{
		if(_root.skip_wetscore) { return; }
		
		lv_pbem=new LoadVars();
		
		lv_pbem.S=_root.Login_Session;
		lv_pbem.name=_root.Login_Name;
		
		lv_pbem.game=game;
		
		lv_pbem.em1=em1;
		lv_pbem.em2=em2;
		
		lv_pbem.onLoad = delegate(send_pbemstart_post,lv_pbem);
		lv_pbem.sendAndLoad(php+"?cmd=pbemstart",lv_pbem,"POST");
	}

	function send_pbemstart_post(success,lv)
	{
	}
	
}