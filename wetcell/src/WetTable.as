/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


#STACK_HAND=16
#STACK_GHOST=17

// A collection of stacks of cards making up the game

class WetTable
{

	static var REPLAY_CODE		:Number	=	19;
	static var REPLAY_VERSION	:Number	=	4;
	
	
	var stacks:Array;	// array of stacks of cards

	var mc:MovieClip;
	var mc_ads:MovieClip;
	
	var menu;
	
	var top_back_stack_depth;
	
	var fmt;
	var fmts;
	
	var mc_tint;
	var mc_moves;

	var mc_score:MovieClip;
	var tf_score:TextField;
//	var tf_score_shadow:TextField;
	
	var mc_status;
	var tf_status;
//	var tf_status_shadow;
	var status_fade;
	
	var last_status;
	var new_status;
	
	var up;
	
	var from_stack:Number;
	var to_stack:Number;
	
	var hand_x:Number;
	var hand_y:Number;
	
	var score:Number;
	var score_max:Number;
	var moves:Number;

	var frame_time:Number;
	
// time stamp of last stack click for double click test; 
	var lstclk_time:Number;
	var lstclk_stack:Number;
	
// array of all active animation
	var animcards;
	
	var done_win;
	
// array of valid moves

	var moves_valid;
	var txtcolor=0;
	
	var record=null;
	var playback=null;
	var playback_index;
	var playback_count;
	var playback_count_time=0;
	var playback_str;
	var playback_done;
	
	var sfxs;
	
	var free_cells=0;
	
	var done_ads=false;
	
	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}

	
	function WetTable(_up)
	{
		up=_up;
	}
	
	function setup_playback(str)
	{
		playback=[];
		playback_index=0;
		playback_count=2;		
		playback_done=false;
			
		if(REPLAY_CODE!=Clown.tonum(str,0,1)) { return; }
		if(REPLAY_VERSION!=Clown.tonum(str,1,1)) { return; }		
		if(6!=Clown.tonum(str,5,1)) { return; }
		
//		up.seed=Clown.tonum(str,2,3);
		
		playback=Clown.str_to_bits(str,6,6);
	}

	function create_playback_str()
	{
	var s;
	var i;
	
		s="";
		
		s+=Clown.tostr(REPLAY_CODE,1);
		s+=Clown.tostr(REPLAY_VERSION,1);
		s+=Clown.tostr(up.seed,3);		// pack seed
		s+=Clown.tostr(6,1);			// number stream size in bits
		
		for(i=0;i<record.length;i++)
		{
			s+=Clown.tostr(record[i],1);
		}

		playback_str=s
//dbg.print(playback_str);
		return playback_str;
	}
	
	function sfx_deal()
	{
		_root.wetplay.wetplayMP3.PlaySFX("sfx_deal");
	}
	
	function sfx_slide()
	{
//		_root.wetplay.wetplayMP3.PlaySFX("sfx_slide");
	}
	
	function sfx_flip()
	{
		_root.wetplay.wetplayMP3.PlaySFX("sfx_flip");
	}
	
	function setup()
	{
		var s;
		var i,j;
		
		done_ads=false;

		sfxs=new Array();
		
		playback=null;
/*
		if(record.length>1) // hack playback test
		{
			create_playback_str();
			setup_playback(playback_str);
		}		
		else
		{
/			dbg.print("record");
		}
*/

//		setup_playback("TEAAAGBCBDBBBAAAAAACABAAAABDEAAAACACAAACAAAAAAADAAAAAAADDDDAAEEEGCFFEDAEFDAAAAA");

//		setup_playback("TE9TDGEADCBBBBBBBCABBAAAAABBDFCFGFFEADFIAADEDHAJAAABACAAABAADHAAAAJADAAAABACACCAABBLLLLAALLLLDJNPQMNNPMOMOMNMOMNMNMNMOMPOPQPQSUVWY");
//		up.seed=13565; up.rnd_seed(up.seed);
//		playback_count_time=5;

/*
		setup_playback("TEUXDGAFBABAAFCBBAAABBBC");
		up.seed=13780; up.rnd_seed(up.seed);
		playback_count_time=5;
*/
		if(up.up.game_replay)
		{
			setup_playback(up.up.game_replay);
			up.up.game_replay=null;
		}

		record=new Array();	
		playback_str=null;
		
		moves_valid=new Array();
		
		done_win=false;
		
		lstclk_time=-60;
		lstclk_stack=-1;
		
		frame_time=0;
		
		score=0;
		score_max=0;
		moves=0;
		
		from_stack=-1;
		to_stack=-1;
		hand_x=0;
		hand_y=0;

		stacks=new Array();
		
		animcards=new Array();
		
		mc=gfx.create_clip(up.mc,null);

// temp use of styles		
		mc.style=new Array();
// generic green background
//		mc.style.fill=0xff008000;
//		gfx.draw_box(mc,0,0,0,800,600);

		gfx.add_clip(mc,'table',null);
		
//		mc_ads=gfx.create_clip(mc,null);
//		mc_ads.loadMovie(_root.import_swf_name);
		

// free cells
		stacks[0]=new WetStack(this);
		s=stacks[0];
		s.layout='spread_top';
		s.pickup='pickup_1';
		s.place='place_1';
		s.mc._x=50+(100*0);
		s.mc._y=14+71;

		stacks[1]=new WetStack(this);
		s=stacks[1];
		s.layout='spread_top';
		s.pickup='pickup_1';
		s.place='place_1';
		s.mc._x=50+(100*1);
		s.mc._y=14+71;

		stacks[14]=new WetStack(this);
		s=stacks[14];
		s.layout='spread_top';
		s.pickup='pickup_1';
		s.place='place_1';
		s.mc._x=50+(100*2);
		s.mc._y=14+71;
		
		stacks[15]=new WetStack(this);
		s=stacks[15];
		s.layout='spread_top';
		s.pickup='pickup_1';
		s.place='place_1';
		s.mc._x=50+(100*3);
		s.mc._y=14+71;

		
// away 1
		stacks[2]=new WetStack(this);
		s=stacks[2];
		s.layout='spread_top';
		s.pickup='pickup_1';
		s.place='place_atok_same_1';
		s.mc._x=50+(100*4);
		s.mc._y=14+71;
// away 2
		stacks[3]=new WetStack(this);
		s=stacks[3];
		s.layout='spread_top';
		s.pickup='pickup_1';
		s.place='place_atok_same_1';
		s.mc._x=50+(100*5);
		s.mc._y=14+71;
// away 3
		stacks[4]=new WetStack(this);
		s=stacks[4];
		s.layout='spread_top';
		s.pickup='pickup_1';
		s.place='place_atok_same_1';
		s.mc._x=50+(100*6);
		s.mc._y=14+71;
// away 4
		stacks[5]=new WetStack(this);
		s=stacks[5];
		s.layout='spread_top';
		s.pickup='pickup_1';
		s.place='place_atok_same_1';
		s.mc._x=50+(100*7);
		s.mc._y=14+71;


// stack 1
		stacks[6]=new WetStack(this);
		s=stacks[6];
		s.layout='spread_down';
		s.pickup='pickup_weave';
		s.place='place_weave';
		s.mc._x=50+(100*0);
		s.mc._y=14+71+142+12+10;
// stack 2
		stacks[7]=new WetStack(this);
		s=stacks[7];
		s.layout='spread_down';
		s.pickup='pickup_weave';
		s.place='place_weave';
		s.mc._x=50+(100*1);
		s.mc._y=14+71+142+12+10;
// stack 3
		stacks[8]=new WetStack(this);
		s=stacks[8];
		s.layout='spread_down';
		s.pickup='pickup_weave';
		s.place='place_weave';
		s.mc._x=50+(100*2);
		s.mc._y=14+71+142+12+10;
// stack 4
		stacks[9]=new WetStack(this);
		s=stacks[9];
		s.layout='spread_down';
		s.pickup='pickup_weave';
		s.place='place_weave';
		s.mc._x=50+(100*3);
		s.mc._y=14+71+142+12+10;
// stack 5
		stacks[10]=new WetStack(this);
		s=stacks[10];
		s.layout='spread_down';
		s.pickup='pickup_weave';
		s.place='place_weave';
		s.mc._x=50+(100*4);
		s.mc._y=14+71+142+12+10;
// stack 6
		stacks[11]=new WetStack(this);
		s=stacks[11];
		s.layout='spread_down';
		s.pickup='pickup_weave';
		s.place='place_weave';
		s.mc._x=50+(100*5);
		s.mc._y=14+71+142+12+10;
// stack 7
		stacks[12]=new WetStack(this);
		s=stacks[12];
		s.layout='spread_down';
		s.pickup='pickup_weave';
		s.place='place_weave';
		s.mc._x=50+(100*6);
		s.mc._y=14+71+142+12+10;
		
// stack 8
		stacks[13]=new WetStack(this);
		s=stacks[13];
		s.layout='spread_down';
		s.pickup='pickup_weave';
		s.place='place_weave';
		s.mc._x=50+(100*7);
		s.mc._y=14+71+142+12+10;
		
		top_back_stack_depth=mc.newdepth;
	

// ghost placement stack
		stacks[#(STACK_GHOST)]=new WetStack(this);
		s=stacks[#(STACK_GHOST)];
		s.layout='spread_down';
		s.pickup='pickup_0';
		s.place='place_0';
		s.mc._alpha=50;

// stack in hand
		stacks[#(STACK_HAND)]=new WetStack(this);
		stacks[#(STACK_HAND)].mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 10, 10, 2, 3) ];

		s=stacks[#(STACK_HAND)];
		s.layout='spread_down';
		s.pickup='pickup_0';
		s.place='place_0';

// deal all cards to a pile
		s=stacks[0];
		s.add_all_cards(mdeal(up.seed));
//		s.shuffle();
		up.pack_code=s.pack_code();


// do natural deal
		for(j=0;j<8;j++)
		{
			for(i=0;i<8;i++)
			{
				if(s.cards.length>0)
				{
					s.deal(1,stacks[6+i]);
				}
			}
		}
/*
		s.deal(1,stacks[6]);
		s.deal(2,stacks[7]);
		s.deal(3,stacks[8]);
		s.deal(4,stacks[9]);
		s.deal(5,stacks[10]);
		s.deal(6,stacks[11]);
		s.deal(7,stacks[12]);
*/
		
//		s.deal(3,stacks[1]);

/*
		for(i=0;i<1;i++) { stacks[7].cards[i].setback(true); }
		for(i=0;i<2;i++) { stacks[8].cards[i].setback(true); }
		for(i=0;i<3;i++) { stacks[9].cards[i].setback(true); }
		for(i=0;i<4;i++) { stacks[10].cards[i].setback(true); }
		for(i=0;i<5;i++) { stacks[11].cards[i].setback(true); }
		for(i=0;i<6;i++) { stacks[12].cards[i].setback(true); }
		for(i=0;i<s.cards.length;i++) { s.cards[i].setback(true); }
*/

		for(i=0;i<stacks.length;i++)
		{
			stacks[i].spread_layout_force();
		}

		mc_tint=gfx.create_clip(mc,null);
		
		mc_moves=gfx.create_clip(mc,null);
		
		mc_score=gfx.create_clip(mc,null);
	    mc_score.filters = [ new flash.filters.DropShadowFilter(2, 45, 0x000000, 1, 4, 4, 2, 3) ];
//		tf_score_shadow=gfx.create_text_html(mc_score,null,800-200+2,600-50+2,200,50);
		tf_score=gfx.create_text_html(mc_score,null,800-200,600-50,200,50);
		
		mc_status=gfx.create_clip(mc,null);
	    mc_status.filters = [ new flash.filters.DropShadowFilter(1, 45, 0x000000, 1, 2, 2, 2, 3) ];
//		tf_status_shadow=gfx.create_text_html(mc_status,null,2,600-32+2,200,50);
		tf_status=gfx.create_text_html(mc_status,null,0,600-32,200,50);
		status_fade=0;
		
		last_status="";
		new_status="";
		

		check_moves();
		
		menu=new PlayMenu(this);
		menu.setup();
	}

	function clean()
	{
		menu.clean();
		
		delete stacks;
		mc.removeMovieClip();
	}

/*
	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}
*/

	function get_word()
	{
	var d,dn;
	
		d=rnd();
		dn=d%(Login.txt_nouns.length-1);
		
		return Login.txt_nouns[dn];
	}

// check what can be moved and to where, fills up the moves array with current valid moves
	function check_moves()
	{
	var m;
	var i,j;
	var s,c;
	
		free_cells=0; // max number of cards you can move at once
	
		for(i=0;i<#(STACK_HAND);i++)
		{
			s=stacks[i];
			if((i>=2)&&(i<=5)) // away stacks are not freecells
			{
			}
			else
			{
				if(s.cards.length==0)
				{
					free_cells++;
				}
			}
		}
//		if(free_cells<1) { free_cells=1; } // can always move 1 card
		
		for(i=0;i<moves_valid.length;i++)
		{
			m=moves_valid[i];
			m.clean();
		}
		
		moves_valid=new Array();
		
// deal cards? anypoint? block user if no point
/*
		if( (stacks[0].cards.length > 0 ) || ( stacks[1].cards.length > 3 ) )
		{
			m=new WetMove(this);
			
			m.set(0,1,1);
			m.txt=get_word();
			
			moves_valid[moves_valid.length]=m;
		}
*/		
				
// check available moves

		var done_away_a=false;
		var done_away_k=false;
		var done_away_a_new=false;
		var done_away_k_new=false;

		for(i=#(STACK_HAND)-1;i>=0;i--)
		{
			s=stacks[i];
			
			done_away_a=done_away_a_new;
			done_away_k=done_away_k_new;
				
			for(j=0;j<=#(STACK_HAND)-1;j++)
			{
				if(j==i) continue; // no move to self
				
				c=0;
				if(stacks[j].cards.length)
				{
					if((j>=1)&&(j<=5))
					{
						c=s.place_test(stacks[j],1);
					}
					else
					{
						c=s.place_test(stacks[j]);
					}
				}
				
				if(c>0)
				{
					m=new WetMove(this);
					m.set(j,i,c);
					moves_valid[moves_valid.length]=m;

					if((i>=2)&&(i<=5)&&(j>=2)&&(j<=5)) // no rearange away stack
					{
						m.hide=true;
					}
					else
					if((i>=2)&&(i<=5))
					{
						if(s.cards.length==0)
						{
							if(done_away_a==false)
							{
								done_away_a_new=true;
							}
							else
							{
								m.hide=true;
							}
						}
					}
					else
					if((i>=6)&&(i<=13))
					{
						if(s.cards.length==0)
						{
							if(done_away_k==false)
							{
								done_away_k_new=true;
							}
							else
							{
								m.hide=true;
							}
						}
					}
					
					if((j>=2)&&(j<=5)) // moving back from put away pile
					{
						m.arrange=true;
					}
					
					if( (stacks[j].cards.length>c) && (j>=6) )// all of them
					{
						// a partial move, check the one before, if its visible then lower priority this move
						if(stacks[j].cards[stacks[j].cards.length-(c+1)].back==false)
						{
							m.arrange=true;
						}						
					}
					
					m.txt=get_word();
				}
			}
		}
		
// allow an expensive undeal of one card to solve unsolvable packs
/*
		if( ( stacks[1].cards.length > 2 ) )
		{
			m=new WetMove(this);
			
			m.set(1,0,1);
			m.txt=get_word();
			
			moves_valid[moves_valid.length]=m;
		}
*/
		draw_moves();
	}
// draw the available moves
	function draw_moves()
	{
	
		return;
		
		
		var mc;
		var i;
		var im;
		var m;
		
		var fs,ts;
		var fc,tc;
		
		var offstack=[0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		var offmax;
		
		if(!mc_tint.done)
		{
		
			gfx.clear(mc_tint);
			mc_tint.style.fill=0xa0ffffff;
//			gfx.draw_box(mc_tint,0,0,0,800,600);
			mc.tint.done=true;
			mc_tint.cacheAsBitmap=true;
		}
		
		gfx.clear(mc_moves);
			
		for(i=0;i<moves_valid.length;i++)
		{
			m=moves_valid[i];
			
			if(m.hide) { continue; }
			
			mc=m.mc;
			mc.clear();
					
			fs=stacks[m.from];
			ts=stacks[m.to];
			
			fc=fs.cards[fs.cards.length-m.len];
			tc=ts.cards[ts.cards.length-1];

			offstack[m.from]++;
			offstack[m.to]++;
			
			if(offstack[m.from]>offstack[m.to])
			{
				offmax=offstack[m.from];
			}
			else
			{
				offmax=offstack[m.to];
			}
			
			if((m.from>=6)&&(m.to>=6)) // special case for left-right movement
			{
				if(m.from>m.to)
				{
					for(im=m.to;im<m.from;im++)
					{
						offstack[im]=offmax;
					}
				}
				else
				{
					for(im=m.from;im<m.to;im++)
					{
						offstack[im]=offmax;
					}
				}
			}
			else
			{
				offstack[m.from]=offmax;
				offstack[m.to]=offmax;
			}
			
			if(fc)
			{	
				m.fx=fs.mc._x + fc.x;
				m.fy=fs.mc._y + fc.y;
			}
			else
			{
				m.fx=fs.mc._x;
				m.fy=fs.mc._y;
			}
			
			if(tc)
			{	
				m.tx=ts.mc._x + tc.x;
				m.ty=ts.mc._y + tc.y;
			}
			else
			{
				m.tx=ts.mc._x;
				m.ty=ts.mc._y;
			}
			
			if(m.arrange)
			{
				mc_moves.lineStyle(32,0x000000,50);
			}
			else
			{
				mc_moves.lineStyle(32,0x000000,100);
			}
			
			m.fy-=30;
			m.ty-=30;
			
			m.fy+=(offmax-1)*40;
			m.ty+=(offmax-1)*40;
			

			m.position_mcs();
			
			mc_moves.moveTo(m.fx,m.fy);
			mc_moves.lineTo(m.tx,m.ty);
			
		}
		
		mc_moves._alpha=50;
		
	}
	
	
	
// check where we can place the floating cards
	function check_placements()
	{
	var s,s1;
	var i;
	var f,fx,fy;
	var t,tx,ty;
	
	
		s=stacks[#(STACK_HAND)];
		f=s.cards[0];
		fx=s.mc._x+f.x;
		fy=s.mc._y+f.y;
		
		for(i=0;i<#(STACK_HAND);i++)
		{
			s=stacks[i];
			t=s.cards[s.cards.length-1];
			tx=s.mc._x+s.place_x;
			ty=s.mc._y+s.place_y;
			if(i==from_stack)
			{
				s.place_legal=true;
			}
			else
			{
				if( (stacks[#(STACK_HAND)].cards.length>0) && (s.place_test(stacks[#(STACK_HAND)])==stacks[#(STACK_HAND)].cards.length) )
				{
					s.place_legal=true;
				}
				else
				{
					s.place_legal=false;
				}
				
// extra special free cell rule, some places are invalid if we are holding too many cards
				if(stacks[#(STACK_HAND)].cards.length>free_cells) // we are holding more cards than we have free cells
				{
					if(s.cards.length==0) // so we can not place in a freecell, only ontop of another stack
					{
						s.place_legal=false;
					}
				}
			}
			
			if(i==from_stack) // weight away from where we started
			{
				s.place_pos=((fx-tx)*(fx-tx))+((fy-ty)*(fy-ty));
				s.place_pos=s.place_pos*s.place_pos/512;
			}
			else
			if( ((i==0)||(i==1)||(i==14)||(i==15)) && ((from_stack==0)||(from_stack==1)||(from_stack==14)||(from_stack==15)) )
			{ // weight away from free cells if we started on a freecell
				s.place_pos=((fx-tx)*(fx-tx))+((fy-ty)*(fy-ty));
				s.place_pos=s.place_pos*s.place_pos/512;
			}
			else
			if( ((i==0)||(i==1)||(i==14)||(i==15)) )
			{ // weight away from free cells even if we didnt start on one
				s.place_pos=((fx-tx)*(fx-tx))+((fy-ty)*(fy-ty));
				s.place_pos=s.place_pos*2;
			}
			else
			if((i>=2) && (i<=5)) // weight towards put away stacks,
			{
				s.place_pos=(Math.abs(fx-tx)+Math.abs(fy-ty))+100*100;
			}
			else // normal weighting (distance squared)
			{
				s.place_pos=((fx-tx)*(fx-tx))+((fy-ty)*(fy-ty));
			}
			
		}

		to_stack=from_stack;
		s1=stacks[to_stack];
		for(i=0;i<#(STACK_HAND);i++)
		{
			s=stacks[i];
			
			if(s.place_legal)
			{
				if(s.place_pos<s1.place_pos)
				{
					to_stack=i;
					s1=stacks[i];
				}
			}
		}
		
	}
	
	function reset_all_anims()
	{
	var i;
	
// reset all animations in progress		
		for(i=0;i<animcards.length;i++)
		{
			if(animcards[i])
			{
				animcards[i].snap();
				
				if(animcards[i].done)
				{
					delete animcards[i];
					animcards.splice(i,1);
					i=i-1;
				}
			}
		}
	}

	function deal_from_stack()
	{
	var s,s1,s2;
	var x,y;
	var i,j,n;
	var top;

		s=stacks[0];
		
		n=s.cards.length;
		
		s1=stacks[1];

		if(n>=3)
		{
			add_animcard();
			set_animcard_from(1,s.cards[s.cards.length-1]);
			
			s.deal(1,s1,false);
			s1.cards[s1.cards.length-1].x=24+((0%3)*((112-48)/2));
			s1.cards[s1.cards.length-1].y=0;
			
			add_animcard();
			set_animcard_from(1,s.cards[s.cards.length-1]);
			
			s.deal(1,s1,false);
			s1.cards[s1.cards.length-1].x=24+((1%3)*((112-48)/2));
			s1.cards[s1.cards.length-1].y=0;
			
			add_animcard();
			set_animcard_from(1,s.cards[s.cards.length-1]);
			
			s.deal(1,s1,false);
			s1.cards[s1.cards.length-1].x=24+((2%3)*((112-48)/2));
			s1.cards[s1.cards.length-1].y=0;

			s1.spread_layout();
			
			set_animcard_to(3,s1.cards[s1.cards.length-1]);
			set_animcard_to(2,s1.cards[s1.cards.length-2]);
			set_animcard_to(1,s1.cards[s1.cards.length-3]);
			
			score-=10;

		}
		else
		if(n>0)
		{
			add_animcard();
			set_animcard_from(1,s.cards[s.cards.length-1]);
			
			s.deal(1,s1,false);
			s1.cards[s1.cards.length-1].x=24+((0%3)*((112-48)/2));
			s1.cards[s1.cards.length-1].y=0;
			
			if(n>1)
			{
				add_animcard();
				set_animcard_from(1,s.cards[s.cards.length-1]);
				
				s.deal(1,s1,false);
				s1.cards[s1.cards.length-1].x=24+((1%3)*((112-48)/2));
				s1.cards[s1.cards.length-1].y=0;
			}
			
			s1.spread_layout();
			
			if(n>1)
			{
				set_animcard_to(1,s1.cards[s1.cards.length-2]);
				set_animcard_to(2,s1.cards[s1.cards.length-1]);
			}
			else
			{
				set_animcard_to(1,s1.cards[s1.cards.length-1]);
			}
			
			score-=10;
		}
		else
		{
			n=s1.cards.length;
			for(i=0;i<n;i++) // flip over back onto stack
			{
				add_animcard();
				set_animcard_from(1,s1.cards[s1.cards.length-1]);
				
				s1.deal(1,s,true);
			}
			
			s.spread_layout();
			
			for(i=0;i<n;i++) // flip over back onto stack
			{
				set_animcard_to(1+i,s.cards[s.cards.length-(n-i)]);
			}
		}
		
		sfx_deal();
	}
	
	function to_from_stack_scores()
	{
		if(to_stack!=from_stack) // a move
		{
			if((from_stack==1) && (to_stack==0)) // undeal move
			{
				score-=1000;
			}
			else
			if((from_stack>=2) && (from_stack<=5))
			{
				if((to_stack>=2) && (to_stack<=5)) // free to arrange aces
				{
//							score+=0;
				}
				else	
				{
					score-=101;
				}
			}
			else
			{
				if((to_stack>=2) && (to_stack<=5))
				{
					score+=100;
				}
				else
				{
					score-=1;
				}
			}
		}
	}

	function flip_tops()
	{
	var i;
	var s;
	var c;
	
/*
		for(i=6;i<=12;i++)
		{
			s=stacks[i];
			
			if(s.cards.length>0)
			{
				c=s.cards[s.cards.length-1];
				
				if(c.back==true)
				{
					score+=10;
					c.setback(false);
					s.spread_layout_force();
					
					sfx_flip();
				}
			}
		}
*/	
	}
					
	function update()
	{
	var s,s1,s2;
	var x,y;
	var i,j,n;
	var top;

	
		if(_root.popup)
		{
			return;
		}

		menu.update();
//		update_ads();
		
		
//		draw_moves();
		
		
		frame_time++;
				
//		x=up.up.replay.mouse_x+400;
//		y=up.up.replay.mouse_y+300;

		var pok=_root.poker.snapshot();
		mc.globalToLocal(pok);
		x=pok.x;
		y=pok.y;

// fadeout ghosts

		if(stacks[#(STACK_GHOST)].fadeout==true)
		{
			stacks[#(STACK_GHOST)].mc._alpha*=0.75;
			if(stacks[#(STACK_GHOST)].mc._alpha<1)
			{
				stacks[#(STACK_GHOST)].fadeout=false;
				stacks[#(STACK_GHOST)].clear_cards();
				stacks[#(STACK_GHOST)].mc._alpha=50;
			}
		}
		else
		{
				stacks[#(STACK_GHOST)].mc._alpha=50;
		}
		
		if(playback) // checking a replay string
		{
			if(playback_index>=playback.length) // endof
			{
				playback_done=true;
			}
			else
			if(playback_count<=0)
			{
			var idx;
			var mve;
			var m;
			
				reset_all_anims();
			
				playback_count=playback_count_time;
				
				check_moves();
				idx=playback[playback_index];
				mve=moves_valid[idx];
				
				
				
				s=" AVAIL ";
				for(i=0;i<moves_valid.length;i++)
				{
					m=moves_valid[i];
					s+=" ( "+m.from+" -> "+m.to+" ) ";
				}
				
				if(mve==undefined)
				{
					dbg.print(idx+" BORKED "+s);
//					while(1){}
				}
					
//				dbg.print(idx);
/*				
				if((mve.from==0)&&(mve.to==1)) // a deal
				{
					deal_from_stack();
					
//					dbg.print(idx+" MOVE DEAL "+s);
					
					playback_index++;
				}
				else
*/
				{
					to_stack=mve.to;
					from_stack=mve.from;
					n=mve.len;					
					for(i=stacks[from_stack].cards.length-n;i<stacks[from_stack].cards.length;i++) // animate
					{
						add_animcard();
						set_animcard_from(1,stacks[from_stack].cards[i]);
					}
					
					stacks[from_stack].deal(n,stacks[to_stack]);
					stacks[#(STACK_GHOST)].fadeout=true;//clear_cards();
					
					for(i=0;i<n;i++) // animate
					{
						set_animcard_to(n-i,stacks[to_stack].cards[stacks[to_stack].cards.length-(n-i)]);
					}
				
					to_from_stack_scores();
					sfx_slide();
					
					flip_tops();
					
//					dbg.print(idx+" MOVE "+from_stack+" -> "+to_stack+s);
					
					playback_index++;
				}
			}
			else
			{
				playback_count--;
			}
		}
		else // mouse control
		{

//		if(up.up.replay.key_on&Replay.KEYM_MBUTTON) // if key down
		if(_root.poker.poke_down)
		{

// reset all animations in progress
			reset_all_anims();
				
/*
			if(from_stack==-1)
			{
				s=stacks[0];
				top=s.cards[s.cards.length-1];
				if( (x>s.mc._x-#(CARD_WIDTH_O2)) && (x<s.mc._x+#(CARD_WIDTH_O2)) && (y>s.mc._y-#(CARD_HEIGHT_O2)) && (y<s.mc._y+#(CARD_HEIGHT_O2)) )
				{
					from_stack=0;
					hand_x=x-(s.mc._x); 
					hand_y=y-(s.mc._y);
				}
			}			
			if(from_stack==-1)
			{
				s=stacks[1];
				top=s.cards[s.cards.length-1];
				if(top)
				{
					if( (x>top.get_x()-#(CARD_WIDTH_O2)) && (x<top.get_x()+#(CARD_WIDTH_O2)) && (y>top.get_y()-#(CARD_HEIGHT_O2)) && (y<top.get_y()+#(CARD_HEIGHT_O2)) )
					{
						s1=stacks[#(STACK_HAND)];
						s2=stacks[#(STACK_GHOST)];
						from_stack=1;
						hand_x=x-(top.get_x()); 
						hand_y=y-(top.get_y());
						s.deal(1,s1,false);
						s1.spread_layout();
						s1.clone(s2);
						s2.fadeout=false;
					}
				}
			}
*/
			
			for(i=0;i<#(STACK_HAND);i++)
			{
				if(from_stack==-1)
				{
					s=stacks[i];
					var maxpick=s.pickupable;
					if(maxpick>free_cells+1) {maxpick=free_cells+1; }
					for(j=s.cards.length-1;j>=s.cards.length-maxpick;j--)
					{
						top=s.cards[j];
						if(top)
						{
					if( (x>top.get_x()-#(CARD_WIDTH_O2)) && (x<top.get_x()+#(CARD_WIDTH_O2)) && (y>top.get_y()-#(CARD_HEIGHT_O2)) && (y<top.get_y()+#(CARD_HEIGHT_O2)) )
							{
/*								if(top.back==true) // uncover a card
								{
									top.setback(false);
									score+=10;
									check_moves();
								}
*/								
								s1=stacks[#(STACK_HAND)];
								s2=stacks[#(STACK_GHOST)];
								from_stack=i;
								hand_x=x-(top.get_x()); 
								hand_y=y-(top.get_y());
								s.deal(s.cards.length-j,s1,false);
								s1.spread_layout();
								s1.clone(s2);
								s2.fadeout=false;
							
								break;
							}
						}
					}
				}
			}
		}


//		if(up.up.replay.key_off&Replay.KEYM_MBUTTON) // if key release
		if(_root.poker.poke_up && x<800)
		{
		
// moves == clicks

			moves++;

// deal cards
/*
			if(from_stack==0)
			{
				s=stacks[0];
				to_stack=0;
				
				if( (x>s.mc._x-#(CARD_WIDTH_O2)) && (x<s.mc._x+#(CARD_WIDTH_O2)) && (y>s.mc._y-#(CARD_HEIGHT_O2)) && (y<s.mc._y+#(CARD_HEIGHT_O2)) )
				{
					if( (stacks[0].cards.length>0) || (stacks[1].cards.length>3) )
					{
						deal_from_stack();
						to_stack=1;
					}
				}
			}
			else
*/
			if(stacks[#(STACK_HAND)].cards.length>0) // 1 or more cards in hand
			{				
				check_placements();
										
				if( (to_stack==from_stack) && (stacks[#(STACK_HAND)].cards.length==1) ) // a click
				{
					
					if( (lstclk_stack==to_stack) && ((frame_time-lstclk_time)<15) ) // a double click
					{
// try to put away
						if(stacks[2].place_legal) { to_stack=2;	}
						if(stacks[3].place_legal) { to_stack=3; }
						if(stacks[4].place_legal) { to_stack=4; }
						if(stacks[5].place_legal) { to_stack=5; }
					}
					
					
// record click and click time for next double click test

					lstclk_stack=to_stack;
					lstclk_time=frame_time;
					
					
					n=stacks[#(STACK_HAND)].cards.length;
					for(i=0;i<n;i++) // animate
					{
						add_animcard();
						set_animcard_from(1,stacks[#(STACK_HAND)].cards[i]);
					}
					
					stacks[#(STACK_HAND)].deal(stacks[#(STACK_HAND)].cards.length,stacks[to_stack]);
					stacks[#(STACK_GHOST)].fadeout=true;//clear_cards();

					for(i=0;i<n;i++) // animate
					{
						set_animcard_to(n-i,stacks[to_stack].cards[stacks[to_stack].cards.length-(n-i)]);
					}
					
					if(to_stack!=from_stack)
					{
						sfx_slide();
					}
					else
					{
						if( animcards[animcards.length-1].get_dist2()>#(CARD_WIDTH_O2)*#(CARD_WIDTH_O2) )
						{
							sfx_slide();
						}
					}
				}
				else
				{						
					sfx_slide();
				
					n=stacks[#(STACK_HAND)].cards.length;					
					for(i=0;i<n;i++) // animate
					{
						add_animcard();
						set_animcard_from(1,stacks[#(STACK_HAND)].cards[i]);
					}
						
					stacks[#(STACK_HAND)].deal(stacks[#(STACK_HAND)].cards.length,stacks[to_stack]);
					stacks[#(STACK_GHOST)].fadeout=true;//clear_cards();
					
					for(i=0;i<n;i++) // animate
					{
						set_animcard_to(n-i,stacks[to_stack].cards[stacks[to_stack].cards.length-(n-i)]);
					}
				}
				
				
				to_from_stack_scores();				
			}
			else
			{

				if((lstclk_stack==-1)&&((frame_time-lstclk_time)<15)) // double click background to auto put away
				{
					to_stack=-1;
						
					for(i=0 ; (i<#(STACK_HAND))&&(to_stack<0) ; i++ )
					{
						if((i>1) && (i<6)) { continue; }				
						if(stacks[i].cards.length<1) { continue; }
						if(stacks[i].cards[stacks[i].cards.length-1].back==true) { continue; }
						
						stacks[i].deal(1,stacks[#(STACK_HAND)]);

// try to put away
						if(stacks[2].place_test(stacks[#(STACK_HAND)])==stacks[#(STACK_HAND)].cards.length) { to_stack=2; }
						if(stacks[3].place_test(stacks[#(STACK_HAND)])==stacks[#(STACK_HAND)].cards.length) { to_stack=3; }
						if(stacks[4].place_test(stacks[#(STACK_HAND)])==stacks[#(STACK_HAND)].cards.length) { to_stack=4; }
						if(stacks[5].place_test(stacks[#(STACK_HAND)])==stacks[#(STACK_HAND)].cards.length) { to_stack=5; }
					
						if(to_stack!=-1) // found a card to move
						{
							from_stack=i;
						
							stacks[#(STACK_HAND)].deal(1,stacks[from_stack]);
							stacks[from_stack].spread_layout();
						
							add_animcard();
							set_animcard_from(1,stacks[from_stack].cards[stacks[from_stack].cards.length-1]);
							
							stacks[from_stack].deal(1,stacks[to_stack]);
							stacks[#(STACK_GHOST)].fadeout=true;//clear_cards();

							set_animcard_to(1,stacks[to_stack].cards[stacks[to_stack].cards.length-1]);

							score+=100;
							
							sfx_slide();
						}
						else
						{
							stacks[#(STACK_HAND)].deal(1,stacks[i]);
							stacks[from_stack].spread_layout();
						}
					}
					
				}
				
				lstclk_stack=-1;
				lstclk_time=frame_time;
			
			}
			
			if( (from_stack!=-1) && (from_stack!=to_stack) )
			{
			var movenum;
			var m;
			
				movenum=63; // duff move...
								
				s=" AVAIL ";
				for(i=0;i<moves_valid.length;i++)
				{
					m=moves_valid[i];
					s+=" ( "+m.from+" -> "+m.to+" ) ";
					
					if(m.from==from_stack)
					{
						if(from_stack==0)
						{
							if(m.to==1)
							{
								movenum=i;
							}
						}
						else
						{
							if(m.to==to_stack)
							{
								movenum=i;
							}
						}
					}
				}
				
				record[record.length]=movenum; // record

				if(from_stack==0)
				{
//					dbg.print(movenum+" MOVE DEAL "+s);
				}
				else
				{
//					dbg.print(movenum+" MOVE "+from_stack+" -> "+to_stack+s);
				}
			}
			
			stacks[to_stack].spread_layout();
			
			from_stack=-1;
			
			flip_tops();
			check_moves();
		}
		
		}
		
		s1=stacks[#(STACK_HAND)];
		s1.mc._x=x-hand_x;
		s1.mc._y=y-hand_y;

		if(stacks[#(STACK_HAND)].cards.length>0) // cards in hand
		{
			check_placements();
			
//			stacks[to_stack].spread_layout_force();
			
			stacks[#(STACK_GHOST)].mc._x=(stacks[to_stack].place_x*#(CARD_SCALE))+stacks[to_stack].mc._x;
			stacks[#(STACK_GHOST)].mc._y=(stacks[to_stack].place_y*#(CARD_SCALE))+stacks[to_stack].mc._y;
			
/*
			if(to_stack==0)
			{
				_root.poker.ShowFloat("This special move will cost you 1000pts and should only be done as a last resort.",1);
			}
*/
		}	

		
		update_score();
		
// handle all card animations


		for(i=0;i<animcards.length;i++)
		{
			if(animcards[i])
			{
				animcards[i].update();
				
				if(animcards[i].done)
				{
					delete animcards[i];
					animcards.splice(i,1);
					i=i-1;
				}
			}
		}
		
// check end game after animations finish
	
		if(animcards.length==0)
		{
			if	(
					(stacks[2].cards.length)
					+
					(stacks[3].cards.length)
					+
					(stacks[4].cards.length)
					+
					(stacks[5].cards.length)
					==
					52			
				)
			{
				if((!_root.popup)&&(!_root.audit)&&(!done_win))
				{
					_root.signals.signal("wetcell","won",this);
//					up.up.dikecomms.send_score();
					popup_win();
					done_win=true;
				}
			}
		}
		
	}
	
	function popup_win()
	{
		up.popup_won.setup();
/*
		var mc_popup;
		
		mc_popup=gfx.create_clip(_root.mc_popup,null);
		_root.popup=mc_popup;
		
		mc_popup._y=200;
		
		mc_popup.mc1=gfx.add_clip(mc_popup,'won',null);
		mc_popup.mc1.gotoAndStop(2);
		mc_popup.mc1._alpha=75;
		mc_popup.mc2=gfx.add_clip(mc_popup,'won',null);
		mc_popup.mc2.gotoAndStop(3);
		mc_popup.mc3=gfx.add_clip(mc_popup,'won',null);
		mc_popup.mc3.gotoAndStop(4);
		
//		mc_popup.mc_front=gfx.add_clip(mc_popup,'won2',null);
		
*/
	}
	
	function add_animcard()
	{
		var ac;
		
		ac=new WetCardAnim(this);
		
		animcards.push(ac);
	}
	
	function set_animcard_from(i,from)
	{
		animcards[animcards.length-i].set_from(from);
	}
	
	function set_animcard_to(i,to)
	{
		animcards[animcards.length-i].set_to(to);
	}
	
// update score
	function update_score()
	{
	var s:String;

		if(score>score_max)
		{
			score_max=score;
		}
		
		mc.style.text=0xffffffff;
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#"+alt.Sprintf.format("%06x",mc.style.text&0xffffff)+"\">";
		s+="<p align=\"center\">";
		s+=score;
		s+="</p>";
		s+="</font>";
		tf_score.htmlText=s;
/*
		mc.style.text=0xff000000;
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#"+alt.Sprintf.format("%06x",mc.style.text&0xffffff)+"\">";
		s+="<p align=\"center\">";
		s+=score;
		s+="</p>";
		s+="</font>";
		tf_score_shadow.htmlText=s;
*/
	}

// update status
	function update_status()
	{
	var s:String;

		if(new_status)
		{
			last_status=new_status;
			status_fade=100;
			
			new_status=null;
		}
		
		
		mc.style.text=0xffffffff;
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"16\" color=\"#"+alt.Sprintf.format("%06x",mc.style.text&0xffffff)+"\">";
		s+="<p align=\"center\">";
		s+=last_status;
		s+="</p>";
		s+="</font>";
		tf_status.htmlText=s;
		tf_status._alpha=status_fade;
/*
		mc.style.text=0xff000000;
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"16\" color=\"#"+alt.Sprintf.format("%06x",mc.style.text&0xffffff)+"\">";
		s+="<p align=\"center\">";
		s+=last_status;
		s+="</p>";
		s+="</font>";
		tf_status_shadow.htmlText=s;
		tf_status_shadow._alpha=status_fade;
*/		
		status_fade*=(15/16);
	}


	function update_ads()
	{
	
		if(!done_ads)
		{
			if	(
					(mc_ads.getBytesTotal()>0)
					&&
					(mc_ads.getBytesTotal()==mc_ads.getBytesLoaded())
				)
			{
//				dbg.print("attempting advert import");
				
				
				_root.wetdike_import.setup_adverts(mc_ads);
					
				done_ads=true;
			}
		}
	}
//
// microsoft MSVC6 crt random number sequence
// http://www.mail-archive.com/cryptography@wasabisystems.com/msg02104.html
//
	var mrnd_num=1; // aparently starts at 1
	function mrnd_seed(n) { mrnd_num=n&0xffffffff; } // 32 bits of seed?
	function mrnd() // returns a number between 0 and 32767
	{
		mrnd_num = ( (mrnd_num * 214013) + 2531011) & 0xffffffff ;
        return((mrnd_num>>16) & 0x7fff);
	}
//
// microsoft freecell card sorting,
// http://solitairelaboratory.com/mshuffle.txt
//
	function mdeal(gamenumber)
	{
		var  i, j;                // generic counters
		var  wLeft = 52;          // cards left to be chosen in shuffle
		var deck,cards;            // deck of 52 unique cards

		/* shuffle cards */

		deck=[];
		cards=[];
		for (i = 0; i < 52; i++)      // put unique card in each deck loc.
		{
			deck[i] = i;
		}

		mrnd_seed(gamenumber);        // gamenumber is seed for rand()
		for (i = 0; i < 52; i++)
		{
			j = mrnd() % wLeft;
			cards[i] = deck[j];
			deck[j] = deck[--wLeft];
		}
		
		return cards;	
	}
	
}
