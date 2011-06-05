/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import flash.Security;


// lets handle some scores

class PlayCode
{
	var up;
	
	var mcb;
	var mc;
	
	var mcs;
	var tfs;
	
	var done;
	var steady;
	
var mcWF;

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function PlayCode(_up)
	{
		up=_up;
	}
	
	function setup()
	{
	var i;
	var bounds;
	var mct;
	var s;
	
			
		_root.popup=this;
		
		mcs=new Array();
		tfs=new Array();
			
		mcb=gfx.create_clip(_root.mc_popup,null);
		if( _root.scalar.oy==600 ) // our size
		{
			mc=mcb;
		}
		else
		{
			mcb._xscale=Math.floor(100 * (_root.scalar.oy/600));
			mcb._yscale=Math.floor(100 * (_root.scalar.oy/600));
			mc=gfx.create_clip(mcb,null);
		}
		mcb.cacheAsBitmap=true;

		
		gfx.dropshadow(mc,5, 45, 0x000000, 1, 20, 20, 2, 3);
//	    mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 20, 20, 2, 3) ];
		
		
		mc._y=0;
		
		mc.dx=0;
		mc._x=-800;
		
//		mc.onEnterFrame=delegate(update,null);

		done=false;
		steady=false;
		
		gfx.clear(mc);
				
		mcs[0]=gfx.create_clip(mc,null);
		mcs[0].onRelease=delegate(onRelease,null);
		mcs[0].showHandCursor=false;
		mcs[0].style.out=0xff000000;
		mcs[0].style.fill=0x10000000;
		gfx.draw_box(mcs[0],0,0,0,800,600);
		mcs[0].style.out=0xff000000;
		mcs[0].style.fill=0x80000000;
		gfx.draw_box(mcs[0],0,100+16,0+16,600-32,600-32);
		
		mcs[1]=gfx.create_clip(mc,null);
		mcs[1].onRelease=delegate(function(){},null);
		mcs[1].showHandCursor=false;
		mcs[1].style.out=0xff000000;
		mcs[1].style.fill=0x10000000;
		gfx.draw_box(mcs[1],0,150,50,500,500);
		
		mcs[2]=gfx.create_clip(mc,null,150,50,150,150);
		
/*
		mcs[0]=gfx.create_clip(mc,null);
//		tfs[0]=gfx.create_text_html(mcs[0],null,150,50,500,150);
		mcs[0].onRelease=delegate(onRelease,null);
		mcs[0].onReleaseOutside=delegate(onRelease,null);
		
		s="";
						
		s+="<p>Copy and paste all the code provided below to place this game on your web page, blog or profile. Then click here to return to the main menu.</p>";
				
		tfs[0].multiline=true;
		tfs[0].wordWrap=true;
		tfs[0].html=true;
		tfs[0].selectable=false;
		
//		gfx.set_text_html(tfs[0],22,0xffffff,s);

		
		mc.style.out=0xff000000;
		mc.style.fill=0xff000080;
		gfx.draw_box(mc,0,200-4,200,400+8,200);
		
//		tfs[1]=gfx.create_text(mc,null,200,200,400,200);
		s="";						
		s+="\n\t<center><embed src=\"http://link.wetgenes.com/link/#(VERSION_NAME).swf\" type=\"application/x-shockwave-flash\" width=\"640\" height=\"480\"></embed><br /><a href=\"http://www.WetGenes.com\" target=\"_blank\" title=\"www.WetGenes.com\">Play free online games at www.WetGenes.com</a></center>";
//		tfs[1].multiline=true;
		tfs[1].wordWrap=true;
		tfs[1].html=false;
		tfs[1].selectable=true;
		tfs[1].text=s;
		
		tfs[2]=gfx.create_text_html(mc,null,150,450,500,150);
		s="";
		s+="<p><a href=\"http://swf.wetgenes.com/swf/wetlinks/images.php?game=#(VERSION_NAME)\" target=\"_blank\">Click here for a webpage with available game icons if you want to create your own links.</a></p>";
//		gfx.set_text_html(tfs[2],22,0xffffff,s);

*/
		
		thunk();
		
		Mouse.addListener(this);

		update_do=delegate(update,null);
		MainStatic.update_add(_root.updates,update_do);
		_root.poker.clear_clicks();
		_root.poker.ShowFloat(null,0);
		
		
		
//--- This code configures and loads Wildfire ---

//Set up security to allow your widget to interact with Wildfire
System.security.allowDomain("cdn.gigya.com"); 
System.security.allowInsecureDomain("cdn.gigya.com");

//This code creates an empty movie clip to host the wildfire interface 
mcWF=gfx.create_clip(mcs[2],null); //_root.createEmptyMovieClip('Wildfire',_root.getNextHighestDepth());
mcWF._lockroot=true;  //lock the root of the newly created movieclip

//Please position Wildfire in your Flash
mcWF._x=0;  mcWF._y=0;

// This code creates a configuration object through which Wildfire will communicate with the host swf
mcWF['ModuleID']='PostModule1';        // passing the module id to wildfire 
var cfg=_root[mcWF['ModuleID']]={};     // initializing the configuration object

//This code assigns the configurations you set in our site to the Wildfire configuration node
cfg['width']='333';
cfg['height']='333';
cfg['partner']='200531';
cfg['UIConfig']='<config><display showEmail="true" showBookmark="true" showCloseButton="true" bulletinChecked="false" networksWithCodeBox="" /></config>';

// Please set up the content to be posted
cfg['defaultContent']=function(){
    return "<center><embed src=\"http://link.wetgenes.com/link/#(VERSION_NAME).swf\" type=\"application/x-shockwave-flash\" width=\"640\" height=\"480\"></embed><br /><a href=\"http://games.WetGenes.com\" target=\"_blank\" title=\"games.WetGenes.com\">Play more free online games at games.WetGenes.com</a></center>";  // <-- YOUR EMBED CODE GOES HERE
}


cfg['facebookURL']= "http://link.wetgenes.com/link/#(VERSION_NAME).fb" ;

var subdomain=(('#(VERSION_NAME)').toLowerCase());

if(subdomain=="wetbasement") { subdomain="basement"; }
if(subdomain=="wetdiamonds") { subdomain="diamonds"; }

cfg['bookmarkURL']= "http://" + subdomain +  ".wetgenes.com/" ;
cfg['widgetTitle']= "Play #(VERSION_NAME) at www.WetGenes.com" ;



// You can set different content for each network
//cfg['myspaceContent']='';
//cfg['friendsterContent']='';
//cfg['facebookContent']='';
//cfg['taggedContent']='';
//cfg['bloggerContent']='';
//cfg['hi5Content']='';
//cfg['freewebsContent']='';
//cfg['xangaContent']='';
//cfg['livejurnalContent']='';
//cfg['blackplanetContent']='';
//cfg['piczoContent']='';
//cfg['wordpressContent']='';
//cfg['typepadContent']='';

//cfg['bulletinSubject']='';  // The subject for bulleting messages of your content
//cfg['bulletinHTML']='';   // code for the bulletin, if it is different than the defaultContent 

//cfg['facebookURL']=''; // If you have your own facebook application you can set it's URL here

// set up an event handler for the postProfile event, this is called when the used completed the proccess of posting to his profile.
cfg['onPostProfile']=delegate(finish);
cfg['onClose']=delegate(finish);
cfg['onLoad']=delegate(WFonLoad);


// This code calls up wildfire 
mcWF.loadMovie('http://cdn.gigya.com/WildFire/swf/wildfire.swf','get');
	
		wf_loaded=false;
	
	}
	var	wf_loaded;
		
	function WFonLoad()
	{
		wf_loaded=true;
	}
	
	var update_do;
	
	function clean()
	{
		if(_root.popup != this)
		{
			return;
		}
		
//		_root[mcWF['ModuleID']]=null;
//		mcWF.unloadMovie();
		mcWF=null;
		
//		MainStatic.update_remove(_root.updates,update_do);
		update_do=null;
		
		mc.removeMovieClip();
		mcb.removeMovieClip();
		_root.popup=null;
		
		Mouse.removeListener(this);
		
		_root.poker.clear_clicks();
		_root.poker.ShowFloat(null,0);
	}
	
	function thunk()
	{
	}
	
	
	function over(s)
	{
	}
	
	function notover(s)
	{
			_root.poker.ShowFloat(null,0);
	}
	
	function click(s)
	{
	}
	

	function onRelease()
	{
		if(_root.popup != this)
		{
			return;
		}

		if(steady)
		{
//			if(!wf_loaded) // allow exit before load
			{
				done=true;
				mc.dx=_root.scalar.ox;
			}
		}
	}

	function finish()
	{
		done=true;
		mc.dx=_root.scalar.ox;
	}

	function update()
	{
		if( (_root.popup != this) || (_root.pause) )
		{
			return;
		}
		
		
		mc._x+=(mc.dx-mc._x)/4;

		if( (mc._x-mc.dx)*(mc._x-mc.dx) < (16*16) )
		{
			steady=true;
			if(done)
			{
				clean();
			}
		}
		else
		{
			steady=false;
		}
		
	}
		
	

}
