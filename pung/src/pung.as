/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/



#include "src/opts.as"

#if TRON=='xray' then	
import com.blitzagency.xray.util.XrayLoader;
#end



class pung 
{

static function drawbox(t,x,y,w,h)
{

	var ww=w/2;
	var hh=h/2;

	t.lineStyle(3,0x00ff00,100);

	t.moveTo(x-ww,y-hh);

	t.beginFill(0x008000,100);

	t.lineTo(x+ww,y-hh);
	t.lineTo(x+ww,y+hh);
	t.lineTo(x-ww,y+hh);
	t.lineTo(x-ww,y-hh);

	t.endFill();

}

static function pat_add(t,x,y,xv,yv,s)
{
var i=t.p_next;

	t.p_i[i]=s;
	t.p_x[i]=x;
	t.p_y[i]=y;
	t.p_xv[i]=xv;
	t.p_yv[i]=yv;

	t.p_next++;
	if(t.p_next >= t.p_max)
	{
		t.p_next=0;
	}
}

static function pat_add_imp(t,x,y,xv,yv,n)
{
var i;

	for(i=0;i<n;i++)
	{
		pung.pat_add(_root.pats,x,y,(Math.random()-0.5)*12-xv,(Math.random()-0.5)*12-yv,8);
	}
}

	var scores:pung_scores;

	// --- Main Entry Point
	static function main()
	{

#if TRON=='xray' then	
		var listener:Object = new Object();
		listener.xrayLoadComplete = function(){
		_global.com.blitzagency.xray.Xray.initConnections();
				XrayLoader.trace("Xray has loaded...");
		}
		XrayLoader.addEventListener("xrayLoadComplete", listener);
		XrayLoader.loadConnector("ConnectorOnly.swf", _root);
		
		trace("XRAY setup.");
#end
		_root.replay=new Replay();

		_root.scores=new pung_scores(_root,"scores",9);
		_root.scores.mc._visible=false;

		_root.title_done=false;
		_root.setup_done=false;
		_root.game_done=true;

		_root.sfx=new Sound(_root);


		_root.mousedown=false;
		_root.onMouseDown=function()		{			_root.mousedown=true;	/*_root.replay.prekey_on(Replay.KEY_MBUTTON);*/	}
		_root.onMouseUp=function()			{			_root.mousedown=false;	/*_root.replay.prekey_off(Replay.KEY_MBUTTON);*/	}
		Mouse.addListener(_root);
		
		_root.onEnterFrame=function()
		{
			_root.kdown=Key.isDown(Key.SPACE) || Key.isDown(Key.ENTER);
			
			var bb;


			bb=_root.bat;
			
	if(_root.mousedown)
	{
		if(_root._ymouse<bb.y)
		{
			bb.m_ON=true;
			bb.m_UP=true;
			bb.m_DOWN=false;
		}
		else
		{
			bb.m_ON=true;
			bb.m_UP=false;
			bb.m_DOWN=true;
		}
	}
	else
	{
		bb.m_UP=false;
		bb.m_DOWN=false;

		if(bb.m_ON) // check for mouse off.. this stuff is borked  :)
		{
			_root.replay.prekey_off(Replay.KEY_UP);
			_root.replay.prekey_off(Replay.KEY_DOWN);
		}
		
		bb.m_ON=false;
	}

	if(bb.m_UP)
	{
		_root.replay.prekey_on(Replay.KEY_UP);
		_root.replay.prekey_off(Replay.KEY_DOWN);
	}
	else
	if(bb.m_DOWN)
	{
		_root.replay.prekey_off(Replay.KEY_UP);
		_root.replay.prekey_on(Replay.KEY_DOWN);
	}
	else
	{
		if(Key.isDown(Key.UP))
		{
			_root.replay.prekey_on(Replay.KEY_UP);
		}
		else
		{
			_root.replay.prekey_off(Replay.KEY_UP);
		}
		
		if(Key.isDown(Key.DOWN))
		{
			_root.replay.prekey_on(Replay.KEY_DOWN);
		}
		else
		{
			_root.replay.prekey_off(Replay.KEY_DOWN);
		}
	}
	



// hacky new key stuff....
			if(Key.isDown(Key.SPACE) || Key.isDown(Key.ENTER))
			{
				_root.replay.prekey_on(Replay.KEY_FIRE);
			}
			else
			{
				_root.replay.prekey_off(Replay.KEY_FIRE);
			}

		
			with(this)
			{

pat_setup=function(t)
{
	t.p_next=0;
	t.p_max=64;
	t.p_i=[0];
	t.p_x=[0];
	t.p_y=[0];
	t.p_xv=[0];
	t.p_yv=[0];
}



pat_update=function(t)
{
	var s;
	var a;
	var x;
	var y;
	var i;

	t.clear();

	t.lineStyle(0,0x000000,0);

	for(i=0;i<t.p_max;i++)
	{
		if(t.p_i[i]>0) // active
		{
			s=t.p_i[i];
			a=t.p_i[i];
			if(a>5) { a=5; }

			t.p_x[i]+=t.p_xv[i];
			t.p_y[i]+=t.p_yv[i];

			x=t.p_x[i];
			y=t.p_y[i];

			t.moveTo(x-s,y-s);

			t.beginFill(0x00ff00,a);

			t.lineTo(x+s,y-s);
			t.lineTo(x+s,y+s);
			t.lineTo(x-s,y+s);
			t.lineTo(x-s,y-s);

			t.endFill();

			t.p_i[i]-=0.125;
		}
	}
}



bat_setup=function(t)
{

	t.x=800-80;
	t.y=300;
	t.w=16;
	t.h=128;

	t.xv=0;
	t.yv=0;

	pung.drawbox(t,t.x,t.y,t.w,t.h);

}


bat_update=function(t)
{
	t.clear();

	if(_root.replay.key&Replay.KEYM_UP) //( Key.isDown(Key.UP) || t.m_UP )
	{
		if(t.h>0)
		{
			if(t.yv>0) { t.yv=0; }
			t.yv-=1;
			t.h-=1;

			pung.pat_add(_root.pats,t.x,t.y+t.h/2,Math.random(),4+(Math.random()*1),8);
			pung.pat_add(_root.pats,t.x,t.y+t.h/2,Math.random(),4+(Math.random()*1),8);
		}
	}
	else
	if(_root.replay.key&Replay.KEYM_DOWN) //( Key.isDown(Key.DOWN) || t.m_DOWN)
	{
		if(t.h>0)
		{
			if(t.yv<0) { t.yv=0; }
			t.yv+=1;
			t.h-=1;

			pung.pat_add(_root.pats,t.x,t.y-t.h/2,Math.random(),-4+(Math.random()*-1),8);
			pung.pat_add(_root.pats,t.x,t.y-t.h/2,Math.random(),-4+(Math.random()*-1),8);
		}
	}

	t.ymin=0+26+(t.h/2);
	t.ymax=600-26-(t.h/2);

	t.y+=t.yv;

	if(t.y<t.ymin)
	{
		pung.pat_add_imp(_root.pats,t.x,t.y-(t.h/2),t.xv,t.yv,8)

		t.y=t.ymin;
		t.yv*=-1;

		_root.sfx.attachSound("beep1");
		_root.sfx.start();
//		_root.attachMovie("beep1","sfx",202);
//		_root.sfx.gotoAndPlay(1);
	}
	else
	if(t.y>t.ymax)
	{
		pung.pat_add_imp(_root.pats,t.x,t.y+(t.h/2),t.xv,t.yv,8)

		t.y=t.ymax;
		t.yv*=-1;

		_root.sfx.attachSound("beep1");
		_root.sfx.start();
//		_root.attachMovie("beep1","sfx",202);
//		_root.sfx.gotoAndPlay(1);
	}

	if(t.h>0)
	{
		pung.drawbox(t,t.x,t.y,t.w,t.h);
	}

}

txt_update=function(t)
{
	if(t.yp>0)
	{
		t._y+=t.yp;
		t.yp-=1;
	}
	else
	if(t.yp<0)
	{
		t._y+=t.yp;
		t.yp+=1;
	}
}


ball_setup=function(t)
{

	t.x=64;
	t.y=300;
	t.w=16;
	t.h=16;

	t.xv=8;
	t.yv=-12;

	pung.drawbox(t,t.x,t.y,t.w,t.h);

}


ball_update=function(t)
{

	t.clear();

	t.ymin=0+26+(t.h/2);
	t.ymax=600-26-(t.h/2);

	t.xmin=0+26+(t.h/2);
	t.xmax=800;

	t.xl=800-80-16;
	t.xh=800-80+16;


	t.y+=t.yv;
	t.x+=t.xv;

	if(t.y<t.ymin)
	{
		pung.pat_add_imp(_root.pats,t.x,t.y,0,t.yv,8)

		t.y=t.ymin;
		t.yv*=-1;

		_root.sfx.attachSound("beep1");
		_root.sfx.start();
//		_root.attachMovie("beep1","sfx",200);
//		_root.sfx.gotoAndPlay(1);

	}
	else
	if(t.y>t.ymax)
	{
		pung.pat_add_imp(_root.pats,t.x,t.y,0,t.yv,8)

		t.y=t.ymax;
		t.yv*=-1;

		_root.sfx.attachSound("beep1");
		_root.sfx.start();
//		_root.attachMovie("beep1","sfx",200);
//		_root.sfx.gotoAndPlay(1);
	}

	if(t.x<t.xmin)
	{
		pung.pat_add_imp(_root.pats,t.x,t.y,t.xv,0,8)

		t.x=t.xmin;
		t.xv*=-1;

		_root.sfx.attachSound("beep1");
		_root.sfx.start();
//		_root.attachMovie("beep1","sfx",200);
//		_root.sfx.gotoAndPlay(1);
	}
	else
	if( (t.x>t.xl) && (t.x<t.xh) )	// bat hit
	{
		if( (t.xv>0) && (_root.bat.h>0) )// only going towards bat
		{
			t.bymin=_root.bat.y-(_root.bat.h/2)-8;
			t.bymax=_root.bat.y+(_root.bat.h/2)+8;

			if( (t.y>t.bymin) && (t.y<t.bymax) ) // on bat
			{
				pung.pat_add_imp(_root.pats,t.x,t.y,t.xv,0,8)

				if(t.y<_root.bat.y)
				{
					t.fixy=(_root.bat.y-t.y)/(_root.bat.y-t.bymin);
					t.fixx=1-t.fixy;
					t.fixy*=-8;
				}
				else
				{
					t.fixy=(t.y-_root.bat.y)/(t.bymax-_root.bat.y);
					t.fixx=1-t.fixy;
					t.fixy*=8;
				}
//				t.x=t.xl;

				t.yv+=t.fixy;
				_root.bat.yv-=t.fixy;

				if(t.yv>0)
				{
					if(t.yv<3)
					{
						t.yv=3;
					}
				}
				else
				{
					if(t.yv>-3)
					{
						t.yv=-3;
					}
				}

				t.xv*=-1;

				_root.sfx.attachSound("beep2");
				_root.sfx.start();
//				_root.attachMovie("beep2","sfx",201);
//				_root.sfx.gotoAndPlay(1);
			}
		}
	}
	else
	if(t.x>t.xmax)
	{
		pung.pat_add_imp(_root.pats,t.x,t.y,t.xv,0,48)

		t.x=t.xmax;
		t.xv=0;
		t.yv=0;
		_root.game_done=true;

		_root.txt._x=-8;
		_root.txt._y=-8;
		_root.txt._y+=_root.yswish_n;
		_root.txt.yp=-_root.yswish_i;


		t.h=0;

		_root.sfx.attachSound("beep3");
		_root.sfx.start();
//		_root.attachMovie("beep3","sfx",203);
//		_root.sfx.gotoAndPlay(1);
		
		if(_root.replay.state==Replay.STATE_PLAY)
		{
			_root.replay.end_play();
		}
		else
		if(_root.replay.state==Replay.STATE_RECORD)
		{
			_root.replay.end_record();
			_root.scores.insert((_root.tims*100)+Math.floor((_root.timf*100)/30) , _root.replay.str);
		}
	}

	if(t.h>0)
	{
		pung.drawbox(t,t.x,t.y,t.w,t.h);
	}

}


if(title_done==false) // initial pre setup
{
var s;

	if(!bak)
	{

	attachMovie("layout","bak",1);
	bak._x=-8;
	bak._y=-8;
	bak.gotoAndStop(1);

	attachMovie("layout","bak2",2);
	bak2._x=-8;
	bak2._y=-8;
	bak2.gotoAndStop(2);


	attachMovie("kriss","bak4",4);
	bak4._x=800-140;
	bak4._y=600-180;
	bak4._xscale=160;
	bak4._yscale=160;

	
	createTextField( "bak5",5 , 8*10 , 8*8 , 8*74 , 8*50 );
	bak5.type="dynamic";
	bak5.multiline=true;
	bak5.embedFonts=true;
	bak5.html=true;
	bak5.selectable=false;
	bak5.wordWrap=true;
	s="<a href=\"asfunction:_root.click_continue\"><font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#000000\">"
	s+="#(VERSION_NAME) <font size=\"16\"> v#(VERSION_NUMBER) #(VERSION_SITE) #(VERSION_BUILD) </font> <font size=\"8\"> (c) Kriss Daniels #(VERSION_STAMP) </font><br>";
	s+="<br>";
	s+="Keep the ball on screen for as long as you can. Use UP/DOWN keys or mouse clicks to move the bat. ";
	s+="But beware, as moving the bat will cause it to shrink. <br>"
	s+="<br>";
	s+="Click or press SPACE to continue."
	s+="</font></a>";
	bak5.htmlText=s

	_root.click_continue=function()
	{
		_root.title_done=true;
		_root.bak2.removeMovieClip();
		_root.bak4.removeMovieClip();
		_root.bak5.removeTextField();
		_root.bak6.removeTextField();
		_root.wet.t.remove();
		_root.click_continue=null;
	}

	createTextField( "bak6",6 , 8*10 , 8*57 , 8*74 , 8*16 );
	bak6.type="dynamic";
	bak6.embedFonts=true;
	bak6.html=true;
	bak6.selectable=false;
	bak6.htmlText="<font face=\"Bitstream Vera Sans\" size=\"56\" color=\"#00ff00\"><a target=\"_top\" href=\"http://www.WetGenes.com\">www.WetGenes.com</a></font>";


	var w:wetDNA=new wetDNA(_root,"wet",8);
	w.color=0x00ff00;
	w.mc._x=370;
	w.mc._y=500;
	w.mc._xscale=120;
	w.mc._yscale=50;

	
	}


	if( (_root.kdown) )
	{
		_root.click_continue();
	}

}
else
if(setup_done==false) // initial setup
{

//beep1=new Sound();
//beep1.attachSound("beep");
//beep1.start(); 


	_root.timf=0;
	_root.tims=0;
	_root.t2o=0;
	_root.t3o=0;
	_root.t4o=0;

	clear();

	attachMovie("layout","bak",1);
	bak._x=-8;
	bak._y=-8;
	bak.gotoAndStop(1);


	createEmptyMovieClip("bat", 10);
	bat_setup(bat);

	createEmptyMovieClip("ball", 11);
	ball_setup(ball);

	createEmptyMovieClip("pats", 12);
	pat_setup(pats);

	bx=400+96;
	bs=-56;
	by=48;

	attachMovie("numbers","num0",100);
	num=num0;
	num.gotoAndStop(2);
	num._x=bx;
	num._y=by;
	num._alpha=50;

	bx+=bs;

	attachMovie("numbers","num1",101);
	num=num1;
	num.gotoAndStop(2);
	num._x=bx;
	num._y=by;
	num._alpha=50;

	bx+=bs;

	attachMovie("numbers","num_",102);
	num=num_;
	num.gotoAndStop(12);
	num._x=bx;
	num._y=by;
	num._alpha=50;

	bx+=bs;

	attachMovie("numbers","num2",103);
	num=num2;
	num.gotoAndStop(2);
	num._x=bx;
	num._y=by;
	num._alpha=50;

	bx+=bs;

	attachMovie("numbers","num3",104);
	num=num3;
	num.gotoAndStop(1);
	num._x=bx;
	num._y=by;
	num._alpha=50;

	bx+=bs;

	attachMovie("numbers","num4",105);
	num=num4;
	num.gotoAndStop(1);
	num._x=bx;
	num._y=by;
	num._alpha=50;





	n=0;
	for(i=1;n<600;i++)
	{
		n+=i;
	}
	_root.yswish_n=n;
	_root.yswish_i=i;

	n=0;
	for(i=1;n<800;i++)
	{
		n+=i;
	}
	_root.xswish_n=n;
	_root.xswish_i=i;


/*
	if(!(txt.yp>0))
	{
		attachMovie("layout","txt",1000);
		txt.gotoAndStop(2);

		txt._x=-8;
		txt._y=-8;
		txt._y+=_root.yswish_n;
		txt.yp=-_root.yswish_i;
	}
*/

setup_done=true;
}
else
if(game_done==false)
{
	_root.replay.update();

// update timer

	timf++;

	if(timf==30)
	{
		timf=0;
		tims++;
	}

	tt=Math.floor((timf*100)/30);
	t0=tt%10;
	t1=tt/10;
	t2=tims%10;
	t3=((tims-t2)/10)%10;
	t4=((tims-t2)-(t3*10))/100;

	if(t2!=t2o) { num2._alpha=100; }
	if(t3!=t3o) { num3._alpha=100; }
	if(t4!=t4o) { num4._alpha=100; }

	t2o=t2;
	t3o=t3;
	t4o=t4;

	num0.gotoAndStop(t0+2);
	num1.gotoAndStop(t1+2);
	num2.gotoAndStop(t2+2);

	if(t4==0)
	{
		if(t3==0)
		{
			num3.gotoAndStop(1);
		}
		else
		{
			num3.gotoAndStop(t3+2);
		}
		num4.gotoAndStop(1);
	}
	else
	{
		num3.gotoAndStop(t3+2);
		num4.gotoAndStop(t4+2);
	}

	clear();

	bat_update(bat);

	ball_update(ball);

	txt_update(txt);

	pat_update(pats);


}
else
{

	if(_root["exit_replay"]) { _root["exit_replay"].removeTextField(); }
	
	_root.replay.update();


	_root.scores.mc._visible=true;
		
//	txt_update(txt);

	pat_update(pats);

	_root.start_game=function()
	{
		_root.scores.mc._visible=false;
		
		_root.setup_done=false;
		_root.game_done=false;
		
#if VERSION_SITE=='pepere' then

		_root.scores.pepere_load_replay_state=-2;
		_root.scores.pepere_load_replay_id=-1;
		
#end
		
	}
	
	_root.click_continue=function()
	{
		_root.start_game();

		_root.click_continue=false;
		_root.replay.start_record();
	}
	
	_root.click_score=function(n)
	{
		var num:Number=Number(n); // make sure?
		var a:Array;
		var s:String;
		var t;
		
		trace("replay="+num);
		
#if VERSION_SITE=='pepere' then

		if(_root.scores.pepere_load_replay_state<=0)
		{
			_root.scores.pepere_load_replay_state=30*5;	// 5 secs to load score before we giveup
			_root.scores.pepere_load_replay_id=num;
			_root.scores.pepere_load_replay();
		}

#else
		_root.start_game();

		_root.click_continue=false;
		
		s=_root.scores.scores[num];
		a=s.split(";");
		s=a[2];
		
		_root.replay.str=s;
		_root.replay.start_play();
		
		_root.createTextField( "exit_replay",1919 , 8*10 , 8*64 , 8*74 , 8*6 );
		t=_root["exit_replay"];t.type="dynamic";t.embedFonts=true;t.html=true; t.multiline=true;t.selectable=false;
		t.htmlText="<a href=\"asfunction:_root.click_continue\"><font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#00ff00\">Click here to exit this replay.</font></a>";
		
		_root.click_continue=function()
		{
			if(_root["exit_replay"]) { _root["exit_replay"].removeTextField(); }

			_root.game_done=true;
			_root.replay.end_play();
			_root.click_continue=false;
		}

#end

	}
	
	if( (_root.kdown) )
	{
		_root.start_game();

		_root.click_continue=false;
		_root.replay.start_record();
	}

#if VERSION_SITE=='pepere' then

	if(_root.scores.pepere_load_replay_state>0) { _root.scores.pepere_load_replay_state--; }
	
	if(_root.scores.pepere_load_replay_state==-1) // loaded replay, jump to it
	{
		_root.start_game();
		_root.click_continue=false;
		
		_root.replay.str=_root.scores.pepere_load_replay_str;
		_root.replay.start_play();
		
		_root.createTextField( "exit_replay",1919 , 8*10 , 8*64 , 8*74 , 8*6 );
		t=_root["exit_replay"];t.type="dynamic";t.embedFonts=true;t.html=true; t.multiline=true;t.selectable=false;
		t.htmlText="<a href=\"asfunction:_root.click_continue\"><font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#00ff00\">Click here to exit this replay.</font></a>";
		
		_root.click_continue=function()
		{
			if(_root["exit_replay"]) { _root["exit_replay"].removeTextField(); }

			_root.game_done=true;
			_root.replay.end_play();
			_root.click_continue=false;
		}
	}

#end

}


if(num2._alpha>50) { num2._alpha-=2; }
if(num3._alpha>50) { num3._alpha-=2; }
if(num4._alpha>50) { num4._alpha-=2; }


			}
		}
	}

}


