

local bit=require('bit')
local gl=require('gl')


local _G=_G

local win=win

local print=print
local pairs=pairs
local ipairs=ipairs
local tonumber=tonumber
local string=string
local type=type



module("wet.state.avatar")



local function explode_color(c)

	local r,g,b,a
	
	a=bit.band(bit.rshift(c,24),0xff)
	r=bit.band(bit.rshift(c,16),0xff)
	g=bit.band(bit.rshift(c, 8),0xff)
	b=bit.band(c,0xff)

	return r/0xff,g/0xff,b/0xff,a/0xff
end

local function implode_color(r,g,b,a)

	if type(r)=="table" then a=r[4] b=r[3] g=r[2] r=r[1] end -- convert from table?

	local c
	
	c=             bit.band(b*0xff,0xff)
	c=c+bit.lshift(bit.band(g*0xff,0xff),8)
	c=c+bit.lshift(bit.band(r*0xff,0xff),16)
	c=c+bit.lshift(bit.band(a*0xff,0xff),24)

	return c
end

local function get_color()
	return w.color.color
end

local function set_color(c)

	local t={explode_color(c)}
	
--	w.color_alpha:set("slide",t[4])
	w.color_red:set("slide",t[1])
	w.color_green:set("slide",t[2])
	w.color_blue:set("slide",t[3])
	w.color.color=c
	w.color.text=string.format("%06x",bit.band(c,0xffffff))
	
	w.color.state="selected"
	w.spec.state="none"
	
	if w.surfs then
		for i,v in pairs(w.surfs) do
			if v.state=="selected" then
				v.color=c
				local s=soul.vanilla.surfaces[v.user]
				if s then
					s.argb=c
				end
			end
		end
		
		win.avatar.map_xsx(xsx,soul)
		
	end
end


local function get_spec()
	return w.spec.color
end

local function set_spec(c)

	local t={explode_color(c)}
	
--	w.color_alpha:set("slide",t[4])
	w.color_red:set("slide",t[1])
	w.color_green:set("slide",t[2])
	w.color_blue:set("slide",t[3])
	w.spec.color=c
	w.spec.text=string.format("%06x",bit.band(c,0xffffff))
	
	w.spec.state="selected"
	w.color.state="none"
	
	if w.surfs then
		for i,v in pairs(w.specs) do
			if v.state=="selected" then
				v.color=c
				local s=soul.vanilla.surfaces[v.user]
				if s then
					s.spec=c
				end
			end
		end
		
		win.avatar.map_xsx(xsx,soul)
		
	end
end

local function get_argb()
	if w.color then
		if w.color.state=="selected" then return get_color()
		else return get_spec() end
	end
end
local function set_argb(c)
	if w.color then
		if w.color.state=="selected" then return set_color(c)
		else return set_spec(c) end
	end
end
local function set_edit(to)
print(to)
	local c
	if w.color.state=="selected" then
		if to=="spec" then --swap
			for i,v in pairs(w.surfs) do
				w.specs[v.user].state=v.state
				v.state="none"
			end
			set_spec(w.spec.color)
		end
	else
		if to=="color" then --swap
			for i,v in pairs(w.specs) do
				w.surfs[v.user].state=v.state
				v.state="none"
			end
			set_color(w.color.color)
		end
	end
end

-- load surfaces from the soul into the buttons
local function load_surf(soul)

	for i,v in pairs(soul.vanilla.surfaces) do
		local s=w.surfs[i]
		if s then
			s.color=v.argb		
		end
		local s=w.specs[i]
		if s then
			s.color=v.spec
		end
	end
end


local function select_surf(n)

local c

	for i,v in pairs(w.surfs) do
		if v.user==n then
			v.state="selected"
			c=v.color
		else
			v.state="none"
		end
	end
	for i,v in pairs(w.specs) do
		v.state="none"
	end

	if c then set_color(c) end
	
end

local function select_spec(n)

local c

	for i,v in pairs(w.specs) do
		if v.user==n then
			v.state="selected"
			c=v.color
		else
			v.state="none"
		end
	end
	for i,v in pairs(w.surfs) do
		v.state="none"
	end


	if c then set_spec(c) end
	
end

--	local block=master:add({hx=640,hy=480,color=0x00000000,static=true})

local hooks={}
	function hooks.click(widget)
print(widget.id)
		if widget.id=="rotate" then
		
		elseif widget.id=="color" then
		
			set_argb(widget.color)
			
		elseif widget.id=="surf" then
		
			select_spec(widget.user)
			select_surf(widget.user)
			
		elseif widget.id=="spec" then
		
			select_surf(widget.user)
			select_spec(widget.user)
			
		elseif widget.id=="set_color" then
		
			set_edit("color")
		
		elseif widget.id=="set_spec" then
		
			set_edit("spec")
			
		elseif widget.id=="goto_colors" then
		
			page(2)
			
		elseif widget.id=="goto_soul" then
		
			page(3)
			
		end
	end
	
	function hooks.slide(widget)
		if widget.id=="rotate" then
		
			local x,y=widget:get("slide")
			rotate= (x*360)-180
			
		elseif widget.id=="alpha" then
		
			local x,y=widget:get("slide")
			local t={explode_color(get_argb())}
			t[4]=x
			set_argb(implode_color(t))
			
		elseif widget.id=="red" then
		
			local x,y=widget:get("slide")
			local t={explode_color(get_argb())}
			t[1]=x
			set_argb(implode_color(t))
			
		elseif widget.id=="green" then
		
			local x,y=widget:get("slide")
			local t={explode_color(get_argb())}
			t[2]=x
			set_argb(implode_color(t))
			
		elseif widget.id=="blue" then
		
			local x,y=widget:get("slide")
			local t={explode_color(get_argb())}
			t[3]=x
			set_argb(implode_color(t))
			
		end
	end
	
function setup()

w={}

pick_colors={

0xff000000,0xff444444,0xff666666,0xff888888,0xffaaaaaa,0xffcccccc,0xffeeeeee,0xffffffff,
0xff0000ff,0xff0088ff,0xff8800ff,0xff8888ff,0xff00ff00,0xff00ff88,0xff88ff00,0xff88ff88,
0xff0000cc,0xff0066cc,0xff6600cc,0xff6666cc,0xff00cc00,0xff00cc66,0xff66cc00,0xff66cc66,
0xff999900,0xff666600,0xff000066,0xff000099,0xff990000,0xff660000,0xff006600,0xff009900,
0xffcccc00,0xffcccc66,0xffcc6600,0xffcc0000,0xffcc0066,0xffcc6666,0xffcc66cc,0xff66cccc,
0xffffff00,0xffffff88,0xffff8800,0xffff0000,0xffff0088,0xffff8888,0xffff88ff,0xff88ffff,
0xffaa6644,0xffdd9977,0xffddcc99,0xffeebb99,0xffffbb99,0xffffaaaa,0xffddbbbb,0xffbbbbdd,

}

pick_surfs={

"skin",
"lips",
"nipples",
"hair",
"hairhi",
"hairlo",
"eyebrows",
"beard",
"specs",
"eye",
"iris",
"body",
"bodyhi",
"bodylo",
"foot",
"toecaps",
"sole",
"socks",

}

rotate=-180

frame=0

xsx_dat=win.data.load("data/avatar/xsx/cycle_walk.xsx")
xsx=win.xsx(xsx_dat)
soul=win.avatar.load_soul("local/avatar/soul/kolumbo_bob.xml")

	win.avatar.map_xsx(xsx,soul)

	
	_G.page=page

	page(2)
end

function page(hash)

-- make an avatar with scrolly bar on the main page
	local function w_avatar(x,y,hx,hy)
	
		w.avatar=win.widget:add{class="rel",hx=hx,hy=hy,ax=x,ay=y}
		w.avatar_goto=w.avatar:add{class="hx",fx=1,fy=1/12,ax=0,ay=0,mx=3}
		w.avatar_colors=w.avatar_goto:add{text="colors",id="goto_colors",hooks=hooks,color=0x44ffffff}
		w.avatar_parts=w.avatar_goto:add{text="parts",id="goto_parts",hooks=hooks,color=0x44ffffff}
		w.avatar_soul=w.avatar_goto:add{text="soul",id="goto_soul",hooks=hooks,color=0x44ffffff}
		w.avatar_anim=w.avatar_goto:add{text="anims",id="goto_anims",hooks=hooks,color=0x44ffffff}
		w.avatar_x5=w.avatar_goto:add{}
		w.avatar_x6=w.avatar_goto:add{}
		w.avatar_rot=w.avatar:add{class="slide",color=0x22ffffff,fx=1,fy=1/24,ax=0,ay=23/24}
		w.avatar_rot:add{id="rotate",color=0x88ffffff,hooks=hooks,ax=0,ay=0,fx=3/10,fy=1}
		
	end

-- make a color selector
	local function w_colors(x,y,hx,hy)
	
		w.colors=win.widget:add{class="rel",hx=hx,hy=hy,ax=x,ay=y}
		
		local colors=w.colors:add({hx=hx,hy=hy/2,mx=8,class="hx",ax=0,ay=0})
		for i,v in ipairs(pick_colors) do
			colors:add{color=v,id="color",hooks=hooks,highlight="shrink"}
		end
		
		local slides=w.colors:add({hx=hx,hy=hy/2,mx=2,class="hx",ax=0,ay=1/2})

--[[		
		w.color_alpha=slides:add{class="slide",sx=2}
		w.color_alpha:add{text="Alpha",color=0x88ffffff,text_color=0xffffffff,id="alpha",hooks=hooks,ax=0,ay=0,fx=4/10,fy=1}
]]		
		w.color_red=slides:add{class="slide",sx=2}
		w.color_red:add{text="Red",color=0x88ffffff,text_color=0xffffffff,id="red",hooks=hooks,ax=0,ay=0,fx=4/10,fy=1}
		
		w.color_green=slides:add{class="slide",sx=2}
		w.color_green:add{text="Green",color=0x88ffffff,text_color=0xffffffff,id="green",hooks=hooks,ax=0,ay=0,fx=4/10,fy=1}

		w.color_blue=slides:add{class="slide",sx=2}
		w.color_blue:add{text="Blue",color=0x88ffffff,text_color=0xffffffff,id="blue",hooks=hooks,ax=0,ay=0,fx=4/10,fy=1}

		w.color=slides:add{text="ff00ff00",highlight="text",color=0xff00ff00,id="set_color",hooks=hooks}
		w.spec=slides:add{text="ff00ff00",highlight="text",color=0xff00ff00,id="set_spec",hooks=hooks}
		
		w.color_gloss=slides:add{class="slide",sx=2}
		w.color_gloss:add{text="Gloss",color=0x88ffffff,text_color=0xffffffff,id="gloss",hooks=hooks,ax=0,ay=0,fx=4/10,fy=1}
		
		set_color(0xff888888)
		
	end

-- make a surface selector
	local function w_surf(x,y,hx,hy)
	
		w.surf=win.widget:add{class="rel",hx=hx,hy=hy,ax=x,ay=y}
		
		w.surfs={}
		w.specs={}

		local surf=w.surf:add({hx=hx,hy=hy*3/4,mx=10,class="hx",ax=0,ay=1/4})
		for i,v in ipairs(pick_surfs) do
			w.surfs[v]=surf:add{color=0xff888888,sx=4,text=v,id="surf",user=v,hooks=hooks,highlight="text"}
			w.specs[v]=surf:add{color=0xff888888,sx=1,id="spec",user=v,hooks=hooks,highlight="text"}
		end
		
		load_surf(soul)
		
		
		select_spec("skin")
		select_surf("skin")
		
	end
		
-- test page layouts

	if tonumber(hash)==0 then
	
		win.widget:remove_all()

		win.widget:layout()
		
		win.widget.state="ready"
	
	elseif tonumber(hash)==1 then
	
		win.widget:remove_all()
		local top=win.widget:add({hx=640,hy=480,mx=5,class="hx",ax=0,ay=0})
		local colors=win.widget:add({hx=320,hy=240,mx=8,class="hx",ax=0,ay=0.5})
		for i,v in ipairs(pick_colors) do
			colors:add{color=v,id="color",hooks=hooks,highlight="shrink"}
		end
		
		top:add({text="random",color=0x88ff0000,id="random",hooks=hooks})
		top:add({text="colors",color=0x88ff0000,id="colors",hooks=hooks})
		top:add({text="pose",color=0x88ff0000,id="pose",hooks=hooks})
		top:add({text="parts",color=0x88ff0000,id="parts",hooks=hooks})
		top:add({text="save",color=0x88ff0000,id="save",hooks=hooks})
		top:add({sy=22,sx=5})
		local drag=top:add({sy=1,sx=5,class="slide",color=0x22ffffff})
		drag:add{text="rotate",color=0x88ffffff,id="rotate",hooks=hooks,ax=0,ay=0,fx=2/10,fy=1}

		win.widget:layout()
		
		win.widget.state="ready"
	
	elseif tonumber(hash)==2 then
	
		win.widget:remove_all()
		
		w={}
		w_avatar(320,0,320,480)
		w_colors(0,0,320,240)
		w_surf(0,240,320,240)
		
		win.widget:layout()
		
		win.widget.state="ready"
	
	elseif tonumber(hash)==3 then
	
		win.widget:remove_all()
		
		w={}
		w_avatar(320,0,320,480)
		
		win.widget:layout()
		
		win.widget.state="ready"
	
	end

end
	
function update()

	frame=(frame+0.020)
	if frame>xsx.length then frame=frame-xsx.length end 

end

function draw()

	gl.MatrixMode("PROJECTION")
	gl.PushMatrix()
	gl.Scale(4,4,1)
	
	gl.MatrixMode("MODELVIEW")
	gl.PushMatrix()
	
	if w.avatar then
	
		local x,y,s
		
		x=2*(w.avatar.px+(w.avatar.hx/2)-320)/240
		y=2*(w.avatar.py-(w.avatar.hy-w.avatar_rot.hy)-240)/240
		s=(w.avatar.hy*15/16)/240
	
		gl.Translate(x,y, -8)
		gl.Scale(s,s,1)
		gl.Rotate(rotate,0,1,0);
		
		xsx.draw(frame);
	end

		
	
	gl.MatrixMode("PROJECTION")
	gl.PopMatrix()
	
	gl.MatrixMode("MODELVIEW")
	gl.PopMatrix()

end

function clean()
	win.widget:remove_all()
end




