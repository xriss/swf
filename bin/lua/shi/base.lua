

gl=require('gl')

win=require('fenestra.wrap').win()


local hex=function(str) return tonumber(str,16) end


win.setup(_G) -- create and associate with this global table, eg _G.print gets replaced



--
-- mouse update
--
local function update()

	if base and base.update then
	
		base.update()
	
	end

end




--
-- mouse input
--
function win.mouse(act,x,y,key)

	if base and base.mouse then
	
		base.mouse(act,x,y,key)
	
	end
	
end


--
-- mouse input
--
function win.keypress2(k1,k2,act)

print(act.." : "..k1.." : "..k2)
	
end


--
-- called to draw everything
-- 
local function draw()

	win.debug_begin()
	
	local width=win.get("width")
	local height=win.get("height")
	
	-- this draws a rectangle to the entire screen	
	win.debug_rect(0,0,width,height,hex"ff004400")
	
	if base and base.draw then
	
		base.draw()
	
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

local times={}

local function times_setup()
	local t={}
	t.time=0
	t.time_live=0
	
	t.hash=0
	t.hash_live=0
	
	t.started=0
	
	function t.start()
		t.started=win.time()
	end
	
	function t.stop()
		local ended=win.time()
		
		t.time_live=t.time_live + ended-t.started
		t.hash_live=t.hash_live + 1
	end
	
	function t.done()
		t.time=t.time_live
		t.hash=t.hash_live
		t.time_live=0
		t.hash_live=0
	end
	
	return t
end



times.update=times_setup()
times.draw=times_setup()
times.swap=times_setup()


win.update=function()

	local t=win.time()
	local d=t-last
	local d_orig=d
-- count frames	
	if t-frame_last >= 1 then -- debug counts updated every sec
	
		fps=frame_count
		frame_count=0
		frame_last=t
		
		times.update.done()
		times.draw.done()
		times.swap.done()
	end
	
-- update

	local do_draw=false
	while d >= 0.020 do

		times.update.start()
		update()
		times.update.stop()
		
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
		
		times.draw.start()
		draw()
		times.draw.stop()
		
		win.console.draw()
		
		times.swap.start()
		win.swap()
		times.swap.stop()
		
		frame_count=frame_count+1
		
		local gci=gcinfo()
		
		win.console.display(string.format("fps=%02.0f ms=%03.0f ums=%03.0f dms=%03.0f sms=%03.0f gc=%0.0fk",fps,math.floor(0.5+(1000/fps)),math.floor(times.update.time*1000),math.floor(times.draw.time*1000),math.floor(times.swap.time*1000),math.floor(gci) ))
		
	end

end



while win.msg("wait") do

	win.update()

end



win.clean()

