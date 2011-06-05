

local gl=require('gl')

win=require('fenestra.wrap').win()


local hex=function(str) return tonumber(str,16) end


win.setup(_G) -- create and associate with this global table, eg _G.print gets replaced




--
-- put all data in pong.something
--
pong={}
pong.balls={}
pong.bat={}
pong.bat.x=5
pong.bat.y=240
pong.bat.h=50

--
-- draw ball with velocity
--
function pong.make_ball(x,y,vx,vy,color)

	local ball={}
	ball.x=x
	ball.y=y
	ball.vx=vx
	ball.vy=vy
	ball.color=color
	return ball

end

pong.balls[1]=pong.make_ball(320,240,1,1,hex"ffff00ff")
pong.balls[2]=pong.make_ball(320,240,3,3,hex"ff00ff00")

--
-- plops
--
function plop(x,y,vx,vy,color)

	local vx=math.random(-200,200)/100
	local vy=math.random(-200,200)/100
	local red=math.random(0,255)
	local green=math.random(0,255)
	local blue=math.random(0,255)
	pong.balls[#pong.balls+1]=pong.make_ball(x,y,vx,vy,hex"ff000000"+red*65536+green*256+blue)

end

--
-- called 50fps to update everything
-- 
function pong.update()

	pong.win_width=win.get("width")
	pong.win_height=win.get("height")

	pong.win_dx = math.floor((pong.win_width-640)/2)
	pong.win_dy = math.floor((pong.win_height-480)/2)
	
	for i,v in ipairs(pong.balls) do
	
		v.x=v.x+v.vx
		v.y=v.y+v.vy
		
		if v.x>625 then
			v.vx=v.vx*-1
			v.x=625
		end
		
		if v.y<pong.bat.y+pong.bat.h and v.y>pong.bat.y-pong.bat.h then
			if v.x<15 then
				v.vx=v.vx*-1
				v.x=15
			end
		end
		
		if v.y>465 then
			v.vy=v.vy*-1
			v.y=465
		end
		
		if v.y<15 then
			v.vy=v.vy*-1
			v.y=15
		end
		
	end

end
pong.update()

--
-- draw a rectangle into a 640x480 screen
--
function pong.rect(x1,y1,x2,y2,color)

-- translate to screen size?
	local dx=pong.win_dx
	local dy=pong.win_dy

	win.debug_rect(x1+dx,y1+dy,x2+dx,y2+dy,color)
	
end


--
-- mouse input
--
function win.mouse(act,x,y,key)

	x=x-pong.win_dx -- turn into local x,y
	y=y-pong.win_dy
	
	if act=="down" then
		plop(x,y)
	end
	
	pong.bat.y=y
	
	if pong.bat.y<60 then
		pong.bat.y=60
	end
	
	if pong.bat.y>420 then
		pong.bat.y=420
	end

end

--
-- draw ball
--
function pong.draw_ball(v)

	pong.rect(v.x-5,v.y-5,v.x+5,v.y+5,v.color)
	
	for i=1,10 do
		local color=v.color-i*256*256*256*24
		pong.rect(v.x-v.vx*i-5,v.y-v.vy*i-5,v.x-v.vx*i+5,v.y-v.vy*i+5,color)
	end
	
end

--
-- called to draw everything
-- 
function pong.draw()

	win.debug_begin()
	
	
-- this draws a rectangle to the entire screen	
	win.debug_rect(0,0,pong.width,pong.height,hex"ff004400")
	
-- this draws a rectangle to the 640x480 game area
	pong.rect(0,0,640,480,hex"ff000000")
--	pong.rect(0,10,10,470,hex"ff666666")
	pong.rect(0,0,640,10,hex"ff666666")
	pong.rect(630,10,640,470,hex"ff666666")
	pong.rect(0,470,640,480,hex"ff666666")
	
	local v=pong.bat
	pong.rect(v.x-5,v.y-v.h,v.x+5,v.y+v.h,hex"ff00ff00")
	
	for i,v in ipairs(pong.balls) do
		pong.draw_ball(v)
	end



	
	win.debug_end()

end










--
-- ignore the stuff bellow
--



local last=win.time()
local frame_last=last
local frame_count=0
local fps=0

win.update=function()

	local t=win.time()
	local d=t-last
	local d_orig=d

-- count frames	
	if t-frame_last >= 1 then
	
		fps=frame_count
		frame_count=0
		frame_last=t
	
	end
	
-- update

	local do_draw=false
	while d >= 0.020 do

		pong.update()
		
		win.console.update()
		
		if d>1 then -- reset when very out of sync
			last=t
			d=0
		else
			last=last+0.020
			d=d-0.020
		end
		
		do_draw=true
	end


	
-- draw

	gl.CullFace("BACK")
	gl.Enable("CULL_FACE")

	if do_draw then

		win.begin()
		
		pong.draw()
		
		win.console.draw()
		
		win.swap()
		frame_count=frame_count+1
		
		local gci=gcinfo()
		
		win.console.display(string.format("fps=%02.0f ms=%03.0f gc=%0.0fk",fps,math.floor(0.5+(1000/fps)),math.floor(gci) ))
		
	end

end



while win.msg("wait") do

	win.update()

end



win.clean()

