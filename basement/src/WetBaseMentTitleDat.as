/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"





class WetBaseMentTitleDat
{

	var up; // WetBaseMentTitle
	
	var minions;
	var frame=0;
	
	var play; // the play class
	
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	

	function WetBaseMentTitleDat(_up,_play)
	{
		up=_up;
		play=_play;
	}
	
	function days_to_string(days)
	{
		var d;
		var s;
		
		if(days== up.up.game_seed_today) { return "Today"; }
		
		d=new Date();
		d.setTime(days*24*60*60*1000);
		
		s=alt.Sprintf.format("%04d%02d%02d",d.getFullYear(),d.getMonth()+1,d.getDate());
		
		return s;
	}

	function setup()
	{
	var i;
	var a;
	
		minions=[];
		frame=0;
		
		switch (up.state)
		{
			case "levels_all" :
			case "zoo_all" :
			
				a=new Array();
				for(i=0;i<10;i++)
				{
					a[i]=new Array();
					a[i][0]=0;
					a[i][1]="me";
					a[i][2]=play.up.game_seed_today-i;
				}
				play.scores_hard=a;
				play.scores_hard_flag=false;
				
				a=new Array();
				for(i=0;i<10;i++)
				{
					a[i]=new Array();
					a[i][0]=0;
					a[i][1]="me";
					a[i][2]=play.up.game_seed_today-i;
				}
				play.scores_easy=a;
				play.scores_easy_flag=false;
				
			break;
		}
		
	}
	
	function clean()
	{
	var i;
	
		for(i=0;i<minions.length;i++)
		{
			minions[i].clean();
		}
		
		minions=[];	
		
		
	}
	
	var anim_over;
	var anim_idx=0;
	
	function update()
	{
	var m;
	var i;
	
		anim_idx++;
		
		m=null;
		
		up.mcs["story_over_1"]._visible=false;
		up.mcs["race_over_1"]._visible=false;
		
		if(anim_over=="race")
		{
			i=((Math.floor(anim_idx/2)%10));
			m=up.mcs["race_over_1"];
		}
		else
		if(anim_over=="story")
		{
			i=((Math.floor(anim_idx/2)%10));
			m=up.mcs["story_over_1"];
		}
		
		if(m)
		{
			gfx.glow( m , 0xffffff, .8, 16, 16, 1, 3, false, false );
			m.gotoAndStop(1);
			m.gotoAndStop(m.baseframe+i);
			m._visible=true;
		}
		
	var ff;
	
		frame++;
		
		ff=Math.floor(frame/6)%6;
		
		for(i=0;i<minions.length;i++)
		{
			minions[i].display("idle",ff);
		}
		
	var mc;
		if(up.state=="end3_all")
		{
/*		
			if(frame<25*1)
			{
			}
			else
			if(frame<25*4)
			{
				mc=up.mcs["slide1"];
				mc._y+=(-900-mc._y)/3;
			}
			else
			if(frame<25*7)
			{
				mc=up.mcs["slide1"];
				mc._y+=(-300-mc._y)/3;
				mc=up.mcs["slide2"];
				mc._y+=(300-mc._y)/3;
			}
			else
			if(frame<25*10)
			{
				mc=up.mcs["slide2"];
				mc._y+=(-300-mc._y)/3;
				mc=up.mcs["slide3"];
				mc._y+=(-900-mc._y)/3;
			}
*/

	var f;
	var ss,s;
		
		f=((frame%100)-50)/50;
		if(f<0){f=-f;}
		ss=f*f;
		s=((ss+(ss*2))-((ss*f)*2));
			
			

			up.mcs["cage1"].twistme._rotation=(s*60)-30;
			up.mcs["minion1"].twistme._rotation=(s*60)-30;
	
		}
		
// load ads?
		if(up.mcs["whore"]) // check if we need an ad
		{
			if(!up.mcs["whore"].whore.ad) // check if we have loaded an ad
			{
				if(_root.wonderfulls) // check if we know what ad to load
				{
					up.mcs["whore"].whore.ad=gfx.create_clip(up.mcs["whore"].whore, null);
					up.mcs["whore"].whore.ad.loadMovie(_root.wonderfulls[0].img);
				}
			}
		}
	}
	
	
	function saves_reset_temps()
	{
	}
	
	function saves_reset()
	{
		up.saves={};
	}

	function update_display()
	{
	var i;
	var mc;
	var nams;			

	var level,l,nmc,box;
	
		
		for(i=0;i<up.mcs_max;i++)
		{
			mc=up.mcs[i];
			nams=mc.nams;

			
			mc._visible=true;
			
			level=nam_to_level(nams[0]);
			if(level)
			{
				l=up.up.levels[level];
				
				if(!mc.level)
				{
					box=mc.getBounds(mc);
					mc.level=gfx.add_clip(mc, l.img_bak, null, box.xMin, box.yMin, (box.xMax-box.xMin)/8, (box.yMax-box.yMin)/6 );
					
					mc.date=gfx.create_text_html(up.mc,null,(box.xMax+box.xMin)/2-80, box.yMin-14,160,20);
					mc.score=gfx.create_text_html(up.mc,null,(box.xMax+box.xMin)/2-80, box.yMax-7,160,20);
					
					if(l.game_seed == up.up.game_seed_today) // highlight todays game
					{
						gfx.set_text_html(mc.date,18,0xffffff,"<p align=\"center\"><b>"+days_to_string(l.game_seed)+"</b></p>");
					}
					else
					{
						gfx.set_text_html(mc.date,12,0xffffff,"<p align=\"center\">"+days_to_string(l.game_seed)+"</p>");
					}
	
	gfx.set_text_html(mc.score,14,0xffffff,"<p align=\"center\">"+"0"+"</p>");
				}
			}
			switch(nams[0])
			{
				case "minion":
				case "minion1":
				case "minion2":
				case "minion3":
				
					if(!mc.minion)
					{
						box=mc.getBounds(mc);
						mc.minimc=gfx.create_clip(mc, null, (box.xMin+box.xMax)/2, box.yMax, (box.xMax-box.xMin), (box.yMax-box.yMin) );
						
						mc.minion=new Minion( {mc:mc.minimc} );
						mc.minion.setup(up.up.tards[up.up.tard_idx].img1,50,100);
						minions[minions.length]=mc.minion;
						
					}
				
				break;
				
				case "whore":
				
					box=mc.getBounds(mc);
					mc.whore=gfx.create_clip(mc, null, box.xMin, box.yMin, 100*(box.xMax-box.xMin)/125, 100*(box.yMax-box.yMin)/125 );
				
						mc._visible=false;
				break;
				
				case "digg":
				
					box=mc.getBounds(mc);
					mc.icon=gfx.add_clip(mc,"icon_digg", null, box.xMin, box.yMin, 100*(box.xMax-box.xMin)/16, 100*(box.yMax-box.yMin)/16 );
				
						mc._visible=false;
				break;
				
				case "stumble":
				
					box=mc.getBounds(mc);
					mc.icon=gfx.add_clip(mc,"icon_stumble", null, box.xMin, box.yMin, 100*(box.xMax-box.xMin)/16, 100*(box.yMax-box.yMin)/16 );
				
						mc._visible=false;
				break;
				
				case "shop":
						mc._visible=false;
				break;

				default :
					if(nams[1]=="over") //hide overlays at start
					{
						mc._visible=false;
					}
				break
			}
		}
		
		if(play.gameskill=="hard")
		{
			up.mcs["hard"]._visible=true;
			up.mcs["easy"]._visible=false;
		}
		else
		{
			up.mcs["hard"]._visible=false;
			up.mcs["easy"]._visible=true;
		}
		
		switch (up.state)
		{
			case "end1_all" :
				up.talky_display("FREEEEDOM!!!");
			break;
			case "end2_all" :
				up.talky_display("uhm?");
			break;
			case "end3_all" :
				up.talky_display("HELP!!!");
			break;

			case "levels_all" :

				_root.signals.signal("#(VERSION_NAME)","set",this);
						
				if(play.gameskill=="easy")
				{
					if(!play.scores_easy_flag)
					{
						get_last();
					}
				}
				else // hard
				{
					if(!play.scores_hard_flag)
					{
						get_last();
					}
				}
				
				thunk_scores();
				
			break;
			
			case "zoo_all" : // get last 10 scores so we can build a full score at the end of each level even in story mode
			
				play.gameskill="easy";
				get_last();
				
			break;

		}
	}
	
var last_id=0;
var last_type;

	function get_last()
	{
//dbg.print("+playget_high");

		_root.signals.signal("#(VERSION_NAME)","set",this);
				
		last_id++;
		last_type=play.gameskill;
//dbg.print("tpe:"+last_type);
		
		_root.comms.get_high("last","global",delegate(got_last,last_id));
	}
	
	function got_last(a,tid)
	{
	var i;
	var l;
	
//dbg.print("+playgot_high");

		if(tid==last_id) // only act on most recent request
		{
		
			for(i=0;i<10;i++)
			{
//dbg.print(a[i]);

				a[i]=a[i].split(";"); // turn strings into array
				a[i][0]=Math.floor(a[i][0]);
				a[i][2]=Math.floor(a[i][2]);
			}
		
			if(last_type=="easy")
			{
				play.scores_easy=a;
				play.scores_easy_flag=true;
			}
			else // hard
			{
				play.scores_hard=a;
				play.scores_hard_flag=true;
			}
			
			thunk_scores();
		}
	}
	
	function thunk_scores()
	{
	var a;
	var aa;
	var i,j;
	var s;
	var m;
	var l;
	
		if(up.state!="levels_all") { return; } // thunk scores may also get called in zoo mode which is special
		
		
	
		if(play.gameskill=="easy")
		{
			a=play.scores_easy;
		}
		else // hard
		{
			a=play.scores_hard;
		}
						
		for(i=0;i<10;i++)
		{
			s=alt.Sprintf.format("level%02d",i+1);
			m=up.mcs[s];
			l=up.up.levels[i+1];
			
			aa=null;
			for(j=0;j<10;j++)
			{
				if(a[j][2]==l.game_seed)
				{
					aa=a[j];
					break;
				}
			}
			if(aa) // got some data
			{
				gfx.set_text_html(m.score,14,0xffffff,"<p align=\"center\">"+aa[0]+"</p>");
			}
			else
			{
				gfx.set_text_html(m.score,14,0xffffff,"<p align=\"center\">"+"0"+"</p>");
			}
		}
		
		
	}

	
	function do_this(me,act)
	{
		if(this["do_"+me.nam])
		{
			this["do_"+me.nam](me,act);
		}
		else
		if(this[ "do_"+me.nams[0]+"_"+me.nams[1] ])
		{
			this[ "do_"+me.nams[0]+"_"+me.nams[1] ](me,act);
		}
		else
		if(this[ "do_"+me.nams[0] ])
		{
			this[ "do_"+me.nams[0] ](me,act);
		}
		else
		if(this[ "do_"+me.nams[1] ])
		{
			this[ "do_"+me.nams[1] ](me,act);
		}
		else
		{
			do_def(me,act);
		}
	}
	
	function nam_to_level(nam)
	{
	var level=null;
	
		switch(nam)
		{
			case "level10": level=10; break;
			case "level09": level=9; break;
			case "level08": level=8; break;
			case "level07": level=7; break;
			case "level06": level=6; break;
			case "level05": level=5; break;
			case "level04": level=4; break;
			case "level03": level=3; break;
			case "level02": level=2; break;
			case "level01": level=1; break;
		}
		
		return level;
	}
	
	function butt_over(nam,me,act)
	{
	var level=nam_to_level(nam);
	var l;
	
		do_over(me,act);
		
		switch(act)
		{
			case "click":
			
				do_under(me,"off");
				_root.poker.ShowFloat(null,0);
				
				if(level!=null)
				{
					up.up.level_idx=level;
					up.up.state_next="play";
					play.gamemode="race";
					play.clean_snapbmp();
					_root.poker.ShowFloat(null,0);
				}
				switch(nam)
				{
					case "minion":
						up.up.tard_idx++;
						if(up.up.tard_idx>=up.up.tards.length) { up.up.tard_idx=1; }
						minions[0].setsoul(up.up.tards[up.up.tard_idx].img1);
						_root.poker.ShowFloat("<b>"+up.up.tards[up.up.tard_idx].name+"</b><br>Click to change your player avatar.",25*10);
					break;
				
					case "easy":
					case "hard":
						me.filters=false;
						
						if(play.gameskill=="easy") { play.gameskill="hard"; }
						else
						if(play.gameskill=="hard") { play.gameskill="easy"; }
						
						update_display();
						
						_root.signals.signal("#(VERSION_NAME)","set",this);

						update_display();


					break;
					
					case "mainmenu":
						up.state_next="title_all";
						
						if(up.up.swish) { up.up.swish.clean(); up.up.swish=null; }
						up.up.swish=new Swish({style:"sqr_plode",mc:up.mc});
						
					break;
					
					case "story":
//						up.state_next="end1_all";
						up.up.state_next="zoo";
					break;
					
					case "race":
						up.state_next="levels_all";

						if(up.up.swish) { up.up.swish.clean(); up.up.swish=null; }
						up.up.swish=new Swish({style:"sqr_slide",mc:up.mc});
					break;
					
					case "scores":
//						up.up.high.setup();
					break;
					
					case "about":
						up.up.about.setup();
					break;
					
					case "code":
						up.up.code.setup();
					break;
						
					case "shop":
						getURL("http://link.wetgenes.com/link/WetBaseMent.shop","_blank");
					break;
					
					case "wetgenes":
						getURL("http://www.wetgenes.com/","_blank");
					break;
					
					case "floater_start":
						up.up.up.level_idx=1;
						up.up.up.state_next="play";
						play.clean_snapbmp();
						play.gameskill="easy"; // force easy mode in story mode
						play.gamemode="story";
						_root.poker.ShowFloat(null,0);
					break;
					
					case "whore":
						if(_root.wonderfulls[0].url)
						{
							getURL(_root.wonderfulls[0].url,"_blank");
						}
					break;
					
					case "digg":
						getURL("http://digg.com/submit?phase=2&url=basement.wetgenes.com&title=WetBasement:+A+water+filled+platform+game+extravaganza!&bodytext=WetBasement:+A+water+filled+platform+game+extravaganza!&topic=playable_web_games","_blank");
					break;
					
					case "stumble":
						getURL("http://www.stumbleupon.com/submit?url=http://basement.wetgenes.com&title=WetBasement:+A+water+filled+platform+game+extravaganza!","_blank");
					break;
				}
				
			break;
			
			case "on":
				if(level!=null)
				{
					l=up.up.levels[level];
					_root.poker.ShowFloat("Play level "+level+"<br>"+l.name,250);
					gfx.glow( me , 0xffffff, .8, 16, 16, 1, 3, false, false );
				}
				switch(nam)
				{
					case "minion":
						_root.poker.ShowFloat("<b>"+up.up.tards[up.up.tard_idx].name+"</b><br>Click to change your avatar.",25*10);
						gfx.glow( me , 0xffffff, .8, 16, 16, 1, 3, false, false );
					break;
					
					case "easy":
						_root.poker.ShowFloat("<b>Easy</b> mode selected.<br>Click to toggle.",250);
						gfx.glow( me , 0xffffff, .8, 16, 16, 1, 3, false, false );
					break;
					
					case "hard":
						_root.poker.ShowFloat("<b>Hard</b> mode selected.<br>Click to toggle.",250);
						gfx.glow( me , 0xffffff, .8, 16, 16, 1, 3, false, false );
					break;
					
					case "mainmenu":
						_root.poker.ShowFloat("Return to the main menu.",250);
						gfx.glow( me , 0xffffff, .8, 16, 16, 1, 3, false, false );
					break;
					
					case "story":
						anim_over="story";
						_root.poker.ShowFloat("Play through each level one after the other in a sequential experience that some may call a story.",250);
					break;
					
					case "race":
						anim_over="race";
						_root.poker.ShowFloat("Race to finish each level with the highest score. A new challenge every day.",250);
					break;
					
					case "scores":
						_root.poker.ShowFloat("Show me the weaners.",250);
					break;
					
					case "about":
						_root.poker.ShowFloat("Did you know this game was made by real people?",250);
					break;
					
					case "code":
						_root.poker.ShowFloat("Get the code to place this game on your blog profile or website.",250);
					break;
						
					case "shop":
						_root.poker.ShowFloat("Because you love us and we love you, all night long baby.",250);
					break;
					
					case "wetgenes":
						_root.poker.ShowFloat("Visit the site that gave birth to this game.",250);
					break;
					
					case "ignoreme":
						_root.poker.ShowFloat("IGNORE ME!.",250);
					break;
					
					case "floater_start":
						_root.poker.ShowFloat("Click start to start.",250);
					break;
					
					case "whore":
						var ass="<font size='10'>These people are helping to keep this game online:<br></font>";
						if(_root.wonderfulls[0].txt)
						{
							ass+=_root.wonderfulls[0].txt;
						}
						_root.poker.ShowFloat(ass,250);
					break;
					
					case "digg":
						_root.poker.ShowFloat("If you like this game, please tell your friends on Digg!",250);
					break;
					
					case "stumble":
						_root.poker.ShowFloat("If you like this game, please tell your friends on StumbleUpon!",250);
					break;
				}
			break;
			
			case "off":
				_root.poker.ShowFloat(null,0);
				if(level!=null)
				{
					me.filters=null;
				}
				switch(nam)
				{
					case "easy":
					case "hard":
					case "mainmenu":
					case "minion":
						me.filters=null;
					break;
					case "story":
						anim_over=null;
					break;
					case "race":
						anim_over=null;
					break;
				}
			break;
			
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_story(me,act)
	{
		butt_over("story",me,act);
	}
	function do_race(me,act)
	{
		butt_over("race",me,act);
	}
	function do_scores(me,act)
	{
		butt_over("scores",me,act);
	}
	function do_about(me,act)
	{
		butt_over("about",me,act);
	}
	function do_code(me,act)
	{
		butt_over("code",me,act);
	}
	function do_wetgenes(me,act)
	{
		butt_over("wetgenes",me,act);
	}
	function do_shop(me,act)
	{
		butt_over("shop",me,act);
	}
	function do_mainmenu(me,act)
	{
		butt_over("mainmenu",me,act);
	}
	function do_easy(me,act)
	{
		butt_over("easy",me,act);
	}
	function do_hard(me,act)
	{
		butt_over("hard",me,act);
	}
	function do_minion(me,act)
	{
		butt_over("minion",me,act);
	}
	function do_ignoreme(me,act)
	{
		butt_over("ignoreme",me,act);
	}
	function do_whore(me,act)
	{
		butt_over("whore",me,act);
	}
	function do_digg(me,act)
	{
		butt_over("digg",me,act);
	}
	function do_stumble(me,act)
	{
		butt_over("stumble",me,act);
	}

	
	function do_level10(me,act)
	{
		butt_over("level10",me,act);
	}
	function do_level09(me,act)
	{
		butt_over("level09",me,act);
	}
	function do_level08(me,act)
	{
		butt_over("level08",me,act);
	}
	function do_level07(me,act)
	{
		butt_over("level07",me,act);
	}
	function do_level06(me,act)
	{
		butt_over("level06",me,act);
	}
	function do_level05(me,act)
	{
		butt_over("level05",me,act);
	}
	function do_level04(me,act)
	{
		butt_over("level04",me,act);
	}
	function do_level03(me,act)
	{
		butt_over("level03",me,act);
	}
	function do_level02(me,act)
	{
		butt_over("level02",me,act);
	}
	function do_level01(me,act)
	{
		butt_over("level01",me,act);
	}
	function do_floater_start(me,act)
	{
		butt_over("floater_start",me,act);
	}
	
	function do_under(me,act)
	{
		switch(act)
		{
			case "on":
				up.mcs[me.nams[0]+"_under"]._visible=false;
				up.mcs[me.nams[0]+"_over"]._visible=true;
			break;
			case "off":
				up.mcs[me.nams[0]+"_under"]._visible=true;
				up.mcs[me.nams[0]+"_over"]._visible=false;
			break;
		}
	}
	function do_over(me,act)
	{
		switch(act)
		{
			case "on":
				up.mcs[me.nams[0]+"_under"]._visible=false;
				up.mcs[me.nams[0]+"_over"]._visible=true;
			break;
			case "off":
				up.mcs[me.nams[0]+"_under"]._visible=true;
				up.mcs[me.nams[0]+"_over"]._visible=false;
			break;
		}
	}
	
	function do_def(me,act)
	{
		switch(act)
		{
			case "on":
//				_root.poker.ShowFloat(me.nam,25*10);
			break;
			case "off":
				_root.poker.ShowFloat(null,0);
			break;
			case "click":
				switch (up.state)
				{
					case "end1_all" :
						up.state_next="end2_all";
					break;
					case "end2_all" :
						up.state_next="end3_all";
					break;
					case "end3_all" :
						up.state_next="title_all";
					break;
				}
			break;
		}
	}
	
}
