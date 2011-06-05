/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

//this is old and not used anymore....

class WetBaseMentChoose
{
	var up;
	
	
	var mc;
	
	var mc_levels;
	
	var mc_tard;
	var mc_skill;
	
	var minion;
	
	var frame;
	
	function WetBaseMentChoose(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function days_to_string(days)
	{
		var d;
		var s;
		
		d=new Date();
		d.setTime(days*24*60*60*1000);
		
		s=alt.Sprintf.format("%04d%02d%02d",d.getFullYear(),d.getMonth()+1,d.getDate());
		
		return s;
	}

	
	

	function setup()
	{
	var i;
	var x,y;
	var nmc;
	
		mc=gfx.create_clip(up.mc,null);
		
		frame=0;
		
		mc_levels=[];
		
		x=100;
		y=100-20;
		for(i=1;i<=10;i++)
		{
			mc_levels[i]=gfx.create_clip(mc,null,x,y,80,80);
			
			mc_levels[i].onRollOver=delegate(mc_over, mc_levels[i]);
			mc_levels[i].onRollOut =delegate(mc_out,  mc_levels[i]);
			mc_levels[i].onRelease =delegate(mc_click,mc_levels[i]);
		
			mc_levels[i].id=i;
		
			gfx.add_clip(mc_levels[i],up.levels[i].img_bak,null,-80,-60,20,20);
			
			mc_levels[i].tf=gfx.create_text_html(mc_levels[i],null,-100,60,200,100);
			gfx.set_text_html(mc_levels[i].tf,24,0xffffff,"<p align=\"center\">"+up.levels[i].name+"</p>");
			
			x+=200;
			if(x>700) { x=100; y+=150; }
		}
		
		nmc=gfx.create_clip(mc,null,800-200,600-100,150,150);
		mc_tard=nmc;
		nmc.id="tard";
		
		nmc.onRollOver=delegate(mc_over, nmc);
		nmc.onRollOut =delegate(mc_out,  nmc);
		nmc.onRelease =delegate(mc_click,nmc);
		
		minion=new Minion( {mc:nmc} );
		minion.setup(up.tards[up.tard_idx].img1,50,100);
		
//		nmc.img=gfx.add_clip(nmc,up.tards[up.tard_idx].img1,1,-50,-100);
//		nmc.img.scrollRect=new flash.geom.Rectangle(0*100, 3*100, 100, 100);

		nmc.tf=gfx.create_text_html(nmc,2,-100,0,200,100);
		gfx.set_text_html(nmc.tf,24,0xffffff,"<p align=\"center\">"+up.tards[up.tard_idx].name+"</p>");
			
		
		nmc=gfx.create_clip(mc,null,100,600-100,100,100);
		mc_skill=nmc;
		nmc.id="skill";
		
		nmc.onRollOver=delegate(mc_over, nmc);
		nmc.onRollOut =delegate(mc_out,  nmc);
		nmc.onRelease =delegate(mc_click,nmc);
		
//		nmc.img=gfx.add_clip(nmc,up.tards[up.tard_idx].img1,1,-50,-100);
//		nmc.img.scrollRect=new flash.geom.Rectangle(0*100, 3*100, 100, 100);

		nmc.tf=gfx.create_text_html(nmc,2,-100,0,400,100);
		gfx.set_text_html(nmc.tf,36,0xffffff,"<p align=\"center\">Difficulty : "+up.play.gameskill+"</p>");
			
		var lev;
		
		for(i=1;i<=10;i++)
		{
			lev=up.levels[i];
			
			gfx.set_text_html(mc.date,14,0xffffff,"<p align=\"center\">"+days_to_string(lev.game_seed)+"</p>");
			gfx.set_text_html(mc.score,16,0xffffff,"<p align=\"center\">"+(11500+i)+"</p>");
		}
	}
	
	function clean()
	{
		mc_out(null);
		mc.removeMovieClip();
	}
	
	function mc_over(t)
	{
		if(_root.popup) return;
		
		if(t.id=="skill")
		{
			_root.poker.ShowFloat("Click to adjust the game skill you wish to play at.",25*10);
		}
		else
		if(t.id=="tard")
		{
			_root.poker.ShowFloat("Click to change your player avatar. You will be able to choose your own in the future: Visit minions.WetGenes.com for the avatar editor.",25*10);
		}
		else
		{
			var lev=up.levels[Number(t.id)];
			
			_root.poker.ShowFloat("Click to play "+lev.name+". You can use arrow keys or the mouse to move around the level.",25*10);
		}
	}
	
	function mc_out(t)
	{
		_root.poker.ShowFloat(null,0);
	}
	
	function mc_click(t)
	{
		if(_root.popup) return;

		if(t.id=="skill")
		{
			if(up.play.gameskill=="easy") { up.play.gameskill="hard"; }
			else
			if(up.play.gameskill=="hard") { up.play.gameskill="easy"; }
			
			gfx.set_text_html(mc_skill.tf,36,0xffffff,"<p align=\"center\">Difficulty : "+up.play.gameskill+"</p>");
		}
		else
		if(t.id=="tard")
		{
			up.tard_idx++;
			if(up.tard_idx>=up.tards.length) { up.tard_idx=1; }
			
			minion.setsoul(up.tards[up.tard_idx].img1);

//			mc_tard.img=gfx.add_clip(mc_tard,up.tards[up.tard_idx].img1,1,-50,-100);
//			mc_tard.img.scrollRect=new flash.geom.Rectangle(0*100, 3*100, 100, 100);
			gfx.set_text_html(mc_tard.tf,24,0xffffff,"<p align=\"center\">"+up.tards[up.tard_idx].name+"</p>");
		}
		else
		{
			up.level_idx=t.id;
			up.state_next="play";
		}
	}
	
	function update()
	{
	var ff;
	
		frame++;
		
		ff=Math.floor(frame/6)%6;
//		if(ff>3) { ff=6-ff; }
		
		minion.display("idle",ff);

//		mc_tard.img.scrollRect=new flash.geom.Rectangle(ff*100, 3*100, 100, 100);

	}

}