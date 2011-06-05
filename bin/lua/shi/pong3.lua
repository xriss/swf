
local bit=require("bit")

local p={} -- locals are faster and shrter names are easier to type
pong=p -- but keep the table in pong as well
p.items={}
p.x=0
p.y=0


--
-- draw bat
--
function p.make_bat(x,y,color)

	local b={}
	b.x=x
	b.y=y
	b.color=color
	
	--
	-- draw bat with blur
	--
	function b.draw()
		local a=bit.band(bit.rshift(b.color,24),0xff)
		local r=bit.band(bit.rshift(b.color,16),0xff)
		local g=bit.band(bit.rshift(b.color,8),0xff)
		local bl=bit.band(bit.rshift(b.color,0),0xff)
		
		local color=bit.lshift(a,24)+bit.lshift(r,16)+bit.lshift(g,8)+bit.lshift(bl,0)
		
--		for i=10,25 do
			p.rect(b.x-10,b.y-50,b.x+10,b.y+50,color)
--			a=a/1.5
--			color=bit.lshift(a,24)+bit.lshift(r,16)+bit.lshift(g,8)+bit.lshift(bl,0)
--		end
	end
	
	--
	-- update bat
	--
	function b.update()		
		b.y=p.y
		
		if b.y>460 then
			b.y=460
		end
		
		if b.y<20 then
			b.y=20
		end
	end
	
	return b
	
end


--
-- draw ball with velocity
--
function p.make_ball(x,y,vx,vy,color)

	local b={}
	b.x=x
	b.y=y
	b.vx=vx
	b.vy=vy
	b.color=color
	
	--
	-- draw ball with blur
	--
	function b.draw()
		local a=bit.band(bit.rshift(b.color,24),0xff)
		local r=bit.band(bit.rshift(b.color,16),0xff)
		local g=bit.band(bit.rshift(b.color,8),0xff)
		local bl=bit.band(bit.rshift(b.color,0),0xff)
		
		local color=bit.lshift(a,24)+bit.lshift(r,16)+bit.lshift(g,8)+bit.lshift(bl,0)
		
--		for i=10,25 do
			p.rect(b.x-10,b.y-10,b.x+10,b.y+10,color)
--			a=a/1.5
--			color=bit.lshift(a,24)+bit.lshift(r,16)+bit.lshift(g,8)+bit.lshift(bl,0)
--		end
	end
	
	--
	-- update ball
	--
	function b.update()		
		b.x=b.x+b.vx
		b.y=b.y+b.vy
		
		if b.x>620 then
			b.vx=math.abs(b.vx)*-1
		end
		
		if p.items.bat.y-60<b.y and p.items.bat.y+60>b.y then
			if b.x<20 and b.x>0 then
				b.vx=math.abs(b.vx)*1.25
			end
		end
		
		if b.y>460 then
			b.vy=math.abs(b.vy)*-1
		end
		
		if b.y<20 then
			b.vy=math.abs(b.vy)
		end
	end
	
	return b
	
end

--
-- random plops
--
function plop(x,y)

--	local a=math.random(128,255)
--	local r=math.random(0,255)
--	local g=math.random(0,255)
--	local bl=math.random(0,255)
	
--	local color=bit.lshift(a,24)+bit.lshift(r,16)+bit.lshift(g,8)+bit.lshift(bl,0)
	
	table.insert(p.items,p.make_ball(x,y,3,3,0xffffffff))
end

p.items.ball=p.make_ball(320,240,3,3,0xffffffff)
p.items.bat=p.make_bat(10,240,0xffffffff)


--
-- mouse input
--
function p.mouse(act,x,y,key)

	if not p.win_dx then return end -- wait for setup

	x=x-p.win_dx -- turn into local x,y
	y=y-p.win_dy
	
	if act=="down" then
		plop(x,y)
	end
	
	p.x=x
	p.y=y
	
end




--
-- called to update every 20ms ( 50fps )
--
function p.update()

	p.win_width=win.get("width")
	p.win_height=win.get("height")

	p.win_dx = math.floor((p.win_width-640)/2)
	p.win_dy = math.floor((p.win_height-480)/2)
	
	for i,v in pairs(p.items) do
		v.update()
	end
	
end


--
-- draw a rectangle into a 640x480 screen
--
function p.rect(x1,y1,x2,y2,color)

-- translate to screen size?
	local dx=p.win_dx
	local dy=p.win_dy

	win.debug_rect(x1+dx,y1+dy,x2+dx,y2+dy,color)
	
end



--
-- draw everything
--
function p.draw()

	p.rect(0,0,640,480,0xff000000)
	
	p.rect(0,0,640,10,0xffffffff)
	p.rect(0,470,640,480,0xffffffff)
--	p.rect(0,10,10,470,0xffffffff)
	p.rect(630,10,640,470,0xffffffff)
	
	for i,v in pairs(p.items) do
		v.draw()
	end
	
end





--
-- tell the main loop to run the functions in (p)ong
--
base=p
dofile("lua/shi/base.lua")
