/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.Sprintf;

class WetBioCurve
{
	var wetbio:WetBio;
	var mc:MovieClip;
	var mco:MovieClip;
	var mcp:MovieClip;


	var title_tf:TextField;

	var sel_time:Number;
	var sel:Number;
	var sleep:Boolean;
	
	var days:Array;

//good to bad 0-3
	var emo0:Array=[
	"Consider starting a new relationship with a homeless man.",
	"Quit everything and become an apprentice nomad.",
	"Teach the world to blink in perfect harmony.",
	"Hug a stranger, preferably one with red shoes and red hair.",
	"Time to learn to play that musical instrument you always wanted to."];
	var emo1:Array=[
	"Do not risk talking to tall dark strangers.",
	"Remember, any day can be your birthday if you want it to.",
	"No, they are not laughing at you. They are laughing at your imaginary friend.",
	"Do not sign any papers today unless they are glowing.",
	"Remember, any day can be surprise april fools day."];
	var emo2:Array=[
	"Don't worry it is the other person who is in the wrong.",
	"Never play leapfrog with a unicorn unless wearing a nazi helmet and they go first.",
	"Your local chinese takeaway does not remember you today, order italian.",
	"When out of snacks, wail loudly until you are brought some.",
	"Sing your happy song to yourself all day, but don't let anyone else join in."];
	var emo3:Array=[
	"You should discuss your current feelings with your mother.",
	"Nobody wants to hear about the voices in your head, but they do.",
	"When the elevator will not close, remove the one closest to you.",
	"Be suspicious of sweets when offered unexpectedly.",
	"Just spend today under the covers and don't answer the phone."];

	var phy0:Array=[
	"When standing in gutter avoid flushing.",
	"The tooth fairy pwns you. and the rest of your family tree as long as you're in it.",
	"Open a door for a stranger and demand to be paid for it.",
	"Start a breakdancing crew and allocate a pawn in different area codes to greet you with secret handshakes.",
	"Do not attempt to lick your own elbow, always go for the nipples."];
	var phy1:Array=[
	"Remember your glass is half full, except when its someone elses round.",
	"Always speak with your mouth open and close instantaneously as if mimicking words.",
	"Skip every third step you take and you'll reach your destination faster and sillier.",
	"Shave one eyebrow and take the entire day to decide if the other needs shaving too.",
	"Anyone who goes to a psychiatrist ought to have their head examined."];
	var phy2:Array=[
	"Never, ever, mistreat your pookah.",
	"Live a little. Buy a whole pig and roast it on a spit.",
	"Peanut butter and tuna do not go together, on a Monday.",
	"Do not attempt 3 cartwheels if you are only able to do 1.",
	"Sometimes it is better to lose than to get caught."];
	var phy3:Array=[
	"Today is a good day to call in sick or to turn up late with an implausable excuse.",
	"Cancel that gym membership NOW.",
	"Buy as many comic books and learn the ways of the superhero.",
	"Only buy paperbacks unless you want a heavy bag.",
	"Remember, king kong died for your sins."];
	
	var int0:Array=[
	"Start a small buisness and con your friends into paying you.",
	"Your intelligence has doubled after reading this.",
	"Everyone will believe anything you tell them today. Even you.",
	"When receiving change, decline politely and tell them you do not accept charity.",
	"Don't bother with crosswords or any other puzzles unless you have a pencil."];
	var int1:Array=[
	"Action may not always be happiness, but there is no happiness without action.",
	"Ignorance is bliss unless it is a blister.",
	"A piece of the pie is useless if you can't finish all of it.",
	"Money may not buy you happiness but this fortune is free.",
	"A drunk mans' words are a sober mans' thoughts, so drink before you think."];
	var int2:Array=[
	"You have too many fiends, remove one at random.",
	"Keep your friends close and your enemies on the phone.",
	"When unsure, ask until they are more confused.",
	"Today is the first day to the rest of your life.",
	"Give a stranger something random and useless as penance for that thought."];
	var int3:Array=[
	"Send me one dollar and you will feel happy for the rest of the day.",
	"If you are still reading this, you should study WetGenes for more enlightenment.",
	"There is no ham in hamburger.",
	"Learn German and it will save your life.",
	"Send me two dollar and you will feel happy for the rest of the week."];

	function WetBioCurve(_wetbio)
	{
		sel_time=0;
		wetbio=_wetbio;
		setup();
		clean();
	}

// ser
	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n; rnd(); rnd(); rnd(); rnd(); rnd(); }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num*75) % 65537)-1)&0xffff; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}

		
// on entering this state
	function setup()
	{
		if(mc)	// rebuild main movieclip
		{
			mc.removeMovieClip();
			mc=null;
		}
		mc=gfx.create_clip(wetbio.view.mc,null);
		mc.t=this;
		mc._x=0;
		mc._visible=true;
		
		var tf;
		var s;

		mc.style=wetbio.view.styles.box_options;
		tf=gfx.create_rounded_text_button(mc,null,0,0,8*10,26);
		tf._y+=3;
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"14\" color=\"#"+Sprintf.format("%06x",mc.style.text&0xffffff)+"\">";
		s+="<p align=\"center\">";
		s+="<a href=\"asfunction:_root."+_root.click_name+",options\"><b>";
		s+="Options</b></a></p>";
		s+="</font>";
		tf.htmlText=s;
		
		mc.style=wetbio.view.styles.box_about;
		tf=gfx.create_rounded_text_button(mc,null,600-8*10,0,8*10,26);
		tf._y+=3;
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"14\" color=\"#"+Sprintf.format("%06x",mc.style.text&0xffffff)+"\">";
		s+="<p align=\"center\">";
		s+="<a href=\"asfunction:_root."+_root.click_name+",about\"><b>";
		s+="About</b></a></p>";
		s+="</font>";
		tf.htmlText=s;
		
		mc.style=wetbio.view.styles.box_title;
		tf=gfx.create_rounded_text_button(mc,null,8*10,0,600-160,26);
		tf._y+=3;
		title_tf=tf;
		rewrite_text();
		
		
		mc.style=wetbio.view.styles.box_view;
		gfx.draw_rounded_rectangle(mc,3,24,2,0,24,600,200-24)
		

		days=new Array();
		for( var i=0; i<32 ; i++)
		{
			days[i]=new WetBioDay(wetbio,mc);
			days[i].x=i*20;
			days[i].y=30;
			days[i].w=20;
			days[i].wf=20;
			days[i].h=164;
			days[i].d=i;
			days[i].setup();
		}

		mco=gfx.create_clip(mc,null);
		mcp=gfx.create_clip(mc,null);

		mcp.clear();
		mcp.style=wetbio.view.styles.box_pop;
		gfx.draw_rounded_rectangle(mcp,3,3,4,0,0,255,130)
		mcp.tf=gfx.create_text_html(mcp,null,4,4,255-8,130-8);


		Mouse.addListener(this);
		sleep=false;
	}

	function onMouseMove()
	{
		sleep=false;
		if(mc._ymouse<24)
		{
			sel=7;
			sel_time=0;
		}
		else
		{
			sel=Math.floor(mc._xmouse/22);
			if(sel<0) { sel=0; }
			if(sel>26) { sel=26; }
			sel_time=10*30; // snap to today after 30 secs
		}
	}

	function rewrite_text()
	{
		var s;
		
		mc.style=wetbio.view.styles.box_title;

		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"14\" color=\"#"+Sprintf.format("%06x",mc.style.text&0xffffff)+"\">";
		s+="<p align=\"center\">";
		s+=wetbio.view.opts.title_str + "</p>";
		s+="</font>";
		title_tf.htmlText=s;
	}

// every frame while in this state
	function update()
	{
		var s;
		var goto_sleep=true;

		if(sel_time>0)
		{
			sel_time--;
		}
		else
		{
			if(sel!=7)
			{
				sleep=false;
				sel=7;	// focus on today
			}
		}
		
		if(sleep==false)
		{
			var i,ww;
			for(  i=0; i<32 ; i++)
			{
				days[i].w_dest=20;
/*
				if((i&1)==0)
				{
					days[i].a_dest=100;
				}
				else
				{
					days[i].a_dest=100;
				}
*/
			}
			days[sel].w_dest=80;
//			days[sel].a_dest=100;
			
			ww=0;
			for( i=0; i<32 ; i++)
			{
//				days[i].mc._alpha= days[i].mc._alpha + ((days[i].a_dest-days[i].mc._alpha)/8) ;	// tween
//				if(Math.abs(days[i].mc._alpha-days[i].a_dest) < 1) { days[i].mc._alpha=days[i].a_dest; }	// snap
			
				days[i].wf= days[i].wf + ((days[i].w_dest-days[i].wf)/8) ;	// tween
				if(Math.abs(days[i].wf-days[i].w_dest) < 1) { days[i].wf=days[i].w_dest; }	// snap
				else { goto_sleep=false; }

				days[i].w=Math.floor(days[i].wf);
				days[i].w=days[i].wf;
				days[i].x=ww;
				days[i].h=164;
				days[i].y=30;
				days[i].d=wetbio.view.opts.display_day+i;
				days[i].update();
				ww+=days[i].w;
			}

// highlight selected day			
			mco.clear();
			mco.style=wetbio.view.styles.box_sel;
			gfx.draw_rounded_rectangle(mco,3,3,4,days[sel].x,days[sel].y-2,days[sel].w,days[sel].h+4)

			for( i=0; i<32 ; i++)
			{
				if( ((i&1)==1) && (i!=sel) )
				{
					mco.style=wetbio.view.styles.darker;
					gfx.draw_box(mco,undefined,days[i].x,days[i].y,days[i].w,days[i].h)
				}
				else
				if( ((i&1)==0) && (i!=sel) )
				{
					mco.style=wetbio.view.styles.lighter;
					gfx.draw_box(mco,undefined,days[i].x,days[i].y,days[i].w,days[i].h)
				}
			}

			
			if(sel<14)
			{
				mcp._x=days[sel].x+days[sel].w;//Math.floor((days[sel].x+days[sel].w)/4)*4;
				mcp._y=47;
			}
			else
			{
				mcp._x=days[sel].x-255;//Math.floor((days[sel].x-255)/4)*4;
				mcp._y=47;
			}
			
			var date=new Date( (wetbio.view.opts.birth_day + wetbio.view.opts.display_day + sel)*1000*60*60*24 );
			mcp.style=wetbio.view.styles.box_pop;
			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"14\" color=\"#"+Sprintf.format("%06x",mcp.style.text&0xffffff)+"\">";
			s+="<p align=\"center\"><b>";
			s+='<font color="#'+Sprintf.format("%06x",wetbio.view.styles.box_pop_day.text&0xffffff)+'">'+wetbio.view.opts.getdaystr(date)+"</font><br>";
			
			var at=new Array();
			at[0]='an <font color="#'+Sprintf.format("%06x",wetbio.view.styles.box_pop_excelent.text&0xffffff)+'">Excellent</font>';
			at[1]='a <font color="#'+Sprintf.format("%06x",wetbio.view.styles.box_pop_good.text&0xffffff)+'">Good</font>';
			at[2]='an <font color="#'+Sprintf.format("%06x",wetbio.view.styles.box_pop_ok.text&0xffffff)+'">OK</font>';
			at[3]='a <font color="#'+Sprintf.format("%06x",wetbio.view.styles.box_pop_bad.text&0xffffff)+'">Bad</font>';
			
			if(days[sel].emotional>0.707)			{ s+="Is "+at[0]+" <font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_emo.text&0xffffff)+"\"> emotional</font>, "; }
			else if(days[sel].emotional>0.1)		{ s+="Is "+at[1]+" <font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_emo.text&0xffffff)+"\"> emotional</font>, "; }
			else if(days[sel].emotional>-0.707)		{ s+="Is "+at[2]+" <font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_emo.text&0xffffff)+"\"> emotional</font>, "; }
			else									{ s+="Is "+at[3]+" <font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_emo.text&0xffffff)+"\"> emotional</font>, "; }

			if(days[sel].physical>0.707)			{ s+=at[0]+" <font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_phy.text&0xffffff)+"\"> physical</font> and "; }
			else if(days[sel].physical>0.1)			{ s+=at[1]+" <font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_phy.text&0xffffff)+"\"> physical</font> and "; }
			else if(days[sel].physical>-0.707)		{ s+=at[2]+" <font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_phy.text&0xffffff)+"\"> physical</font> and "; }
			else									{ s+=at[3]+" <font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_phy.text&0xffffff)+"\"> physical</font> and "; }
			
			if(days[sel].intellectual>0.707)		{ s+=at[0]+" <font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_int.text&0xffffff)+"\"> intellectual</font> day.<br>"; }
			else if(days[sel].intellectual>0.1)		{ s+=at[1]+" <font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_int.text&0xffffff)+"\"> intellectual</font> day.<br>"; }
			else if(days[sel].intellectual>-0.707)	{ s+=at[2]+" <font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_int.text&0xffffff)+"\"> intellectual</font> day.<br>"; }
			else									{ s+=at[3]+" <font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_int.text&0xffffff)+"\"> intellectual</font> day.<br>"; }

			rnd_seed((wetbio.view.opts.display_day+sel));
			
			var hun=((wetbio.view.opts.display_day+sel)/100);
			if(hun==Math.floor(hun)) // its yer birfday
			{
				s+="<font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_int.text&0xffffff)+"\">";
				s+="Here is your birfday badge,<br>'I R " + hun + " hundred days old today.' wear it with pride.";
				s+="</font>";
				s+="</p></b></font>";
			}
			else
			{
				var as:Array=emo0;
			
				var r=rnd()%3;//(wetbio.view.opts.display_day+sel)%3;
				if(r==0)
				{
					if(days[sel].emotional>0.707)			{	as=emo0;	}
					else if(days[sel].emotional>0.1)		{	as=emo1;	}
					else if(days[sel].emotional>-0.707)		{	as=emo2;	}
					else 									{	as=emo3;	}
					
					s+="<font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_emo.text&0xffffff)+"\">";
				}
				else
				if(r==1)
				{
					if(days[sel].physical>0.707)			{	as=phy0;	}
					else if(days[sel].physical>0.1)			{	as=phy1;	}
					else if(days[sel].physical>-0.707)		{	as=phy2;	}
					else 									{	as=phy3;	}
					
					s+="<font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_phy.text&0xffffff)+"\">";
				}
				else
				if(r==2)
				{
					if(days[sel].intellectual>0.707)		{	as=int0;	}
					else if(days[sel].intellectual>0.1)		{	as=int1;	}
					else if(days[sel].intellectual>-0.707)	{	as=int2;	}
					else 									{	as=int3;	}
					
					s+="<font color=\"#"+Sprintf.format("%06x",wetbio.view.styles.box_pop_int.text&0xffffff)+"\">";
				}

				r=rnd()%(as.length);
				s+=as[r];
				
				s+="</font>";
				s+="</p></b></font>";
			}
				
			mcp.tf.htmlText=s;

			if(goto_sleep==true) // things have stoped moving
			{
				sleep=true;
			}
		}
	}

// on leaving this state
	function clean()
	{
		mc._visible=false;
	}


}


