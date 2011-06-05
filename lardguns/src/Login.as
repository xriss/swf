/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;
import com.wetgenes.dbg;
import com.dynamicflash.utils.Delegate;
import alt.Sprintf;


// an 800x200 login requester

class Login
{
// check these on exit

	var session=null;
	var login=null;
	
	var done=false;
	var again=false;
	
// main comunication script
	
	var user_php;
	
	
	var mc:MovieClip;
	var mc2:MovieClip;
	var mc3:MovieClip;
	var mcm:MovieClip;
	
	var mc_popup; // dialogue 
	var tf_popup;
	var tf_popup2;
	
	var frame;
	
	var mcps;
	
	var fmt;
	
	var tfs;
	var tf_login;
	var tf_password;
	var tf_email;
	
	var done_enter;
	
	var mcps_names=[
		"",
		"",
		"",
		"",
		"",
		"back",
		"do_login",
		"reroll",
		"do_guest_login",
		"go_login",
		"go_signup",
		"back",
		"do_signup"
		];

				
	var txt_name;
	
	var focus;
	
	var timeout_lv;
	var timeout_time;
	var timeout_func;
	
	function delegate(f,d)	{	return Delegate.create(this,f,d);	}
	

// --- Main Entry Point
#if not SKIP_MAIN_ENTRY then
	static function main()
	{
		var orset_root=function(a,b)
		{
			if(_root[a]==undefined) { _root[a]=b; }
		}
		orset_root("host","swf.wetgenes.com");
		
		_root.newdepth=1;
		_root.login=new Login();
	}
#end
	
	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
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
		txt_name=nam;
		tf_login.text=nam;
		tf_login.setTextFormat(fmt);
	}
	
	var so=null;
	var VERSION=16;

	function so_load()
	{
		so=SharedObject.getLocal(_root.host+"/login");
		
		var t=so.data;
		
		if(t.version==VERSION)
		{
			if(t.login)		{ tf_login.text=t.login; tf_login.setTextFormat(fmt); }
//			if(t.email)		{ tf_email.text=t.email; tf_email.setTextFormat(fmt); }
			if(t.session)	{ session=t.session; }
		}
		
// check for S override
		if(_root.S)	{ session=_root.S; }
		
// atempt session login

		if(session!=null)
		{
			do_session();
		}
	}
	function so_save()
	{
		var t=so.data;
		
		t.version=VERSION;
		
		t.login=tf_login.text
//		t.email=tf_email.text
		t.session=session;
		
		so.flush();
	}

	
	function Login()
	{
		setup();
	}
	
	function setup()
	{
	var i;
	
		user_php="http://"+_root.host+"/swf/users.php";
		
//		if(_root.loading.server=="www")
//		{
//			user_php="http://swf.wetgenes.com/swf/users.php";
//		}
	
		focus="guest";
	
		done=false;
		
		frame=0;
		
		if(_root.name!=undefined)
		{
			name_set(_root.name);
		}
		else
		if(_root.kongregate_username!=undefined)
		{
			name_set(_root.kongregate_username);
		}
		else
		{
			reroll();
		}
		
		mcps=new Array();
		
		mc=gfx.create_clip(_root,16384);
	    mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 20, 20, 2, 3) ];
		
		mc.scrollRect=new flash.geom.Rectangle(0, 0, 800, 200);
		mc.cacheAsBitmap=true;

		mc.onEnterFrame=delegate(update,null);
		
/*
		mcm=gfx.create_clip(mc,null);
		mcm._visible=false;
		mc.setMask(mcm);
		mcm.style={	fill:0xffffffff,	out:0xffffffff,	text:0xffffffff	};
		gfx.draw_box(mcm,undefined,0,0,800,200)
*/
				
		mc2=gfx.create_clip(mc,null);
		
		mc2._x=-800;
		mc2.vx=0;
		mc2.dx=-800;
		
		mc2.dy=0;
		mc2._y=-250;
		
		for(i=1;i<=12;i++)
		{
			mcps[i]=gfx.add_clip(mc2,'register',null);
			mcps[i].gotoAndStop(i);
			mcps[i].active=true;
		}
		mcps[2]._visible=false;
		mcps[3]._visible=true;
		mcps[4]._visible=false;
				
		mcps[1].active=false;
		mcps[2].active=false;
		mcps[3].active=false;
		mcps[4].active=false;
		
		mc3=gfx.create_clip(mc2,null);
//		mc3.loadMovie("http://www.wetgenes.com/data/WetTest20040116.jpg");


//		mc2._x=0;
//		mc2._x=-800;
//		mc2._x=-1600;

		mc3.style={	fill:0x40000000,	out:0xff000000,	text:0xffffffff	};

//		gfx.draw_box(mc3,1,370,60,200,26);
//		gfx.draw_box(mc3,1,370,119,200,26);
		
//		gfx.draw_box(mc3,1,590,75,50,50);
		
		
//		gfx.draw_box(mc3,1,800+25,122,240,26);
		
//		gfx.draw_box(mc3,1,800+125,160,140,30);
		
//		gfx.draw_box(mc3,1,800+460,35,220,40);
//		gfx.draw_box(mc3,1,800+460,125,220,40);
		
		
//		gfx.draw_box(mc3,1,1600+370,45,200,26);
//		gfx.draw_box(mc3,1,1600+370,89,200,26);
//		gfx.draw_box(mc3,1,1600+370,134,200,26);
		
//		gfx.draw_box(mc3,1,1600+590,75,50,50);
	
		Mouse.addListener(this);
		
		
		fmt=new TextFormat();
		fmt.font="Bitstream Vera Sans";
		fmt.size=20;
		fmt.color=0x000000;
		fmt.bold=false;

		
		
		var tf;
		
		tfs=new Array();
/*		
		tf=gfx.create_text_edit(mc3,null,370,60,200,26);
//		tf.onKillFocus=delegate(onKillFocus);
		tf.text="golden_cucumber";
		tf.setTextFormat(fmt);
		tf.restrict="0123456789ABCDEFGHIJKLMNOPRSTUVWXYZabcdefghijklmnopqrstuvwxyz_-";
		tf.maxChars=64;

		tf=gfx.create_text_edit(mc3,null,370,119,200,26);
//		tf.onKillFocus=delegate(onKillFocus);
		tf.text="golden_cucumber";
		tf.setTextFormat(fmt);
		tf.restrict="0123456789ABCDEFGHIJKLMNOPRSTUVWXYZabcdefghijklmnopqrstuvwxyz_-";
		tf.maxChars=64;
*/
		
		tf=gfx.create_text_edit(mc3,null,800+40,122,210,26);
//		tf.onKillFocus=delegate(onKillFocus);
		tf.text=txt_name;
		tf.setTextFormat(fmt);
		tf.restrict="0123456789ABCDEFGHIJKLMNOPRSTUVWXYZabcdefghijklmnopqrstuvwxyz_";
		tf.maxChars=64;
		tf_login=tf;
		tfs[tfs.length]=tf;
		tf.dx=tf._x;tf.dy=tf._y;
		tf.id="login";
		tf.onKillFocus=delegate(onKillFocus,tf);
/*
		tf=gfx.create_text_edit(mc3,null,1600+370,45,200,26);	
//		tf.onKillFocus=delegate(onKillFocus);
		tf.text="golden_cucumber";
		tf.setTextFormat(fmt);
		tf.restrict="0123456789ABCDEFGHIJKLMNOPRSTUVWXYZabcdefghijklmnopqrstuvwxyz_-";
		tf.maxChars=64;
*/
		
		tf=gfx.create_text_edit(mc3,null,1600+365,89,210,26);	
//		tf.onKillFocus=delegate(onKillFocus);
		tf.text="secret";
		tf.setTextFormat(fmt);
//		tf.restrict="0123456789ABCDEFGHIJKLMNOPRSTUVWXYZabcdefghijklmnopqrstuvwxyz_-";
		tf.maxChars=64;
		tf.password=true;
		tf_password=tf;
		tfs[tfs.length]=tf;
		tf.dx=tf._x;tf.dy=tf._y;
		tf.id="password";
		tf.onKillFocus=delegate(onKillFocus,tf);

		tf=gfx.create_text_edit(mc3,null,1600+365,134,210,26);	
//		tf.onKillFocus=delegate(onKillFocus);
		tf.text="Me@WetGenes.com";
		tf.setTextFormat(fmt);
//		tf.restrict="0123456789ABCDEFGHIJKLMNOPRSTUVWXYZabcdefghijklmnopqrstuvwxyz_-";
		tf.maxChars=256;
		tf_email=tf;
		tfs[tfs.length]=tf;
		tf.dx=tf._x;tf.dy=tf._y;
		tf.id="email";
		tf.onKillFocus=delegate(onKillFocus,tf);
		
// popup

		mc_popup=gfx.create_clip(mc,null);
		mc_popup.style={	fill:0xc0ffffff,	out:0xffffffff,	text:0xff000000	};
		tf_popup=gfx.create_rounded_text_button(mc_popup,null,20+100,20,800-40-200,200-40,3,8,4);
		tf_popup._x+=10;
		tf_popup._y+=10;
		tf_popup._width-=20;
		tf_popup._height-=20+20;
		tf_popup2=gfx.create_text_html(mc_popup,null,20+100,200-60,800-40-200,40);
		
		popup_hide();
		
// load data, might start trying to connect to sites
		
		so_load();
		
		
		Stage.scaleMode="noScale";
		Stage.align="TL";
		Stage.addListener(this);
		onResize();

	}
		
//think about layout stuff
	function onResize()
	{
		var siz;
		var x=800;
		var y=600;
		
		mc._rotation=0;
		
		siz=Stage.width/x;
		if(siz*y>Stage.height)
		{
			siz=Stage.height/y;
		}
		
		mc._x=Math.floor((Stage.width-siz*x)/2);
		mc._y=Math.floor((Stage.height-siz*y)/2);
		mc._xscale=siz*100;
		mc._yscale=siz*100;
	}

	function popup_display()
	{
		mc_popup._visible=true;
		
		tf_login.type="dynamic";
		tf_password.type="dynamic";
		tf_email.type="dynamic";
		
		tf_login.selectable=false;
		tf_password.selectable=false;
		tf_email.selectable=false;

	}
	function popup_hide()
	{
		mc_popup._visible=false;
		
		tf_login.type="input";
		tf_password.type="input";
		tf_email.type="input";
		
		tf_login.selectable=true;
		tf_password.selectable=true;
		tf_email.selectable=true;
		
		mc2._visible=true;
	}
	function popup_text(str)
	{
	var s;
	var fntsiz;
	var fntcol;
	
		fntsiz=24;
		fntcol=0x000000;
	
		s="<font face=\"Bitstream Vera Sans\" size=\""+fntsiz+"\" color=\"#"+Sprintf.format("%06x",fntcol&0xffffff)+"\"><b>";
		s+="<p align=\"center\">";
		s+=str;
		s+="</p>";
		s+="</b></font>";
		tf_popup.htmlText=s;
	}
	function popup_presstext(str)
	{
	var s;
	var fntsiz;
	var fntcol;
	
		fntsiz=24;
		fntcol=0x000000;
	
		s="<font face=\"Bitstream Vera Sans\" size=\""+fntsiz+"\" color=\"#"+Sprintf.format("%06x",fntcol&0xffffff)+"\"><b>";
		s+="<p align=\"center\">";
		s+=str;
		s+="</p>";
		s+="</b></font>";
		tf_popup2.htmlText=s;
	}

	
	function update()
	{
	var i;
	var d;
	var f;
	var frate=5;
	
	
		if(done)
		{
			mc2.dy=-250;

			mc2._y+=(mc2.dy-mc2._y)/4;
			if(Math.abs(mc2.dy-mc2._y)<1)
			{
				mc2._y=mc2.dy;
				popup_hide();
				mc._visible=false;
//				if(_root.popup==this) { _root.popup=null; }
			}
			mc_popup._y=mc2._y;
			
/*
			mc._alpha+=(0-mc._alpha)/8;
			if(mc._alpha<1)
			{
				mc._alpha=0;
				mc._visible=false;				
			}
*/
		}
		else
		{
//			if(_root.popup==null) { _root.popup=this; }
			
			mc2.dy=0;
			
			mc2._y+=(mc2.dy-mc2._y)/4;
			if(Math.abs(mc2.dy-mc2._y)<1)
			{
				mc2._y=mc2.dy;
			}
			mc_popup._y=mc2._y;
			
/*
			mc._alpha+=(100-mc._alpha)/8;
			if(mc._alpha>99)
			{
				mc._alpha=100;
			}
*/
		}
	
	
		if(timeout_lv)
		{
			timeout_time--;
			if(timeout_time<=0)
			{
				timeout_lv.err="Network TimeOut!";
				timeout_func(false,timeout_lv);
				timeout_lv=null;
				timeout_time=null;
				timeout_func=null;
			}
		}
	
		frame+=1;
		if(frame>=frate*4)
		{
			frame=0;
		}
		
		f=Math.floor(frame/frate);
		if(f>2) { f=1; }
		
//		mcps[3].gotoAndPlay(1);
		mcps[3].gotoAndStop(2+f);

		if(Key.isDown(Key.ENTER))
		{
			if(!done_enter)
			{
				key_enter()
				done_enter=true;
			}
		}
		else
		{
			done_enter=false;
		}
		
// swish texts...

		for(i=0;i<tfs.length;i++)
		{
			if(tfs[i]._x!=tfs[i].dx)
			{
				d=tfs[i].dx-tfs[i]._x;
				
				if(Math.abs(d)>1)
				{
					tfs[i]._x+=d*0.25;
				}
				else
				{
					tfs[i]._x=tfs[i].dx;
				}
			}
			if(tfs[i]._y!=tfs[i].dy)
			{
				d=tfs[i].dy-tfs[i]._y;
				
				if(Math.abs(d)>1)
				{
					tfs[i]._y+=d*0.25;
				}
				else
				{
					tfs[i]._y=tfs[i].dy;
				}
			}
		}
	
// swish mc2 to dx	
		if(mc2.dx!=mc2._x)
		{
			d=mc2.dx-mc2._x;
			
			if(Math.abs(d)>1)
			{
				mc2._x+=d*0.25;
			}
			else
			{
				mc2._x=mc2.dx;
			}
		}
	
		for(i=1;i<mcps.length;i++)
		{
			if(mcps[i].active)
			{
				if(mcps[i].hitTest(_root._xmouse,_root._ymouse,false))
				{
					mcps[i]._alpha=100;
				}
				else
				{
					if(mcps[i]._alpha>60)
					{
						mcps[i]._alpha-=5;
					}
				}
			}
		}
	}
	
	function onKillFocus(tf)
	{
	
		if(tf.id="login")
		{
//			Selection.setFocus("_root.login.tf_password");
		}
		else
		if(tf.id="password")
		{
//			Selection.setFocus("_root.login.tf_email");
		}
		else
		if(tf.id="email")
		{
//			Selection.setFocus("_root.login.tf_login");
		}
	
	}
	
	function key_enter()
	{
		if(mc_popup._visible==true)	// do nothing
		{
			return;
		}
		
		if(focus=="login")
		{
			do_str("do_login");
		}
		else
		if(focus=="guest")
		{
			do_str("do_guest_login");
		}
		else
		if(focus=="signup")
		{
			do_str("do_signup");
		}
	}
	
	function onMouseDown()
	{
	var i;
	
		if(mc_popup._visible==true)	// do nothing
		{
			return;
		}
		if(mc._visible==false)	// do nothing
		{
			return;
		}
	
		for(i=1;i<mcps.length;i++)
		{
			if(mcps[i].active)
			{
				if(mcps[i].hitTest(_root._xmouse,_root._ymouse,false))
				{
					do_str(mcps_names[i]);
				}
			}
		}
	
	}

	function do_str(str)
	{
		switch(str)
		{
			
			case "reroll":
				reroll();
			break;
			
			case "go_login":
			
				focus="login";
				
				mc2.dx=0;
				
				tf_login.dx=365;
				tf_login.dy=60;
				tf_login._visible=true;
				
				tf_password.dx=365;
				tf_password.dy=119;
				tf_password._visible=true;
				
				tf_email._visible=false;
				
			break;
			
			case "back":
			
				focus="guest";
				
				mc2.dx=-800;
				
				tf_login.dx=800+40;
				tf_login.dy=122;
				tf_login._visible=true;
				
				tf_password._visible=false;

				tf_email._visible=false;

			break;
			
			case "go_signup":
			
				focus="signup";
				
				mc2.dx=-1600;
				
				tf_login.dx=1600+365;
				tf_login.dy=45;
				tf_login._visible=true;
				
				tf_password.dx=1600+365;
				tf_password.dy=89;
				tf_password._visible=true;
				
				tf_email._visible=true;
				
			break;
			
			case "do_signup":
				do_signup();
			break;
			
			case "do_guest_login":
				do_guest();
			break;
			
			case "do_login":
				do_login();
			break;
		}
	}
	
	function clean()
	{
//		mc._alpha=0;
//		popup_hide();
		done=true;
	}

	
	function RootClick(str)
	{
		mc._visible=true;
		
		if(str=="continue")
		{
			popup_hide();
		}
		else
		if(str=="skip")
		{
			login="me";
			session=null;
			clean();
		}
		else
		if(str=="done")
		{
			clean();
			so_save();
		}
		
		_root.Login_Click=null;
	}
	
	
	function do_signup()
	{
	var lv;
	
		if(timeout_lv) { return; }
		
		lv=new LoadVars();
		
		lv.name =  tf_login.text;
		lv.pass =  tf_password.text;
		lv.email = tf_email.text;
		
		lv.sendAndLoad(user_php+"?cmd=create",lv,"POST");
		lv.onLoad = delegate(do_signup_post,lv);
		
		popup_display();
		popup_text("Creating new account on "+_root.host);
		popup_presstext("");
		
		_root.Login_Click=delegate(RootClick,"signup");
		
		timeout_lv=lv;
		timeout_time=30*10;
		timeout_func=delegate(do_signup_post,null);
	}
	
	
	function do_signup_post(success,lv)
	{
		if(timeout_lv!=lv) { return; }
		timeout_lv=null;
		
		if(lv.err!="OK")
		{
			session=null;
			popup_text(lv.err?lv.err:"Unknown ERROR");
			popup_presstext("<a href=\"asfunction:_root.Login_Click,continue\">Click here to continue!</a>");
		}
		else
		{
			login=lv.name;
			session=lv.S;
			popup_text(lv.name + " account created succesfully please **CHECK EMAIL** to confirm");
			popup_presstext("<a href=\"asfunction:_root.Login_Click,done\">Click here to continue!</a>");
		}
	}
	
	function do_guest()
	{
	var lv;
	
		if(timeout_lv) { return; }
		
		lv=new LoadVars();
		
		lv.name =  tf_login.text;
		
		lv.sendAndLoad(user_php+"?cmd=guest",lv,"POST");
		lv.onLoad = delegate(do_guest_post,lv);
		
		popup_display();
		popup_text("Trying "+ lv.name +" guest account on "+_root.host);
		popup_presstext("");
		
		_root.Login_Click=delegate(RootClick,"guest");

		timeout_lv=lv;
		timeout_time=30*10;
		timeout_func=delegate(do_guest_post,null);
	}
	
	function do_guest_post(success,lv)
	{
		if(timeout_lv!=lv) { return; }
		timeout_lv=null;
		
		if(lv.err!="OK")
		{
			session=null;
			popup_text(lv.err?lv.err:"Unknown ERROR");
			popup_presstext("<a href=\"asfunction:_root.Login_Click,continue\">Click here to continue!</a>");

// allow continue anyway if netword timeout

			if( (lv.err=="Network TimeOut!") || (lv.err==null) )
			{
				popup_presstext("<a href=\"asfunction:_root.Login_Click,skip\">Click here to skip login!</a>");
			}
		}
		else
		{
			login=lv.name;
			session=null;
			popup_text("The "+ lv.name +" guest account is available on "+_root.host);
			popup_presstext("<a href=\"asfunction:_root.Login_Click,done\">Click here to continue!</a>");
//auto cancel
			RootClick("done","guest");
		}
	}
	
	function do_login()
	{
	var lv;
	
		if(timeout_lv) { return; }
		
		lv=new LoadVars();
		
		lv.name =  tf_login.text;
		lv.pass =  tf_password.text;
		
		lv.sendAndLoad(user_php+"?cmd=login",lv,"POST");
		lv.onLoad = delegate(do_login_post,lv);
		
		popup_display();
		popup_text("Logging on as "+ lv.name +" at "+_root.host);
		popup_presstext("");
		
		_root.Login_Click=delegate(RootClick,"login");
		
		timeout_lv=lv;
		timeout_time=30*10;
		timeout_func=delegate(do_login_post,null);
	}
	
	function do_login_post(success,lv)
	{
		if(timeout_lv!=lv) { return; }
		
		timeout_lv=null;
		
		if(lv.err!="OK")
		{
			session=null;
			popup_text(lv.err?lv.err:"Unknown ERROR");
			popup_presstext("<a href=\"asfunction:_root.Login_Click,continue\">Click here to continue!</a>");
		}
		else
		{
			login=lv.name;
			session=lv.S;
			popup_text("You have logged in as "+ lv.name +" on "+_root.host);
			popup_presstext("<a href=\"asfunction:_root.Login_Click,done\">Click here to continue!</a>");
//auto cancel
			RootClick("done","login");
		}
	}
	
	function do_session()
	{
	var lv;
	
		if(timeout_lv) { return; }
		
		lv=new LoadVars();
		
		lv.session =  session;
		
		lv.sendAndLoad(user_php+"?cmd=session",lv,"POST");
		lv.onLoad = delegate(do_session_post,lv);
		
		popup_display();
		popup_text("attempting to auto log in to "+_root.host);
		popup_presstext("");
		
		_root.Login_Click=delegate(RootClick,"session");
		
		
		timeout_lv=lv;
		timeout_time=30*10;
		timeout_func=delegate(do_session_post,null);
		
		mc2._visible=false;
	}
	
	function do_session_post(success,lv)
	{
		if(timeout_lv!=lv) { return; }
		timeout_lv=null;
		
		if(lv.err!="OK")
		{
			session=null;
			popup_text(lv.err?lv.err:"Unknown ERROR");
			popup_presstext("<a href=\"asfunction:_root.Login_Click,continue\">Click here to continue!</a>");
// cancel			
			RootClick("continue","session");
		}
		else
		{
			login=lv.name;
			session=lv.S;
			
			popup_text("You have logged in as "+ lv.name +" on "+_root.host);
			popup_presstext("<a href=\"asfunction:_root.Login_Click,done\">Click here to continue!</a>");

			if(lv.login)	{ tf_login.text=lv.login; tf_login.setTextFormat(fmt); }
//auto cancel
			RootClick("done","session");
		}
		
	}
	static var txt_adjectives=[
#for line in io.lines("src/adjectives.txt") do 
	"#(line)",
#end
	""];
	
	static var txt_nouns=[
#for line in io.lines("src/nouns.txt") do 
	"#(line)",
#end
	""];

	
}


