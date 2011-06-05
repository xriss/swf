/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class Vtard
{
	var up;
	
	var type_name="vtard";
	
	var mc;
	
	var minion;
	
	var talk;

	var focus;
	
	var frame;
	
	var anim;
	
	var dx,dy,dz; // display x,y,z and snap to 10px for animation
	
	var tx,ty,tz; // move to this point
	
	var sx,sy,sz;
	
	var px,py,pz;
	var vx,vy,vz;
	
	var fx,fy,fz; // from position when doing jump animation
	
	var frame_wait;
	
//	var rndstate;
//	var rndcount;

	var brain;
	
	var idle_type;
	
	var held; // we are being held by someone
	var hold; // we are holding something
	
	var victim_name=""; // a victim if we have one
	
	var loading;	
	var vcobj; // the controlling comms object
	
	var balloon; // the controlling comms object
	
	var speed;
	
	
	var plan; // what we plan to do
	var plan_time; // when we plan to give up trying
	var plan_target; // what we plan to do it to
	var plan_movewait; // wait till after we have moved before trying again
	
	var room;
	
	function Vtard(_up)
	{
		up=_up;
		room=up.room;
		
		balloon=new Vballoon(up);
		balloon.owner=this;
		
		
	}
	
	var entertype;
	var movetype;
	var roomfrom; // room we came from
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function setup(nam)
	{
		speed=100;
		entertype=undefined;//"door";
		movetype=undefined;//"walk";
	
	
		mc=gfx.create_clip(up.mc,null);
		mc.cc=this;
		up.insert_mc(mc,true);
		
		mc._xscale=100;
		mc._yscale=100;
		
		
		menuset();
		
// hitarea is too big by default, set it to something smaller...

		mc.hitArea1=gfx.create_clip(mc,0xffff);
		mc.hitArea1._visible=false;
		gfx.clear(mc.hitArea1);
		gfx.draw_box(mc.hitArea1,0,-30,-70,60,70);
		
		mc.hitArea2=gfx.create_clip(mc,0xffff-1);
		mc.hitArea2._visible=false;
		gfx.clear(mc.hitArea2);
		gfx.draw_box(mc.hitArea2,0,-30,-30,60,30);
		
		mc.hitArea=mc.hitArea1; // defalt hit area
			
		minion=new Minion(this);
		minion.setup(nam,50,94);
		
		sx=0;
		sy=0;
		sz=0;
		
		fx=0;
		fy=0;
		fz=0;
		
		px=0;
		py=0;
		pz=0;
		
		tx=0;
		ty=0;
		tz=0;
		
		vx=0;
		vy=0;
		vz=0;
		
		anim=null;
		
		idle_type="idle";
		
//		update();
		
		balloon.setup();
	}
	
	
	function say(txt)
	{
		talk.display(txt,25*5);
	}
	function act(txt)
	{
		vcobj.vobj.talk.display_act("**"+txt+"**",1);
	}
	
	
	function set_title(str)
	{
	var m;
	
		if(!mc.title)
		{
			m=gfx.create_clip(mc,null,0,-90);
			m.tf=gfx.create_text_html(m,null,0,0,200,25);
			m._visible=false;
			mc.title=m;
		}
		m=mc.title;
		
		gfx.set_text_html(m.tf,16,0xffffff,"<b>"+str+"</b>");
		
		m.w=m.tf.textWidth;
		m.h=m.tf.textHeight;
		m.tf._x=-m.w/2;
		m.tf._y=-m.h/2;
		
		gfx.clear(m);
		m.style.fill=0xff000000;
		gfx.draw_rounded_rectangle(m,10,10,0,-m.w/2-10-2,-m.h/2-10-1,m.w+20+6+4,m.h+20+6);
	}
	
	function load_xml(url)
	{
		minion.load_xml(url);
	}
	
	function clean()
	{
		balloon.clean();
		
		held.hold=null; // unlink
		hold.held=null;
		
		talk.clean(); talk=null;
		
		mc.cc=null;
		mc.removeMovieClip();
		mc=null;
	}
	
	function menuset()
	{
	var m;
	
		mc.menu={};
	
		m={};
		m.name="base";
		m.items=[];
		
		if(up.focus==mc) // only we can emote ourselves via a menu
		{
			m.items.push({	txt:"Cancel"	});
			m.items.push({	txt:"Emote"		});
			m.items.push({	txt:"Reload Room"		});
			m.items.push({	txt:"Choose Avatar"		});
		}
		else // actions you can do to others
		{
			m.items.push({	txt:"Cancel"					});
			
			if( (held) && (held.hold==this) && (held==up.up.poker.cc) ) // drop
			{
				m.items.push({	txt:"Drop"					});
			}
			else
			{
				m.items.push({	txt:"Pick up"					});
			}
			
			m.items.push({	txt:"Give"		});
			m.items.push({	txt:"Test"		});
		}
		
		m.menuclick=delegate(menuclick,m);
		
		mc.menu.base=m;
		
		m={};
		m.name="give";
		m.items=[];
		m.items.push({	txt:"Balloon"				});
		m.items.push({	txt:"Cancel"				});
		m.menuclick=delegate(menuclick,m);
		mc.menu.give=m;
		
		
		m={};
		m.name="emote";
		m.items=[];
		m.items.push({	txt:"Cancel"		});
		m.items.push({	txt:"idle_right"	});
		m.items.push({	txt:"idle_back"		});
		m.items.push({	txt:"idle_left"		});
		
		m.items.push({	txt:"Teapot"		});
		m.items.push({	txt:"Angry"			});
		m.items.push({	txt:"Confused"		});
		m.items.push({	txt:"Determind"		});
		m.items.push({	txt:"Devious"		});
		m.items.push({	txt:"Embarrassed"	});
		m.items.push({	txt:"Energetic"		});
		m.items.push({	txt:"Excited"		});

		m.items.push({	txt:"Happy"			});
		m.items.push({	txt:"Indescribable"	});
		m.items.push({	txt:"Nerdy"			});
		m.items.push({	txt:"Sad"			});
		m.items.push({	txt:"Scared"		});
		m.items.push({	txt:"Sleepy"		});
		m.items.push({	txt:"Thoughtful"	});
		m.items.push({	txt:"Working"		});
		m.items.push({	txt:"Dance"		});
		m.menuclick=delegate(menuclick,m);		
		mc.menu.emote=m;
		
		m={};
		m.name="avatar";
		m.items=[];
		m.items.push({	txt:"Cancel"				});
		m.items.push({	txt:"boi"					});
		m.items.push({	txt:"gurl"					});
		m.items.push({	txt:"reset"					});
		m.menuclick=delegate(menuclick,m);
		mc.menu.avatar=m;
		
		m={};
		m.name="avatar_boy";
		m.items=[];
		m.items.push({	txt:"Cancel"				});
		m.items.push({	txt:"bboy"					});
		m.items.push({	txt:"pirate punk dude"		});
		m.items.push({	txt:"emo gof fag"			});
		m.items.push({	txt:"joker"					});
		m.items.push({	txt:"matrix boy"			});
		m.items.push({	txt:"vlad"					});
		m.items.push({	txt:"clown boy"				});
		m.items.push({	txt:"geek boy"				});
		m.items.push({	txt:"rocker billy"			});
		m.items.push({	txt:"manson gof fag"		});
		m.items.push({	txt:"stripe gof fag"		});
		m.items.push({	txt:"corp gof fag"			});
		m.items.push({	txt:"punk fag"				});
		m.items.push({	txt:"bam gof fag"			});
		m.items.push({	txt:"grey gof fag"			});
		m.items.push({	txt:"white surf dude"		});
		m.items.push({	txt:"rowboat"				});
		m.items.push({	txt:"green gof fag"			});
		m.items.push({	txt:"albino gof fag"		});
		m.items.push({	txt:"raver fag"				});
		m.items.push({	txt:"ginger surf dude"		});
		m.items.push({	txt:"pink gof fag"			});
		m.items.push({	txt:"tri gof fag"			});
		m.items.push({	txt:"squee"					});
		m.items.push({	txt:"smerf"					});
		m.items.push({	txt:"wabbit"				});
		m.items.push({	txt:"boy"					});
		m.items.push({	txt:"pigsy"					});
		m.items.push({	txt:"chiky"					});
		m.items.push({	txt:"chucks"				});
		m.items.push({	txt:"papsmerf"				});
		m.items.push({	txt:"pixl"					});
		m.items.push({	txt:"brakku"				});
		m.items.push({	txt:"failchan"				});
		m.items.push({	txt:"chief"					});
		m.items.push({	txt:"haysus"				});
		m.items.push({	txt:"cthulhu"				});
		m.items.push({	txt:"phreak"				});
		m.items.push({	txt:"loki"					});
		m.menuclick=delegate(menuclick,m);		
		mc.menu.avatar_boy=m;
		
		m={};
		m.name="avatar_girl";
		m.items=[];
		m.items.push({	txt:"Cancel"				});
		m.items.push({	txt:"bgirl"					});
		m.items.push({	txt:"bunny chik"			});
		m.items.push({	txt:"emo gof whore"			});
		m.items.push({	txt:"killer blonde"			});
		m.items.push({	txt:"lib killer"			});
		m.items.push({	txt:"pirate punk chik"		});
		m.items.push({	txt:"red head stabber"		});
		m.items.push({	txt:"matrix chic"			});
		m.items.push({	txt:"mystique"				});
		m.items.push({	txt:"storm"					});
		m.items.push({	txt:"cheer leader"			});
		m.items.push({	txt:"clown girl"			});
		m.items.push({	txt:"geek girl"				});
		m.items.push({	txt:"rocker girl"			});
		m.items.push({	txt:"bam gof whore"			});
		m.items.push({	txt:"smokin gof whore"		});
		m.items.push({	txt:"ginger surf chick"		});
		m.items.push({	txt:"ginger tanned chick"	});
		m.items.push({	txt:"punk whore"			});
		m.items.push({	txt:"red girl"				});
		m.items.push({	txt:"peak gof whore"		});
		m.items.push({	txt:"albino gof whore"		});
		m.items.push({	txt:"intel gof whore"		});
		m.items.push({	txt:"raver whore"			});
		m.items.push({	txt:"girl"					});
		m.items.push({	txt:"smerfat"				});
		m.items.push({	txt:"miku"					});
		m.menuclick=delegate(menuclick,m);		
		mc.menu.avatar_girl=m;

		mc.getmenu=delegate(getmenu,null);


	}
	

		
		
	function getmenu(poke)
	{
		menuset(); // makesure menu is current
		
		if( mc.vcobj_menu.base ) // server has suplied a menu to use, so override with it
		{
			return mc.vcobj_menu.base;
		}
	
		return mc.menu.base;
	}

	
	function menuclick(poke,item,menu)
	{
	var s;
	
// poke.cc.vcobj is the player operating the mouse
// vcobj is avatar that has been clicked on
	
		switch(menu.name)
		{
			
			default:
			
				switch(item.txt.toLowerCase())
				{
					case "choose avatar":
						poke.showmenu(mc.menu.avatar);
					break;
					
					case "test":
//						poke.cc.plan_ahead( "bonk" , vcobj.id ); // send test request
						poke.hidemenu();
					break;
						
					case "pick up":
					case "drop":
						if( (held) && (held.hold==this) && (held==poke.cc) ) // drop
						{
//							held.vcobj.send_msg_prop( "hold" , "*" );
//							vcobj.send_msg_prop( "held" , "*" );
							
							poke.cc.vcobj.send_msg_prop( "pickup" , "*" ); // send drop request
						}
						else
						{
//							vcobj.send_msg_prop( "held" , poke.cc.vcobj.id );
//							poke.cc.vcobj.send_msg_prop( "hold" , vcobj.id );
							
							poke.cc.plan_ahead( "pickup" , vcobj.id ); // send pickup request
//							poke.cc.vcobj.send_msg_prop( "pickup" , vcobj.id ); // send pickup request
						}
						poke.hidemenu();
					break;
					
					case "reload room":
						vcobj.send_msg_setup();
						poke.hidemenu();
					break;
					
					case "emote":
						poke.showmenu(mc.menu.emote);
					break;
					
					case "give":
						poke.showmenu(mc.menu.give);
					break;
					
					case "focus":
						poke.up.focus=mc;
						poke.hidemenu();
					break;
					
					default:
						poke.hidemenu();
					break;
				}
				
			break;
			
			case "give":
			
				switch(item.txt.toLowerCase())
				{
					case "balloon":
						poke.hidemenu();
						vcobj.send_msg_prop( "use" , "give balloon" );
					break;
										
					default:
						poke.hidemenu();
					break;
				}
			break;
			
			case "avatar":
			
				switch(item.txt.toLowerCase())
				{
					case "boi":
						poke.showmenu(mc.menu.avatar_boy);
					break;
					
					case "gurl":
						poke.showmenu(mc.menu.avatar_girl);
					break;
					
					case "reset":
						vcobj.send_msg_prop( "avatar" , "me" );
						poke.hidemenu();
					break;
					
					default:
						poke.hidemenu();
					break;
				}
			break;
			
			case "avatar_boy":
			
				switch(item.txt.toLowerCase())
				{
					case "cancel":
						poke.hidemenu();
					break;
					
					default:
						vcobj.send_msg_prop( "avatar" , item.txt.toLowerCase() );
						poke.hidemenu();
					break;
				}
			break;
			
			case "avatar_girl":
			
				switch(item.txt.toLowerCase())
				{
					case "cancel":
						poke.hidemenu();
					break;
					
					default:
						vcobj.send_msg_prop( "avatar" , item.txt.toLowerCase() );
						poke.hidemenu();
					break;
				}
			break;
			
			case "emote":
			
				switch(item.txt.toLowerCase())
				{
					case "cancel":
						poke.hidemenu();
//						idle_type="idle";
						vcobj.send_msg_prop( "idle" , "idle" );
					break;
					
					default:
//						talk.display("*I am "+item.txt+"*",25*5);

//						idle_type=item.txt.toLowerCase();

						vcobj.send_msg_prop( "idle" , item.txt.toLowerCase() );
						
						poke.hidemenu();
					break;
				}
				
			break;
			
		}
	}

	
//
// we have a new plan, it may take some time
//
	function plan_ahead(p,targ,tim)
	{
	var dest;
	
		if( p == "forget" )
		{
			plan=null;
		}
		else
		if( p == "bonk" )
		{
			plan=null;
			plan_target=targ;
			plan_time=0;
			
			dest=up.up.up.comms.vcobjs[plan_target].vobj;
			if(dest)
			{
				balloon.set_bonk(dest);
			}
		}
		else
		if( p == "bonked" )
		{
			plan=p;
		}
		else
		if( p == "lazer" )
		{
			plan=p;
			plan_target=targ;
			plan_time=1;
		}
		else
		if( p == "pickup" )
		{
			plan=p;
			plan_target=targ;
			plan_movewait=true; // wait for this to be false (we moved)
			plan_time=room.tick_time+25; // wait a little while before trying again
			
			vcobj.send_msg_prop( "pickup" , plan_target ); // send pickup request
		}
		else
		if( p == "try" ) // server is moving us, and wants us to try to use again when we get there
		{
			plan=p;
			plan_target=targ;
			plan_movewait=true; // wait for this to be false (we finished moving)
		}
	}
	
//
// Vcobj props ave changeds, update the vobj with new settings
//
	function update_vcobj(props)
	{
		brain.update_vcobj(props); // pass onto brain
		
	var aa;
	var v;
	
	
		if(!props) { props=vcobj.props; } // if no changes passed in use main props
		
		if(props.roomfrom) // name of the room we came from 
		{
			roomfrom=props.roomfrom;
//dbg.print("FROM "+roomfrom);
		}
		
		if(props.xyz) // new server position, tell object to move here
		{
//			plan_movewait=false;
				
			aa=props.xyz.split(":");			
			
			if( aa[3] == "now" ) // just move where we are now to here, change nothing else
			{
				px=Math.floor(aa[0]);
				py=Math.floor(aa[1]);
				pz=Math.floor(aa[2]);
			}
			else
			{
				
				tx=Math.floor(aa[0]);
				ty=Math.floor(aa[1]);
				tz=Math.floor(aa[2]);
				
				if( aa[3] == "jump" ) // special jump anim movement
				{
					movetype="jump";
					fx=px;
					fy=py;
					fz=pz;
				}
				else
				if( aa[3] == "drop" ) // special drop from sky anim movement, and force location
				{
					px=tx;
					py=ty;
					pz=tz;
					movetype="drop";
				}
				else
				if( aa[3] == "force" ) // force to this location without animation
				{
					px=tx;
					py=ty;
					pz=tz;
					movetype="force";
				}
				else // normal walking
				{
					movetype="walk";
				}
			}
		}
		
		if(props.idle) // new idle anim
		{
			idle_type=props.idle;
		}
		
		if(props.size) // new size of item
		{
			mc._xscale=Math.floor(props.size);
			mc._yscale=mc._xscale;
		}
		
		if(props.speed) // new speed of item
		{
			speed=Math.floor(props.speed);
		}
		
		if(props.victim) // new idle anim
		{
			victim_name=props.victim;
		}
		
		if(props.balloon) // new balloon settings
		{
			aa=props.balloon.split(":");
			
			balloon.set_style( aa[1] , Math.floor(aa[2]) , Math.floor(aa[3]) , Math.floor(aa[4]) , aa[5] );
			
		}
		
		if(props.focus) // new focus
		{
			focus=vcobj.up.vcobjs[props.focus].vobj;
		}
		
		if(props.held) // we have been picked up?
		{
//dbg.print("held "+props.held);

			v=vcobj.up.vcobjs[props.held];
			
			if( v ) // we have been picked up by
			{
				held=v.vobj;
			}
			else
			{
				held=null;
			}
		}
		
		if(props.hold) // we have picked something up?
		{
//dbg.print("hold "+props.hold);

			v=vcobj.up.vcobjs[props.hold];
			
			if( v ) // we have picked this up
			{
				hold=v.vobj;
			}
			else
			{
				hold=null;
			}
		}
// bonk somone
		if(props.bonk)
		{
			plan_ahead( "bonk" , props.bonk );
		}

		
		if(props.playsfx)
		{
			aa=props.playsfx.split(":");			
			_root.wetplay.wetplayMP3.PlaySFX("sfx_"+aa[0],aa[1]/1,undefined,aa[2]/100);
		}
		if(props.loopsfx)
		{
			aa=props.loopsfx.split(":");			
			_root.wetplay.wetplayMP3.PlaySFX("sfx_"+aa[0],aa[1]/1,65535,aa[2]/100);
		}

		
// bonked by somone
		if(props.bonked)
		{
			if( Math.floor(props.bonked)==0 )
			{
				plan_ahead( "forget" );
			}
			else
			{
				plan_ahead( "bonked" , props.bonk );
			}
		}
		
// server is telling us to try a use command again on an object but only when we stop moving
		if(props["try"])
		{
//dbg.print("try "+props["try"]);
			plan_ahead( "try" , props["try"]);
		}
		
		if(props.jiggle) // jiggle balloons
		{
			balloon.jiggle( props.jiggle/1 );
		}
	}
	
	function update()
	{
	var f;
	var nx,ny,nz;
	var dd;
	var i,o,oo;
	var spd=3*speed/100;
	
	var jump_total;
	var jump_delta;
	var jump_rot;
	var jump;
	var targ;
	var p1,p2;
	
	
		if(entertype=="door") // force position from a door, when the room has loaded
		{	
			for(i=0;i<up.up.objs.length;i++)
			{
//dbg.print(o.type);
				o=up.up.objs[i];
				
				if(o.type=="door")
				{
//dbg.print("TO "+o.brain.dest);
					if(!oo) { oo=o; }
					else
					{
						if( o.brain.dest == roomfrom ) // found a better door
						{
							oo=o;
						}
					}
				}
			}
			if(oo)
			{
				
				px=oo.px;
				py=oo.py;
				pz=oo.pz;
				
			}
			entertype=undefined;
		}
		
		if(movetype=="jump")
		{
			spd*=4;
		}
			
			
		brain.update();
				
		vx=0;
		vz=0;
		
		vx=tx-px;
		vz=tz-pz;

// cap maximum velocity

		f=vx*vx+vz*vz;
		if(f>spd*spd)
		{
			f=Math.sqrt(f);
			vx=vx*spd/f;
			vz=vz*spd/f;
		}
		
		px+=vx;
		py+=vy;
		pz+=vz;
		
		if(px<up.x3_min+20)		{ px=up.x3_min+20; }//rndstate="right"; }
		if(py<up.y3_min+0)		{ py=up.y3_min+0; }//rndcount=0; }
		if(pz<up.z3_min+20)		{ pz=up.z3_min+20; }//rndstate="out"; }
		
		if(px>up.x3_max-20)		{ px=up.x3_max-20; }//rndstate="left"; }
		if(py>up.y3_max-0)		{ py=up.y3_max-0; }//rndcount=0; }
		if(pz>up.z3_max-20)		{ pz=up.z3_max-20; }//rndstate="in"; }
		
		nx=Math.floor((px+5)/10)*10;
		ny=Math.floor((py+5)/10)*10;
		nz=Math.floor((pz+5)/10)*10;
		
		if(movetype=="jump")
		{
			jump_total= Math.sqrt( (tx-fx)*(tx-fx) + (tz-fz)*(tz-fz) );
			jump_delta= Math.sqrt( (nx-fx)*(nx-fx) + (nz-fz)*(nz-fz) );
			jump=spinearc( jump_delta/jump_total );
			jump_rot=0;
		}                                     
		
		
		if((vx==0)&&(vz==0))
		{
			if(anim!="idle")
			{
				anim="idle";
				frame=0;
				frame_wait=0;
				dx=nx;
				dy=ny;
				dz=nz;
			}
			
			if(movetype=="jump")
			{
				movetype=null;
			}
			if(plan=="pickup")
			{
				if( !plan_movewait ) // wait till we have moved before attempting to pickup again
				{
					vcobj.send_msg_prop( "pickup" , plan_target+":only" ); // send pickup request again
					plan_ahead("forget");
				}
			}
			else
			if(plan=="try")
			{
				if( !plan_movewait ) // wait till we have moved before attempting to use again
				{
					targ=up.up.up.comms.vcobjs[plan_target];
					
					if(targ)
					{
						targ.send_msg_prop( "use" , "try" ); // send use request again (the proper use will have been queued serverside)
					}
					
					plan_ahead("forget");
				}
			}
		}
		else
		{
			plan_movewait=false; // we have moved
			
			if( (vz==0) || ( Math.abs(vx/vz) > 0.75 ) ) // left-right
			{
				if(vx>0) //right
				{
					if(anim!="right")
					{
						anim="right";
						frame=3;
						frame_wait=0;
						dx=nx;
						dy=ny;
						dz=nz;
					}
				}
				else // left
				{
					if(anim!="left")
					{
						anim="left";
						frame=3;
						frame_wait=0;
						dx=nx;
						dy=ny;
						dz=nz;
					}
				}
			}
			else // in or out
			{
				if(vz>0) //in
				{
					if(anim!="in")
					{
						anim="in";
						frame=3;
						frame_wait=0;
						dx=nx;
						dy=ny;
						dz=nz;
					}
				}
				else // out
				{
					if(anim!="out")
					{
						anim="out";
						frame=3;
						frame_wait=0;
						dx=nx;
						dy=ny;
						dz=nz;
					}
				}
			}
					}
		var fp;
		var ff;
		
		mc.hitArea=mc.hitArea1; // defalt hit area
		
		var scale_speed=1/(mc._xscale/100);
		
		switch(anim)
		{
			case "idle":
			
				frame_wait++;
				if(frame_wait>8)
				{
					frame+=1;
					frame_wait=0;
				}
				
				dx=nx;
				dy=ny;
				dz=nz;
				
				//frame=frame%6;
				
/*
				if( rndstate=="pose" )
				{
					minion.display(rndpose,frame);
				}
				else
*/
				if( (plan=="bonked") || (plan=="splat") )
				{
					minion.display("splat",frame);
					mc.hitArea=mc.hitArea2; // splatted hit area
				}
				else
				{
					minion.display(idle_type,frame);
				}
			break;
			
			case "left":
			
				if( (held) && (held.hold==this) ) { break; } // being held
				frame_wait++;
				dd=Math.sqrt((nx-dx)*(nx-dx) + (nz-dz)*(nz-dz)*0.25 )
				fp=Math.round(scale_speed*(dd)/10);
				if(fp!=0)
				{
					frame+=fp;
					frame_wait=0;
				}
				if(frame_wait>8)
				{
					frame+=1;
					frame_wait=0;
				}
				dx=nx;
				dy=ny;
				dz=nz;
				
				if(movetype=="jump")
				{
					frame=Math.floor(4*jump_delta/jump_total);
					jump_rot=15;
				}
					
				frame=frame%8;				
				minion.display("left",frame);
			break;
			
			case "right":
			
				if( (held) && (held.hold==this) ) { break; } // being held
				frame_wait++;
				dd=Math.sqrt((nx-dx)*(nx-dx) + (nz-dz)*(nz-dz)*0.25 )
				fp=Math.round(scale_speed*(dd)/ 10);
				if(fp!=0)
				{
					frame+=fp;
					frame_wait=0;
				}
				if(frame_wait>8)
				{
					frame+=1;
					frame_wait=0;
				}
				dx=nx;
				dy=ny;
				dz=nz;
				
				if(movetype=="jump")
				{
					frame=Math.floor(4*jump_delta/jump_total);
					jump_rot=-15;
				}
				
				frame=frame%8;				
				minion.display("right",frame);
			break;
			
			case "in":
			
				if( (held) && (held.hold==this) ) { break; } // being held
				frame_wait++;
				fp=Math.round(scale_speed*(nz-dz)/ 10);
				if(fp!=0)
				{
					frame+=fp;
					frame_wait=0;
				}
				if(frame_wait>8)
				{
					frame+=1;
					frame_wait=0;
				}
				dx=nx;
				dy=ny;
				dz=nz;
				
				if(movetype=="jump")
				{
					frame=Math.floor(4*jump_delta/jump_total);
					jump_rot=0;
				}
				
				frame=frame%4;
				minion.display("in",frame);
			break;
			
			case "out":
			
				if( (held) && (held.hold==this) ) { break; } // being held
				frame_wait++;
				fp=Math.round(scale_speed*(nz-dz)/-10);
				if(fp!=0)
				{
					frame+=fp;
					frame_wait=0;
				}
				if(frame_wait>8)
				{
					frame+=1;
					frame_wait=0;
				}
				dx=nx;
				dy=ny;
				dz=nz;
				
				if(movetype=="jump")
				{
					frame=Math.floor(4*jump_delta/jump_total);
					jump_rot=0;
				}
				
				frame=frame%4;
				minion.display("out",frame);
			break;
		}
		
		
		if(movetype=="jump")
		{
			dy=jump*(0-jump_total*0.5);
		}

		if( (held) && (held.hold==this) ) // held/hold must be mutual
		{
			if(held.mc._rotation==90) //multi
			{
				dx=held.dx;
				dy=held.dy-(50*held.mc._xscale/100);
				dz=held.dz;
			}
			else
			{
				dx=held.dx-(30*held.mc._xscale/100);
				dy=held.dy-(100*held.mc._xscale/100);
				dz=held.dz;
			}
			
			mc._x=up.x2+dx+(dz/4);
			mc._y=up.y2+dy-(dz/4);
			mc._z=dz;
			
			mc._rotation=90;
			
			tx=held.mc.cc.tx;
			ty=held.mc.cc.ty;
			tz=held.mc.cc.tz;
		}
		else
		{
			mc._x=up.x2+dx+(dz/4);
			mc._y=up.y2+dy-(dz/4);
			mc._z=dz;
			
			mc._rotation=0;
			
			if(movetype=="jump")
			{
				mc._rotation=0;
				
				var js=(((jump_delta/jump_total)-0.5)*4);
				if(js<-1) { js=-2-js; }
				else
				if(js> 1) { js= 2-js; }
				
				if(js<0)	{js=-spine(js); }
				else		{js= spine(js); }
				
				mc._rotation=js*jump_rot;
			}
		}
		
		
//		dbg.print( mc._x + " " + mc._y );
		
		balloon.update();
		
		if(plan=="lazer")
		{
			p1={};
			p2={};
		
			p1.x=0;
			p1.y=-40;
			p2.x=400;
			p2.y=0;
			
			mc.localToGlobal(p1);
			up.up.up.pixls.mc.globalToLocal(p1);
			
			targ=up.up.up.comms.vcobjs[plan_target].vobj;
//				targ=up.up.up.comms.vcobjs[up.up.up.comms.names[owner.victim_name.toLowerCase()]];
			if( targ )
			{
				p2.x=0;
				p2.y=-60;
				targ.mc.localToGlobal(p2);
				up.up.up.pixls.mc.globalToLocal(p2);
				
				up.up.up.pixls.add_line(
				0xffff0000,
				20,
				p1.x,p1.y,
				p2.x,p2.y);
//					p2.x+((up.rnd()-32768)/1024),p2.y+((up.rnd()-32768)/1024));
			}
			
			plan_time--;
			if(plan_time<=0)
			{
				plan_ahead("forget");
			}
		}
	}
	
// input -1 to 0 to +1 and output 1 to 0 to 1 smoothing to and from the 0 and 1
	function spine( a )
	{
	var aa;

		if(a<0) a=-a;

		aa=a*a;

		return ((aa+(aa*2.0))-((aa*a)*2.0));
	}
	
// input 0 to 1 and output 0 to 1 to 0 again with shape ends at the 0 points
	function spinearc( a )
	{
	var aa;

		a-=0.5;
		if(a<0) a=-a;

		aa=a*a;

		return 1.0-(((aa+(aa*2.0))-((aa*a)*2.0))*2.0);
	}
	
	
}