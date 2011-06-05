/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/



#include "src/opts.as"


class pung 
{
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	

function drawbox(t,x,y,w,h)
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

function pat_add(t,x,y,xv,yv,s)
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

function pat_add_imp(t,x,y,xv,yv,n)
{
var i;

	for(i=0;i<n;i++)
	{
		pat_add(mc.pats,x,y,(Math.random()-0.5)*12-xv,(Math.random()-0.5)*12-yv,8);
	}
}

	var up;
	
	var mc;

//	var scores:pung_scores;
	
	var replay;
//	var scores;
	
	var title_done;
	var setup_done;
	var game_done;
	
	
//	var pats;
//	var bat;
//	var txt;
//	var ball;
	
//	var high;
	
	var xswish_n;
	var xswish_i;
	var yswish_n;
	var yswish_i;
	

	var tims;
	var timf;
	
	var t2o;
	var t3o;
	var t4o;
	
	var kdown;
	
//	var bak;
	
	var bx;
	var by;
	var bs;
	
	var wet;
	
	
	// --- Main Entry Point
	function pung(_up)
	{
//dbg.print("pung_construct");
		up=_up;

//tell root to listen to mouse
		_root.mousedown=false;
		_root.onMouseDown=function()		{			_root.mousedown=true;	/*_root.replay.prekey_on(Replay.KEY_MBUTTON);*/	}
		_root.onMouseUp=function()			{			_root.mousedown=false;	/*_root.replay.prekey_off(Replay.KEY_MBUTTON);*/	}
		Mouse.addListener(_root);
		
		
		


	}
		
	
	function setup()
	{
//dbg.print("pung_setup");
		mc=gfx.create_clip(up.mc,null);
		
		replay=new Replay();

//		scores=new pung_scores(this.mc,"scores",9);
//		scores.mc._visible=false;

		title_done=false;
		setup_done=false;
		game_done=true;

//		high=new PlayHigh(this);
	}
	
	function clean()
	{
//dbg.print("pung_clean");
		mc.removeMovieClip();
	}
	
	
	
	
function pat_setup(t)
{
	t.p_next=0;
	t.p_max=64;
	t.p_i=[0];
	t.p_x=[0];
	t.p_y=[0];
	t.p_xv=[0];
	t.p_yv=[0];
}



function pat_update(t)
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



function bat_setup(t)
{

	t.x=800-80;
	t.y=300;
	t.w=16;
	t.h=128;

	t.xv=0;
	t.yv=0;

	drawbox(t,t.x,t.y,t.w,t.h);

	gfx.glow(t , 0x00ff00, .8, 16, 16, 1, 3, false, false );
}


function bat_update(t)
{
	t.clear();

	if(replay.key&Replay.KEYM_UP) //( Key.isDown(Key.UP) || t.m_UP )
	{
		if(t.h>0)
		{
			if(t.yv>0) { t.yv=0; }
			t.yv-=1;
			t.h-=1;

			pat_add(mc.pats,t.x,t.y+t.h/2,Math.random(),4+(Math.random()*1),8);
			pat_add(mc.pats,t.x,t.y+t.h/2,Math.random(),4+(Math.random()*1),8);
		}
	}
	else
	if(replay.key&Replay.KEYM_DOWN) //( Key.isDown(Key.DOWN) || t.m_DOWN)
	{
		if(t.h>0)
		{
			if(t.yv<0) { t.yv=0; }
			t.yv+=1;
			t.h-=1;

			pat_add(mc.pats,t.x,t.y-t.h/2,Math.random(),-4+(Math.random()*-1),8);
			pat_add(mc.pats,t.x,t.y-t.h/2,Math.random(),-4+(Math.random()*-1),8);
		}
	}

	t.ymin=0+26+(t.h/2);
	t.ymax=600-26-(t.h/2);

	t.y+=t.yv;

	if(t.y<t.ymin)
	{
		pat_add_imp(mc.pats,t.x,t.y-(t.h/2),t.xv,t.yv,8)

		t.y=t.ymin;
		t.yv*=-1;

		
		_root.wetplay.PlaySFX("sfx_beep1",1);	
	}
	else
	if(t.y>t.ymax)
	{
		pat_add_imp(mc.pats,t.x,t.y+(t.h/2),t.xv,t.yv,8)

		t.y=t.ymax;
		t.yv*=-1;

		_root.wetplay.PlaySFX("sfx_beep1",1);	
	}

	if(t.h>0)
	{
		drawbox(t,t.x,t.y,t.w,t.h);
	}

}

function txt_update(t)
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


function ball_setup(t)
{

	t.x=64;
	t.y=300;
	t.w=16;
	t.h=16;

	t.xv=8;
	t.yv=-12;

	drawbox(t,t.x,t.y,t.w,t.h);

	gfx.glow(t , 0x00ff00, .8, 16, 16, 1, 3, false, false );
}


function ball_update(t)
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
		pat_add_imp(mc.pats,t.x,t.y,0,t.yv,8)

		t.y=t.ymin;
		t.yv*=-1;

		_root.wetplay.PlaySFX("sfx_beep1",1);	

	}
	else
	if(t.y>t.ymax)
	{
		pat_add_imp(mc.pats,t.x,t.y,0,t.yv,8)

		t.y=t.ymax;
		t.yv*=-1;

		_root.wetplay.PlaySFX("sfx_beep1",1);	
	}

	if(t.x<t.xmin)
	{
		pat_add_imp(mc.pats,t.x,t.y,t.xv,0,8)

		t.x=t.xmin;
		t.xv*=-1;

		_root.wetplay.PlaySFX("sfx_beep1",1);	
	}
	else
	if( (t.x>t.xl) && (t.x<t.xh) )	// bat hit
	{
		if( (t.xv>0) && (mc.bat.h>0) )// only going towards bat
		{
			t.bymin=mc.bat.y-(mc.bat.h/2)-8;
			t.bymax=mc.bat.y+(mc.bat.h/2)+8;

			if( (t.y>t.bymin) && (t.y<t.bymax) ) // on bat
			{
				pat_add_imp(mc.pats,t.x,t.y,t.xv,0,8)

				if(t.y<mc.bat.y)
				{
					t.fixy=(mc.bat.y-t.y)/(mc.bat.y-t.bymin);
					t.fixx=1-t.fixy;
					t.fixy*=-8;
				}
				else
				{
					t.fixy=(t.y-mc.bat.y)/(t.bymax-mc.bat.y);
					t.fixx=1-t.fixy;
					t.fixy*=8;
				}
//				t.x=t.xl;

				t.yv+=t.fixy;
				mc.bat.yv-=t.fixy;

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

				_root.wetplay.PlaySFX("sfx_beep2",2);	
			}
		}
	}
	else
	if(t.x>t.xmax)
	{
		pat_add_imp(mc.pats,t.x,t.y,t.xv,0,48)

		t.x=t.xmax;
		t.xv=0;
		t.yv=0;
		game_done=true;

		mc.txt._x=-8;
		mc.txt._y=-8;
		mc.txt._y+=yswish_n;
		mc.txt.yp=-yswish_i;


		t.h=0;

		_root.wetplay.PlaySFX("sfx_beep3",3);
		
		/*
		if(replay.state==Replay.STATE_PLAY)
		{
			replay.end_play();
		}
		else
		if(replay.state==Replay.STATE_RECORD)
		{
			replay.end_record();
			scores.insert((tims*100)+Math.floor((timf*100)/30) , replay.str);
		}
		*/
//ENDOFGAME

		_root.signals.signal("batwsball","end",this);
		
	}

	if(t.h>0)
	{
		drawbox(t,t.x,t.y,t.w,t.h);
	}

}
	
	
	function start_game()
	{
//		scores.mc._visible=false;
		
		setup_done=false;
		game_done=false;
		
		
	}


	
	function update()
		{
//dbg.print("pung_update");

			kdown=Key.isDown(Key.SPACE) || Key.isDown(Key.ENTER);
			
			var bb;


			bb=mc.bat;
			
	if(_root.mousedown)
	{
		if(mc._ymouse<bb.y)
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
			replay.prekey_off(Replay.KEY_UP);
			replay.prekey_off(Replay.KEY_DOWN);
		}
		
		bb.m_ON=false;
	}

	if(bb.m_UP)
	{
		replay.prekey_on(Replay.KEY_UP);
		replay.prekey_off(Replay.KEY_DOWN);
	}
	else
	if(bb.m_DOWN)
	{
		replay.prekey_off(Replay.KEY_UP);
		replay.prekey_on(Replay.KEY_DOWN);
	}
	else
	{
		if(Key.isDown(Key.UP))
		{
			replay.prekey_on(Replay.KEY_UP);
		}
		else
		{
			replay.prekey_off(Replay.KEY_UP);
		}
		
		if(Key.isDown(Key.DOWN))
		{
			replay.prekey_on(Replay.KEY_DOWN);
		}
		else
		{
			replay.prekey_off(Replay.KEY_DOWN);
		}
	}
	



// hacky new key stuff....
			if(Key.isDown(Key.SPACE) || Key.isDown(Key.ENTER))
			{
				replay.prekey_on(Replay.KEY_FIRE);
			}
			else
			{
				replay.prekey_off(Replay.KEY_FIRE);
			}

		
//			with(pungmc)
//			{


if(title_done==false) // initial pre setup
{
var s;

	title_setup();


	if( (kdown) )
	{
		_root.click_continue();
	}

}
else
if(setup_done==false) // initial setup
{
	pat_update(mc.pats);
	
	if(!_root.popup)
	{
		game_setup();
		
	}
}
else
if(game_done==false)
{
	if(!_root.popup)
	{

	_root.signals.signal("batwsball","update",this);
		
	replay.update();

// update timer

	timf++;

	if(timf>=25) // allegedly 25 fps
	{
		timf=0;
		tims++;
	}
	
var tt;
var t0;
var t1;
var t2;
var t3;
var t4;

	tt=Math.floor((timf*100)/25);
	t0=Math.floor(tt%10);
	t1=Math.floor(tt/10);
	t2=Math.floor(tims%10);
	t3=Math.floor(((tims-t2)/10)%10);
	t4=Math.floor(((tims-t2)-(t3*10))/100);

	if(t2!=t2o) { mc.num2._alpha=100; }
	if(t3!=t3o) { mc.num3._alpha=100; }
	if(t4!=t4o) { mc.num4._alpha=100; }

	t2o=t2;
	t3o=t3;
	t4o=t4;

	mc.num0.gotoAndStop(t0+2);
	mc.num1.gotoAndStop(t1+2);
	mc.num2.gotoAndStop(t2+2);

	if(t4==0)
	{
		if(t3==0)
		{
			mc.num3.gotoAndStop(1);
		}
		else
		{
			mc.num3.gotoAndStop(t3+2);
		}
		mc.num4.gotoAndStop(1);
	}
	else
	{
		mc.num3.gotoAndStop(t3+2);
		mc.num4.gotoAndStop(t4+2);
	}

	mc.clear();

	bat_update(mc.bat);

	ball_update(mc.ball);

	txt_update(mc.txt);

	pat_update(mc.pats);


	}
}
else
{
	pat_update(mc.pats);
	
	if(!_root.popup)
	{	
		up.high.setup();

		start_game();
	}
}


if(mc.num2._alpha>50) { mc.num2._alpha-=2; }
if(mc.num3._alpha>50) { mc.num3._alpha-=2; }
if(mc.num4._alpha>50) { mc.num4._alpha-=2; }


		}


function title_setup()
{
var s;

	if(mc.bak) return;

	mc.attachMovie("layout","bak",1);
	mc.bak._x=-8;
	mc.bak._y=-8;
	mc.bak.gotoAndStop(1);

	mc.attachMovie("layout","bak2",2);
	mc.bak2._x=-8;
	mc.bak2._y=-8;
	mc.bak2.gotoAndStop(2);


	mc.attachMovie("kriss","bak4",4);
	mc.bak4._x=800-140;
	mc.bak4._y=600-180;
	mc.bak4._xscale=160;
	mc.bak4._yscale=160;

	
	mc.createTextField( "bak5",5 , 8*10 , 8*8 , 8*74 , 8*50 );
	mc.bak5.type="dynamic";
	mc.bak5.multiline=true;
	mc.bak5.embedFonts=true;
	mc.bak5.html=true;
	mc.bak5.selectable=false;
	mc.bak5.wordWrap=true;
	s="<a href=\"asfunction:_root.click_continue\"><font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#000000\">"
	s+="#(VERSION_NAME) <font size=\"16\"> v#(VERSION_NUMBER) #(VERSION_SITE) #(VERSION_BUILD) </font> <font size=\"8\"> (c) Kriss Daniels #(VERSION_STAMP) </font><br>";
	s+="<br>";
	s+="Keep the ball on screen for as long as you can. Use UP/DOWN keys or mouse clicks to move the bat. ";
	s+="But beware, as moving the bat will cause it to shrink. <br>"
	s+="<br>";
	s+="Click or press SPACE to continue."
	s+="</font></a>";
	mc.bak5.htmlText=s

	_root.click_continue=delegate(click_continue_a);

	mc.createTextField( "bak6",6 , 8*10 , 8*58 , 8*74 , 8*16 );
	mc.bak6.type="dynamic";
	mc.bak6.embedFonts=true;
	mc.bak6.html=true;
	mc.bak6.selectable=false;
	mc.bak6.htmlText="<font face=\"Bitstream Vera Sans\" size=\"56\" color=\"#00ff00\"><a target=\"_blank\" href=\"http://www.WetGenes.com\">www.WetGenes.com</a></font>";



	var w = new wetDNA(mc,"wet",8);
	w.color=0x00ff00;
	w.mc._x=370;
	w.mc._y=500;
	w.mc._xscale=120;
	w.mc._yscale=50;
	gfx.glow(w.mc , 0x00ff00, 1, 16, 16, 1, 3, false, false );
	wet=w;
	
}

function title_clean()
{
	mc.bak2.removeMovieClip();
	mc.bak4.removeMovieClip();
	mc.bak5.removeTextField();
	mc.bak6.removeTextField();
	wet.mc.removeMovieClip();
	
}


function click_continue_a()
	{
//dbg.print("click_continue_a");

		title_clean();
		
		title_done=true;
		_root.click_continue=null;
	}
	

function game_setup()
{
var num;

//beep1=new Sound();
//beep1.attachSound("beep");
//beep1.start(); 

	_root.signals.signal("batwsball","start",this);

	timf=0;
	tims=0;
	t2o=0;
	t3o=0;
	t4o=0;

	mc.clear();

	mc.attachMovie("layout","bak",1);
	mc.bak._x=-8;
	mc.bak._y=-8;
	mc.bak.gotoAndStop(1);
	
	mc.bak.cacheAsBitmap=true;


	mc.createEmptyMovieClip("bat", 10);
	bat_setup(mc.bat);

	mc.createEmptyMovieClip("ball", 11);
	ball_setup(mc.ball);

	mc.createEmptyMovieClip("pats", 12);
	pat_setup(mc.pats);

	bx=400+96;
	bs=-56;
	by=48;

	mc.attachMovie("numbers","num0",100);
	num=mc.num0;
	num.gotoAndStop(2);
	num._x=bx;
	num._y=by;
	num._alpha=50;
	gfx.glow(num , 0x00ff00, .8, 16, 16, 1, 3, false, false );

	bx+=bs;

	mc.attachMovie("numbers","num1",101);
	num=mc.num1;
	num.gotoAndStop(2);
	num._x=bx;
	num._y=by;
	num._alpha=50;
	gfx.glow(num , 0x00ff00, .8, 16, 16, 1, 3, false, false );

	bx+=bs;

	mc.attachMovie("numbers","num_",102);
	num=mc.num_;
	num.gotoAndStop(12);
	num._x=bx;
	num._y=by;
	num._alpha=50;
	gfx.glow(num , 0x00ff00, .8, 16, 16, 1, 3, false, false );

	bx+=bs;

	mc.attachMovie("numbers","num2",103);
	num=mc.num2;
	num.gotoAndStop(2);
	num._x=bx;
	num._y=by;
	num._alpha=50;
	gfx.glow(num , 0x00ff00, .8, 16, 16, 1, 3, false, false );

	bx+=bs;

	mc.attachMovie("numbers","num3",104);
	num=mc.num3;
	num.gotoAndStop(1);
	num._x=bx;
	num._y=by;
	num._alpha=50;
	gfx.glow(num , 0x00ff00, .8, 16, 16, 1, 3, false, false );

	bx+=bs;

	mc.attachMovie("numbers","num4",105);
	num=mc.num4;
	num.gotoAndStop(1);
	num._x=bx;
	num._y=by;
	num._alpha=50;
	gfx.glow(num , 0x00ff00, .8, 16, 16, 1, 3, false, false );


//dbg.print("click_continue_bb1");


var n;
var i;

	n=0;
	for(i=1;n<600;i++)
	{
		n+=i;
	}
	yswish_n=n;
	yswish_i=i;

	n=0;
	for(i=1;n<800;i++)
	{
		n+=i;
	}
	xswish_n=n;
	xswish_i=i;


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
	
		
}


