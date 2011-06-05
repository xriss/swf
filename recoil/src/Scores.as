/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


#EDIT_NAME=true


#if VERSION_SITE=='pnflashgames' then

#EDIT_NAME=true

#end


#if VERSION_SITE=='bunchball' then

import com.bunchball.Api;

#EDIT_NAME=true

#end

#if VERSION_SITE=='pepere' then

#EDIT_NAME=false

#end


import com.dynamicflash.utils.Delegate;



class Scores
{
	var main;
	
	static var VERSION:Number=11;

	var show_replay_str:String;	// if not null, then we just setup this replay so use it


	var high_global:Array;
	var high_today:Array;
	var high:Array;
	
	var chars_num;
	var chars_name;
	
	var so:SharedObject;
	

	var thunk:Function;				// call back to rebuild display
	var game_name:String='Recoil';	// our game name
	var myname:String;				// our player name
	
	var new_score_to_add:String;
	

	function delegate(f:Function,d:Array)
	{
		return Delegate.create(this,f,d);
	}



#if VERSION_SITE=='pnflashgames' then
	
	var pnfg:pnFlashGames;	

#end


#if VERSION_SITE=='bunchball' then

	var bb_revision_n:Number;

	var bb:com.bunchball.Api;
	var details:Object;


	function got_details(_success:Boolean, _details:Object)
	{
		if(_success)
		{
		trace("success");
			details = _details;
			

			if(details.userName_str=='guest')	// pull in local name for guest accounts
			{
				so_load();
// or use the chatname if possible
 				if( (typeof(details.chatName_str)=='string') && (details.chatName_str!='') )
				{
					myname=details.chatName_str;
				}
			}
			else
			{
				myname=details.screenName_str;	// pull in username from server
			}

			thunk();
			go_get_scores(null);
		}
		else
		{
		trace("fail");
			details = null;
			
			so_load();
		}
		
// register msg callback for simple use from now on

		bb_revision_n=0;
		bb.setNewDataCallback(delegate(got_bb_msg,null));
		
	}

	function got_bb_msg(newData_array:Array, turn_str:String)
	{
		var t:Object;
		
		trace('got msg');
		trace(newData_array);
		trace(turn_str);

		for (var i=0; i < newData_array.length; i++)
		{
//			if(newData_array[i].revision_n > bb_revision_n ) // check is new
//			{
//			bb_revision_n=newData_array[i].revision_n;
//			trace(bb_revision_n);
				
				t = newData_array[i].newData_obj;
	
				if(typeof(t.new_score_to_add)=='string')
				{
					var a:Array;
					
					a=t.new_score_to_add.split(';');
					
					if((a[0]>0)&&(a[1]!=''))
					{
//						var date=new Date();
						bb.call("writeChat", a[1]+" just scored "+Math.floor(a[0]/100)+":"+a[0]%100, delegate(writechat_done,null));
					}
				}
//			}
//			trace (message_obj.userName_str);
//			trace (message_obj.screenName_str);
//			trace (message_obj.source_str);
		}
	
//		trace ("Whose Turn: " + turn_str);

		return true;
	}

	function writechat_done(_success:Boolean)
	{
	}


	var gone_to_get_scores:Date;
	function go_get_scores(new_score:String) // start a score update
	{
		var d:Array=new Array();
		var date=new Date();
		
		if	(
				(gone_to_get_scores==null)
				|| 
				( ( date.getTime() - gone_to_get_scores.getTime() ) > (1000*60) )
				||
				(new_score!=null)
			)
		{
			gone_to_get_scores=date; // timestamp request
			d.new_score_to_add=new_score;
			d.global=false;
			d.write=false;
			bb.call("loadStatic", d.write, d.global, delegate(got_scores,d));
		}
	}
	
	function got_scores(_success:Boolean, _chunk_info:Object, f:Function, d:Array )
	{
		var added_score:Boolean=false;
		var date:Date=new Date();
		
		trace("write="+d.write);
		trace("global="+d.global);
		
		if(_success)
		{
		trace("success");
			d.chunk_info=_chunk_info;
			d.chunk=d.chunk_info.static_obj;
		}
		else
		{
		trace("fail");
			d.chunk_info = null;
			d.chunk = null;
		}
		
		if( (typeof(d.chunk)!='object') || (d.chunk.version!=VERSION) ) // build all new, things are broken
		{
			d.chunk=new Object;
			d.chunk.version=VERSION;	// sanity

			if(d.global==false)
			{
				d.chunk.high=get_reset_scores(); 			// default high scores
			}
			else
			{
				d.chunk.high_global=get_reset_scores(); 	// default high scores
			}
			
			added_score=true;
		}
		
		if(d.global==false)
		{
			if(d.chunk.high_today==undefined)
			{
				d.chunk.high_today=get_reset_scores(); 	// default high scores
				d.chunk.timestamp=date.getTime();
				added_score=true;
			}
		}

		var high_str:String=null;
		var today_str:String=null;
		var loop_str:String=null;

		if(d.global==false)
		{
		
// check time stamp for local time out of 24 hours on todays scores
			if( (date.getTime() - d.chunk.timestamp ) > (1000*60*60*24) ) // one day old, so reset
			{
				d.chunk.high_today=get_reset_scores(); 	// default high scores
				d.chunk.timestamp=date.getTime();
				added_score=true;
			}
			
			high=d.chunk.high;
			high_today=d.chunk.high_today;
			
			high_str='high';
			today_str='high_today';
		}
		else
		{
			high_global=d.chunk.high_global;

			high_str='high_global';
			today_str=null;
		}
		
		if(d.new_score_to_add!=null)
		{
			var insert_idx;
			var i;
			var nn;
			var aa;
	
			nn=d.new_score_to_add.split(';');
	
			for(var ll=0;ll<2;ll++)
			{
				if(ll==0) { loop_str=high_str; }
				if(ll==1) { loop_str=today_str; }
			
				if(loop_str!=null)
				{
					insert_idx=10;
					for(i=0;i<10;i++)
					{
						aa=this[loop_str][i].split(';');
						
		//				trace( aa[1] , nn[1] );
						
						if(aa[1]==nn[1])	// only one score per name
						{
							if( Number(aa[0]) < Number(nn[0]) )	// so ignore it if it is worse
							{
								insert_idx=i;
							}
							else
							{
								insert_idx=-1;
							}
							break;
						}
					}
					this[loop_str][10]=null;
			
					if(insert_idx>=0) // adding new score
					{
						this[loop_str][insert_idx]=d.new_score_to_add;
		
						this[loop_str].sort(sort_scores);
			
						this[loop_str][10]=null;
						this[loop_str].length=10;
						
					}
// check if the newtable contains the new score
					for(i=0;i<10;i++)
					{
						if(this[loop_str][i]==d.new_score_to_add)
						{
							added_score=true;
						}
					}
				}
			}
		}
		
// build top5 for next string to display, always use the local high score table
		d.next_str='';
		for(var i=0;i<5;i++)
		{
			var aa=high[i].split(';');
			
			d.next_str+=aa[1];
			
			if(i!=4)
			{
				d.next_str+=',';
			}
			
		}
				
		if(added_score) // we need to write
		{
			if(d.write==false) // can only write if we have write access
			{
// ask for write access and try all this again
				d.write=true;
				bb.call("loadStatic", d.write, d.global, delegate(got_scores,d));
//EXIT****EXIT****EXIT	
				return;
//EXIT****EXIT****EXIT	
			}
		}
		
		if(d.write==true)	// if we asked to write then we have to write so check size and write
		{
			var i;
			var aa;
			var max_len=1024*15; // 15k max replay size
	
			for(i=0;i<10;i++) // check maximum size of replays
			{
				aa=this[high_str][i].split(';');
				
				if(aa[2]!=null)	// have a replay, do we keep it?
				{
					max_len-=aa[2].length;
					
					if(max_len<0)
					{
						this[high_str][i]=aa[0] + ';' + aa[1];
					}
				}
			}
			d.chunk[high_str]=this[high_str];
			
			if(today_str)	// do todays scores as well (local chunk only)
			{
				for(i=0;i<10;i++) // check maximum size of replays
				{
					aa=this[today_str][i].split(';');
					
					if(aa[2]!=null)	// have a replay, do we keep it?
					{
						max_len-=aa[2].length;
						
						if(max_len<0)
						{
							this[today_str][i]=aa[0] + ';' + aa[1];
						}
					}
				}
				d.chunk[today_str]=this[today_str];
			}
			
			bb.call("saveStatic", d.chunk, d.global, d.chunk_info.key_str, delegate(done_scores,d));
		}
		else
		{
			if(d.global==false) // after doing local (we got here so stuff is sorted) do global update
			{
				d.write=false;
				d.global=true
				bb.call("loadStatic", d.write, d.global, delegate(got_scores,d));
			}
			else
			{
				gone_to_get_scores=null;
				var msg=new Object();
				msg.new_score_to_add=d.new_score_to_add;
				bb.call("sendMessage", msg, d.next_str, delegate(done_msg,null));
			}
		}
		
		thunk();
	}
	
	function done_scores(_success:Boolean, f:Function, d:Array )
	{
		if(_success)
		{
		trace("success");
			if(d.global==false) // after doing local (we got here so stuff is sorted) do global update
			{
				d.write=false;
				d.global=true
				bb.call("loadStatic", d.write, d.global, delegate(got_scores,d));
			}
			else
			{
				gone_to_get_scores=null;
				var msg=new Object();
				msg.new_score_to_add=d.new_score_to_add;
				bb.call("sendMessage", msg, d.next_str, delegate(done_msg,null));
			}
			thunk();
		}
		else
		{
		trace("fail");
		}
	}
	function done_msg(_success:Boolean)
	{
		if(_success)
		{
		trace("success");
		}
		else
		{
		trace("fail");
		}
	}
	
#end

#if VERSION_SITE=='pepere' then

	static var pepere_params:String="30914_1141074667";
//	static var pepere_params:String="30914_1139791406";
	


	var pepere_score_ids:Array;
	
	var pepere_record:LoadVars;
	var pepere_set_data:LoadVars;
	var pepere_get_score_list:LoadVars;
	var pepere_get_data:LoadVars;

	function pepere_record_post()
	{
		if(pepere_record!=null)
		{
			var rank:Number=-1;
			var recordid:Number=-1;
			
			if( typeof(pepere_record.result)!="undefined" ) { rank=Number(pepere_record.result); }
			if( typeof(pepere_record.recordid)!="undefined" ) { recordid=Number(pepere_record.recordid); }
			
		trace('rank='+rank );
		trace('recordid='+recordid );

			if((rank>=1) && (rank<=10))	// top 10 only get replay saved
			{
				if(recordid>0)
				{
					var nn;

					nn=new_score_to_add.split(';');
					
					if(nn[2]!=null)	// check recording string
					{
						pepere_set_data=new LoadVars();
						pepere_set_data.data = nn[2];
						pepere_set_data.recordid = recordid;
						pepere_set_data.params = pepere_params;
						pepere_set_data.sendAndLoad("set_data.php",pepere_set_data,"POST");
						pepere_set_data.onLoad = delegate(pepere_set_data_post,null);
					}
					
					new_score_to_add=null;// flag done
				}
			}
		}
		pepere_record=null;
	}
	
	function pepere_set_data_post()
	{
		trace(pepere_set_data.params );

		if(pepere_set_data!=null)
		{
			pepere_get_score_list_pre();
		}
		pepere_set_data=null;
	}

	function pepere_get_score_list_pre()
	{
		pepere_get_score_list=new LoadVars();
		pepere_get_score_list.params = pepere_params;
		pepere_get_score_list.start = 0;
		pepere_get_score_list.count = 10;
		pepere_get_score_list.sendAndLoad("get_score_list.php",pepere_get_score_list,"POST");
		pepere_get_score_list.onLoad = delegate(pepere_get_score_list_post,null);
	}
	function pepere_get_score_list_post()
	{
		var i:Number;
		
		trace(pepere_get_score_list.params );

		if(pepere_get_score_list!=null)
		{
			reset_scores();
			
			pepere_score_ids=[-1];
			for(i=0;i<=10;i++)
			{
				pepere_score_ids[i]=-1;
			}
			for(i=0;i<=10;i++)	// do some sanity and copy scores across
			{
				if(pepere_get_score_list["name_"+i]+"" != "undefined" )
				{
					if(Number(pepere_get_score_list["score_"+i])>0)
					{
						high[i]= 	pepere_get_score_list["score_"+i] + ";" + 
									pepere_get_score_list["name_"+i] + ";";
									
						pepere_score_ids[i]=Number(pepere_get_score_list["recordid_"+i]);
					}
				}
			}
			thunk();
		}
		pepere_get_score_list=null;
	}
	
	
// load in replay then signal game to start on sucess

	function pepere_load_replay(num:Number)
	{
		show_replay_str=null;
		
		pepere_get_data=new LoadVars();
		pepere_get_data.recordid = pepere_score_ids[num];
		pepere_get_data.params = pepere_params;
		pepere_get_data.sendAndLoad("get_data.php",pepere_get_data,"POST");
		pepere_get_data.onLoad = delegate(pepere_get_data_post,null);
	}

	function pepere_get_data_post()
	{
		trace(pepere_get_data.params );

		if(pepere_get_data!=null)
		{
			show_replay_str=String(pepere_get_data.data);
		}
		pepere_get_data=null;
	}

	
#end


	function so_load()
	{
		so=SharedObject.getLocal("www.wetgenes.com/"+game_name);
		
		var t=so.data;
		
		if(t.version==VERSION)
		{
			if(	t.myname) myname=t.myname;
			for(var i=0;i<10;i++)
			{
				if(	t['score'+i]) high[i]=t['score'+i];
			}
		}
	}
	function so_save()
	{
		var t=so.data;
		
		t.version=VERSION;
		t.myname=myname;
		for(var i=0;i<10;i++)
		{
			t['score'+i]=high[i];
		}
		so.flush();
	}


	function get_reset_scores()
	{
		var a:Array=new Array();
		
		for(var i=0;i<10;i++)
		{
			a[i]="0;...";
		}
		return a;
	}
	
	function reset_scores()
	{
		for(var i=0;i<10;i++)
		{
			high[i]=get_reset_scores();
			high_global[i]=get_reset_scores();
			high_today[i]=get_reset_scores();
		}
	}

	function Scores(_main,_thunk:Function)
	{
		main=_main;
		thunk=_thunk;
		
		myname="Me";
		
		high=new Array();
		high_global=new Array();
		high_today=new Array();
		reset_scores();

		chars_num=new Array(5);
		chars_name=new Array(5);


#if VERSION_SITE=='bunchball' then

		so_load();
		
		new_score_to_add=null;
		bb=new com.bunchball.Api;
		bb.call("getDetails", delegate(got_details,null));

#end

#if VERSION_SITE=='generic' then

		so_load();

#end

#if VERSION_SITE=='pnflashgames' then

		so_load();

		pnfg=new pnFlashGames();

#if	VERSION_BUILD=='debug' then
		pnfg.debugMode=true;
#end

#end

#if VERSION_SITE=='pepere' then

	pepere_get_score_list_pre();

#end
		
		thunk();
		
	}

	static function sort_scores(a:String,b:String){ var as=a.split(";");  var bs=b.split(";"); return Number(as[0])<Number(bs[0]); }
	
	function insert(num:Number,replay:String)
	{
		var str= "" + num + ";" + myname + ';' + replay ;

#if VERSION_SITE=='pnflashgames' then

	pnfg.storeScore(num);

#end


#if VERSION_SITE=='generic' or VERSION_SITE=='pnflashgames' then

		high[10]=str;
		
		high.sort(sort_scores);
		
		high[10]=null;
		high.length=10;
		
		thunk();
		
		so_save();

#end


#if VERSION_SITE=='bunchball' then

		go_get_scores(str);

		so_save();
		
#end


#if VERSION_SITE=='pepere' then

		new_score_to_add=str;
		
		pepere_record=new LoadVars();
		pepere_record.params = pepere_params;
		pepere_record.score = num;
		pepere_record.sendAndLoad("record.php",pepere_record,"POST");
		pepere_record.onLoad = delegate(pepere_record_post,null);

#end

	}
	
	function request_replay(num:Number,from:String)
	{
	
#if VERSION_SITE=='pepere' then

	pepere_load_replay(num);
	
#else
	
		var ss;
		
		if(from=='local')	{	ss=main.scores.high[num];			}
		if(from=='global')	{	ss=main.scores.high_global[num];	}
		if(from=='today')	{	ss=main.scores.high_today[num];		}
		
		var aa=ss.split(";");
		show_replay_str=aa[2];

#end

	}
	
	function update_high()
	{
	
#if VERSION_SITE=='pepere' then
		pepere_get_score_list_pre();
#end

#if VERSION_SITE=='bunchball' then
		go_get_scores(null);
#end
	}
	
}

