

local gl=require('gl')

win=require('fenestra.wrap').win()


local hex=function(str) return tonumber(str,16) end


win.setup(_G) -- create and associate with this global table, eg _G.print gets replaced


--
-- put all data in pong.something
--
pong={}
pong.balls={}


--
-- called 50fps to update everything
-- 
function pong.update()

	pong.width=win.get("width")
	pong.height=win.get("height")

	

end

function pong.rect(x1,y1,x2,y2,color)

-- translate to screen size?

	local dx = math.floor((pong.width-640)/2)
	local dy = math.floor((pong.height-480)/2)

	win.debug_rect(x1+dx,y1+dy,x2+dx,y2+dy,color)
	
end

--
-- called to make a ball
-- 
function pong.ballmake(x,y,vx,vy,color)

	local ball={}
	ball.x=x
	ball.y=y
	ball.vx=vx
	ball.vy=vy
	ball.color=color
	return ball
	
end

pong.balls[1]=pong.ballmake(320,240,1,1,hex"ff00ff00")
pong.balls[2]=pong.ballmake(320,240,3,3,hex"ff0000ff")

--
-- called to add plops
--
function plop(x,y)

	local alfa=math.random(0,255)
	local red=math.random(0,255)
	local green=math.random(0,255)
	local blue=math.random(0,255)
	local vx=(math.random()-0.5)*4
	local vy=(math.random()-0.5)*4
	pong.balls[#pong.balls+1]=pong.ballmake(x,y,vx,vy,alfa*16777216+red*65536+green*256+blue)
	
end

--
-- call plops with mouse
--
function win.mouse(act,x,y,key)

	if act=="down" then
		plop(x,y)
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
	pong.rect(0,0,10,480,hex"ff666666")
	pong.rect(0,0,640,10,hex"ff666666")
	pong.rect(630,0,640,480,hex"ff666666")
	pong.rect(0,470,640,480,hex"ff666666")
	
	for i,v in ipairs(pong.balls) do
		pong.draw_ball(v.x,v.y,v.color)
	end
	
	
	win.debug_end()

end


--
-- called to draw ball anywhere
-- 
function pong.draw_ball(x,y,color)

	pong.rect(x-10,y-10,x+10,y+10,color)
	
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
		
		for i,v in ipairs(pong.balls) do
			if v.y>460 then
				v.vy=v.vy*-1
			end
			
			if v.y<20 then
				v.vy=v.vy*-1
			end
			
			if v.x>620 then
				v.vx=v.vx*-1
			end
			
			if v.x<20 then
				v.vx=v.vx*-1
			end
			
			
			v.x=v.x+v.vx
			v.y=v.y+v.vy
		end
		
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

