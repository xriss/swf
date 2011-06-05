
local bit=require("bit")

local p={} -- locals are faster and shrter names are easier to type
pong=p -- but keep the table in pong as well
p.items={} -- put a table aka list in p.items
p.items[1]={w=10,x=320,vx=1,y=240,vy=1,color=0xff00ff00,type="ball"} -- makes an item with variables in my list of item
p.items[2]={w=20,x=240,vx=1,y=150,vy=1,color=0xffff0000,type="ball"}


--
-- mouse input
--
function p.mouse(act,x,y,key)

--print(act.." "..x..","..y.." "..key)
	if not p.win_dx then return end -- wait for setup

	x=x-p.win_dx -- turn into local x,y
	y=y-p.win_dy
	
end




--
-- called to update every 20ms ( 50fps ) aka moving in laymman's term
--
function p.update()

	p.win_width=win.get("width")
	p.win_height=win.get("height")

	p.win_dx = math.floor((p.win_width-640)/2)
	p.win_dy = math.floor((p.win_height-480)/2)
	
	for i,v in ipairs (p.items) do -- i is index [], v is value of the things in that index, ipairs is in sequence of the value
		v.x=v.x+v.vx -- vx is velocity of x
		v.y=v.y+v.vy -- vx is velocity of y
		
		if v.x>640-v.w then v.vx=-v.vx end
		if v.x<  0+v.w then v.vx=-v.vx end
		if v.y>480-v.w then v.vy=-v.vy end
		if v.y<  0+v.w then v.vy=-v.vy end
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
-- func to draw ball
--
function p.ball(w,x,y,color)


	p.rect(x-w,y-w,x+w,y+w,color) -- keep in mind that this draws things so keep it pure

	
end

--
-- draw everything
--
function p.draw()

	p.rect(0,0,640,480,0xff000000)
	for i,v in ipairs (p.items) do -- i is index [], v is value of the things in that index, ipairs is in sequence of the value
		p.ball(v.w,v.x,v.y,v.color)
	end
	
end





--
-- tell the main loop to run the functions in (p)ong
--
base=p
dofile("lua/shi/base.lua")
