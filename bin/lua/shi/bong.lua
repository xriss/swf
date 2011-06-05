
local hex=function(str) return tonumber(str,16) end





local p={} -- locals are faster and shrter names are easier to type
pong=p -- but keep the table in pong as well


p.world=require("box2d.wrap").world()



--
-- mouse input
--
function p.mouse(act,x,y,key)

	if not p.win_dx then return end -- wait for setup

	x=x-p.win_dx -- turn into local x,y
	y=y-p.win_dy
	
end


local ground = p.world.body{}
ground.shape{box={width=50,height=10},density=1,friction=0.3}
ground.set{x=0,y=-10,a=0}

local body=p.world.body{position={0,40}}
body.shape{box={width=1,height=1},density=1,friction=0.3,restitution=0.25}
body.set{mass="shapes",x=0,y=40,a=1} -- calculate from shapes

--
-- called to update every 20ms ( 50fps )
--
function p.update()

	p.win_width=win.get("width")
	p.win_height=win.get("height")

	p.win_dx = math.floor((p.win_width-640)/2)
	p.win_dy = math.floor((p.win_height-480)/2)
	
	
	
	p.world.step(1/50.10)
	
	body.get()
	
--	print(body.x..","..body.y)

--	print(body.x.." "..body.y)

	
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

function p.draw_body(t,color)


	local x=(-t.x*10)+320
	local y=(-t.y*10)+400

	p.rect(x-10,y-10,x+10,y+10,color)
end


--
-- draw everything
--
function p.draw()

	p.rect(0,0,640,480,hex"ff000000")
	
	
	p.draw_body(body,0xffff0000)
	
end





--
-- tell the main loop to run the functions in (p)ong
--
base=p
dofile("lua/shi/base.lua")
