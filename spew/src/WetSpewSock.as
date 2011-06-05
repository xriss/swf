/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#GFX=GFX or "gfx"
#DBG=DBG or "dbg"

class WetSpewSock
{
	var mc;

	var up;
	
	var sock;
	
	var connected;
	var authenticated;
	
	var logged_in;
	
	var state;
	var substate;

	
// user list for the current room...
	var user_lookup=[];
	var users=[];
	var users_stamp=0; // last time users table list was updated

	var room="limbo";
	
	var room_lookup=[];
	var rooms=[];
	var rooms_stamp=0; // last time rooms table list was updated
	
	
	var game_msgid=1;
	var game_callbacks;
	
	var ville_msgid=1;
	var ville_callbacks;
	
	var ewarz_msgid=1;
	var ewarz_callbacks;
	
	var joins=[]; // smart join/part notification
	var parts=[];
	
	
// keep track of who is playing what when we get notified, never clear these arrays

	var map_user_to_color=[];		// user name -> color
	var map_user_to_gameid=[];		// user name -> game number
	var map_gameid_to_gamename=[];	// game number -> game name
	
	var map_user_to_info=[];		// user name -> { information }
	
	var watch_chat; // chat callback function to see what is said
	
	var standalone;
	
	function WetSpewSock(_up,_standalone)
	{
		up=_up;
		standalone=_standalone;
		
		setup();
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function setup()
	{
	var s;
	
		so_load();
	
		mc=#(GFX).create_clip(up.mc,null);
//		mc.onEnterFrame=delegate(update,null);
		
		state=null;
		substate=null;
		
		if( !_root.Login_Name ) { _root.Login_Name="me"; }
//		if( !_root.host ) { _root.host="spew.wetgenes.com"; }
//		if( !_root.scalar ) { _root.scalar=new Scalar(400,600); }
		
		sock= new XMLSocket();
		
		connected=false;
		authenticated=false;
		
		game_callbacks=new Array();
		ville_callbacks=new Array();
		ewarz_callbacks=new Array();
		
		sock.onConnect = delegate(sock_onconnect);
		sock.onClose = delegate(sock_onclose);
		sock.onData = delegate(sock_ondata);
	
//		sock.connect("toosh", 5223);

		sock.connect("spew.wetgenes.com", 5223); // force chat host
		
	}
	
	var msg;
	var usr;
	var hash;
	
	function sock_onconnect(success:Boolean)
	{
		msg=new Object();
		usr=new Object();
		
		up.talk.chat_status("Booting WetSpew chat client V#(VERSION_NUMBER) (c) Shi+Kriss Daniels #(VERSION_STAMPNUMBER) please remain calm, everything will be alright.");
		
	    if (success)
		{
			up.talk.chat_status("Connected to "+_root.host);
//		    dbg.print("Connection succeeded!")
			connected=true;
			
		var p;
		var phost="&arg2="+escape(_root._url);
				
			hash=_root.hash;
		
			if(!hash) // then send filename without the .swf as hash value, eg room to join
			{
				var hash_a=_root._url.split("/");
				var hash_name=hash_a[hash_a.length - 1];
				hash_a=hash_name.split(".");
				hash_a.pop();
				hash=hash_a.join(".");
			}
			
//	#(DBG).print(hash);
			
		
			if( _root.signals.up.v.name )
			{
				p="";
				p+="&cmd=note";
				p+="&note=playing";
				p+="&arg1="+_root.signals.up.v.name;
				p+=phost;
				p+="&hash="+escape(hash);
				p+="&\n";
				sock.send(p);
			}
			else
			if( _root.wetdike )
			{
				p="";
				p+="&cmd=note";
				p+="&note=playing";
				p+="&arg1="+"WetDike";
				p+=phost;
				p+="&hash="+escape(hash);
				p+="&\n";
				sock.send(p);
			}
			else
			if( _root.gamename )
			{
				p="";
				p+="&cmd=note";
				p+="&note=playing";
				p+="&arg1="+escape(_root.gamename);
				p+=phost;
				p+="&arg3="+escape(_root.gameid);
				p+="&hash="+escape(hash);
				p+="&\n";
				sock.send(p);
			}
			else
			{
				p="";
				p+="&cmd=note";
				p+="&note=playing";
				p+="&arg1="+"chat";
				p+=phost;
				p+="&arg3=0";
				p+="&hash="+escape(hash);
				p+="&\n";
				sock.send(p);
			}
	    }
		else
		{
			up.talk.chat_status("Failed to connect to "+_root.host);
//			dbg.print("Connection failed!")
			connected=false;
	    }
	}
	
	function sock_onclose()
	{
		msg=new Object();
		
		up.talk.chat_status("Lost connection to "+_root.host);
		up.talk.chat_status("try /connect to reconnect...");
//		dbg.print("Connection closed!")
		connected=false;
	}
	
	function check_show_joins(usr) // show that the user has joined only when they talk
	{
		if( joins[usr] )
		{
			var t=up.talk.chat_status(joins[usr]);
			joins[usr]=undefined;
			
			t.usr=usr;
		}
		parts[usr]=true;
	}
	
	function setrgb(usr,rgb) // server says to set the users text color to this
	{
		if(usr && rgb)
		{
			up.talk.rgbarr[usr]=rgb;
		}
	}
	
//
// Main incoming data function
//
// string packets come into this main function
//
	function sock_ondata(s)
	{
	var aa,a,r,i;
	var idx;
	var info;
	
		if(s=="") { return; } // ignore blank data, but data containing just an "&" is a repeated msg so should not be ignored
		
//		dbg.print("got : "+s);
		
		r=new Object();
		aa=s.split("&");
		for(i=0;i<aa.length;i++)
		{
			a=aa[i].split("=");
			
			
			if(a[0]&&a[1])
			{
//				#(DBG).print("*"+a[0]+"="+a[1]);
				
				r[a[0]]=unescape(a[1].split("+").join("%2B")); // do I still need to fix + ???
//				r[a[0]]=unescape(a[1]); // yes i do, oh well
			}
			else
			if(a[0])
			{
				r[a[0]]="";
			}
		}
		
		for(idx in r)
		{
			msg[idx]=r[idx];
		}


		if(msg["swf_class"]&&msg["swf_version"]&&msg["swf_url"]&&msg["swf_urlbase"]&&(msg["cmd"]=="swf_update"))
		{
			var json = new JSON();
		
			var cc=_root[ msg["swf_class"] ];
			
			_root.server_data={}
			
			_root.server_data.swf_class=msg.swf_class;
			_root.server_data.swf_version=msg.swf_version;
			_root.server_data.swf_url=msg.swf_url;
			_root.server_data.swf_urlbase=msg.swf_urlbase;
			_root.server_data.swf_dat=msg.swf_dat; // load xml data from here
			
			_root.server_data.swf_json=msg.swf_json; // more json encoded data
			
//			#(DBG).print("test "+msg["swf_class"]);
//			#(DBG).print("test "+msg["swf_version"]);
//			#(DBG).print("test "+msg["swf_url"]);
					
			if( cc )
			{
//				#(DBG).print("check class");

				if( (cc.v.number*1) < (msg["swf_version"]*1) ) // check failed
				{
					var m=#(GFX).create_clip(mc,99999);
					m.tf=#(GFX).create_text_html(m,null,0,0,400,200);
					#(GFX).set_text_html(m.tf,32,0xffffff,"<p align=\"center\">This version is now obsolete, please visit www.WetGenes.com for a new version.</p>");
		
		
//					#(DBG).print("reload movie");

/*
					var id;
					for( id in _root)
					{
						if (typeof(_root[id]) == "movieclip")
						{
							if( ( _root[id] != _root ) )
							{
								_root[id].removeMovieClip();
							}
						}
						_root[id]=undefined;
					}
*/

//					_root.onEnterFrame=undefined;
//					_root.loadMovie( msg["swf_url"] );

//					unloadMovie("_level0");

/*
					cc.mc.removeMovieClip();
					_root.sock.clean();
					_root.talk.clean();
					
					var args="?hash="+hash;
					if(_root.S)
					{
						args=args+"&S="+_root.S;
					}
					if(_root.name)
					{
						args=args+"&name="+_root.name;
					}

					getURL(msg["swf_url"]+args,"_level0");
*/
				}
			}
			
			_root.server_json=json.parse(msg.swf_json); // more game datas expanded
		}
		else
		if(msg["txt"]&&msg["frm"]&&msg["lnk"]&&(msg["cmd"]=="lnk"))
		{
		var t={};
		
			check_show_joins(msg["frm"]);
			
			t.frm=msg["frm"];
			t.cmd="say";
			t.txt=msg["txt"];
			t.lnk=msg["lnk"];
			t.img=msg["img"];
			up.talk.chat(t);
			
		}
		else
		if(msg["txt"]&&(msg["cmd"]=="mux"))
		{
			var muxtxt;//=msg["txt"].split("&lt;").join("<").split("&gt;").join(">"); // allow html control
//			muxtxt=muxtxt.split("<img xch_graph=hide>").join("");
//			muxtxt=muxtxt.split("<xch_page clear=links>").join("");
			
// till we can send valid xhtml...

			muxtxt=msg["txt"];
			
			up.talk.chat_mux(muxtxt+"<br>")
		}
		else
		if(msg["txt"]&&msg["frm"]&&(msg["cmd"]=="say"))
		{
		var t={};
		
			check_show_joins(msg["frm"]);
			
			t.frm=msg["frm"];
			t.cmd="say";
			t.txt=msg["txt"].split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;"); // disable any html people may say
			up.talk.chat(t);
			
		}		
		else
		if(msg["txt"]&&msg["frm"]&&(msg["cmd"]=="act"))
		{
		var t={};
		
			check_show_joins(msg["frm"]);
			
			t.frm=msg["frm"];
			t.cmd="act";
			t.txt=msg["txt"].split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;"); // disable any html people may say
			up.talk.chat(t);
			
		}		
		else
		if(msg["cmd"]=="note")
		{
			switch(msg["note"])
			{
				case "feat": // achieved a server side feat
					
					_root.signals.submit_award(msg["arg1"],msg["arg2"]);
					
					if( (msg["arg2"]!="1") && (_root.fb_sig) ) // ok tell facebook to update if we are on facebook
					{
						var t=new LoadVars();
						var ts;
						for(ts in _root)
						{
							if(ts.substring(0,6)=="fb_sig")
							{
								t[ts]=_root[ts];
							}
						}
						t.sendAndLoad("http://swf.wetgenes.com/swf/facebook/wetgenes.php/feedpost",t,"POST");
					}
				break;
				
				case "rank": // server side rank changed (global up/down score) for multiplayer games
					_root.signals.submit_rank(msg["arg1"],msg["arg2"]);
				break;
				
				case "info": // setting some precise info
					if( msg["info"]=="user" )
					{
						if( msg["name"] )
						{
//				#(DBG).print("gotinfo "+msg["name"]+" : "+msg["avatar"]);

							if( ! map_user_to_info[ msg["name"] ] )
							{
								map_user_to_info[ msg["name"] ]={};
							}
							
							info=map_user_to_info[ msg["name"] ];
							
							info.avatar=msg["avatar"]; // the web location of a 100x100 avatar
							info.stat=msg["stat"]; // the current user status
							
							if( msg["joined"] )
							{
								info.joined=msg["joined"]; // date (unixtime) user joined site or 0 if guest etc
							}
							
							var date=new Date();
							info.t=date.getTime()
							
							if( msg["gameid"] && msg["gamename"] && (msg["gameid"]!="-") && (msg["gamename"]!="-") )
							{
								map_user_to_gameid[ 		msg["name"] ]		=	msg["gameid"];
								map_gameid_to_gamename[		msg["gameid"] ]		=	msg["gamename"];
							}
						}
					}
				break;
				
				case "act": // display results of new smart acts
					if( msg["arg1"] )
					{
						up.talk.chat_status("<font color=\"#00ff00\">"+msg["arg1"]+"</font>")
					}
				break;
				
				case "error":
					if( msg["arg1"] )
					{
						up.talk.chat_status("ERROR: "+msg["arg1"])
					}
				break;
				
				case "warning":
					if( msg["arg1"] )
					{
						up.talk.chat_status("WARNING: "+msg["arg1"])
					}
				break;
				
				case "notice":
					if( msg["arg1"] )
					{
						up.talk.chat_status("NOTICE: "+msg["arg1"])
					}
				break;
				
				case "welcome":
					if( msg["arg1"] )
					{
						up.talk.chat_status("<b>"+msg["arg1"]+"</b>")
						
						joins=[]; // new room , new smart notes
						parts=[];
						
						
						up.talk.set_back( msg["back"] );
					}
				break;
				
				case "ranking":
					if( msg["arg1"] && msg["arg2"] && msg["arg3"] && msg["arg4"] )
					{
					var t={};
//						check_show_joins(msg["arg3"]);
						
						t.frm="*";
						t.cmd="say";
						t.txt=msg["arg1"]+":"+msg["arg2"]+" "+msg["arg3"]+" is now #"+msg["arg4"];
						t.gamename=msg.arg1;
						t.gameseed=msg.arg2;
						t.username=msg.arg3;
						t.userrank=msg.arg4;					
						up.talk.chat(t);
						
					}
				break;
				
				case "rename":
					if( msg["arg1"] && msg["arg2"] && msg["arg3"] )
					{
						check_show_joins(msg["arg2"]);
//						setrgb(msg["arg2"],msg["rgb"]);
						
						if( msg["arg3"]=="guest" )
						{
							up.talk.chat_status(msg["arg1"]+" is now known as "+msg["arg2"]+" the guest")
							authenticated="guest";
						}
						else
						{
							up.talk.chat_status(msg["arg1"]+" is now known as "+msg["arg2"])
							authenticated="user";
						}
					}
				break;
				
					
				case "join":
					if( msg["arg1"] && msg["arg2"] && msg["arg3"] )
					{
//						setrgb(msg["arg1"],msg["rgb"]);
			
						if( msg["arg2"]!="*" ) // these joins are not really joins
						{
							joins[msg["arg1"]]=msg["arg1"]+" has joined room "+msg["arg2"]+" playing "+msg["arg3"]+" click here to play it with them!!!"; // just remember the join msg
						}
						
						var username=msg["arg1"];
						var gamename=msg["arg3"];
						var gameid=msg["arg4"];
						var color=msg["arg5"];
						
						gameid=Math.floor(gameid);
						if(gameid<0) { gameid=0; }
						
						var str=gamename.split(".")[0];
						var dat=up.talk.game_infos[str];
						
						if(dat) // override with local gameid if we have it from name
						{
							if(dat.lnkid>0)
							{
								if(gameid==0)
								{
									gameid=dat.lnkid;
								}
							}
						}
						
						
						map_user_to_gameid[username]=gameid;
						map_gameid_to_gamename[gameid]=gamename;
						
						if(color && color!="" && color!="0")
						{
//	#(DBG).print("SET: "+username);
							map_user_to_color[username]=color;
						}
						else
						{
//	#(DBG).print("CLR: "+username);
							map_user_to_color[username]=undefined;
						}
						
//						up.talk.chat_status(msg["arg1"]+" has joined room "+msg["arg2"]+" playing "+msg["arg3"])
					}
				break;
				
				case "part":
					if( msg["arg1"] && msg["arg2"] )
					{
						if(parts[ msg["arg1"] ]) // user is flaged as intersting so we say when they leave the room
						{
							up.talk.chat_status(msg["arg1"]+" has left room "+msg["arg2"])
							parts[ msg["arg1"] ]=undefined;
						}
					}
				break;
				
				case "ban":
					if( msg["arg1"] && msg["arg2"] && msg["arg3"])
					{
						if( Math.floor(msg["arg3"]) > 0 )
						{
							up.talk.chat_status(msg["arg2"]+" has been banned by "+msg["arg1"])
						}
						else
						{
							up.talk.chat_status(msg["arg2"]+" has been unbanned by "+msg["arg1"])
						}
					}
				break;
				
				case "gag":
					if( msg["arg1"] && msg["arg2"] && msg["arg3"])
					{
						if( Math.floor(msg["arg3"]) > 0 )
						{
							up.talk.chat_status(msg["arg2"]+" has been gagged by "+msg["arg1"])
						}
						else
						{
							up.talk.chat_status(msg["arg2"]+" has been ungagged by "+msg["arg1"])
						}
					}
				break;
				
				case "dis":
					if( msg["arg1"] && msg["arg2"] && msg["arg3"])
					{
						if( Math.floor(msg["arg3"]) > 0 )
						{
							up.talk.chat_status(msg["arg2"]+" has been disemvowled by "+msg["arg1"])
						}
						else
						{
							up.talk.chat_status(msg["arg2"]+" has been revowled by "+msg["arg1"])
						}
					}
				break;
				
				case "users":
					if( msg["list"] && msg["room"] )
					{
					var	us=msg["list"].split(",").sort();
					var ut;
					var u;
					
						room=msg["room"];
						
						users=[];
						user_lookup=[];
						
						for( i=0 ; i<us.length ; i++)
						{
							ut=us[i].split(":");
							
							u={};
							u.user_name=ut[0];
							u.game_name=ut[1];
							u.game_id=Math.floor(ut[2]);
							u.formrank=ut[3];
							u.color=ut[4];
							
							users[i]=u;
							user_lookup[u.user_name]=u;
							
							var str2=u.game_name.split(".")[0];
							var dat2=up.talk.game_infos[str2];
							
							if(dat2) // override with local gameid if we have it from name
							{
								if(dat2.lnkid>0)
								{
									if(u.game_id==0)
									{
										u.game_id=dat2.lnkid;
									}
								}
							}
						
							map_user_to_gameid[u.user_name]=u.game_id;
							map_gameid_to_gamename[u.game_id]=u.game_name;
							if(u.color && u.color!="" )
							{
								map_user_to_color[u.user_name]=u.color;
							}
							else
							if(up.talk.rgbarr[u.user_name]) // assigned by us
							{
								u.color=up.talk.rgbarr[u.user_name];
							}
						}
						
						users_stamp++;
					}
					else
					if( msg["room"] ) // no users
					{
						room=msg["room"];
						users=[];
						users_stamp++;
					}
				break;
				
				case "rooms":
					if( msg["list"])
					{
					var	rs=msg["list"].split(",").sort();
					var rt;
					var rr;
					
						rooms=[];
						room_lookup=[];
						
						
						for( i=0 ; i<rs.length ; i++)
						{
							rt=rs[i].split(":");
							
							rr={};
							rr.room_name=rt[0];
							rr.room_members=Math.floor(rt[1]);
							
							rooms.push(rr);
							room_lookup[rr.room_name]=rr;
							
						}
						
						rooms_stamp++;
					}
					
				break;
			}
		}
		else
		if(msg["cmd"]=="game")
		{
		var tab=new Array();
		
			for(idx in msg) // copy msg to return
			{
				tab[idx]=msg[idx];
			}
			
			tab.gid=Math.floor(tab.gid); // force to integer
			
			if(game_callbacks[tab.gid])
			{
				game_callbacks[tab.gid](tab); // callback with result
				
				if(tab.gid!=0) // never forget the base callback
				{
					game_callbacks[tab.gid]=null; // forget
				}
			}
			else
			if(game_callbacks[0])
			{
				game_callbacks[0](tab); // callback with result
			}
/*
			else
			{
	#(DBG).print("missed gmsg");
			}
*/
		}
		else
		if(msg["cmd"]=="ville")
		{
		var tab=new Array();
		
			for(idx in msg) // copy msg to return
			{
				tab[idx]=msg[idx];
			}
			
			tab.vid=Math.floor(tab.vid); // force to integer
			
			if(ville_callbacks[tab.vid])
			{
				ville_callbacks[tab.vid](tab); // callback with result
				
				if(tab.vid!=0) // never forget the base callback
				{
					ville_callbacks[tab.vid]=null; // forget
				}
			}
			else
			if(ville_callbacks[0])
			{
				ville_callbacks[0](tab); // callback the master callback with result
			}
		}
		else
		if(msg["cmd"]=="ewarz")
		{
		var tab=new Array();
		
			for(idx in msg) // copy msg to return
			{
				tab[idx]=msg[idx];
			}
			
			tab.eid=Math.floor(tab.eid); // force to integer
			
			if(ewarz_callbacks[tab.eid])
			{
				ewarz_callbacks[tab.eid](tab); // callback with result
				
				if(tab.eid!=0) // never forget the base callback
				{
					ewarz_callbacks[tab.eid]=null; // forget
				}
			}
			else
			if(ewarz_callbacks[0])
			{
				ewarz_callbacks[0](tab); // callback the master callback with result
			}
		}

	}


//
// send a game message to the server, return information to the callback when and if the server talks to us
//
// returns true if you should expect a callback, but hey, you still might not get one.
//
	function gmsg(msg,callback) 
	{
	var p;
	var idx;
	
		if(connected) // cant use these commands untill we are connected
		{
			if(msg==null) // just register a generic callback for game msgs
			{
				game_callbacks[0]=callback; // remember generic callback
				return true;
			}
		
			game_msgid++;
			
			game_callbacks[game_msgid]=callback; // remember callback
		
			p="";
			p+="&cmd="+"game";
			p+="&gid="+game_msgid;

// gid  == the id of this packet every sent msg generates a response with the same id (sender incs with each send)

// gcmd == the game command (all commands have a 'ret' response for returned values which is paired by the id)
// garg == the game command arg string ( deliminated by ',' )
// gret == the returned value from the command, deliminated by ',' for lists etc "OK" for command worked, an error string if it failed
// gdat == a mime encoded "large" chunk of data sent or received

			for(idx in msg)
			{
				p+="&"+idx+"="+msg[idx];
			}
			
			p+="&\n";
			
			return sock.send(p);
		}
		
		return false;
	}

//
// send a ville message to the server, return information to the callback when and if the server talks to us
//
// returns true if you should expect a callback, but hey, you still might not get one.
//
	function vmsg(msg,callback) 
	{
	var p;
	var idx;
	
		if(connected) // cant use these commands untill we are connected
		{
			if(msg==null) // just register a generic callback for game msgs
			{
				ville_callbacks[0]=callback; // remember generic callback
				return true;
			}
		
			ville_msgid++;
			
			ville_callbacks[ville_msgid]=callback; // remember callback
		
			p="";
			p+="&cmd="+"ville";
			p+="&vid="+ville_msgid;

// vid  == the id of this packet every sent msg generates a response with the same id (sender incs with each send)

// vcmd == the ville command (all commands have a 'ret' response for returned values which is paired by the id)
// varg == the game command arg string ( deliminated by ',' )
// vret == the returned value from the command, deliminated by ',' for lists etc "OK" for command worked, an error string if it failed
// vdat == a mime encoded "large" chunk of data sent or received

			for(idx in msg)
			{
				p+="&"+idx+"="+msg[idx];
			}
			
			p+="&\n";
			
			return sock.send(p);
		}
		
		return false;
	}

//
// send a ewarz message to the server, return information to the callback when and if the server talks to us
//
// returns true if you should expect a callback, but hey, you still might not get one.
//
	function emsg(msg,callback) 
	{
	var p;
	var idx;
	
		if(connected) // cant use these commands untill we are connected
		{
			if(msg==null) // just register a generic callback for game msgs
			{
				ewarz_callbacks[0]=callback; // remember generic callback
				return true;
			}
		
			ewarz_msgid++;
			
			ewarz_callbacks[ewarz_msgid]=callback; // remember callback
		
			p="";
			p+="&cmd="+"ewarz";
			p+="&eid="+ewarz_msgid;

// vid  == the id of this packet every sent msg generates a response with the same id (sender incs with each send)
			
			for(idx in msg)
			{
				p+="&"+idx+"="+escape(msg[idx]);
			}
			
			p+="&\n";
			
			return sock.send(p);
		}
		
		return false;
	}

	function trim_str_space(s)
	{
		var i=0;
		var l=0;
		var r=s.length-1;
		for(i=0;i<s.length;i++)
		{
			if(s.charCodeAt(i)>32)
			{
				l=i;
				break;
			}
		}
		for(i=s.length-1;i>=0;i--)
		{
			if(s.charCodeAt(i)>32)
			{
				r=i;
				break;
			}
		}
		return(s.substr(l,r+1-l));
	}
	
	function trim_str_star(s)
	{
		var i=0;
		var l=0;
		var r=s.length-1;
		for(i=0;i<s.length;i++)
		{
			if(s.charCodeAt(i)!=42)
			{
				l=i;
				break;
			}
		}
		for(i=s.length-1;i>=0;i--)
		{
			if(s.charCodeAt(i)!=42)
			{
				r=i;
				break;
			}
		}
		return(s.substr(l,r+1-l));
	}


	
//
// Main outgoing data function
//
// send simple string to server, IE chat
//
// This is turning into a onestop output factory
//
// with other functions just using /cmds to request things in a stateless fasion
//
	function chat(s) 
	{
	var f;
	var p;
	var aa;
	var ss;
	
		if(s.substring(0,1)=="*") // a shorthand for /me
		{
			if(connected) // cant use these commands untill we are connected
			{
				ss=trim_str_space( trim_str_star(s) );
				
				if( ss && ss!="" ) // check something is left
				{
					p="";
					p+="&cmd="+"act";
					p+="&txt="+escape(ss);
					p+="&\n";			
					f=sock.send(p);
				}
			}
		}
		else
		if(s.substring(0,1)=="/") // handle / commands
		{
			aa=s.split(" ");
			
			if(connected) // cant use these commands untill we are connected
			{
				switch( aa[0].toLowerCase() )
				{
					case "/me" :
						p="";
						p+="&cmd="+"act";
						p+="&txt="+escape( (s.substring(4)) );
						p+="&\n";
						
						f=sock.send(p);
				
					break;
					
					case "/info" : // request some info
					
						p="";
						p+="&cmd="+"note";
						p+="&note=info";
						p+="&info="+escape( aa[1]?aa[1]:"user" );
						p+="&name="+escape( aa[2]?aa[2]:"me" );
						p+="&\n";
					
						f=sock.send(p);
						
					break;
					
					case "/login" :
					case "/nick" :
					
//						msg["cmd"]="login";
//						msg["name"]=aa[1]?aa[1]:"me";
//						msg["pass"]=aa[2]?aa[2]:"";
							
						so.data.login=aa[1]?aa[1]:"me";
						
						so_save();
						
						p="";
						p+="&cmd="+"login";
						p+="&name="+escape( so.data.login );
						p+="&pass="+escape( aa[2]?aa[2]:"" );
						p+="&\n";
					
						f=sock.send(p);
				
					break;
					
					case "/session" :
					
//						msg["cmd"]="session";
//						msg["sess"]=aa[1]?aa[1]:"";
						
						so.data.session=aa[1]?aa[1]:"";
						
						so_save();
						
						p="";
						p+="&cmd="+"session";
						p+="&sess="+escape( so.data.session );
						p+="&\n";
					
						f=sock.send(p);
				
					break;
					
					case "/join" :
					
//						msg["cmd"]="join";
//						msg["room"]=aa[1]?aa[1]:"";
							
						p="";
						p+="&cmd="+"join";
						p+="&room="+escape( aa[1]?aa[1]:"" );
						p+="&\n";
					
						f=sock.send(p);
				
					break;
					
					case "/users" :
					
//						msg["cmd"]="users";
							
						p="";
						p+="&cmd="+"users";
						p+="&\n";
					
						f=sock.send(p);
				
					break;
					
					case "/rooms" :
					
//						msg["cmd"]="rooms";
							
						p="";
						p+="&cmd="+"rooms";
						p+="&\n";
					
						f=sock.send(p);
				
					break;
					
					case "/find" :
							
						p="";
						p+="&cmd="+"find";
						p+="&user="+escape( aa[1]?aa[1]:"me" );
						p+="&\n";
					
						f=sock.send(p);
				
					break;
					
					case "/connect" :
					
						sock.close();
						sock.connect(aa[1]?aa[1]:_root.host, aa[2]?aa[2]:5223);
					
					break;
					
					
					case "/kick" : // kick into another room
					
						p="";
						p+="&cmd="+"kick";
						p+="&user="+escape( aa[1]?aa[1]:"me" );
						p+="&room="+escape( aa[2]?aa[2]:"limbo" );
						p+="&\n";
					
						f=sock.send(p);
				
					break;
					
					case "/ban" : // banish to limbo , they can not even leave to play social games
					
//						msg["cmd"]="ban";
//						msg["user"]=aa[1]?aa[1]:"me";
//						msg["time"]=aa[2]?aa[2]:"15"; // default of 15 minutes
							
						p="";
						p+="&cmd="+"ban";
						p+="&user="+escape( aa[1]?aa[1]:"me" );
						p+="&time="+escape( aa[2]?aa[2]:"15" );
						p+="&\n";
					
						f=sock.send(p);
				
					break;
					
					case "/gag" :	// only allowed to utter vowels, but they can still play social games
					
//						msg["cmd"]="gag";
//						msg["user"]=aa[1]?aa[1]:"me";
//						msg["time"]=aa[2]?aa[2]:"15"; // default of 15 minutes
							
						p="";
						p+="&cmd="+"gag";
						p+="&user="+escape( aa[1]?aa[1]:"me" );
						p+="&time="+escape( aa[2]?aa[2]:"15" );
						p+="&\n";
					
						f=sock.send(p);
				
					break;
					
					case "/dis" : // disemvowel, only allowed to utter consonants , but they can still play social games
					
//						msg["cmd"]="dis";
//						msg["user"]=aa[1]?aa[1]:"me";
//						msg["time"]=aa[2]?aa[2]:"15"; // default of 15 minutes
							
						p="";
						p+="&cmd="+"dis";
						p+="&user="+escape( aa[1]?aa[1]:"me" );
						p+="&time="+escape( aa[2]?aa[2]:"15" );
						p+="&\n";
					
						f=sock.send(p);
				
					break;
					
					default:
						up.talk.chat_status("unknown /command")
					break;
				}
			}
			else
			{
				switch( aa[0].toLowerCase() )
				{
					case "/connect" :
					
						sock.close();
						sock.connect(aa[1]?aa[1]:_root.host, aa[2]?aa[2]:5223);
					
					break;
				}
			}
			
		}
		else
		{
			if(connected) // cant chat till we are ready
			{
			
//				msg["cmd"]="say";
//				msg["txt"]=(s);
				
				p="";
				p+="&cmd="+"say";
				p+="&txt="+escape( s );
				p+="&\n";
			
//			dbg.print(s);

				
				f=sock.send(p);
			}
		}
	}
	
	function clean()
	{
		sock.close();
		
		mc.removeMovieClip();
	}

	function update()
	{
		
		if(connected) // cant chat till we are ready
		{
			if(standalone) // spew is stand alone
			{
				if(!so_login_done)
				{
					so_login() // so try a remembered login
					so_login_done=true;
				}
			}
			else
			if(_root.Login_Done) // we have logged in
			{
				if( usr.Login_Name != _root.Login_Name) // new login name so need to tell chat about it
				{				
					if( _root.Login_Session!=0 ) // real login
					{
						chat("/session "+_root.Login_Session);
					}
					else // guest
					{
						chat("/login "+_root.Login_Name);
					}
					
					usr.Login_Name=_root.Login_Name; // mark this name as processed
				}
			}
		}
		
//		#(DBG).print("sockit")
	}
	
	var so;
	
	function so_load()
	{
		so=SharedObject.getLocal("spew");
	}

	function so_save()
	{
		so.flush();
	}
	
	var so_login_done;
	
	function so_login() // attempt a log in from  so data
	{
		if(_root.S) // try passed in session as main login override
		{
			chat("/session "+_root.S);
			return;
		}
				
		so_load();
		
//	#(DBG).print("so_login")

		if((so.data.session)&&(so.data.session!=""))
		{
			chat("/session "+so.data.session);
//	#(DBG).print("session"+so.data.session)
		}
		else
		if((so.data.login)&&(so.data.login!=""))
		{
			chat("/login "+so.data.login);
//	#(DBG).print("login"+so.data.login)
		}
		else
		if((_root.name)&&(_root.name!=""))
		{
			chat("/login "+_root.name);
		}
	}
	
}
