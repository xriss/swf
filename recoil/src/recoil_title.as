/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.dynamicflash.utils.Delegate;


class recoil_title
{
	var main:recoil;
	var mc:MovieClip;
	
	var loaded_percent:Number;
	
	var main_tf:TextField;
	var scores_tf:TextField;
	
	static var STATE_NONE      	:Number =   0;
	static var STATE_SPLASH    	:Number =   1;
	static var STATE_WIN       	:Number =   2;
	static var STATE_LOSE      	:Number =   3;
	static var STATE_MAIN_MENU	:Number =   4;
	static var STATE_CREDITS 	:Number =   5;
	static var STATE_OPTIONS 	:Number =   6;
	static var STATE_SCORES 	:Number =   7;
// state to use, set before changing master state to this
	var state		:Number;


	var score_view:String;

	var str_numst:Array=[' 1st',' 2nd',' 3rd',' 4th',' 5th',' 6th',' 7th',' 8th',' 9th','10th','11th','12th','13th','14th','15th'];


	
	var fmt:TextFormat;

	function delegate(f:Function) { return Delegate.create(this,f); }

	function recoil_title(t)
	{
		loaded_percent=0;
		score_view='local';
		
		fmt=new TextFormat();
		fmt.font="Bitstream Vera Sans";
		fmt.size=32;
		fmt.color=0x000000;
		fmt.bold=true;
	
		main=t;
		setup();
		clean();
	}
	
	function build_bub()
	{
	var t;
	var s;
	
		t=gfx.add_clip(mc,"kriss");
		t._x=800-160;
		t._y=600-200;
		t._xscale=200;
		t._yscale=200;

		t=gfx.add_clip(mc,"layout");
		t.gotoAndStop(4);
		
		t=new wetDNA(mc,"dna",++mc.newdepth);
		mc.DNA=t;
		t.color=0x000080;
		t.mc._x=350;
		t.mc._y=520;
		t.mc._yscale=50;
		t.mc._xscale=120;

		t=gfx.create_text_html(t.mc,1,-246,-60,500,50);
		t._yscale=200;
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"42\" color=\"#000080\">";
		s+="<a target=\"_top\" href=\"http://www.WetGenes.com\"><b>www.WetGenes.com</b></a><br>";
		s+="</font>";
		t.htmlText=s;

		t=gfx.create_text_html(mc,++mc.newdepth,50,50,700,400);
		return t;
	}
	
	function setup()
	{
// rebuild main movieclip
		if(mc)
		{
			mc.removeMovieClip();
			mc=null;
		}
		mc=gfx.create_clip(_root);
		mc.t=this;

		main.scores.show_replay_str=null;

		var t;
		var s;
		

		if(state==STATE_SPLASH)
		{
			main_tf=build_bub();
			main_tf.htmlText=get_splash_text();
			_root[_root.click_name]=delegate(click_id);
		}
		else
		if(state==STATE_CREDITS)
		{
			t=build_bub();
	
			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#000000\">";
			
			s+="<a target=\"_top\" href=\"http://jebus_hat.esyou.com\"><b>";
			s+="Shi</b></a> ";
			s+="made the jingles and the scary looking clowns.";
			s+="<br><br>";
			
			s+="<a target=\"_top\" href=\"http://XIXs.com\"><b>";
			s+="Kriss</b></a> ";
			s+="did everything else and is a scary looking clown.";
			s+="<br><br><br>";

			s+="Click on names to view their homepages.";
			s+="<br><br>";
			
			s+="<a href=\"asfunction:_root."+_root.click_name+",menu\"><b>";
			s+="Click here to continue. </b></a>";
			s+="<br>";
			s+="</font>";
			t.htmlText=s;
	
			_root[_root.click_name]=delegate(click_id);
		}
		else
		if(state==STATE_MAIN_MENU)
		{
			t=build_bub();
	
			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#000000\">";
			
			s+="<a href=\"asfunction:_root."+_root.click_name+",splash\"><b>";
			s+="View instructions again?</b></a>";
			s+="<br><br>";
			
			s+="<a href=\"asfunction:_root."+_root.click_name+",options\"><b>";
			s+="Change name and options?</b></a>";
			s+="<br><br>";
			
			s+="<a href=\"asfunction:_root."+_root.click_name+",scores\"><b>";
			s+="View High Scores and replays?</b></a>";
			s+="<br><br>";
			
			s+="<a href=\"asfunction:_root."+_root.click_name+",credits\"><b>";
			s+="Who did what with the what now?</b></a>";
			s+="<br><br>";

			s+="But what you really want to do is<br>";
			s+="<a href=\"asfunction:_root."+_root.click_name+",start\"><b>";
			s+="Click here to start a Game.</b></a>";
			s+="<br><br>";
			
			s+="</font>";
			t.htmlText=s;
	
			_root[_root.click_name]=delegate(click_id);
		}
		else
		if(state==STATE_WIN)
		{
			var n:Number;
			
			if(_root.jingle==null)
			{
				_root.jingle=_root.attachMovie("jingle_win","jingle",-999);
			}
			
			t=gfx.add_clip(mc,"layout");
			t.gotoAndStop(2);
			
			t=gfx.create_text_html(mc,++mc.newdepth,50,40,700,150);
			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#000000\">";
			s+="Why would you do that to us? All we ever wanted was to be loved, ";
			s+="by a pony and to destroy your reality.";
			s+="<br><br>";
			s+="</font>";
			
			t.htmlText=s;


			t=gfx.create_text_html(mc,++mc.newdepth,50,250,400,500);
			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#000000\">";
			
			s+="You scored "+main.game.score;
			s+="<br><br>";

			s+="<a href=\"asfunction:_root."+_root.click_name+",start\"><b>";
			s+="Play again?</b></a><br><br>";
			
			s+="<a href=\"asfunction:_root."+_root.click_name+",menu\"><b>";
			s+="Go to main menu?</b></a><br><br>";
			
			s+="<a href=\"asfunction:_root."+_root.click_name+",scores\"><b>";
			s+="View high scores and replays?</b></a><br><br>";
			
			s+="</font>";
			
			t.htmlText=s;

			_root[_root.click_name]=delegate(click_id);
		}
		else
		if(state==STATE_LOSE)
		{
			if(_root.jingle==null)
			{
				_root.jingle=_root.attachMovie("jingle_lose","jingle",-999);
			}

			t=gfx.add_clip(mc,"layout");
			t.gotoAndStop(3);
		
			t=gfx.create_text_html(mc,++mc.newdepth,50,40,700,150);
			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#000000\">";
			s+="Ha HA HAAAAAAAAA!!!<br>";
			s+="Now all we need is a clean pair of shoes.<br>";
			s+="Then everything will be ours.<br>";
			s+="<br><br>";
			s+="</font>";
			
			t.htmlText=s;
	

			t=gfx.create_text_html(mc,++mc.newdepth,50,250,400,500);
			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#000000\">";
			
			s+="You scored nothing";
			s+="<br><br>";

			s+="<a href=\"asfunction:_root."+_root.click_name+",start\"><b>";
			s+="Play again?</b></a><br><br>";
			
			s+="<a href=\"asfunction:_root."+_root.click_name+",menu\"><b>";
			s+="Go to main menu?</b></a><br><br>";
			
			s+="<a href=\"asfunction:_root."+_root.click_name+",scores\"><b>";
			s+="View high scores and replays?</b></a><br><br>";
			
			s+="</font>";
			
			t.htmlText=s;

			_root[_root.click_name]=delegate(click_id);
		}
		else
		if(state==STATE_SCORES)
		{
			t=gfx.add_clip(mc,"layout");
			t.gotoAndStop(5);
			
			main_tf=gfx.create_text_html(mc,++mc.newdepth,40,40,720,600);
			scores_tf=gfx.create_text_html(mc,++mc.newdepth,20,180,760,400);
			
			thunk_scores();
			
			_root[_root.click_name]=delegate(click_id);
			
			main.scores.update_high();	// check for new scores
		}
		else
		if(state==STATE_OPTIONS)
		{
			main_tf=build_bub();

			main_tf.htmlText=get_options_text();
			
#if VERSION_SITE=='pepere' then

#else
			mc.createTextField( "mynameis",++mc.newdepth , 8*36 , 8*25 , 8*48 , 8*6 );
			t=mc["mynameis"];t.embedFonts=true;
			t.text=main.scores.myname;
			t.restrict="0123456789ABCDEFGHIJKLMNOPRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
			t.maxChars=16;
			t.setTextFormat(fmt);
			t.type="input";
			t.selectable=true;
			t.addListener(this);
#end
	
			_root[_root.click_name]=delegate(click_id);
		}

		mc._visible=true;
	}
	
	function  onChanged()	// only the name..
	{
		if(mc.mynameis.text)
		{
			main.scores.myname=mc.mynameis.text;
		}
	}
	
	function thunk_scores() // update score display, (if it is visible)
	{
		var s:String;
		
		if(state==STATE_SCORES)
		{
			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#000000\">";

			s+="<a href=\"asfunction:_root."+_root.click_name+",menu\"><b>";
			s+="Click here to return to main menu. </b></a><br>";

			s+="<br>";
			
			s+="Click a high score to view its replay.<br>";
				
			s+="<br><br><br><br><br><br><br><br><br>";
			
			s+="<br>";
			
			s+="<a href=\"asfunction:_root."+_root.click_name+",start\"><b>";
			s+="Click here to start a game. </b></a>";
			s+="<br>";
			

			s+="</font>";
			
			main_tf.htmlText=s;

			s="";
			s+="<font face=\"Bitstream Vera Sans Mono\" size=\"22\" color=\"#000000\">";

			s+="<a href=\"asfunction:_root."+_root.click_name+",high_global\"><b>";
			s+="   Global Scores ";
			s+="</b></a> . ";
			s+="<a href=\"asfunction:_root."+_root.click_name+",high_local\"><b>";
			s+=" Local Scores ";
			s+="</b></a> . ";
			s+="<a href=\"asfunction:_root."+_root.click_name+",high_today\"><b>";
			s+=" Todays Scores ";
			s+="</b></a>";
			s+="<br>";
			s+="<br>";

// check type of highscore
			var score_view_str:String;
			var array_str:String;
			if(score_view=='global')
			{
				score_view_str='Global';
				array_str='high_global';
			}
			else
			if(score_view=='local')
			{
				score_view_str= 'Local ';
				array_str='high';
			}
			else
			if(score_view=='today')
			{
				score_view_str= 'Todays';
				array_str='high_today';
			}
			
			for(var i=0;i<10;i++)
			{
				var a:Array;
				var n:Number;
				var scr:String;
				
				a=main.scores[array_str][i].split(';');

				n=Number(a[0]);
				if(n<10)	{ scr="    "+n; }
				else
				if(n<100)	{ scr="   "+n; }
				else
				if(n<1000)	{ scr="  "+n; }
				else
				if(n<10000)	{ scr=" "+n; }
				else
							{ scr=""+n; }
					
				if(a[2]==null)
				{
					s+=" "+score_view_str+' '+str_numst[i]+"  "+scr+"  "+a[1].substr(0,30);
					s+="<br>";
				}
				else
				{
					s+="<a href=\"asfunction:_root."+_root.click_name+",replay_"+i+"\"><b>";
					s+=" "+score_view_str+' '+str_numst[i]+"  "+scr+"  "+a[1].substr(0,20);
					s+="</b></a><br>";
				}
			}
			s+="</font>";

			scores_tf.htmlText=s;

		}
	}

	function get_splash_text()
	{
	var s:String;
	
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#000000\">";
		
		s+="<b>#(VERSION_NAME) </b> <font size=\"16\"> v#(VERSION_NUMBER) #(VERSION_SITE) #(VERSION_BUILD) </font> <font size=\"8\"> (c) Kriss Daniels #(VERSION_STAMP) </font>";

		s+="<br><br>";
		s+="The evil clowns are plotting to build a singularity out of balloons. ";
		s+="Pop them all before it is too late. ";
		s+="<br><br>";
		s+="Mouse control only, just click to shoot and the recoil will move you. ";
		s+="<br><br>";

		if(loaded_percent==100)
		{
#if VERSION_SITE=='pepere' then

			s+="<a href=\"asfunction:_root."+_root.click_name+",menu\"><b>";
			
#else

			if( (main.scores.myname=='Me') || (main.scores.myname.substr(0,5)=='Guest') ) // remind them to change anme
			{
				s+="<a href=\"asfunction:_root."+_root.click_name+",options\"><b>";
			}
			else
			{
				s+="<a href=\"asfunction:_root."+_root.click_name+",menu\"><b>";
			}
#end
			s+="Click here to continue. </b></a>";
		}
		else
		{
			s+="Loading "+loaded_percent+"%";
		}
		s+="<br>";
		s+="</font>";
		
		return s;
	}
			
	function get_options_text()
	{
		var s:String;
		
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#000000\">";
		
		s+="Sound is <a href=\"asfunction:_root."+_root.click_name+",togsound\"><b>";
		if(main.opt_sound) { s+="ON"; }	else { s+="OFF"; }
		s+="</b></a>";
		s+="<br><br>";
		s+="Transitions are <a href=\"asfunction:_root."+_root.click_name+",togtransitions\"><b>";
		if(main.opt_transitions) { s+="PRETTY"; }	else { s+="FAST"; }
		s+="</b></a>";
		s+="<br><br>";
		
#if VERSION_SITE=='pepere' then

		s+="<br><br><br><br>";
#else

		s+="My name is:<br>";
		s+="Click to edit, and remember that this name will be saved with any highscores.";
		s+="<br><br><br>";
#end
		
		s+="<a href=\"asfunction:_root."+_root.click_name+",menu\"><b>";
		s+="Click here to continue.</b></a>";
		s+="<br><br>";
		
		s+="</font>";
		
		return s;
	}
	
	function click_id(id:String)
	{
		var a:Array;
		
		a=id.split('_');
		
		trace(a);
		
		switch(a[0])
		{
			case "splash":
				state=STATE_SPLASH;
				main.state_next=recoil.STATE_TITLE;
			break;
			
			case "options":
				state=STATE_OPTIONS;
				main.state_next=recoil.STATE_TITLE;
			break;
			
			case "menu":
				state=STATE_MAIN_MENU;
				main.state_next=recoil.STATE_TITLE;
			break;
			
			case "credits":
				state=STATE_CREDITS;
				main.state_next=recoil.STATE_TITLE;
			break;
			
			case "scores":
				state=STATE_SCORES;
				main.state_next=recoil.STATE_TITLE;
			break;
			
			case "start":
				main.state_next=recoil.STATE_GAME;
				main.replay.start_record();
			break;
			
			case "replay":
				main.scores.request_replay(Number(a[1]),score_view);	// this may take a little while...
			break;
			
			case "togsound":
				main.opt_sound=!main.opt_sound;
				main.opt_update();
				main_tf.htmlText=get_options_text();
			break;

			case "togtransitions":
				main.opt_transitions=!main.opt_transitions;
				main.opt_update();
				main_tf.htmlText=get_options_text();
			break;
			
			case 'high':
				score_view=a[1];
				thunk_scores();
			break;
		}
		
		if(main.state_next!=recoil.STATE_NONE)
		{
			_root[_root.click_name]=null;
		}
	}
	
	
	function update()
	{
		if(state==STATE_SPLASH) // pre loader
		{
			loaded_percent= Math.floor(_root.getBytesLoaded()*100 / _root.getBytesLoaded());
			main_tf.htmlText=get_splash_text();
		}
		else
		if(state==STATE_SCORES)
		{
			if(main.scores.show_replay_str!=null) // we got given a replay to show
			{
				main.state_next=recoil.STATE_GAME;
				main.replay.start_play(main.scores.show_replay_str);
				main.scores.show_replay_str=null;
			}
		}
	}

	function clean()
	{
		_root.jingle=null;
		mc._visible=false;
	}

	
}