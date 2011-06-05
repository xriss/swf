/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vbrain_bogtard
{
	var up;
	var room;
	
	var dat;
	
	function Vbrain_bogtard(_up)
	{
		up=_up;
		
		up.type_name="vobj_bogtard"
			
		room=up.up.up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}


	function setup(xml)
	{
	var m;
	var vt;
	
		if(xml)
		{
			parse_xml(xml,0);
		}
		
		dat=[];
		set_idle();
		
//		menuset();
	}
	
	function clean()
	{
	}
	
	function set_idle()
	{
		up.focus.focus=null;
		up.focus=null;
		
		dat[0]="idle";
		dat[1]=((room.rnd()%5)+1)*25;
		
//dbg.print(dat[0]+" : "+dat[1]);
	}
	
	function set_piss()
	{
	var targ;
	
		targ=find_vobj("urinal");
		
		if(!targ)
		{
			set_idle();
		}
		else
		{
			up.focus=targ;
			targ.focus=up;
			
			dat[0]="piss";
			dat[1]=((room.rnd()%5)+5)*25;
		}
		
//dbg.print(dat[0]+" : "+dat[1]);
	}
	
	function set_poop()
	{
	var targ;
	
		targ=find_vobj("toilet");
		
		if(!targ)
		{
			set_idle();
		}
		else
		{
			up.focus=targ;
			targ.focus=up;
			
			dat[0]="poop";
			dat[1]=((room.rnd()%10)+5)*25;
		}
		
//dbg.print(dat[0]+" : "+dat[1]);
	}
	
	function set_wash()
	{
	var targ;
	
		targ=find_vobj("sink");
		
		if(!targ)
		{
			set_idle();
		}
		else
		{
			up.focus=targ;
			targ.focus=up;
			
			dat[0]="wash";
			dat[1]=((room.rnd()%5)+5)*25;
		}
		
//dbg.print(dat[0]+" : "+dat[1]);
	}
	
	function find_vobj(typ)
	{
	var i,o;
	var aa;
	
		aa=[];
		
		for(i=0;i<room.objs.length;i++)
		{
			o=room.objs[i];
			
			if(o.type==typ)
			{
				aa.push(o);
			}
		}
		
		if(aa.length>0)
		{
			i=room.rnd()%aa.length;
			return aa[i];
		}
		else
		{
			return null;
		}
	}
	
	function parse_xml(e,d,flavour)
	{
	var ec;
	var children;
	
		children=false;
		
		if(e.nodeType==1)
		{
//dbg.print(d+":"+e.nodeType+":"+e.nodeName);

			switch(e.nodeName)
			{
				default:
					children=true;
				break;
			}
			if( children )
			{
				for( ec=e.firstChild ; ec ; ec=ec.nextSibling )
				{
					parse_xml(ec,d+1,flavour);
				}
			}
		}
		
	}	
	
	function update_vcobj(props)
	{
	var aa;
	
		if(!props) { props=up.vcobj.props; } // if no changes passed in use main props
		
		if(props.xyz) // new server position, tell object to move here
		{
			aa=props.xyz.split(":");
			
			up.px=Math.floor(aa[0]);
			up.py=Math.floor(aa[1]);
			up.pz=Math.floor(aa[2]);
			
		}
	}
	
	function update()
	{
	
		switch(dat[0])
		{
			case "idle":
			
				if(dat[1]>0)
				{
					dat[1]-=1;
				}
				else
				{
					switch(room.rnd()%2)
					{
						case 0: set_piss(); break;
						case 1: set_poop(); break;
					}
				}
				
			break;
			
			case "piss":
			
				if((up.focus.focus==up)&&(up.focus.type=="urinal")) // stay on target
				{
					up.focus.brain.do_use(up);
					
					if( (up.dx==up.px) && (up.dz==up.pz) )
					{
						if(dat[1]>0)
						{
							dat[1]-=1;
						}
						else
						{
							up.focus.brain.do_dirt();
							set_wash();
						}
					}
				}
				
			break;
			
			case "poop":
			
				if((up.focus.focus==up)&&(up.focus.type=="toilet")) // stay on target
				{
					up.focus.brain.do_use(up);
					
					if( (up.dx==up.px) && (up.dz==up.pz) )
					{
						if(dat[1]>0)
						{
							dat[1]-=1;
						}
						else
						{
							up.focus.brain.do_dirt();
							set_wash();
						}
					}
				}
				
			break;
			
			case "wash":
			
				if((up.focus.focus==up)&&(up.focus.type=="sink")) // stay on target
				{
					up.focus.brain.do_use(up);
					
					if( (up.dx==up.px) && (up.dz==up.pz) )
					{
						if(dat[1]>0)
						{
							dat[1]-=1;
						}
						else
						{
							switch(room.rnd()%2)
							{
								case 0: set_piss(); break;
								case 1: set_poop(); break;
							}
						}
					}
				}
				
			break;
		}
	}
}
