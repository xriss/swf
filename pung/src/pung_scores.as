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
import com.dynamicflash.utils.Delegate;

#EDIT_NAME=true

#end

#if VERSION_SITE=='pepere' then

import com.dynamicflash.utils.Delegate;

#EDIT_NAME=false

#end


class pung_scores
{
	static var VERSION:Number=5;


	
	var mc:MovieClip;
	var scores;
	var chars_num;
	var chars_name;
	var myname:String;
	
	var so:SharedObject;
	
	var new_score_to_add:String;
	
#if VERSION_SITE=='pnflashgames' then
	
	var pnfg:pnFlashGames;	

#end


#if VERSION_SITE=='bunchball' then

	var bb_revision_n:Number;

	var bb:com.bunchball.Api;
	var details:Object;

	var chunk_info:Object;
	var chunk:Object;

	function delegate(f:Function)
	{
		return Delegate.create(this,  f);
	}

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
			bb.call("loadStatic", true, false, delegate(got_scores));
		}
		else
		{
		trace("fail");
			details = null;
			
			so_load();
		}
		
// register msg callback for simple use from now on

		bb_revision_n=0;
		bb.setNewDataCallback(delegate(got_bb_msg));
		
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
						bb.call("writeChat", a[1]+" just scored "+Math.floor(a[0]/100)+":"+a[0]%100, delegate(writechat_done));
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


	
	function got_scores(_success:Boolean, _chunk_info:Object)
	{
	var nxt:String;
	var msg:Object;
		
		
		if(_success)
		{
		trace("success");
			chunk_info=_chunk_info;
			chunk=chunk_info.static_obj;
		}
		else
		{
		trace("fail");
			chunk_info = null;
			chunk = null;
		}
		
		if( (typeof(chunk)!='object') || (chunk.version!=VERSION) ) // build new
		{
			chunk=new Object;
			
			chunk.version=VERSION;	// sanity
			chunk.scores=scores; 	// copy default scores
		}
		
		scores=chunk.scores;
		
		if(new_score_to_add!=null)
		{
			var insert_idx;
			var i;
			var nn;
			var aa;
	
			nn=new_score_to_add.split(';');
	
			insert_idx=5;
			for(i=0;i<5;i++)
			{
				aa=scores[i].split(';');
				
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
			scores[5]=null;
	
			if(insert_idx>=0) // adding new score
			{
				scores[insert_idx]=new_score_to_add;

				scores.sort(sort_scores);
	
				scores[5]=null;
				scores.length=5;
				
				chunk.scores=scores;
				
			}
			
			nxt='';
			for(i=0;i<5;i++)
			{
				aa=scores[i].split(';');
				
				nxt+=aa[1];
				
				if(i!=4)
				{
					nxt+=',';
				}
				
			}
			
			msg=new Object();
			msg.new_score_to_add=new_score_to_add;
			trace(msg);
			bb.call("sendMessage", msg, nxt, delegate(done_msg));
			new_score_to_add=null;
		}
		bb.call("saveStatic", chunk, false, chunk_info.key_str, delegate(done_scores));
	}
	
	function done_scores(_success:Boolean)
	{
		if(_success)
		{
		trace("success");
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

	static var pepere_params:String="30914_0";
//	static var pepere_params:String="30914_1139791406";
	


	var pepere_score_ids:Array;
	

	var pepere_load_replay_state:Number;// -1 for loaded, -2 for dont want any, More than 0 is a count down frame timer waiting to load
	var pepere_load_replay_id:Number;
	var pepere_load_replay_str:String;

	var pepere_record:LoadVars;
	var pepere_set_data:LoadVars;
	var pepere_get_score_list:LoadVars;
	var pepere_get_data:LoadVars;

	function delegate(f:Function)
	{
		return Delegate.create(this,  f);
	}

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

			if((rank>=1) && (rank<=5))	// top 5 only get replay saved
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
						pepere_set_data.onLoad = delegate(pepere_set_data_post);
					}
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
		pepere_get_score_list.count = 5;
		pepere_get_score_list.sendAndLoad("get_score_list.php",pepere_get_score_list,"POST");
		pepere_get_score_list.onLoad = delegate(pepere_get_score_list_post);
	}
	function pepere_get_score_list_post()
	{
		var i:Number;
		
		trace(pepere_get_score_list.params );

		if(pepere_get_score_list!=null)
		{
			scores[0]="42;Behold";
			scores[1]="23;the";
			scores[2]="19;stench";
			scores[3]="13;of";
			scores[4]="5;pung";
			
			pepere_score_ids=[-1,-1,-1,-1,-1];
		
			for(i=0;i<=5;i++)	// do some sanity and copy scores across
			{
				if(pepere_get_score_list["name_"+i]+"" != "undefined" )
				{
					if(Number(pepere_get_score_list["score_"+i])>0)
					{
						scores[i]= 	pepere_get_score_list["score_"+i] + ";" + 
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

	function pepere_load_replay()
	{
		pepere_load_replay_str="";
		
		trace(pepere_load_replay_id );
		
		pepere_get_data=new LoadVars();
		pepere_get_data.recordid = pepere_score_ids[pepere_load_replay_id];
		pepere_get_data.params = pepere_params;
		pepere_get_data.sendAndLoad("get_data.php",pepere_get_data,"POST");
		pepere_get_data.onLoad = delegate(pepere_get_data_post);
	}

	function pepere_get_data_post()
	{
		trace(pepere_get_data.params );

		pepere_load_replay_state=-2;	// bad

		if(pepere_get_data!=null)
		{
			pepere_load_replay_str=String(pepere_get_data.data);
			pepere_load_replay_state=-1; // good
		}
		pepere_get_data=null;
	}

	
#end


	function so_load()
	{
		so=SharedObject.getLocal("www.wetgenes.com/pung");
		
		var t=so.data;
		
		if(t.version==VERSION)
		{
			if(	t.myname) myname=t.myname;
			if(	t.pung00_score0) scores[0]=t.pung00_score0;
			if(	t.pung00_score1) scores[1]=t.pung00_score1;
			if(	t.pung00_score2) scores[2]=t.pung00_score2;
			if(	t.pung00_score3) scores[3]=t.pung00_score3;
			if(	t.pung00_score4) scores[4]=t.pung00_score4;
		}
	}
	function so_save()
	{
		var t=so.data;
		
		t.version=VERSION;
		t.myname=myname;
		t.pung00_score0=scores[0];
		t.pung00_score1=scores[1];
		t.pung00_score2=scores[2];
		t.pung00_score3=scores[3];
		t.pung00_score4=scores[4];
		
		so.flush();
	}

	function pung_scores(master,name,level)
	{
		myname="Me";
		mc=master.createEmptyMovieClip(name,level);
		mc.t=this;
		
		scores=new Array(6);
		
		scores[0]="42;Behold";
		scores[1]="23;the";
		scores[2]="19;stench";
		scores[3]="13;of";
		scores[4]="5;pung";

		chars_num=new Array(5);
		chars_name=new Array(5);


#if VERSION_SITE=='bunchball' then

		so_load();
		
		new_score_to_add=null;
		bb=new com.bunchball.Api;
		bb.call("getDetails", delegate(got_details));

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

		myname=pnfg.uname;
#end

#if VERSION_SITE=='pepere' then

	pepere_load_replay_state=-2;
	pepere_load_replay_id=-1;
	
	pepere_get_score_list_pre();

#end
		
		thunk();
		
		mc.onEnterFrame=function()
		{
			if(!this._visible) { return; }
			
			var t=this;
			
//			if(t._alpha>50) { t._alpha-=1; }
			
			t.t.update();
			t.t.draw();
		}
	}

	static function sort_scores(a:String,b:String){ var as=a.split(";");  var bs=b.split(";"); return Number(as[0])<Number(bs[0]); }
	
	function insert(num:Number,replay:String)
	{
		var str= "" + num + ";" + myname + ';' + replay ;


#if VERSION_SITE=='pnflashgames' then

	pnfg.storeScore(num);

#end


#if VERSION_SITE=='generic' or VERSION_SITE=='pnflashgames' then

		scores[5]=str;
		
		scores.sort(sort_scores);
		
		scores[5]=null;
		scores.length=5;
		
		thunk();
		
		so_save();

#end


#if VERSION_SITE=='bunchball' then

		new_score_to_add=str;
		bb.call("loadStatic", true, false, delegate(got_scores));

		so_save();
		
#end


#if VERSION_SITE=='pepere' then

		new_score_to_add=str;
		
		pepere_record=new LoadVars();
		pepere_record.params = pepere_params;
		pepere_record.score = num;
		pepere_record.sendAndLoad("record.php",pepere_record,"POST");
		pepere_record.onLoad = delegate(pepere_record_post);

#end

	}

	function  onChanged()
	{
		if(mc.mynameis.text)
		{
			myname=mc.mynameis.text;
		}
	}

// create all char text elements
	function thunk()
	{
		var chr;
		var n;
		var nam;
		var num;
		var t;
		var i,j,k;
		var div;
		var sp;
		
		for(i=0;i<5;i++)
		{
			sp=scores[i].split(";");
			num=Number(sp[0]);
//			chars_num[i]=new Array(6);
			div=100000;
			for(k=0;k<7;k++)
			{
				if(k!=3) { div/=10; }
				
				nam=("chars_num"+i)+k;
				if(k==6)
				{
					chr="  " + sp[1];
				}
				else
				if(k==3)
				{
					chr=":";
				}
				else
				{
					n=Math.floor((num/div)%10);
					
					if( (k==0) && (n==0) )
					{
						chr=" ";
					}
					else
					if( (k==1) && (n==0) && (num<10000) )
					{
						chr=" ";
					}
					else
					{
						chr=String.fromCharCode(48+n);
					}
				}
				if(k==6)
				{
					mc.createTextField( nam,((i+1)*10+k) , 0 , 0 , 512 , 64 );
				}
				else
				{
					mc.createTextField( nam,((i+1)*10+k) , 0 , 0 , 64 , 64 );
				}
				t=mc[nam];
				t.type="dynamic"; t.embedFonts=true; t.html=true; t.selectable=false;
				t.htmlText="<font face=\"Bitstream Vera Sans\" size=\"48\" color=\"#00ff00\">" +
				
					"<a href=\"asfunction:_root.click_score," + i + "\">"+
					chr +
					"</a>"+
					"</font>";
				t._x=120+k*32;
				t._y=160+32+i*48;
				chars_num[i][k]=t;
			}
		}

		mc.createTextField( "mynametxt",9990 , 8*10 , 8*65 , 8*74 , 8*6 );
		t=mc["mynametxt"];t.type="dynamic";t.embedFonts=true;t.html=true; t.selectable=false;
		t.htmlText="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#00ff00\">My name is : </font>";

		mc.createTextField( "mynameis",9991 , 8*38 , 8*65 , 8*48 , 8*6 );
		t=mc["mynameis"];t.embedFonts=true;
		t.text=myname;
		t.restrict="0123456789ABCDEFGHIJKLMNOPRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		t.maxChars=16;

#if EDIT_NAME then
	t.type="input";
	t.selectable=true;
#else
	t.type="dynamic";
	t.selectable=false;
#end

		var fmt=new TextFormat();
		fmt.font="Bitstream Vera Sans";
		fmt.size=32;
		fmt.color=0x00ff00;
		t.setTextFormat(fmt);
		t.addListener(this);
		

		mc.createTextField( "continue",9992 , 8*10 , 8*58 , 8*74 , 8*6 );
		t=mc["continue"];t.type="dynamic";t.embedFonts=true;t.html=true; t.multiline=true;t.selectable=false;
		t.htmlText="<a href=\"asfunction:_root.click_continue\"><font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#00ff00\">Click here or press SPACE to play.</font></a>";
		
		mc.createTextField( "replayinfo",9993 , 8*10 , 8*18 , 8*74 , 8*6 );
		t=mc["replayinfo"];t.type="dynamic";t.embedFonts=true;t.html=true; t.multiline=true;t.selectable=false;
		t.htmlText="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#00ff00\">Click a high score to view its replay.</font>";


	}

	function update()
	{
	}

	function draw()
	{
	}
	
}

