/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import alt.Sprintf;

#XLT=XLT or function(s) return '"'..s..'"' end



#login_file_names={ "register" }



class Login
{

	var user_php;

	var name_text="me";
	var session=0;

	var locked=false;
	
	var up; // mainclass

	var mc;
	var zmc;
	var omc;
	var oldmc;
		
	var over; //which layer is currently under the mouse
	
	var mcs;
	var parallax;
	var mcs_max;
	
	var saves=null;
	
	
	
	var dat;
	

	var file_name;
	var file_lines;
	
	var mc_score;
	var score;
	
	var mc_title;
	
	var snapbmp;
	var snapfrom;
	
	var topmc;
	
	var viewYdest;
	var viewY;
	
	var frame;
	
	var	opt_chat=true;
	var	opt_sound=true;
	
//	var doing_session_login;


		function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	
// ser
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	var	autologin=true;
	var	joinonly=false;
	
	function Login(_up,_str)
	{		
		up=_up;
		
		_root.login=this;
		
		if(_str=="join")
		{
			joinonly=true;
			autologin=false;
		}
	}
			

	
	
	
	
	function setup()
	{	
	var i;
	var line;
	var lin;
	var box;
	var nmc;
	var smc;
	var pidx;
	var pmc;		
				
		if(_root.skip_wetlogin) // do not do login
		{
			so_load();
			_root.Login_Name="me";
			_root.Login_Done=true;
			_root.Login_Session=0;
			up.state_next="menu";
			return;
		}
		
		user_php="http://"+_root.host+"/swf/users.php";

		viewYdest=0;
		viewY=0;
		frame=0;
		
//		dbg.print("SETUP:"+state);
				
		file_name="register";
		file_lines=register_lines;
		
		dat.saves_reset_temps();
		
		mc.removeMovieClip();
		mc=gfx.create_clip(up.mc,null);
		MainStatic.apply_800x600_scale(mc);
		zmc=gfx.create_clip(mc,null);
		omc=gfx.create_clip(mc,null,400,300);
					
		mcs=new Array();
		parallax=new Array();
		
		pidx=0;
		pmc=null;
		
//dbg.print(file_name);
//dbg.print(file_lines[0]);
				
		mcs_max=file_lines.length-1;
		for(i=0;i<mcs_max;i++)
		{
			line=file_lines[i];
			lin=line.split(",");
			
			if(lin[0]=="") { lin[0]=null; }
			if(lin[1]=="") { lin[1]=null; }
			if(lin[2]=="") { lin[2]=null; }
			
			
//dbg.print(lin[0]);
			
			pmc=parallax[ lin[1] ];
			if(pmc==null) // got a new depth
			{
				pmc=gfx.create_clip(zmc,null,400,300);
				{
					pmc.zoom=1;
				}
				parallax[ lin[1] ]=pmc;
				
				pmc.cacheAsBitmap=true;
				
				switch(lin[1])
				{
					case "login":
						pmc._y-=600;
					break;
					case "signup":
						pmc._y+=600;
					break;
				}
			}
			
			if(lin[0]=="circ")
			{
				mcs[i]=gfx.create_clip(pmc,null);
				
				mcs[i].mc=gfx.add_clip(mcs[i],file_name,null);
				mcs[i].mc.gotoAndStop(i+1);
				mcs[i].cacheAsBitmap=true;
				
				box=mcs[i].mc.getBounds(mcs[i]);
				box.fx=(box.xMax+box.xMin)/2;
				box.fy=(box.yMax+box.yMin)/2;
				
				mcs[i]._x+=box.fx-400;
				mcs[i].mc._x-=box.fx;
				mcs[i]._y+=box.fy-300;
				mcs[i].mc._y-=box.fy;
			}
			else
			{
				mcs[i]=gfx.add_clip(pmc,file_name,null);
				nmc=mcs[i];
				nmc._x=-400;
				nmc._y=-300;
				nmc.gotoAndStop(i+1);
				nmc.cacheAsBitmap=true;
			}
							
			nmc.active=true;
			
			nmc.onPress=delegate(press,nmc);
			nmc.onRelease=delegate(click,nmc);
			nmc.onRollOver=delegate(hover_on,nmc);
			nmc.onRollOut=delegate(hover_off,nmc);
			nmc.onReleaseOutside=delegate(hover_off,nmc);
			nmc.tabEnabled=false;
			nmc.useHandCursor=false;
			
			nmc=mcs[i];
			
			
			nmc.idx=i;
			nmc.nam=lin[0];
			nmc.group=lin[1];
			
			nmc.nams=nmc.nam.split("_");
			
			nmc._visible=true; // everything off by default
			
			switch(nmc.nams[0])
			{
				case "but":
					nmc._alpha=25;
					
					if(nmc.nams[1]=="flag")
					{
						nmc._visible=false;
					}
					
					nmc.useHandCursor=true;
				break;
				
				case "text":

					box=nmc.getBounds(pmc);
					box.w=(box.xMax-box.xMin);
					box.h=(box.yMax-box.yMin);
					
					nmc.tf=gfx.create_text_html(pmc,null,box.xMin,box.yMin,box.w,box.h);
					
					gfx.set_text_html(nmc.tf,16,0x000000,nmc.nam);
					
				break;
				
				case "edit":

					box=nmc.getBounds(pmc);
					box.w=(box.xMax-box.xMin);
					box.h=(box.yMax-box.yMin);
					
					nmc.tf=gfx.create_text_edit(pmc,null,box.xMin,box.yMin,box.w,box.h);
					nmc.tf.setNewTextFormat(gfx.create_text_format(40,0xff000000));
					nmc.tf.text="me";
					
					nmc.tf.onKillFocus=delegate(lostfocus,nmc);
				break;
			}
			
			mcs[nmc.nam]=nmc; // swing both ways?
			
			topmc=pmc;
		}
		
		mcs["but_skiplogin"]._visible=false;
		
		mcs["edit_pass2"].tf.password=true; // hide passwords
		mcs["edit_pass3"].tf.password=true;
		mcs["edit_pass2"].tf.text="";
		mcs["edit_pass3"].tf.text="";

				
		thunk();
				
//		update_do=delegate(update,null);
//		MainStatic.update_add(_root.updates,update_do);
		update();
		
		if(_root.name!=undefined)
		{
			name_set(_root.name);
		}
		else
		if(_root.ng_username!=undefined)
		{
			name_set(_root.ng_username);
		}
		else
		if( (_root.kongregate_username!=undefined) && (_root.kongregate_username.toLowerCase()!="guest") )
		{
			name_set(_root.kongregate_username);
		}
		else
		if( (_root.signals.name) ) // got a name from nooba?
		{
			name_set(_root.signals.name);
		}
		else
		{
			reroll();
		}
		
		info_show("");
		info_unlock("");
		
		so_load();
		
		thunk();
	}
	
	function logindone() // notify these that login has been done 
	{
		_root.wtf.logindone();
		_root.wetplay.logindone();
	}
		
	var update_do;
	
	function clean()
	{
		
		if(_root.skip_wetlogin) // do not do login
		{
			logindone();
			return;
		}
		
		if(!_root.swish) // do not cancel old swish
		{
			_root.swish.clean();
			_root.swish=(new Swish({style:"slide_left",mc:mc})).setup();
		}
		
//		MainStatic.update_remove(_root.updates,update_do);

		zmc._x=0;
		zmc._y=0;
				
		mc.removeMovieClip(); mc=null;	
		
		_root.Login_Name=name_text;
		_root.Login_Done=true;
		_root.Login_Session=session;
		so_save();
		
		autologin=false; // turn off autologin
		logindone();
	}
		
	var so=null;
	var VERSION=17;

	function so_load()
	{
		so=SharedObject.getLocal("wetlogin");
		
		var t=so.data;
		
		if(t.version==VERSION)
		{
			if(t.name)		{ name_set(t.name); }
			if(t.session)	{ session=t.session; }
			if(t.opt_chat)	{ opt_chat=((t.opt_chat==1)?true:false); }
			if(t.opt_sound)	{ opt_sound=((t.opt_sound==1)?true:false); }
		}
		
// check for S override
		if(_root.S)	{ session=_root.S; }
		
// atempt session login

		if((session!=null)&&(session!=0)&&(autologin))
		{
			do_session();
		}
	}
	function so_save()
	{
		var t=so.data;
		
		t.version=VERSION;
		
		t.name=name_text;
		t.session=session;
		
		t.opt_chat=opt_chat?1:2;
		t.opt_sound=opt_sound?1:2;
		
		so.flush();
	}


	function hover_off(me)
	{
		if((_root.popup)|(locked)) return;
				
		if(over==me)
		{
			do_this(me,"off");
			over=null;
		}
	}
	
	function hover_on(me)
	{
		if((_root.popup)|(locked)) return;
		
		if(over!=me)
		{
			do_this(me,"on");
			over=me;
		}
	}

	function press(me)
	{
		if((_root.popup)|(locked)) return;
		
		do_this(me,"press");
		
	}
	
	function click(me)
	{
		if((_root.popup)|(locked)) return;
		
		do_this(me,"click");
	}
	
	function lostfocus(nmc,me)
	{
		if((_root.popup)|(locked)) return;
		
		switch(me.nam)
		{
			case "edit_name1":
			case "edit_name2":
			case "edit_name3":
				name_set(me.tf.text);
			break;
		}
	}

	
	
	function thunk()
	{
	
/*
		mc._visible=true;
		if(doing_session_login)
		{
			if(_root.swish) // hide session login at start...
			{
				mc._visible=false;
			}
		}
*/
	
		if(joinonly) // move from guest to signup
		{
			if( viewYdest==0 )
			{
				mcs["but_back1"]._visible=false;
				mcs["but_back2"]._visible=false;
			}
		}
		
		if(opt_chat)
		{
			mcs["but_chat_on"]._alpha=100;
			mcs["but_chat_off"]._alpha=25;

		}
		else
		{
			mcs["but_chat_on"]._alpha=25;
			mcs["but_chat_off"]._alpha=100;
		}
		
		if(opt_sound)
		{
			mcs["but_sound_on"]._alpha=100;
			mcs["but_sound_off"]._alpha=25;

		}
		else
		{
			mcs["but_sound_on"]._alpha=25;
			mcs["but_sound_off"]._alpha=100;
		}
	}
	
	function update()
	{
		if(_root.skip_wetlogin) // do not do login
		{
			return;
		}
		
		if(timeout_lv)
		{
			timeout_time--;
			if(timeout_time<=0)
			{
				timeout_lv.err="Network TimeOut! Try again or click on the SKIP LOGIN button below.";
				timeout_func(false,timeout_lv);
				timeout_lv=null;
				timeout_time=null;
				timeout_func=null;
				mcs["but_skiplogin"]._visible=true;
			}
		}
		
		if(joinonly) // move from guest to signup
		{
			if( viewYdest==0 )
			{
				viewYdest= 600;
			}
		}
		
		if(_root.popup) return;		
		
		frame++;
		
		if(viewYdest!=viewY)
		{
			viewY=(viewY+((viewYdest-viewY)*1/8));
			if(((viewY-viewYdest)*(viewY-viewYdest))<0.5)
			{
				viewY=viewYdest;
			}
			
			parallax["guest"]._y=viewY+300;
			parallax["login"]._y=viewY+300+600;
			parallax["signup"]._y=viewY+300-600;
			
			mcs["circ"]._rotation=viewY*360/600;
		}
		
		var a=Math.floor(frame/8)%4;
		if(a==3) { a=1; }
		
		switch(a)
		{
			case 0:
				mcs["anim1a"]._visible=true;
				mcs["anim1b"]._visible=true;
				mcs["anim2a"]._visible=false;
				mcs["anim2b"]._visible=false;
				mcs["anim3a"]._visible=false;
				mcs["anim3b"]._visible=false;
			break;
			case 1:
				mcs["anim1a"]._visible=false;
				mcs["anim1b"]._visible=false;
				mcs["anim2a"]._visible=true;
				mcs["anim2b"]._visible=true;
				mcs["anim3a"]._visible=false;
				mcs["anim3b"]._visible=false;
			break;
			case 2:
				mcs["anim1a"]._visible=false;
				mcs["anim1b"]._visible=false;
				mcs["anim2a"]._visible=false;
				mcs["anim2b"]._visible=false;
				mcs["anim3a"]._visible=true;
				mcs["anim3b"]._visible=true;
			break;
		}
	
	}
	
	
	function do_this(me,act)
	{
		if(me.nams[0]=="but")
		{
			if(act=="on")
			{
				me._alpha=100;
				switch(me.nams[1])
				{
					case "login":
						info_pop("Goto login page.");
					break;
					case "signup":
						info_pop("Goto signup page.");
					break;
					case "back1":
					case "back2":
						info_pop("Back to guest login page.");
					break;
					case "no":
						info_pop("Get a new random name.");
					break;
					case "yes":
						info_pop("Shall we play a game?");
					break;
					case "chat":
						info_pop("In game chat?");
					break;
					case "sound":
						info_pop("In game sound?");
					break;
				}
			}
			else
			if(act=="off")
			{
				me._alpha=25;
				thunk();
				info_pop();
			}
			else
			if(act=="press")
			{
				me._alpha=75;
			}
			else
			if(act=="click")
			{
				me._alpha=100;
				
				switch(me.nams[1])
				{
					case "login":
						viewYdest=-600;
					break;
					case "signup":
						viewYdest= 600;
					break;
					case "back1":
					case "back2":
						viewYdest=   0;
					break;
					case "no":
						reroll();
					break;
					case "chat":
						if(me.nams[2]=="on")
						{
							opt_chat=true;
						}
						else
						{
							opt_chat=false;
						}
						thunk();
					break;
					case "sound":
						if(me.nams[2]=="on")
						{
							opt_sound=true;
							_root.wp_vol=50;
						}
						else
						{
							opt_sound=false;
							_root.wp_vol=0;
						}
						thunk();
					break;
					case "yes":
						do_guest();
					break;
					case "dosignup":
						do_signup();
					break;
					case "dologin":
						do_login();
					break;
					case "skiplogin":
						session=0;
						name_set("me");
						up.state_next="menu";
					break;
				}
			}
		}
	}

	function reroll()
	{
	var d,da,dn;
	
		d=new Date();
		d=Math.floor(d.getTime()/1);
		rnd_seed(d);
		da=d%(txt_adjectives.length-1);
		dn=rnd()%(txt_nouns.length-1);
		
		name_set(txt_adjectives[da]+"_"+txt_nouns[dn]);
	}
	
	function name_set(nam)
	{
		mcs["edit_name1"].tf.text=nam;
		mcs["edit_name2"].tf.text=nam;
		mcs["edit_name3"].tf.text=nam;
		name_text=nam;
	}

	var info_text="";
	
	function info_lock() // lock user interface and force msgs showing
	{
		locked=true;
	}
	function info_unlock() // unlock user interface and unforce msgs showing
	{
		locked=false;
	}
	function info_show(s) // display a msg
	{
		info_text=s;
		info_pop(s);
	}
	function info_pop(s) // display tempory msg
	{
		if(!s)
		{
			s=info_text;
		}
		gfx.set_text_html(mcs["text_tip"].tf,16,0x000000,s);
		
		if(s=="")
		{
			mcs["back_tooltip"]._visible=false;
		}
		else
		{
			mcs["back_tooltip"]._visible=true;
		}
	}
	
	
var timeout_lv;
var timeout_time;
var timeout_func;

	function do_guest()
	{
	var lv;
	
		if(timeout_lv) { return; }
		
		lv=new LoadVars();
		
		lv.name =  name_text;
		
		fbsig.copy_fb_sigs(_root,lv);
		
		lv.sendAndLoad(user_php+"?cmd=guest",lv,"POST");
		lv.onLoad = delegate(do_guest_post,lv);
		
		info_lock();
		info_show("Trying "+ lv.name +" guest account on "+_root.host);

		timeout_lv=lv;
		timeout_time=25*10;
		timeout_func=delegate(do_guest_post,null);
	}
	
	function do_guest_post(success,lv)
	{
		if(timeout_lv!=lv) { return; }
		timeout_lv=null;
		
		name_set(lv.name); // server may have edited name
		session=0;
			
		if(lv.err=="OK")
		{
			_root.Login_Img=lv.img;
			up.state_next="menu";
		}
		else //fail
		{
			mcs["but_skiplogin"]._visible=true;
			session=null;
			info_show((lv.err?lv.err:"ERROR"));
			info_unlock();

// force a skip login on a failed guest login, dumb user == silent fails

			if(!joinonly)
			{
				session=0;
				name_set("me");
				up.state_next="menu";
			}
			
		}
	}


	function do_signup()
	{
	var lv;
	
		if(timeout_lv) { return; }
		
		lv=new LoadVars();
		
		lv.name =  name_text;
		lv.pass =  mcs["edit_pass3"].tf.text;
		lv.email = mcs["edit_email3"].tf.text;
		lv.refer = _root.refer;
		
		fbsig.copy_fb_sigs(_root,lv);
		
		lv.sendAndLoad(user_php+"?cmd=create",lv,"POST");
		lv.onLoad = delegate(do_signup_post,lv);
		
		info_lock();
		info_show("Creating new account on "+_root.host);

		timeout_lv=lv;
		timeout_time=25*10;
		timeout_func=delegate(do_signup_post,null);
	}
	
	function do_signup_post(success,lv)
	{
		if(timeout_lv!=lv) { return; }
		timeout_lv=null;
		
		name_set(lv.name); // server may have edited name
		session=lv.S;

		if(lv.err=="OK")
		{
			_root.Login_Img=lv.img;
			up.state_next="menu";
		}
		else //fail
		{
			mcs["but_skiplogin"]._visible=true;
			session=null;
			info_show((lv.err?lv.err:"ERROR"));
			info_unlock();
		}
	}

		
	function do_login()
	{
	var lv;
	
		if(timeout_lv) { return; }
		
		lv=new LoadVars();
		
		lv.name =  name_text;
		lv.pass =  mcs["edit_pass2"].tf.text;
		
		fbsig.copy_fb_sigs(_root,lv);
		
		lv.sendAndLoad(user_php+"?cmd=login",lv,"POST");
		lv.onLoad = delegate(do_login_post,lv);
		
		info_lock();
		info_show("Logging on as "+ lv.name +" at "+_root.host);

		timeout_lv=lv;
		timeout_time=25*10;
		timeout_func=delegate(do_login_post,null);
	}
	
	function do_login_post(success,lv)
	{
		if(timeout_lv!=lv) { return; }
		timeout_lv=null;
		
		name_set(lv.name); // server may have edited name
		session=lv.S;

		if(lv.err=="OK")
		{
			_root.Login_Img=lv.img;
			up.state_next="menu";
		}
		else //fail
		{
			mcs["but_skiplogin"]._visible=true;
			session=null;
			info_show((lv.err?lv.err:"ERROR"));
			info_unlock();
		}
	}


	function do_session()
	{
	var lv;
	
//		doing_session_login=true;
		
		if(timeout_lv) { return; }
		
		lv=new LoadVars();
		
		lv.session =  session;
				
		fbsig.copy_fb_sigs(_root,lv);
		
		lv.sendAndLoad(user_php+"?cmd=session",lv,"POST");
		lv.onLoad = delegate(do_session_post,lv);
		
		info_lock();
		info_show("attempting to auto log in to "+_root.host);

		timeout_lv=lv;
		timeout_time=25*10;
		timeout_func=delegate(do_session_post,null);
	}
	
	function do_session_post(success,lv)
	{
//		doing_session_login=false;
		
		if(timeout_lv!=lv) { return; }
		timeout_lv=null;
		
		name_set(lv.name); // server may have edited name
		session=lv.S;

		if(lv.err=="OK")
		{
			_root.Login_Img=lv.img;
			up.state_next="menu";
		}
		else //fail
		{
			mcs["but_skiplogin"]._visible=true;
			session=null;
			info_show((lv.err?lv.err:"ERROR"));
			info_unlock();
		}
	}

	
	
#for i,v in ipairs({"register"}) do
	static var #(v)_lines=[
#for line in io.lines("../wetsrc/art/"..v..".txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""
	];	
#end


	static var txt_adjectives=[
#for line in io.lines("../wetsrc/art/adjectives.txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""];

#if VERSION_SITE=="pepere" then -- save a few k when doing a pepere build

	static var txt_nouns=[
	"pepere",
	""];
	
#else

	static var txt_nouns=[
#for line in io.lines("../wetsrc/art/nouns.txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""];
#end

}
