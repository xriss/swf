/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class VcommsObj
{
	var up;
	
	
	var vobj;
	
	var id;
	var type;
	var parent;
	var owner;
	var url;
	
	var props;
/*
VOUT:
vcmd=vobj
vlock=-
vparent=2.0
vowner=big_sink
vobj=1.0
cmd=ville
vtype=user
vprops=anim,idle,xyz,0:0:0
vid=0
vurl=http://data.wetgenes.com/game/s/ville/test/vtard/me.xml
*/


	function VcommsObj(_up)
	{
		up=_up;
	}

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function setup_msg(msg) // associate with this msg data
	{
	var i,aa,nam,dat;
	
		id=msg["vobj"];
		type=msg["vtype"];
		parent=msg["vparent"];
		owner=msg["vowner"];
		parent=msg["vparent"];
		url=msg["vurl"];
		
		props=[];
		
		aa=msg["vprops"].split(",");
		
		for(i=0;i<aa.length;i+=2)
		{
			nam=aa[i];
			dat=aa[i+1];
			
			props[nam]=dat;
		}
	}
	
	function setup_vobj(_vobj) // associate with this real vobj
	{
		
		vobj=_vobj;
		vobj.vcobj=this;
		
		vobj.update_vcobj();
	}
	
	function update_msg(msg) // new settings for this vcobj
	{
	var i,aa,nam,dat;
	
	var newprops=[];
	
//dbg.print(msg["vprops"]);
				
		aa=msg["vprops"].split(",");
		
		for(i=0;i<aa.length;i+=2)
		{
			nam=aa[i];
			dat=aa[i+1];
			
			props[nam]=dat;
			newprops[nam]=dat;
		}
		
		if(vobj)
		{
			vobj.update_vcobj(newprops);
			
			if(newprops.menu) // create the new menu
			{
//				dbg.print(newprops.menu);
				vcobj_menu_set(newprops.menu);
			}
		}
		
	}
	
	function say(txt)
	{
		if(vobj)
		{
			vobj.say(txt);
		}
	}
	function act(txt)
	{
		if(vobj)
		{
			vobj.act(txt);
		}
	}
	
	function send_msg_prop(nam,dat) // tell server we would like this object to move to this position
	{
	var msg={vcmd:"vupd",vobj:id};
	
		msg.vprops=nam+","+dat;
	
		up.vmsgsend(msg);
	}
	
	function send_msg_setup() // tell server we would like to re-enter our current chat room, clearing all state
	{
	var msg={vcmd:"setup"};
	
		up.vmsgsend(msg);
	}
	
	function clean() // free everything and remove associations, please also remove from vcobjs table afterwards
	{
		vobj.clean();
	}


// apply a server provided menu over the top of another objects menu

	function vcobj_menu_set(data)
	{
	if(!data) { return; }
	
	var aaa;
	var aa;
	var m,it;
	var idx,i;
	
//dbg.print(data);

		vobj.mc.vcobj_menu={};
		
		aaa=data.split(":");
		
		for(idx in aaa)
		{
			aa=(aaa[idx]).split("/");
			
			m={};
			m.name=aa[0];
			m.items=[];
			m.menuclick=delegate(vcobj_menu_click,m);
			vobj.mc.vcobj_menu[m.name]=m;
		
			for( i=1 ; i<aa.length ; i++ )
			{
				it={};
				it.txt=aa[i];
				it.id=m.name+" "+aa[i];
				m.items[i-1]=it;
			}
		}
		

	}
	
	
// handle a special vcobj menu	
	function vcobj_menu_click(poke,item,menu)
	{
	var s;
	var sl;
		
		switch(item.id)
		{
			case "cancel":
				poke.hidemenu();
			break;
			
			default:
			
// check if we have another menu ready to display			

				if(vobj.mc.vcobj_menu[ item.id ] )
				{
					poke.showmenu(vobj.mc.vcobj_menu[ item.id ] );
				}
				else	// else send this id to the server and close the menu
				{
					poke.hidemenu();
					send_msg_prop("use",item.id);
				}
				
			
			break;
		}
	}
}