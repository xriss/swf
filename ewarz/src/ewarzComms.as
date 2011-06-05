/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class ewarzComms
{
	var up;
	
	var state;
	
	var names; // user names to avatar vcobjs ids
	
	var id; // the id of our avatar
	
	var vcobjs;
	
	var loading; // a loading msg if we seem to be loading still
	
	function ewarzComms(_up)
	{
		up=_up;
		
		state="setup";
		
		loading="setup";
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function setup()
	{
		if((_root.sock)&&(_root.sock.connected)&&(_root.sock.authenticated)) // need a sock available
		{
			if((state!="ready")&&(state!="loading"))
			{
				if( _root.sock.emsg( null , delegate(back,null) ) ) // request all ewarz msgs to come through here till further notice
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
		if(t.frm && t.txt)
		{
		}
	}

	
//
// Send a msg to the server, returns true is we tried to send it
//
	function send(msg)
	{
//		dbg.dump(msg);
	
		_root.sock.emsg(msg) 
		return;
	}
	
//
// Incoming msgs from the server
//
	function back(msg,sentmsg)
	{
	
//		if(!sentmsg) // incoming msg, not a reply, do this stateless?
		{
			switch(msg.ewarz)
			{
				case "display" :
					up.pages.display(msg.xhtml);
				break;
			}
		}
/*
		else
		{
			switch(msg.ewarz)
			{
				case "act" :
				break;
			}
		}
*/
	}
	
}