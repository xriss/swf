/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.Sprintf;

class WetBioAbout
{
	var wetbio:WetBio;
	var mc:MovieClip;


	function WetBioAbout(_wetbio)
	{
		wetbio=_wetbio;
		setup();
		clean();
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
		mc._x=600;
		mc._visible=true;
		
		var tf;
		var s;
		
		mc.style=wetbio.view.styles.box_about;
		tf=gfx.create_rounded_text_button(mc,null,0,0,8*10,26);
		tf._y+=3;
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"14\" color=\"#"+Sprintf.format("%06x",mc.style.text&0xffffff)+"\">";
		s+="<p align=\"center\"><a href=\"asfunction:_root."+_root.click_name+",view\"><b>";
		s+="Back</b></a></p>";
		s+="</font>";
		tf.htmlText=s;
		
		mc.style=wetbio.view.styles.box_about;
		tf=gfx.create_rounded_text_button(mc,null,80,0,600-80,26);
		tf._y+=3;
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"14\" color=\"#"+Sprintf.format("%06x",mc.style.text&0xffffff)+"\">";
		s+="<p align=\"center\">";
		s+="<a target=\"_top\" href=\"http://www.wetgenes.com/biorhythm\"><b>";
		s+="#(VERSION_NAME)</b></a>";
		s+=" V#(VERSION_NUMBER) #(VERSION_SITE) (c) "
		s+="<a target=\"_top\" href=\"http://xixs.com\"><b>";
		s+="Kriss Daniels</b></a> "; 
		s+="#(VERSION_STAMP).</p>";
		s+="</font>";
		tf.htmlText=s;
		

		mc.style=wetbio.view.styles.box_about;
		tf=gfx.create_rounded_text_button(mc,null,0,24,600,200-24);
		tf._x+=7;
		tf._width-=14;
		tf._y+=3+6;
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"16\" color=\"#"+Sprintf.format("%06x",mc.style.text&0xffffff)+"\">";

		s+="This is of course all lies, however, if I rotate my chaos magicians hat to just the right "
		s+="angle I find I believe in it perfectly and am therefore qualified to sell it to you. ";
		s+="I can also assure you that any mistakes are fully intentional as my hand is guided ";
		s+="perfectly by the goddess.<br> ";
		s+="<br>";
		s+="This toy is intended to be personalised and embed in your site, <br>blog, profile, page or myspace. Visit ";
		s+="<a target=\"_top\" href=\"http://www.wetgenes.com/biorhythm\"><b>";
		s+="www.WetGenes.com</b></a> <br>";
		s+="to find out how to set up your own.";
		s+="</font>";
		tf.htmlText=s;

		tf=gfx.create_rounded_text_button(mc,null,0,24,600,200-24);

		var me=gfx.add_clip(mc,"kriss",null);
		
		me._x=600-85;
		me._y=200-102;
//

		
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


