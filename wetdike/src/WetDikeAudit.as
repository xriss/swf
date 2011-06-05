/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// lets handle some scores

class WetDikeAudit
{
	var mc;
	var mch;
	var tf;
	
	var up; // WetDikePlay
	
	var strs;
	var strs_cache;
	var str;
	
	var state;
	
	var lv_audit;
	
	function delegate(f)	{	return com.dynamicflash.utils.Delegate.create(this,f);	}


	function WetDikeAudit(_up)
	{
		up=_up;
		
		setup();
	}

	function setup()
	{
		
		mch=gfx.create_clip(up.mc,null);
		mc=gfx.create_clip(mch,null);
		
		mch._x=400;
		mch._y=450;
		
		mc._alpha=70;
		gfx.clear(mc);
		mc.style.out=0xff000000;
		mc.style.fill=0xffffffff;
		gfx.draw_rounded_rectangle(mc,20,20,6,200-400,350-450,400,200);
		tf=gfx.create_text_html(mc,null,-200+30,-100+30,400-60,200-60);
		
		mc._visible=false;
		
		strs=[];
		strs_cache=[];

		
	}
	
	
	function thunk()
	{
	var i;
	var doit;
	
		doit=false;
		for(i=0;i<3;i++)
		{
			if(strs_cache[i]!=strs[i])
			{
				doit=true;
			}
		}
		
		if(doit)
		{
			str="";
			for(i=0;i<3;i++)
			{
				if(strs[i])
				{
					str+=strs[i];
				}
			}	
			
			gfx.set_text_html(tf,16,0,str);
		}
	}
	
	function clean()
	{
		mc.removeMovieClip();
	}

	function update()
	{
		
		if(mc._visible==false)
		{
			if(_root.audit==true)
			{
				mc._visible=true;
				
				state="init";
				
				_root.auditfunc=delegate(auditfunc);
			}
		}
		else
		{
			if(_root.audit!=true)
			{
				state="quit_audit";
				mc._visible=false;
				_root.auditfunc=null;
			}
		}
		
		switch(state)
		{
			case "init":
			
				_root.comms.send_score_check();
			
				strs[0]="Attempting to initiate audit mode, this will only work for select users. If you dont know whats going on or why then you should just close this window.<br>";
				strs[1]="<br>";
				strs[2]="<a href=\"asfunction:_root.auditfunc,quit\"><b>Click here to close this window.</b></a><br>";
				state="init_wait";
				
				_root.comms.send_audit(-1,0,0);
			break;
			
			case "init_wait":
				if( (_root.comms.lv_audit_got!=null) && (_root.comms.lv_audit_got.err=="OK") )
				{
					state="do_audit";
					
//					dbg.print(_root.comms.lv_audit_got.err);
				}
			break;
			
			case "do_audit":
				lv_audit=_root.comms.lv_audit_got;
				_root.comms.lv_audit_got=null;
				
				lv_audit.seed=int(lv_audit.seed);
				lv_audit.replay_id=int(lv_audit.replay_id);
				
				strs[0]="X100 auditsoft is auditing score id "+(lv_audit.replay_id)+" with game seed "+(lv_audit.seed)+" .<br>";
				strs[1]="<br>";
				strs[2]="<a href=\"asfunction:_root.auditfunc,quit\"><b>Click here to close this window.</b></a><br>";
				
				if(lv_audit.replay_id==-1)
				{
					_root.comms.lv_audit_got=null;
					state="init_wait";
					lv_audit=null;
				}
				else
/*
				if((lv_audit.err!=null)&&(lv_audit.err!="OK"))
				{
					strs[0]=lv_audit.err+" .<br>";
					strs[1]="<br>";
					strs[2]="<a href=\"asfunction:_root.auditfunc,quit\"><b>Click here to close this window.</b></a><br>";
					_root.comms.lv_audit_got=null;
					state="init_wait";
					lv_audit=null;
				}
				else
*/

// check for obviously broken replays and reply imediatly

				if((lv_audit.seed==0)||(!lv_audit.replay_str)||(lv_audit.replay_str==""))
				{
					_root.comms.send_audit(lv_audit.replay_id,0,lv_audit.replay_str);
					state="init_wait";
					lv_audit=null;
				}
// perform actual audit				
				else
				{
					up.state_next=WetDike.STATE_PLAY;
					up.game_seed=lv_audit.seed;
					up.game_replay=lv_audit.replay_str;
					state="doing_audit";
//					dbg.print(up.game_replay);
				}
			break;
			
			case "doing_audit":
				if(up.dikeplay.table.playback_done)
				{
					_root.comms.send_audit(lv_audit.replay_id,up.dikeplay.table.score_max,up.game_replay);
					state="init_wait";
				}
			break;
			
			case "quit_audit":
				var date=new Date();
				_root.wetdike.game_seed=Math.floor(((date.getTime()/1000))/(24*60*60))&0xffff;
				_root.wetdike.state_next=WetDike.STATE_PLAY;
				_root.audit=false;
				up.dikeplay.table.score_max=0;
				state="none";
			break;
		}
		
		
		thunk();
	}
	
	function auditfunc(str)
	{
		if(_root.audit!=true) { return; }
		
		if(str=="quit")
		{
			_root.wetdike.dikeaudit.state="quit_audit";
		}
	}
	
}
