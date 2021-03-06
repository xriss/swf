
-- build your own dungeon
--
-- a little bit hacky but hey, i didnt knw how i was going to do it when i started :)

local _G=_G

local win=win

local table=table
local ipairs=ipairs
local string=string
local math=math
local os=os

local setfenv=setfenv
local unpack=unpack

local gl=gl


local function print(...) _G.print(...) end


module("wet.state.rouge.map")

local a_space=string.byte(" ",1)
local a_under=string.byte("_",1)
local a_star=string.byte("*",1)
local a_hash=string.byte("#",1)
local a_dash=string.byte("-",1)
local a_dot=string.byte(".",1)


function create(level)

	local d=build_map(level)
	
	return d
end


function build_map(level)
	
local d={}

local asc={}
local asc_xh=0
local asc_yh=0	


function d.rand_weight_change()

local a
	d.rx={}
	d.ry={}
	
	d.ry[-1]=0
	for y=0,asc_yh-1 do
		d.ry[y]=0
		for x=0,asc_xh-1 do
			a=d.get_asc(x,y)
			if a~=a_dot then
				d.ry[y]=d.ry[y]+1
				d.ry[-1]=d.ry[-1]+1
			end
		end
	end
	
	d.rx[-1]=0
	for x=0,asc_xh-1 do
		d.rx[x]=0
		for y=0,asc_yh-1 do
			a=d.get_asc(x,y)
			if a~=a_dot then
				d.rx[x]=d.rx[x]+1
				d.rx[-1]=d.rx[-1]+1
			end
		end
	end
end

function d.rand_weight_xy()

	local r
	
	r=d.rand(0,d.rx[-1]-1)
	for i=0,asc_xh-1 do
		r=r-d.rx[i]
		if r<=0 then
			d.x=i
			break
		end
	end

	r=d.rand(0,d.rx[-1]-1)
	for i=0,asc_yh-1 do
		r=r-d.ry[i]
		if r<=0 then
			d.y=i
			break
		end
	end
	
end

function d.rand_xy_door(room)
	local r=d.rand(1,4) -- pick a wall
	
	if r==1 then 
		d.x=room.x-1
		d.y=d.rand(room.y+1,room.y+room.yh-2)
		d.vx=-1
		d.vy=0
	elseif r==2 then 
		d.x=room.x+room.xh
		d.y=d.rand(room.y+1,room.y+room.yh-2)
		d.vx=1
		d.vy=0
	elseif r==3 then 
		d.x=d.rand(room.x+1,room.x+room.xh-2)
		d.y=room.y-1
		d.vx=0
		d.vy=-1
	elseif r==4 then 
		d.x=d.rand(room.x+1,room.x+room.xh-2)
		d.y=room.y+room.yh
		d.vx=0
		d.vy=1
	end
	return r
end

function d.rand(a,b)
	if a>=b then return a end
	return math.random(a,b)
end
function d.rand_xy()
	d.x=d.rand(0,asc_xh-1)
	d.y=d.rand(0,asc_yh-1)
end

function d.get_asc(x,y)
	if x<0 then return nil end
	if y<0 then return nil end
	if x>=asc_xh then return nil end
	if y>=asc_yh then return nil end
	return asc[1+x+y*asc_xh]
end

function d.set_asc(x,y,a)
	if x<0 then return nil end
	if y<0 then return nil end
	if x>=asc_xh then return nil end
	if y>=asc_yh then return nil end
	asc[1+x+y*asc_xh]=a
	return true
end

function d.room_rand()
	d.rand_weight_xy()
	d.xh=d.rand(1,4)
	d.yh=d.rand(1,4)
	d.x=d.x-d.xh
	d.y=d.y-d.yh
	d.xh=d.xh+d.rand(2,5)
	d.yh=d.yh+d.rand(2,5)
--	if d.xh==2 and d.yh==2 then d.xh=3 end -- do not allow 2x2 rooms
	
	if d.room_check() then d.room_dig() end
end
function d.room_check()
	for y=d.y-1,d.y+d.yh do
		for x=d.x-1,d.x+d.xh do
			local a=d.get_asc(x,y)
			if (not a) or (a==a_dot) then return false end
		end
	end
	return true
end
function d.room_dig()
	for y=d.y,d.y+d.yh-1 do
		for x=d.x,d.x+d.xh-1 do
			d.set_asc(x,y,a_dot)
		end
	end
	d.rand_weight_change()
	local r={}
	r.x=d.x
	r.y=d.y
	r.xh=d.xh
	r.yh=d.yh
	r.doors={}
	table.insert(d.rooms,r)
	table.insert(d.rooms_groups,{r})
	return r
end

-- try and connect all the rooms

function d.room_find(x,y)
	for i,v in ipairs(d.rooms) do
	
		if v.x<=x and v.x+v.xh>x and v.y<=y and v.y+v.yh>y then -- hit
			return v
		end
	end
	
	return nil
end

function d.alleys_merge_find(r1,r2)

local g1,g2

	for g,v in ipairs(d.rooms_groups) do
		for r,v in ipairs(v) do
			if v==r1 then g1=g end
			if v==r2 then g2=g end
		end
	end
	
	return g1,g2
end

function d.alleys_merge(r1,r2)

local g1,g2=d.alleys_merge_find(r1,r2)

--print(g1.." - "..g2)
	if g1~=g2 then
		for i,v in ipairs(d.rooms_groups[g2]) do -- merge groups
			table.insert(d.rooms_groups[g1],v)
		end
		table.remove(d.rooms_groups,g2) -- destroy old groups
	end
end

function d.alleys_rand()

	for i=1,1000 do
	
--print(i..":"..#d.rooms_groups)
	
		if #d.rooms_groups<=1 then break end -- all connected
	
	local r2=nil
	local r=d.rooms[ d.rand(1,#d.rooms) ]
	local door=d.rand_xy_door(r)
	local door_hit=0
	
--		if not r.doors[door] then -- only one room per room side
		
			local fail=true
			--	print("start "..d.x.." , "..d.y)
			if d.get_asc(d.x,d.y)==a_hash then -- can start digging
				if d.vx~=0 then
					local y=d.y
					for x=d.x,d.x+d.vx*1000 do
						local a=d.get_asc(x,y)
						if a==nil then break end -- hit edge
						if a==a_dot then -- found another alley/room
							r2=d.room_find(x,y)
							d.xh=x-d.x
							d.yh=1
							fail=false
							break
						end
						if d.get_asc(x,y-1)==a_dot then
							r2=d.room_find(x,y-1)
							break
						elseif d.get_asc(x,y+1)==a_dot then
							r2=d.room_find(x,y+1)
							break
						end
--[[
						if r2 then
							d.xh=x-d.x+1
							d.yh=1
							fail=false
							break
						end
]]
					end
				elseif d.vy~=0 then
					local x=d.x
					for y=d.y,d.y+d.vy*1000 do
						local a=d.get_asc(x,y)
						if a==nil then break end -- hit edge
						if a==a_dot then -- found another alley/room
							r2=d.room_find(x,y)
							d.yh=y-d.y
							d.xh=1
							fail=false
							break
						end
						if d.get_asc(x-1,y)==a_dot then
							r2=d.room_find(x-1,y)
							break
						elseif d.get_asc(x+1,y)==a_dot then
							r2=d.room_find(x+1,y)
							break
						end
--[[
						if r2 then
							d.yh=y-d.y+1
							d.xh=1
							fail=false
							break
						end
]]
					end
				end
			end
			
			if not fail then
			
				local g1,g2=d.alleys_merge_find(r,r2)
				
				local c1,c2
				
	if d.x==r.x or d.x==r.x+r.xh-1 or d.y==r.y or d.y==r.y+r.yh-1 then c1=true end
	if d.x+d.xh-1==r2.x or d.x+d.xh-1==r2.x+r2.xh-1 or d.y+d.yh-1==r2.y or d.y+d.yh-1==r2.y+r2.yh-1 then c2=true end
				
				if g1~=g2 and not c1 and not c2 then -- only if it connects two groups

					local alley=d.room_dig()
					table.insert(r.doors,alley)
					table.insert(alley.doors,r)
					table.insert(r2.doors,alley)
					table.insert(alley.doors,r2)
					
					d.alleys_merge(r,alley)
					d.alleys_merge(r,r2)
					
				end
				
			end
		
--		end
	end
	
end

-- fill level with solid
	asc_xh=level.xh
	asc_yh=level.yh
	
	for y=0,asc_yh-1 do
		for x=0,asc_xh-1 do
		
			i=1+x+y*asc_xh
			asc[i]=a_hash

		end
	end
	
	math.randomseed(os.time())
	
	d.rooms={}
	d.rooms_groups={} -- every room starts in its own group, then we try and join them all into one

	d.rand_weight_change()
	for i=1,100 do
		d.room_rand()
	end
	
	d.alleys_rand()
	
	return d
	
end

