/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vcomms
{
	var up;
	
	var state;
	
	var names; // user names to avatar vcobjs ids
	
	var id; // the id of our avatar
	
	var vcobjs;
	
	var loading; // a loading msg if we seem to be loading still
	
	function Vcomms(_up)
	{
		up=_up;
		
		state="setup";
		
		loading="setup";
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
		if((_root.sock)&&(_root.sock.connected)) // need a sock available
		{
			if((state!="ready")&&(state!="loading"))
			{
				if( _root.sock.vmsg( null , delegate(vmsgback,null) ) ) // request all ville msgs to come through here till further notice
				{
					_root.sock.watch_chat=delegate(chat);
					
					state="ready";
				}
			}
		}
	}
	
	function clean()
	{
	}

//
// Watch all chat msgs
//
	function chat(t)
	{
	var vcobj;
	
		if(t.frm && t.txt)
		{

			vcobj=vcobjs[names[t.frm.toLowerCase()]]
			
			if(vcobj) // this person is talking
			{
				if(t.cmd=="act") // action
				{
					vcobj.vobj.talk.display_act("**"+t.txt+"**",1);
				}
				else // talking
				{
					vcobj.vobj.talk.display(t.txt,25*5);				
				}
			}
		}
	}

	
//
// Send a msg to the server, returns true is we tried to send it
//
	function vmsgsend(msg)
	{
//		dbg.dump(msg);
	
		_root.sock.vmsg(msg) 
		return;
	}
	
//
// Incoming msgs from the server
//
	function vmsgback(msg,sentmsg)
	{
	var vobj,vcobj;
	
		if(!sentmsg) // incoming msg, not a reply
		{
			switch(msg.vcmd)
			{
			
				case "vid" : // recieving id info
				
					id=msg.vobj;
				
				break;
						
				case "vobj" : // new vobject, depending on type this may do other things
				
					state="loading";
										
					switch(msg.vtype)
					{
						
						case "room" : // new room, destroy all objects and start again with this room
						
							clear_all_vcobjs();
						
							vcobj=new VcommsObj(this);
							vcobj.setup_msg(msg);
							vcobjs[vcobj.id]=vcobj;
					
							up.room.clean();
							vobj=up.room.setup(msg.vurl);
							
							vcobj.setup_vobj(vobj);

						break;
						
						case "bot" : // a bot is just a user really
						case "user" : // new user, set focus if it is us, otherwise its just an object
						
							vcobj=vcobjs[msg.vobj];
							if(vcobj) // update old object
							{
								vcobj.update_msg(msg);
								break;
							}
					
							vcobj=new VcommsObj(this);
							vcobj.setup_msg(msg);
							vcobjs[vcobj.id]=vcobj;
							
							vobj=up.room.add_vtard(msg.vurl);
							vcobj.setup_vobj(vobj);
							
							if(vcobj.props.name)
							{
								vobj.set_title(vcobj.props.name);
							}
							else
							{
								vobj.set_title(vcobj.owner.split("_").join(" "));
							}
							vcobj.vcobj_menu_set(vcobj.props.menu);
							
							names[vcobj.owner.toLowerCase()]=msg.vobj; // remember players id
							
							if( vcobj.id == id ) // us
							{
								up.room.bounds.focus=vobj.mc;
								up.room.poker.cc=vobj;
							}
							
							vobj.menuset();
							
						break;
						
						default: // new generic object
						
//dbg.print(msg.vurl);
							vobj=up.room.add_vobj(msg.vurl);
							
//							dbg.print(vobj.nodes[1].x +" : "+ vobj.nodes[1].y);
							
							vcobj=new VcommsObj(this);
							vcobj.setup_msg(msg);
							vcobjs[vcobj.id]=vcobj;					
							vcobj.setup_vobj(vobj);
						
							vcobj.vcobj_menu_set(vcobj.props.menu);
							
						break;
					}
					
					up.room.bounds.sort_full(); // keep stuff sorted
					
				break;
				
				
				case "vdel" : // delete an old vobj
				
					vcobj=vcobjs[msg.vobj];

					vcobj.clean();
					
					vcobjs[msg.vobj]=null;
					
				break;
				
				
				case "vupd" : // update an existing vobj
				
					vcobj=vcobjs[msg.vobj];
					
//dbg.print("got vupd msg");
					
					if(vcobj)
					{
						vcobj.update_msg(msg);
					}
					
				break;
				
				case "say" :
				
					vcobj=vcobjs[msg.vobj];
					if(vcobj && msg.txt)
					{
						vcobj.say(msg.txt);
					}
					
				break;
				case "act" :
				
					vcobj=vcobjs[msg.vobj];
					if(vcobj && msg.txt)
					{
						vcobj.act(msg.txt);
					}
					
				break;
			}
		}
	}
	
//
// Clear all the vcobjs in preperation for a new room
//
	function clear_all_vcobjs()
	{
	var idx;
	var vcobj;
	
		for(idx in vcobjs)
		{
			vcobj=vcobjs[idx];
			
			vcobj.clean()
			
		}
		
		vcobjs=[]; // new array
		names=[]; // new array

	}
	
//
// Check if vobjs are still loading, set a loading msg if so
//
	function check_loading()
	{
	var idx;
	var vcobj;
	
		if(state!="loading")
		{
			loading=state;
			return loading;
		}
		
		loading=null;
		
		for(idx in vcobjs)
		{
			vcobj=vcobjs[idx];
			
			loading=vcobj.vobj.loading;
			
			if(loading) { break; } // stop when we find a msg
		}
		
		if(!loading) // stuff is loaded
		{
			state="ready";
		}
		
		return loading;
	}
}