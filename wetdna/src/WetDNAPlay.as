/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;
import com.wetgenes.wetDNA;


class WetDNAPlay
{
	var up;
	var mc;
	var mc2;
	var tf;
	var dna;
	var back;
	
	var fade;

	function WetDNAPlay(_up)
	{
		up=_up;
	}
	
	function update()
	{
		fade-=1;
		if(fade<0) { fade=0; }
		
		back._alpha=25+(fade*0.75);
		
		tf._alpha=100-fade;
		dna.mc._alpha=tf._alpha;
	}

	function setup()
	{
	var s;
	
		fade=100;
	
		mc=gfx.create_clip(up.mc,null);

		back=gfx.add_clip(mc,'back',null);
		back._xscale=100*800/468;
		back._yscale=100*300/175;

		mc2=gfx.create_clip(mc,null);
		
		dna=new wetDNA(mc2,'dna'+(++mc2.newdepth),++mc2.newdepth,0x0000ff);
		
		dna.mc._x=400;
		dna.mc._y=150;
		dna.mc._xscale=100*760/512;
		dna.mc._yscale=100*260/256;
		
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"66\" color=\"#0040ff\">";
		s+="<p align=\"center\">";
		s+="<b>www.WetGenes.com</b>";
		s+="</p>";
		s+="</font>";
		tf=gfx.create_text_html(mc2,null,0,150-65,800,50);
		tf.htmlText=s;
		tf._yscale=150;
		tf._alpha=0;

	    mc2.filters = [ new flash.filters.GlowFilter(0x0020ff, 1, 20, 20, 2, 3) ];
		
		
//		mc.style= {			fill:0xffffffff,	out:0xffffffff,	text:0xffffffff		};
//		gfx.draw_box(mc,10,100,100,100,100);

	}

	function clean()
	{
	
		dna.removeMC();
		dna=null;
		
		mc.removeMovieClip();
		mc=null;
	}

}


