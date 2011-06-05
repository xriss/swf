--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--


------------------------------------------------------------------------
--
-- some words to shout.
--
------------------------------------------------------------------------

amaze.stop_words =	{
						XLT( "Stop!" ),
						XLT( "Cease!" ),
						XLT( "Desist!" ),
						XLT( "Stay!" ),
						XLT( "Halt!" ),
						XLT( "Hold!" ),
						XLT( "Wait!" ),
						XLT( "Abstain!" ),
						XLT( "Freeze!" ),
						XLT( "Thief!" ),
						XLT( "Purloiner!" ),
						XLT( "Pilferer!" ),
						XLT( "Filcher!" ),
						XLT( "Rapscallion!" ),
						XLT( "Vagabond!" ),
						XLT( "Cad!" ),
						XLT( "Bounder!" ),
						XLT( "Scoundrel!" ),
						XLT( "Blighter!" ),
						XLT( "Rotter!" ),
						XLT( "Forsooth!" ),
						XLT( "Gadzooks!" ),
						XLT( "Villian!" ),
						XLT( "Scallywag!" ),
						XLT( "Varlet!" ),
						XLT( "Scamp!" ),
						XLT( "Resistence is useless!" ),
						XLT( "Heel! Bitch!" ),
					}

function amaze.stop_words.random()

	return amaze.stop_words[ math.random(table.getn(amaze.stop_words)) ]

end

------------------------------------------------------------------------
--
-- build bidirectional lookup table of available turn char codes, left=1 , right=2, forwards=3 , backwards=4
--
-- this assumes that the numbers 1-4 and the character codes do not clash, this is almost almost always going to be true :)
--
-- this is used in AI turn pattern control
--
------------------------------------------------------------------------

amaze.turn_lookup =	{	[string.byte("L")]=1 ,
						[string.byte("R")]=2 ,
						[string.byte("F")]=3 ,
						[string.byte("B")]=4 ,
						[1]=string.byte("L") ,
						[2]=string.byte("R") ,
						[3]=string.byte("F") ,
						[4]=string.byte("B") }

------------------------------------------------------------------------
--
-- journal helpers
--
------------------------------------------------------------------------

amaze.journal={}


amaze.journal.seek=function(j,pos)

	j[1].seek(pos)

end


amaze.journal.read=function(j)

local v=j.v
local t

	t=j[1].read()

	v.rt=false
	v.lt=false
	v.dn=false
	v.up=false

	if t >= 8 then v.rt=true ; t=t-8 end
	if t >= 4 then v.lt=true ; t=t-4 end
	if t >= 2 then v.dn=true ; t=t-2 end
	if t >= 1 then v.up=true ; t=t-1 end


end

amaze.journal.write=function(j)

local v=j.v
local s,o
local up1,up3
local t

-- read keys

	s,o=KEYS['p1_up']()		;		v.k_up=s or o
	s,o=KEYS['p1_down']()	;		v.k_dn=s or o
	s,o=KEYS['p1_left']()	;		v.k_lt=s or o
	s,o=KEYS['p1_right']()	;		v.k_rt=s or o

-- adjust for view

	up1,up3=amaze.getview_uprt()

	if up1 > 0 then

		v.up=v.k_lt
		v.dn=v.k_rt
		v.lt=v.k_dn
		v.rt=v.k_up

	elseif up1 < 0 then

		v.up=v.k_rt
		v.dn=v.k_lt
		v.lt=v.k_up
		v.rt=v.k_dn

	elseif up3 > 0 then

		v.up=v.k_up
		v.dn=v.k_dn
		v.lt=v.k_lt
		v.rt=v.k_rt

	elseif up3 < 0 then

		v.up=v.k_dn
		v.dn=v.k_up
		v.lt=v.k_rt
		v.rt=v.k_lt

	else

		v.up=false
		v.dn=false
		v.lt=false
		v.rt=false

	end

-- conmpress into a single value and write to journal

	t=0

	if v.up then t=t+1 end
	if v.dn then t=t+2 end
	if v.lt then t=t+4 end
	if v.rt then t=t+8 end

	j[1].write(t)

end


function amaze.journal.create()

local j={}

	j[1]=journal.alloc_stream()

	j.v={}
	j.info={}

	amaze.journal.readwrite(j)

	return j
end




function amaze.journal.readwrite(j)

	j.read=amaze.journal.read
	j.write=amaze.journal.write
	j.seek=amaze.journal.seek

	j:seek(0)

	return j
end

function amaze.journal.readonly(j)

	j.read=amaze.journal.read
	j.write=function() end
	j.seek=amaze.journal.seek

	j:seek(0)

	return j
end

------------------------------------------------------------------------
--
-- return a scaled 3d vector as 3 arguments
--
------------------------------------------------------------------------
function amaze.scale_vec(vec,scale)

	return	vec[1]*scale,vec[2]*scale,vec[3]*scale

end

------------------------------------------------------------------------
--
-- get the y rotation(radians) and direction enum(lt,rt,up,dn) from a given vector input,
-- (vector is assumed to be aligned to an axis)
--
------------------------------------------------------------------------
function amaze.vec_to_yrot(vec)


	if			vec[1] < 0		then

		return	math.pi*0.5		, 1

	elseif		vec[1] > 0		then

		return	math.pi*-0.5	, 2

	elseif		vec[3] > 0		then

		return	math.pi			, 3

	elseif		vec[3] < 0		then

		return	0				, 4

	end

end

function amaze.dir_to_yrot(dir)


	if			dir==1		then

		return	math.pi*0.5

	elseif		dir==2		then

		return	math.pi*-0.5

	elseif		dir==3		then

		return	math.pi

	elseif		dir==4		then

		return	0

	end

end

------------------------------------------------------------------------
--
-- just walk/push in a specified direction for a given amount of ticks
--
------------------------------------------------------------------------
function amaze.mind_walk(item,vec,ticks)

local cx,cy
local dest
local solid

	item.state="walk"

	item:vel(vec[1],vec[2],vec[3])
	item.cellmove=ticks

	item:aim_yrot( amaze.vec_to_yrot(vec) , 2 )

	cx=0
	cy=0
	if vec[1]>0  then cx= 1 elseif vec[1]<0 then cx=-1 end
	if vec[3]>0  then cy=-1 elseif vec[3]<0 then cy= 1 end


	if amaze.iscell_solid(item.cellx+cx,item.celly+cy) then -- hit something


		solid=amaze.cell_find_solid(item.cellx+cx,item.celly+cy)

		if solid and solid:pushable() then

			item:vel(0,0,0)
			item.cellmove=0
			
			amaze.body_avatar_main_tween_to(item,"anim_push",4)
			
			
			for i=1,4 do -- get ready to push

				coroutine.yield("T","")
				
			end

--			if solid:push( cx , cy ) then -- we might move it
			
				solid:push( cx , cy )

				if solid.type=="clod" then 

					solid:setmind(amaze.mind_item_push,"T")

				end
				
				item:vel(vec[1],vec[2],vec[3])
						
				for i=1,ticks do -- do the push
				
					coroutine.yield("T","")
					
					if not amaze.iscell_solid(item.cellx+cx,item.celly+cy) then
					
						item:vel(vec[1],vec[2],vec[3])
--						item:placecell(item.cellx+cx,item.celly+cy)

					else
					
						item:vel(0,0,0)
					
					end

					
				end

				
				if amaze.iscell_solid(item.cellx+cx,item.celly+cy) then
				
					item:vel(-vec[1],-vec[2],-vec[3])
					
				else
				
					item:vel(0,0,0)
				
				end
				
				coroutine.yield("T","")
				item:vel(0,0,0)

			
--				for i=1,1 do -- finish splating
--					coroutine.yield("T","")
--				end
			
				amaze.body_avatar_main_tween_to(item,"anim_splat_to_idle",4)
			
				for i=1,1 do -- getup

					coroutine.yield("T","")
					
				end

				item:play(amaze.sfx.slap01,1,1) -- full sound no 3d

				for i=1,8 do -- getup

					coroutine.yield("T","")
					
				end
				
--			end
			
			return

		else
			
			item:vel(0,0,0)
			item.cellmove=0

		end


	end

	if item.cellmove~=0 then -- empty cell, move our colision position into it immediatly

		item:placecell(item.cellx+cx,item.celly+cy)

	end

	amaze.body_avatar_main_tween_to(item,"cycle_walk",4)

	while true do


		item.cellmove=item.cellmove-1


		if item.cellmove<=0 then

--			item:vel(0,0,0)
--			item.cellmove=0
			return

		end

		coroutine.yield("T","")
	end

end

------------------------------------------------------------------------
--
-- just idle for a while
--
------------------------------------------------------------------------
function amaze.mind_idle(item,ticks)

	item.state="idle"

	item:vel(0,0,0)
	item.cellmove=ticks

	amaze.body_avatar_main_tween_to(item,"cycle_breath",4)

	while true do

		item.cellmove=item.cellmove-1

		if item.cellmove<=0 then

			return

		end

		coroutine.yield("T","")
	end

end

------------------------------------------------------------------------
--
-- basic player initalisation function also used by evildudes
--
------------------------------------------------------------------------
function amaze.mind_avatar_init(item)

	item.state="init"

	item.cellmove=0

	item.walk_vel=1.0/0.6
	item.walk_wait=10*0.6		-- this should be an integer

-- direction vectors, (may be adjusted later acording to current view direction )

	item.lt_vec	={	-1	,	0	,	0	}
	item.rt_vec	={	1	,	0	,	0	}
	item.up_vec	={	0	,	0	,	1	}
	item.dn_vec	={	0	,	0	,	-1	}

	item.dir_vecs={ item.lt_vec , item.rt_vec , item.up_vec , item.dn_vec }

	item.chase=false

	item.trapped=0

	item:aim_yrot( amaze.dir_to_yrot(item.facing) , 0 )

	item:setbody(amaze.body_avatar,"T") ; amaze.body_avatar_setup(item)

end

------------------------------------------------------------------------
--
-- check current location for pickups
-- expects item.cell_contents to be valid
-- item passed in will be a protagonist
--
------------------------------------------------------------------------
function amaze.mind_avatar_pickup(item)

local do_score

	for i,v in ipairs( item.cell_contents ) do


		do_score=false

		if		v.type == "fire" then

			do_score=true
			v:setmind(amaze.mind_item_pickedup,"T")

		elseif	v.type == "aether" then

			do_score=true
			v:setmind(amaze.mind_item_pickedup,"T")

		end

		if do_score then -- apply pickup score

			if item:score_init() > 0 then -- we are counting down

				item:score( item:score() - v:score() )

				if item:score() < 0 then -- we are teh winnah

					item:score(0)
					amaze.time_step(0)

				end

			else -- we are counting up

				item:score( item:score() + v:score() )

			end

		end

	end

end


------------------------------------------------------------------------
--
-- logic for item behaviour on pickup
--
------------------------------------------------------------------------
function amaze.mind_item_pickedup(item)

	item.pickup_sfx:play(1,1) -- full sound no 3d

	item:swish()

	item:free()

end

------------------------------------------------------------------------
--
-- logic for item behaviour on push
--
------------------------------------------------------------------------
function amaze.mind_item_push(item)

-- play a sound effect everytime the mind gets called which is regulated in code

	while true do

		if item.push_sfx then

			item:play(item.push_sfx,1,1)

			coroutine.yield("T","") -- first mind tick is used for setup

		end

	end

end

------------------------------------------------------------------------
--
-- a basic protagonist mind
--
-- run every mind tick deal with inputs and make the body react to them
--
------------------------------------------------------------------------
function amaze.mind_protagonist(item)

--local vx,vy,vz

local freedom

	amaze.mind_avatar_init(item)

	if journal.replay then

		item.j=journal.replay

		amaze.journal.readonly(item.j)

		journal.replay=null	-- turn replay off

	else

		item.j=amaze.journal.create()

		journal.last=item.j	-- save this recording here

	end

-- test loading
--	item.j=journal.load_journal("local/replay/amaze_20050817/basic/00000/20050818_102712_me.xml")
--	amaze.journal.readonly(item.j)


	coroutine.yield("T","") -- first mind tick is used for setup

	while true do


		item.state="think"

--		item.up_vec[1] , item.up_vec[3] , item.rt_vec[1] , item.rt_vec[3] = amaze.getview_uprt()
--		item.dn_vec[1] , item.dn_vec[3] , item.lt_vec[1] , item.lt_vec[3] = -item.up_vec[1] , -item.up_vec[3] , -item.rt_vec[1] , -item.rt_vec[3]
--		item:getkeys()

		item.j:write()
		item.j:read()

		item.cellx , item.celly = item:snapcell() -- get curent cell and force center us on it (fixes any movement rounding errors)


		item.cell_contents=amaze.getcell_contents( item.cellx , item.celly )


-- check that we can still move, flag game over condition if not

		freedom=4
		if amaze.iscell_solid(item.cellx,item.celly+1) then freedom=freedom-1 end
		if amaze.iscell_solid(item.cellx,item.celly-1) then freedom=freedom-1 end
		if amaze.iscell_solid(item.cellx+1,item.celly) then freedom=freedom-1 end
		if amaze.iscell_solid(item.cellx-1,item.celly) then freedom=freedom-1 end
		if freedom==0 then item.trapped=item.trapped+1 else item.trapped=0 end


		amaze.mind_avatar_pickup(item)

--		vx,vy,vz=item:vel()
--		print( "x=" .. item.cellx .. " y=" .. item.celly )
--		print( "vx=" .. vx .. " vy=" .. vy  .. " vz=" .. vz )

		if item.j.v.lt then

			amaze.mind_walk( item, {amaze.scale_vec(item.lt_vec,item.walk_vel)} , item.walk_wait )

		elseif item.j.v.rt then

			amaze.mind_walk( item, {amaze.scale_vec(item.rt_vec,item.walk_vel)} , item.walk_wait )

		elseif item.j.v.dn then

			amaze.mind_walk( item, {amaze.scale_vec(item.dn_vec,item.walk_vel)} , item.walk_wait )

		elseif item.j.v.up then

			amaze.mind_walk( item, {amaze.scale_vec(item.up_vec,item.walk_vel)} , item.walk_wait )

		else

			amaze.mind_idle( item , 1 )
--			item:vel(0,0,0)

		end


		coroutine.yield("T","")

	end

end




------------------------------------------------------------------------
--
-- a basic antagonist mind
--
-- run every mind tick deal with inputs and make the body react to them
--
------------------------------------------------------------------------
function amaze.mind_antagonist(item)

local dir
local lt,rt,fd,bk
local turns
local next

	lt={}
	rt={}
	fd={}
	bk={}
	turns={lt,rt,fd,bk}

	amaze.mind_avatar_init(item)

	item.turn_idx=1

	coroutine.yield("T","") -- first mind tick is used for setup

	while true do

--print( item.name .. " " .. item.state .. "\n" )

		item.state="think"


		item.cellx , item.celly = item:snapcell() -- get curent cell and force center us on it (fixes any movement rounding errors)


		if		item.facing==1 then

			lt.dir=4
			rt.dir=3
			fd.dir=1
			bk.dir=2

		elseif	item.facing==2 then

			lt.dir=3
			rt.dir=4
			fd.dir=2
			bk.dir=1

		elseif	item.facing==3 then

			lt.dir=1
			rt.dir=2
			fd.dir=3
			bk.dir=4

		elseif	item.facing==4 then

			lt.dir=2
			rt.dir=1
			fd.dir=4
			bk.dir=3

		end

		for i,v in ipairs( turns ) do


			v.vec=item.dir_vecs[v.dir]
			v.cx=item.cellx+v.vec[1]
			v.cy=item.celly-v.vec[3]
			v.solid=amaze.iscell_solid(v.cx,v.cy)
			v.look=amaze.cell_find_solid(v.cx,v.cy,v.dir)

		end


		next=nil

		if not fd.solid then

			if item.chase==true then -- keep going till we hit something

				next=fd

			elseif ( lt.solid ) and ( rt.solid ) then -- no choice afailable, move forwards

				next=fd

			end

		else -- possibly a t junction or a dead end

			if not fd.look or fd.look.name~="protagonist" then

				item.chase=false

			end


			if		( lt.solid ) and ( rt.solid ) then -- no choice available, move backwards

				next=bk

			elseif	( not lt.solid ) and ( rt.solid ) then -- no choice available, move left

				next=lt

			elseif	( lt.solid ) and ( not rt.solid ) then -- no choice available, move right

				next=rt

			end

		end


		for i,v in ipairs( turns ) do

			if v.look and v.look.name=="protagonist" then -- chase em

				next=v

				if not item.chase then

					item.chase=true

					item:say(amaze.stop_words.random())

				end

			end

		end


		if next==nil then -- pick the next choice from the turn pattern

			next = turns[ amaze.turn_lookup[ string.byte( item.turn_pattern , item.turn_idx ) ] ]

			item.turn_idx=item.turn_idx+1

			if item.turn_idx > string.len(item.turn_pattern) then item.turn_idx=1 end

			if next.solid then next=fd end -- if we couldnt move left or right then try forwards again

		end


		
		if next and ( ( not next.solid ) or ( next.look and next.look.name=="protagonist" ) ) then -- we made a good choice

			item.facing=next.dir

			amaze.mind_walk( item, { amaze.scale_vec( item.dir_vecs[next.dir] , item.walk_vel ) } , item.walk_wait )

		else

			amaze.mind_idle( item , 1 )

		end


		coroutine.yield("T","")

	end

end

------------------------------------------------------------------------
--
-- a basic avatar body , protagonist or antagonist
--
-- setup then run every body tick deal with mind comands and update the body
--
------------------------------------------------------------------------
function amaze.body_avatar_setup(item)

	soul.set_tween(item.tweens[1],"cycle_breath")
	item.tweens[1].frame=0
	item.tweens[1].blend=1

	soul.set_tween(item.tweens[2],"cycle_breath")
	item.tweens[2].frame=0
	item.tweens[2].blend=0

	item.tweens.main_base=1
	item.tweens.main_dest=2
	item.tweens.main_blend_speed=0

end

function amaze.body_avatar(item)

local ts,t1,t2
local s


	ts=item.tweens


	while true do

		s=amaze.body_step()

		t1=ts[ts.main_base]
		t2=ts[ts.main_dest]

		if ts.main_blend_speed ~= 0 then -- we are tweening\

			amaze.body_avatar_main_tween_update(item)

		end

		if t1.blend~=0 then

			t1.frame=t1.frame+s
			if t1.length<t1.frame then t1.frame=t1.frame-t1.length end

		end

		if t2.blend~=0 then

			t2.frame=t2.frame+s
			if t2.length<t2.frame then t2.frame=t2.frame-t2.length end

		end

		coroutine.yield("T","")

	end

end


------------------------------------------------------------------------
--
-- set a new destination anim to tween too
--
-----------------------------------------------------------------------
function amaze.body_avatar_main_tween_to(item,name,speed)

local ts,t1,t2

local ID

--	speed=speed|0.1

	ID=soul.info.anims[name]

	ts=item.tweens

	if ts.main_blend_speed ~= 0 then -- we are already doing a blend

		t1=ts[ts.main_base]
		t2=ts[ts.main_dest]

		if t1.ID==ID then -- we are already tweening from so just swap base/dest and set speed

			ts.main_base , ts.main_dest = ts.main_dest , ts.main_base
			ts.main_blend_speed=speed
			return

		end
		
		if t2.ID==ID then -- we are already tweening too so just set speed

			ts.main_blend_speed=speed
			return

		end

-- this is a new anim so snap old blending to dest anim before we do anything else

		t1.blend=0
		t2.blend=1
		ts.main_base , ts.main_dest = ts.main_dest , ts.main_base
		ts.main_blend_speed=0

	else

		t1=ts[ts.main_base]

		if t1.ID==ID then -- already tweened to this anim so do nothing

			return

		end

	end

	ts.main_blend_speed=speed

	t2=ts[ts.main_dest]

	soul.set_tween(t2,name)
	t2.frame=0

end

------------------------------------------------------------------------
--
-- update animated tweening between the 2 basic animations
--
-----------------------------------------------------------------------
function amaze.body_avatar_main_tween_update(item)

local ts,t1,t2
local s

	ts=item.tweens

	s=amaze.body_step()

--	if ts.main_blend_speed ~= 0 then -- we are tweening

		t1=ts[ts.main_base]
		t2=ts[ts.main_dest]

		t1.blend=t1.blend-(ts.main_blend_speed*s)
		t2.blend=t2.blend+(ts.main_blend_speed*s)

		if t1.blend<0 or t2.blend>1 then -- blend has finished

			t1.blend=0
			t2.blend=1
			ts.main_base , ts.main_dest = ts.main_dest , ts.main_base
			ts.main_blend_speed=0

		end

--	end

end

------------------------------------------------------------------------
--
-- load in more files
--
------------------------------------------------------------------------

dofile( wet.amaze.lua_dir .. "amaze_basic.lua")