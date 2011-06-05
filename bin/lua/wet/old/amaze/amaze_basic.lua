--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--



------------------------------------------------------------------------
--
-- a basic director mind
--
-- run every mind tick deal with global level issues
--
------------------------------------------------------------------------
function amaze.mind_director_basic(item)

local ready

local chasing
local chase

	chasing=false

	sfx.stream( false )

	print(coroutine)
	print("yield",coroutine.yield)

	coroutine.yield("T","") -- first mind tick is used for setup


	if not opt.skip_prologue then -- second mind tick is used for dialogue display

		amaze.hudgizmos.prologue:display("center")
		amaze.pause_request(true)
		hud.choice=nil

		repeat

			ready=false
			if hud.choice=="exit" then
			
				opt.next_state("main_state_menu")
				ready=true
				
			elseif hud.choice=="start" then
			
				ready=true
				
			elseif hud.choice=="next" then
			
				opt.next_number(amaze.next_level)
				opt.next_state("main_state_amaze")
				ready=true
					
			end

			coroutine.yield("T","")

		until ready

	end

	opt.skip_prologue=false
	hud.hide()
	amaze.pause_request(false)

	sfx.stream( wet.amaze.data_dir .. "sfx/loop_chase_slow.ogg" )

	while true do


	

		chase=false

		for i,v in ipairs(amaze.antagonists) do

			if v.chase then chase=true end

		end



		if chase~=chasing then -- change muzak


			if chase then

				sfx.stream( wet.amaze.data_dir .. "sfx/loop_chase_fast.ogg" )

			else

				sfx.stream( wet.amaze.data_dir .. "sfx/loop_chase_slow.ogg" )

			end

			chasing=chase

		end


		if amaze.protagonist:score() == 0 then -- we are teh winnah

			if not journal.last.autosaved then	-- only save once

				journal.last.info.time=amaze.time_str(amaze.time()+1) -- need to add one as that is what will get displayed
				journal.last.info.score=amaze.protagonist:score()

				journal.save_journal_auto(journal.last,'amaze',opt.next_level(),string.format('%05d',opt.next_number()))
				journal.last.autosaved=true

			end

			amaze.hudgizmos.epilogue:display("center")
			amaze.pause_request(true)
			hud.choice=nil

			repeat

				ready=false
				if hud.choice=="exit" then
				
					opt.next_state("main_state_menu")
					ready=true
					
				elseif hud.choice=="retry" then
				
					opt.next_state("main_state_amaze")
					ready=true

				elseif hud.choice=="view" then
				
					journal.replay=journal.last
					opt.skip_prologue=true

					opt.next_state("main_state_amaze")
					ready=true
					
				elseif hud.choice=="next" then
				
					opt.next_number(amaze.next_level)
					opt.next_state("main_state_amaze")
					ready=true
					
				end

				coroutine.yield("T","")

			until ready

		elseif amaze.protagonist.trapped>10 then -- we are teh looser

			amaze.hudgizmos.epitaph:display("center")
			amaze.pause_request(true)
			hud.choice=nil

			repeat

				ready=false
				if hud.choice=="exit" then
				
					opt.next_state("main_state_menu")
					ready=true
					
				elseif hud.choice=="retry" then
				
					opt.skip_prologue=true
					opt.next_state("main_state_amaze")
					ready=true
					
				elseif hud.choice=="next" then
				
					opt.next_number(amaze.next_level)
					opt.next_state("main_state_amaze")
					ready=true
					
				end

				coroutine.yield("T","")

			until ready

		end


		coroutine.yield("T","")

	end

end



------------------------------------------------------------------------
--
-- process a contour 8x8 tile bitmap
--
------------------------------------------------------------------------

function amaze.load_cont_basic(filename)

	local cont,ckey,hm

	ckey=mmap.alloc()

	ckey.image=devil.alloc()
	ckey.image:load( wet.amaze.local_dir .. "basic/" .. "key_cont.png")
	ckey:cutup( 8 , 8 )


	cont=mmap.alloc()
	cont.image=devil.alloc()
	cont.image:load( wet.amaze.local_dir .. "basic/" .. filename)

	-- cut into 8x8 tiles
	cont:cutup( 8 , 8 )
	cont:merge()
	cont:keymap(ckey)


	hm=hmap.alloc()
	hm:build_from_mmap( cont , 1/4 )
	amaze.usehmap(hm)

end


------------------------------------------------------------------------
--
-- process a maze 8x8 tile bitmap
--
------------------------------------------------------------------------

function amaze.load_maze_basic(filename)

	local score_available=0

	local maze,mkey

	local item

	amaze.antagonists={}

	mkey=mmap.alloc()

	mkey.image=devil.alloc()
	mkey.image:load( wet.amaze.local_dir .. "basic/" .. "key_maze.png")
	mkey:cutup( 8 , 8 )


	maze=mmap.alloc()
	maze.image=devil.alloc()
	maze.image:load( wet.amaze.local_dir .. "basic/" .. filename)

	-- cut into 8x8 tiles
	maze:cutup( 8 , 8 )
	maze:merge()
	maze:keymap(mkey)

	local max_x=(maze.image:get("IL_IMAGE_WIDTH")/8)-1
	local max_y=(maze.image:get("IL_IMAGE_HEIGHT")/8)-1

	for y=0 , max_x do
		local tx,ty
		local i,c,face
		local s
		s=""

		for x= 0 , max_y do
		local t={}

			maze:get_master_tile(t,x,y)
			tx=t.x/16
			ty=t.y/16

			c=0
			i=0
			face=3

			if t.master~=t.base then

				if (ty)>0 then
					if (tx)>3 then
						i=2
					else
						i=0
					end

					face=math.mod(tx,4)+1

					c=ty
				else
					i=tx
				end
			end

			if i==1 then
				item=amaze.alloc_item("base")

				if x==0 or x==max_x or y==0 or y==max_y then -- its an edge piece
					item:setcell(x,y,0.5-0.125)
					item:setxox("objects/xox/solid_earth.xox")
					item:setsize(0.75)
				else
					item:setcell(x,y,0.5)
					item:setxox("objects/xox/acone.xox")
					item:setsize(1.0)
				end

				item.type="earth"
				item.name=item.type
				item:solid(true)
			end
			if i==2 then
				item=amaze.alloc_item("base")
				item:setcell(x,y,0.5)
				item:setxox("objects/xox/solid_fire.xox")
				item:setsize(0.25)
				item:setbob(x*y/256,0.5)
				item.type="fire"
				item.name=item.type
				item:score_init(1)

				item.pickup_sfx=amaze.sfx.pickup01
				score_available=score_available+item:score()
			end
			if i==3 then
				item=amaze.alloc_item("base")
				item:setcell(x,y,0.5)
				item:setxox("objects/xox/solid_aether.xox")
				item:setsize(0.25)
				item:setbob(x*y/256,0.5)
				item.type="aether"
				item.name=item.type
				item:score_init(5)

				item.pickup_sfx=amaze.sfx.pickup01
				score_available=score_available+item:score()
			end

			if c==1 then
				item=amaze.alloc_item("protagonist")
				item.name="protagonist"
				item.tweens=soul.create_tweens()
				item:solid(true)
				item:setcell(x,y,0)
				item:setsoul("me")
				item:setsize(0.75)
				item:setmind(amaze.mind_protagonist,"T")
				item.type="entity"
				item.facing=face

				amaze.protagonist=item
			end
			if c==2 then
				item=amaze.alloc_item("antagonist")
				item.name="antagonist1"
				item.tweens=soul.create_tweens()
				item:solid(true)
				item:setcell(x,y,0)
				item:setsoul("kriss")
				item:setsize(0.75)
				item:setmind(amaze.mind_antagonist,"T")
				item.type="entity"
				item.turn_pattern="LR"
				item.facing=face

				amaze.antagonists[ table.getn(amaze.antagonists)+1 ]=item
			end
			if c==3 then
				item=amaze.alloc_item("antagonist")
				item.name="antagonist2"
				item.tweens=soul.create_tweens()
				item:solid(true)
				item:setcell(x,y,0)
				item:setsoul("jess")
				item:setsize(0.75)
				item:setmind(amaze.mind_antagonist,"T")
				item.type="entity"
				item.turn_pattern="RLF"
				item.facing=face

				amaze.antagonists[ table.getn(amaze.antagonists)+1 ]=item
			end
			if c==4 then
				item=amaze.alloc_item("antagonist")
				item.name="antagonist3"
				item.tweens=soul.create_tweens()
				item:solid(true)
				item:setcell(x,y,0)
				item:setsoul("phee")
				item:setsize(0.75)
				item:setmind(amaze.mind_antagonist,"T")
				item.type="entity"
				item.turn_pattern="LFRF"
				item.facing=face

				amaze.antagonists[ table.getn(amaze.antagonists)+1 ]=item
			end

			if c==5 then
				item=amaze.alloc_item("clod")
				item:setcell(x,y,0.5)

				if		face==1		then

					item:setxox("objects/xox/aball.xox")
					item:rolls("XY")

				elseif	face==2		then

					item:setxox("objects/xox/atube_z.xox")
					item:rolls("X")

				elseif	face==3		then

					item:setxox("objects/xox/atube_x.xox")
					item:rolls("Y")

				elseif	face==4		then

					item:setxox("objects/xox/acube.xox")
					item:rolls("")

				end

				item.push_sfx=amaze.sfx.roll01

				item:setsize(1.00)
				item.type="clod"
				item.name=item.type
				item:solid(true)
			end

			s=s..i..i

		end
	--	print(s)
	end

	--print()


	-- set timer to count up and score to count down from all available things to pickup

	amaze.time_step(1)
	amaze.time_init(0)
	amaze.protagonist:score_init(score_available)

end



------------------------------------------------------------------------
--
-- initialize available sound effects
--
------------------------------------------------------------------------

amaze.sfx={}

amaze.sfx.pickup01=sfx.load(wet.amaze.data_dir .. "sfx/pickup01.wav")

amaze.sfx.slap01=sfx.load(wet.amaze.data_dir .. "sfx/slap01.wav")

amaze.sfx.roll01=sfx.load(wet.amaze.data_dir .. "sfx/roll01.wav")





--
-- Basic popup requester data
--


amaze.hudtabs={}
amaze.hudgizmos={}


function amaze.hudtabs.prefab(name_tab,name_gizmo,text)

	amaze.hudtabs[name_tab.."_text"].text=text
	amaze.hudgizmos[name_gizmo] = hud.alloc():build( amaze.hudtabs[name_tab] )

end

amaze.hudtabs.prologue_text={aspect=4.0,font="comic",color="0xff000000",text="Start."}
amaze.hudtabs.prologue=
{
	xalign=0,
	yalign=0,
	{
		handle="BTN_Window",
		style="cartoon",
		limit_wide=1,
		{
			limit_wide=1,
			amaze.hudtabs.prologue_text,
			{
				limit_high=1,
				{	button="BTN_ChoiceStart",	lua="hud.choice='start'",	{	text="Start.",	},	color=menu.colors.button_green },
				{	button="BTN_ChoiceNext",	lua="hud.choice='next'",	{	text="Skip.",	},	color=menu.colors.button_yellow },
				{	button="BTN_ChoiceExit",	lua="hud.choice='exit'",	{	text="Exit.",	},	color=menu.colors.button_red },
			},
		},
	},
}


amaze.hudtabs.epilogue_text={aspect=4.0,font="comic",color="0xff000000",text="Winnah."}
amaze.hudtabs.epilogue=
{
	xalign=0,
	yalign=0,
	{
		handle="BTN_Window",
		style="cartoon",
		limit_wide=1,
		{
			limit_wide=1,
			amaze.hudtabs.epilogue_text,
			{
				limit_high=1,
				{	button="BTN_ChoiceRetry",	lua="hud.choice='retry'",	{	text="Retry.",	},	color=menu.colors.button_green 	},
				{	button="BTN_ChoiceNext",	lua="hud.choice='next'",	{	text="Next.",	},	color=menu.colors.button_yellow 	},
				{	button="BTN_ChoiceExit",	lua="hud.choice='exit'",	{	text="Exit.",	},	color=menu.colors.button_red 	},
			},
			{
				limit_high=1,
				{	button="BTN_ChoiceView",	lua="hud.choice='view'",	{	text="View replay.",	},	color=menu.colors.button_green 	},
			},
		},
	},
}



amaze.hudtabs.epitaph_text={aspect=4.0,font="comic",color="0xff000000",text="loooser."}
amaze.hudtabs.epitaph=
{
	xalign=0,
	yalign=0,
	{
		handle="BTN_Window",
		style="cartoon",
		limit_wide=1,
		{
			limit_wide=1,
			amaze.hudtabs.epitaph_text,
			{
				limit_high=1,
				{	button="BTN_ChoiceRetry",	lua="hud.choice='retry'",	{	text="Retry.",	},	color=menu.colors.button_green 	},
				{	button="BTN_ChoiceNext",	lua="hud.choice='next'",	{	text="Skip.",	},	color=menu.colors.button_yellow 	},
				{	button="BTN_ChoiceExit",	lua="hud.choice='exit'",	{	text="Exit.",	},	color=menu.colors.button_red 	},
			},
		},
	},
}




