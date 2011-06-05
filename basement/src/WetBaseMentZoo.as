/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class WetBaseMentZoo
{
	var up;
	
	
	var mc;
	
	var mc_levels;
	
	var mc_tard;
	var mc_skill;
	
//	var minion;
	
	var x2;
	var y2;
	var x2_min;
	var y2_min;
	var x2_max;
	var y2_max;
	
	var x3;
	var y3;
	var z3;
	var x3_min;
	var y3_min;
	var z3_min;
	var x3_max;
	var y3_max;
	var z3_max;
	
	var minion;
	var monkeysee;
	
	var tards;
	
	var frame;
	
	var back;
	
	var talky;
	
	var floatx,floaty;
//	var frame;
	
	
	function WetBaseMentZoo(_up)
	{
		up=_up;
	}
	
	function delegate(f,d1,d2)	{	return com.dynamicflash.utils.Delegate.create(this,f,d1,d2);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}



	
	

	function setup()
	{
	var i;
	var x,y;
	var nmc;
	
	
		floatx=0;
		floaty=0;
		frame=0;
	
		mc=gfx.create_clip(up.mc,null);
		
		back=new WetBaseMentTitle(this,"zoo_all",up.play);
//		back.state="zoo_all";
		back.setup();
//		gfx.add_clip(mc,"zooback");
		
//2d origin and bounds
		
		x2=25;
		y2=575;
		
		x2_min=0;
		y2_min=0;
		x2_max=800;
		y2_max=600;
		
//3d origin	and bounds

		x3=0;
		y3=0;
		z3=0;
		
		x3_min=0;
		y3_min=0;
		z3_min=0;
		
		x3_max=600;
		y3_max=600;
		z3_max=600;
		
		tards=new Array();
		
		for(i=1;i<up.tards.length;i++)
		{
			tards[i]=new Vtard3d(this);
			tards[i].setup(up.tards[i].img1);
			tards[i].updat=up.tards[i];
			tards[i].px=x3_min+((rnd()/65536)*(x3_max-x3_min));
			tards[i].py=y3_min;
			tards[i].pz=z3_min+((rnd()/65536)*(z3_max-z3_min));
			
			tards[i].mc.onRollOver=delegate(dotard,"over",tards[i]);
			tards[i].mc.onRollOut=delegate(dotard,"out",tards[i]);
			tards[i].mc.onReleaseOutside=delegate(dotard,"out",tards[i]);
			tards[i].mc.onRelease=delegate(dotard,"release",tards[i]);
			tards[i].mc.onPress=delegate(dotard,"press",tards[i]);

			tards[i].update();
		}
		
		talky=new Talky(this);
		talky.setup();
		
		for(i=1;i<tards.length;i++)
		{
			tards[i].talk=talky.create(tards[i].mc,0,-30);
		}
	
		nmc=gfx.create_clip(mc,null,75,150,150,150);
		mc_tard=nmc;
		nmc.id="tard";
		
		minion=new Minion( {mc:nmc} );
		minion.setup(up.tards[up.tard_idx].img1,50,100);
		monkeysee=tards[up.tard_idx];
		
		mc_tard.mcname=gfx.create_clip(mc_tard,null);
		gfx.dropshadow(mc_tard.mcname,2, 45, 0x000000, 1, 4, 4, 2, 3);
		mc_tard.name=gfx.create_text_html(mc_tard.mcname,null,-80,-102,160,20);

		drag=null;
	}
	
	function clean()
	{
		back.clean();
		mc.removeMovieClip();
	}
	
	var drag=null;
	
	function dotard(act,tard)
	{
//	var i;
	
		switch(act)
		{
			case "over":
//				_root.poker.ShowFloat(tard.updat.name,25*5);
			break;
			case "out":
				_root.poker.ShowFloat(null,0);
				drag=null;
			break;
			case "release":
				drag=null;
			break;
			case "press":
				drag={};
				drag.tard=tard;
				drag.mx=mc._xmouse;
				drag.my=mc._ymouse;
				drag.px=tard.px;
				drag.pz=tard.pz;
				
				minion.setsoul(tard.updat.img1);
				
				monkeysee=tard;
				
				up.tard_idx=tard.updat.idx;
				
			break;
		}
	}
	
	function update()
	{
	var i;
	var t;
	var f;
	var ss,s;
	
		frame++;
		
		f=((frame%50)-25)/25;
		if(f<0){f=-f;}
		ss=f*f;
		s=((ss+(ss*2))-((ss*f)*2));

		
		floatx=0;
		floaty=s*25;

		
		mc_tard._x=390+floatx;
		mc_tard._y=205+floaty;
		
		back.mcs["floater_back"]._x=-400+floatx;
		back.mcs["floater_back"]._y=-300+floaty;
		back.mcs["floater_start"]._x=-400+floatx;
		back.mcs["floater_start"]._y=-300+floaty;
		
		
		if(drag)
		{
			var dx,dy,dz;
			
			dx=mc._xmouse-drag.mx;
			dy=mc._ymouse-drag.my;
			dx+=dy;
			dz=-dy*4;
			
			drag.tard.px=drag.px+dx;
			drag.tard.pz=drag.pz+dz;
			
			drag.tard.rndstate="idle";
			drag.tard.rndcount=25*5;
		}
	
		for(i=1;i<tards.length;i++)
		{
			tards[i].update();
		}
		
		for(i=2;i<tards.length;i++)
		{
			if( tards[i].pz > tards[i-1].pz )
			{
				if( tards[i].mc.getDepth() > tards[i-1].mc.getDepth() )
				{
					tards[i].mc.swapDepths(tards[i-1].mc);
					
					t=tards[i];
					tards[i]=tards[i-1];
					tards[i-1]=t;
				}
			}
		}
		
		minion.display(monkeysee.minion.anim,monkeysee.minion.frame);
		
		gfx.set_text_html(mc_tard.name,12,0xffffff,"<p align=\"center\"><b>"+up.tards[up.tard_idx].name+"</b></p>");
		
		talky.update();
	}

}