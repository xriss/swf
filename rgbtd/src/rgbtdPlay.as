/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class rgbtdPlay
{
	var up;
	
	var mc;
	
	var comms;
	
	var room;

	var state;
	
	var pixls;
	
	var map;
	
	var levels;
	
	var level;
	
	var paste;
	
	var score;
	var score_total;
	var replay;
	
	
	function rgbtdPlay(_up)
	{
		up=_up;
		
		levels=[
		
					new rgbtd_level00() ,
					new rgbtd_level01() ,
					new rgbtd_level02() ,
					new rgbtd_level03() ,
					new rgbtd_level04() ,
					new rgbtd_level05() ,
					new rgbtd_level06() ,
					new rgbtd_level07() ,
					new rgbtd_level08() ,
					new rgbtd_level09() ,
					new rgbtd_level10() ,
					new rgbtd_level11() ,
					new rgbtd_level12() ,
					new rgbtd_level13() ,
					new rgbtd_level14() ,
					new rgbtd_level15() ,
					new rgbtd_level16() ,
					new rgbtd_level17() ,
					new rgbtd_level18() ,
					new rgbtd_level19() ,
					new rgbtd_level20() ,
					new rgbtd_level21() ,
					new rgbtd_level22() ,
					new rgbtd_level23() ,
					new rgbtd_level24() ,
					
					null		
				];
		
		var l;
		
		l=levels[0];
		l.winscore=[100,150,202];
		l.help="Place shapes to guide your plots over the <font color=\"#00ff00\" ><b>+</b></font> food before they reach the exit. Guide them through all the <font color=\"#00ff00\" ><b>+</b></font> food to score high and unlock the next level.";
		l.name="Plop Plop.";
		
		l=levels[1];
		l.winscore=[100,196,200];
		l.help="<p>Plots will always try and take the shortest path. Avoid the <font color=\"#ff0000\" ><b>-</b></font> traps to keep your plots alive, collect the <font color=\"#00ff00\" ><b>+</b></font> food to score high.</p><p></p><p>You will need to choose a different block shape using the menu on the right to complete this level.</p>";
		l.name="Pixel Juice.";
		
		l=levels[2];
		l.winscore=[100,180,260];
		l.help="Get your plots nice and fat so they can survive the <font color=\"#ff0000\" ><b>-</b></font> traps and make it into the exit. Plots always move up/down or left/right never diagonaly.";
		l.name="Pr0n snackrifice.";
		
		l=levels[3];
		l.winscore=[100,170,234];
		l.help="Plots like lemmings are not very smart, guide them very carefully into the exit. Remember the longer the path of the plots the less you will score, that doesn't help you here but you should still remember it.";
		l.name="Snake Plissken.";
		
		l=levels[4];
		l.winscore=[100,200,285];
		l.help="Sometimes getting to the exit is easy, but you will want to take a longer path and feed your plots so they get nice and plump first. The less blocks you use the more you score.";
		l.name="The high road.";
		
		l=levels[5];
		l.winscore=[100,250,426];
		l.help="Portals are fun but plots are dumb. You must always be very careful not to give your plots any opportunity to do something silly. Plots love to make bad decisions.";
		l.name="Puzzle box or portal to hell?";
		
		l=levels[6];
		l.winscore=[100,300,559];
		l.name="Spoon Matrix.";
		
		l=levels[7];
		l.winscore=[100,400,659];
		l.name="Hokey Cokey.";

		l=levels[8];
		l.winscore=[100,450,826];
		l.name="Left hand down a bit.";

		l=levels[9];
		l.winscore=[100,400,529];
		l.name="One does not simply walk into Mordor.";

		l=levels[10];
		l.winscore=[100,250,456];
		l.name="1337 skillz.";
		
		l=levels[11];
		l.winscore=[100,250,496];
		l.name="Quadrophenia.";

		l=levels[12];
		l.winscore=[100,350,660];
		l.name="Traffic lights.";

		l=levels[13];
		l.winscore=[100,350,591];
		l.name="Bizzy buzzy beezz.";

		l=levels[14];
		l.winscore=[100,300,665];
		l.name="V for Vienetta.";

		l=levels[15];
		l.winscore=[100,250,553];
		l.name="Johney five is alive.";

		l=levels[16];
		l.winscore=[100,250,576];
		l.name="12 donkeys.";

		l=levels[17];
		l.winscore=[100,400,849];
		l.name="10 percent of doom.";

		l=levels[18];
		l.winscore=[100,300,752];
		l.name="Mad Cat Hat Pat.";

		l=levels[19];
		l.winscore=[100,400,731];
		l.name="Narcissistic Bastard.";

		l=levels[20];
		l.winscore=[100,450,854];
		l.name="A maze of twisty little passages, all alike.";

		l=levels[21];
		l.winscore=[100,200,614];
		l.name="Portallis Upyoor Endee.";

		l=levels[22];
		l.winscore=[100,450,839];
		l.name="Hot cross bunz of steal.";

		l=levels[23];
		l.winscore=[100,700,1078];
		l.name="Blankety blank.";

		l=levels[24];
		l.winscore=[100,1000,2018];
		l.name="Green green grass of homer.";

		}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function setup()
	{
	var m;
	var vt;
	
		up.lselect.manifest_level(up.game_seed);			

		score=0;
		score_total=0;
		replay="";
	
		new_map=false;
	
		state="none";
		
		mc=gfx.create_clip(up.mc,null);
		
		mc.back=gfx.add_clip(mc,"back2",null);
				
		level=levels[up.game_seed];
		
		map=new tdmap(this); map.setup(); // effect layer

		_root.signals.signal("rgbtd0","start",this);
		
		
		pixls=new OverPixls(up); pixls.setup(); // effect layer
		
		paste=new PlayPaste(this);
		
	}
	
	function clean()
	{
		_root.signals.signal("rgbtd0","end",this);
		
		_root.swish.clean();
		_root.swish=(new Swish({style:"slide_left",mc:mc})).setup();
		
		map.clean();
		pixls.clean();
		
		mc.removeMovieClip();
	}

	
	var new_map;
	
	
	function update()
	{
	var i;
	
		_root.bmc.check_loading();
		
		if( Key.isDown(Key.SPACE) && (Selection.getCaretIndex()==-1) )
		{
			if(!_root.popup)
			{
//				new_map="\n\t"+
				new_map=map.map_to_str();
				paste.setup(new_map);
			}
		}
		
		if(!_root.popup)
		{
		
			_root.signals.signal("rgbtd0","update",this);
		
			if(new_map) // maybe got a new map
			{
				var r=Clown.clean_str(paste.result);
				
				if( r != new_map ) // got some new code
				{
					map.set_map_str(r);
				}
				
				new_map=null;
			}
			map.update();
		}
		
	}
	
	function update_less()
	{
		if(!_root.popup)
		{
			pixls.update();
		}
	}
}