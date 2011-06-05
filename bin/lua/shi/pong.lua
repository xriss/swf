
local bit=require("bit")

local p={} -- locals are faster and shrter names are easier to type
pong=p -- but keep the table in pong as well



--
-- mouse input
--
function p.mouse(act,x,y,key)

	if not p.win_dx then return end -- wait for setup

	x=x-p.win_dx -- turn into local x,y
	y=y-p.win_dy
	
end




--
-- called to update every 20ms ( 50fps )
--
function p.update()

	p.win_width=win.get("width")
	p.win_height=win.get("height")

	p.win_dx = math.floor((p.win_width-640)/2)
	p.win_dy = math.floor((p.win_height-480)/2)
	
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
	
end





--
-- tell the main loop to run the functions in (p)ong
--
base=p
dofile("lua/shi/base.lua")
