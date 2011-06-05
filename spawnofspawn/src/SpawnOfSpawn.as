/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


//import com.wetgenes.gfx;


class SpawnOfSpawn
{
	var state_last;
	var state;
	var state_next;

	var	setup_done=false;

	var mc;

	var esplay;
	
	var game_seed:Number=0;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	static function main()
	{
		_root.cacheAsBitmap=false;

		var orset_root=function(a,b)
		{
			if(_root[a]==undefined) { _root[a]=b; }
			_root[a]=b;
		}
// overide only basic wetplay settings
//		orset_root("wp_vol",0);
		orset_root("wp_xspf","http://wetdike.wetgenes.com/swf/WetDike.xspf");
		orset_root("wp_auto",0);
		orset_root("wp_shuffle",1);
		orset_root("wp_back",0xff000000);
		orset_root("wp_fore",0xffffffff);
		

// limit size
//		orset_root("maxs",0.9);
		orset_root("maxw",640);
		orset_root("maxh",480);
		
		_root.newdepth=1;
		
		_root.scalar=new Scalar(800,600);
		_root.poker=new Poker(false);
		_root.loading=new Loading();
		_root.wetplay=new WetPlayIcon();
		_root.spawn=new SpawnOfSpawn();
		_root.wtf=new WTF();
	}



	function SpawnOfSpawn()
	{
		mc=gfx.create_clip(_root,null);
		mc.onEnterFrame=delegate(update);
		
		mc.scrollRect=new flash.geom.Rectangle(0, 0, _root.scalar.ox, _root.scalar.oy);
	}
		
	
	function setup()
	{
	var date=new Date();
		game_seed=Math.floor(((date.getTime()/1000))/(24*60*60))&0xffff;
		
		state_last=null;
		state=null;
		state_next=null;

//		mc2=gfx.create_clip(_root,null);
		
		{
		var cm;
		var cmi;
		var f;
			cm = new ContextMenu();
			cm.hideBuiltInItems();

			f=function()
			{
				if(!_root.popup)
				{
					_root.spawn.state_next="play";
				}
			};
			cmi = new ContextMenuItem("Restart.", f );
			cm.customItems.push(cmi);
			
			f=function()
			{
				if( Stage["displayState"] == "normal" )
				{
					Stage["displayState"] = "fullScreen";
				}
				else
				{
					Stage["displayState"] = "normal";
				}
			};
			cmi = new ContextMenuItem("Toggle fullscreen mode.", f );
			cm.customItems.push(cmi);
			
			_root.menu=cm;
		}

		esplay=new EsPlay(this);
		
		state_next="play";

		_root.wetplay.setup();

	}
	
	
	

	function update()
	{
		_root.scalar.apply(mc);
		
		if(!setup_done)
		{
			if(_root.loading.done)
			{
				setup();
				setup_done=true;
			}
			return;
		}		
		
		if(state_next!=null)
		{
		
			switch(state)	// clean
			{
				case "play":		esplay.clean();		break;
			}

			state_last=state;	// change master state
			state=state_next;
			state_next=null;
			

			switch(state)	// setup
			{
				case "play":		esplay.setup();		break;
			}
		}
		
		switch(state)	// update
		{
			case "play":			esplay.update();	break;
		}
			
		_root.wetplay.update();
			
	}
	
	function clean()
	{
	}
	
	
}


