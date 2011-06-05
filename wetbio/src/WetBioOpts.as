/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


import com.Sprintf;
import com.dynamicflash.utils.Delegate;

import com.bunchball.Api;


class WetBioOpts
{
	static var VERSION:Number=5;
	
	var wetbio:WetBio;
	var mc:MovieClip;
	
	var theme_str:String='pastelblue';
	
	var date_ms:Number; // birthddate in ms
	var date_str:String="1/1/1970";
	var date_tf;
	
	var title_str:String="My biorhythms reading for today.";
	var title_tf;

	var main_tf:TextField;

	var display_day		:Number;	// (days since birth) left most edge of graph +7 for today
	var birth_day		:Number;	//  days from 1st jan 1970
	var to_day			:Number;	//  days from 1st jan 1970

	var day_str=new Array('Sun',"Mon",'Tue','Wed','Thu','Fri','Sat');
	var numth_str=new Array('1st','2nd','3rd','4th','5th','6th','7th','8th','9th','10th','11th','12th','13th','14th','15th','16th','17th','18th','19th','20th','21st','22nd','23rd','24th','25th','26th','27th','28th','29th','30th','31st');
	var month_str=new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");

	function getdaystr(date)
	{
		return day_str[date.getDay()] + ' ' + numth_str[date.getDate()-1] + ' ' + month_str[date.getMonth()] + ' ' + date.getFullYear();
	}
	
	function delegate(f:Function,d) { return Delegate.create(this,f,d); }


	function check_root()
	{
// pull in settings
		if(_root.birth)		{	date_str=_root.birth;	}
		if(_root.title)		{	title_str=_root.title;	}
		if(_root.theme)		{	theme_str=_root.theme;	}
	}

	function WetBioOpts(_wetbio)
	{
		check_root();

		wetbio=_wetbio;
		setup();
		clean();

#if VERSION_SITE=='bunchball' then
		bb=new com.bunchball.Api;
		bb.call("getDetails", delegate(got_details,null));
#end

	}

#if VERSION_SITE=='bunchball' then

	var bb:com.bunchball.Api;
	var details:Object;


	function got_details(_success:Boolean, _details:Object)
	{
		if(_success)
		{
		trace("success");
			details = _details;
			
			go_get_data();
		}
		else
		{
		trace("fail");
			details = null;
		}
		
	}

	function go_get_data() 
	{
		var d:Array=new Array();
		
		d.global=false;
		d.write=false;
		bb.call("loadStatic", d.write, d.global, delegate(got_data,d));
	}
	
	function go_set_data() 
	{
		var d:Array=new Array();
		
		d.global=false;
		d.write=true;
		bb.call("loadStatic", d.write, d.global, delegate(got_data,d));
	}

	function got_data(_success:Boolean, _chunk_info:Object, f:Function, d:Array )
	{
		var added_score:Boolean=false;
		var date:Date=new Date();
		
		trace("write="+d.write);
		trace("global="+d.global);
		
		if(_success)
		{
		trace("success");
			d.chunk_info=_chunk_info;
			d.chunk=d.chunk_info.static_obj;
		}
		else
		{
		trace("fail");
			d.chunk_info = null;
			d.chunk = null;
		}
		
		if( (typeof(d.chunk)!='object') || (d.chunk.version!=VERSION) ) // build all new, things are broken
		{
			d.chunk=new Object;
			d.chunk.version=VERSION;	// sanity

// set default data
			d.chunk.title_str="My biorhythms reading for today.";
			d.chunk.birth_str="1/1/1970";
			d.chunk.theme_str="pastelblue";
			
		}

// read data from chunk and fill vars with it or write data to chunk

		if(d.write==false)
		{
			title_str=d.chunk.title_str;
			date_str=d.chunk.birth_str;
			theme_str=d.chunk.theme_str;
		}
		else
		{
			d.chunk.title_str=title_str;
			d.chunk.birth_str=date_str;
			d.chunk.theme_str=theme_str;
			bb.call("saveStatic", d.chunk, d.global, d.chunk_info.key_str, delegate(done_data,d));
		}

		_root.wetbio.view.clean();
		_root.wetbio.view.setup();

// reset everything we can see

	}
	
	function done_data()
	{
	}

#else

// stub
	function go_set_data() 
	{
	}

#end

		
// on entering this state
	function setup()
	{
		display_day=0;
		birth_day=0;
		to_day=0;
		
		if(mc)	// rebuild main movieclip
		{
			mc.removeMovieClip();
			mc=null;
		}
		mc=gfx.create_clip(wetbio.view.mc,null);
		mc._x=-600;
		mc.t=this;
		mc._visible=true;
		
		var tf;
		var s;


		mc.style=wetbio.view.styles.box_options;
		tf=gfx.create_rounded_text_button(mc,null,600-8*10,0,8*10,26);
		tf._y+=3;
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"14\" color=\"#"+Sprintf.format("%06x",mc.style.text&0xffffff)+"\">";
		s+="<p align=\"center\">";
		s+="<a href=\"asfunction:_root."+_root.click_name+",view\"><b>";
		s+="Back</b></a></p>";
		s+="</font>";
		tf.htmlText=s;
		
		mc.style=wetbio.view.styles.box_options;
		tf=gfx.create_rounded_text_button(mc,null,0,0,600-80,26);
		tf._y+=3;
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"14\" color=\"#"+Sprintf.format("%06x",mc.style.text&0xffffff)+"\">";
		s+="<p align=\"center\">";
		s+="Anyone can edit these options but only the owner can save them.</p>";
		s+="</font>";
		tf.htmlText=s;
		
		mc.style=wetbio.view.styles.box_options;
		tf=gfx.create_rounded_text_button(mc,null,0,24,600,200-24);
		tf._x+=7;
		tf._width-=14;
		tf._y+=6+3;
		main_tf=tf;
		rewrite_text();

		wetbio.view.fmt.size=13;
		wetbio.view.fmt.color=0x000000;
		wetbio.view.fmt.bold=false;

		mc.style=wetbio.view.styles.box_input;
		tf=gfx.create_rounded_text_button(mc,null,230+40,32,100,24);
		tf._x+=7;
		tf._width-=14;
		tf._y+=2;

		tf.html=false;
		tf.multiline=false;

		tf.text=date_str;

		tf.restrict="0123456789/";
		tf.maxChars=10;
		tf.setTextFormat(wetbio.view.fmt);
		tf.type="input";
		tf.selectable=true;
		tf.onKillFocus=delegate(onKillFocus);
		tf.onSetFocus = function() {	var ci = Selection.getCaretIndex();	Selection.setFocus(this);
		Selection.setSelection(0,0);	Selection.setSelection(ci,ci);		}
		date_tf=tf;
		
		mc.style=wetbio.view.styles.box_input;
		tf=gfx.create_rounded_text_button(mc,null,80,38+52,600-160,24);
		tf._x+=7;
		tf._width-=14;
		tf._y+=2;
		
		tf.html=false;
		tf.multiline=false;

		tf.text=title_str;

		tf.restrict=" 0123456789ABCDEFGHIJKLMNOPRSTUVWXYZabcdefghijklmnopqrstuvwxyz!.,:;'@#$%^&*()";
		tf.maxChars=64;
		tf.setTextFormat(wetbio.view.fmt);
		tf.type="input";
		tf.selectable=true;
		tf.onKillFocus=delegate(onKillFocus);
		tf.onSetFocus = function() {	var ci = Selection.getCaretIndex();	Selection.setFocus(this);
		Selection.setSelection(0,0);	Selection.setSelection(ci,ci);		}
		title_tf=tf;
	}
	
	function rewrite_text()
	{
		var s;
		
// build birthdate
		var a:Array=date_str.split('/');
		
#if	DATEFMT=='MM/DD/YYYY' then

		a['mm']=Number(a[0]);
		a['dd']=Number(a[1]);
		a['yyyy']=Number(a[2]);
		
#else

		a['dd']=Number(a[0]);
		a['mm']=Number(a[1]);
		a['yyyy']=Number(a[2]);
		
#end
		var birth:Date=new Date(a['yyyy'],a['mm']-1,a['dd']);
		var today:Date=new Date();
		var today_ms:Number;
		
		
		date_ms=birth.getTime();
		today_ms=1000*60*60*24*Math.floor(today.getTime()/(1000*60*60*24));
		
		to_day=Math.floor(today_ms/(1000*60*60*24));
		birth_day=Math.floor(date_ms/(1000*60*60*24));
		display_day=(to_day-birth_day)-7;

		mc.style=wetbio.view.styles.box_options;

		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"15\" color=\"#"+Sprintf.format("%06x",mc.style.text&0xffffff)+"\">";

		s+="Enter your bithdate: "+"#(DATEFMT)"+" ";
		s+="                      " + getdaystr(birth);
		s+="<br><br>";
		s+="Enter the text you want to see in the main title bar below: <br>"
		s+="<br>";
		s+="<br>";
		s+="Right click to bring up a list of themes, choose one and it will be applied instantly. <br>"
		s+="<br>";
		
#if VERSION_SITE=='bunchball' then
		if( (typeof(details.creator_str)=='string') && (details.userName_str.toLowerCase() == details.creator_str.toLowerCase()) )
		{
			s+="<a href=\"asfunction:_root."+_root.click_name+",save\"><b>";
			s+="Click here to save all these settings.</b></a> <br>"
		}
		else
#end
		{
			s+="Visit ";
			s+="<a target=\"_top\" href=\"http://www.wetgenes.com/biorhythm\"><b>";
			s+="www.WetGenes.com</b></a> ";
			s+="to find out how to set up your own.";
		}
		
		s+="</font>";
		main_tf.htmlText=s;
	}
	
	function  onKillFocus()	// grab text then rebuild us..
	{
		date_str=date_tf.text;
		title_str=title_tf.text;
		
		rewrite_text();
		wetbio.view.curve.rewrite_text();
	}


// every frame while in this state
	function update()
	{
	}

// on leaving this state
	function clean()
	{
		mc._visible=false;
	}

}


