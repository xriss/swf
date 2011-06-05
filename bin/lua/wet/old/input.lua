--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--



function input.get_tab_idx( type , unit , name )

	if type=="J" or type=="Joy" then -- joy

		return 0+unit , input.joy_names[name]

	elseif type=="M" or type=="Mouse" then -- mouse

		return 8+unit , input.mouse_names[name]

	elseif type=="K" or type=="Key" then -- key

		return 16+unit ,  input.key_names[name]

	end

	return -1 , -1
end



function input.bind( type , unit , name , func )

local tab,idx

	print( "key binding " .. type .. "_" .. name )

	tab,idx=input.get_tab_idx(type,unit,name)

	input[tab][idx]=func

end


function input.getbind( type , unit , name )

local tab,idx

	tab,idx=input.get_tab_idx(type,unit,name)

	return input[tab][idx]

end



--
-- Joystick helper function, since the input is a range from 0-65535 turn that into key presses
--

local minrange=65536*1/4
local maxrange=65536*3/4
local k=KEYS

local function axis_to_bools(val,min,max)

	if val<minrange then

		min(1)
		max(0)

	elseif val>maxrange then
	
		min(0)
		max(1)

	else

		min(0)
		max(0)

	end

end


--
-- and usefull bindings to the above helper function
--


function input.p1_leftright(val)

	axis_to_bools(val,k.p1_left,k.p1_right)

end

function input.p1_updown(val)

	axis_to_bools(val,k.p1_up,k.p1_down)

end

function input.inout(val)

-- mouse wheel is special, it gives a posative or negative number and should just act like a button
-- the number scale is not really defined and depends on mouse

	if val<0 then

		k['in'](1)
		k['in'](0)
		k['out'](0)

	elseif val>0 then
	
		k['in'](0)
		k['out'](1)
		k['out'](0)

	else

		k['in'](0)
		k['out'](0)

	end

end




--
-- Set default keys
--

input.bind("Key",0,		"A",		KEYS['p1_left'])
input.bind("Key",0,		"D",		KEYS['p1_right'])
input.bind("Key",0,		"W",		KEYS['p1_up'])
input.bind("Key",0,		"S",		KEYS['p1_down'])

input.bind("Key",0,		"LEFT",		KEYS['p1_left'])
input.bind("Key",0,		"RIGHT",	KEYS['p1_right'])
input.bind("Key",0,		"UP",		KEYS['p1_up'])
input.bind("Key",0,		"DOWN",		KEYS['p1_down'])

input.bind("Key",0,		"H",		KEYS['left'])
input.bind("Key",0,		"K",		KEYS['right'])
input.bind("Key",0,		"U",		KEYS['up'])
input.bind("Key",0,		"J",		KEYS['down'])
input.bind("Key",0,		"COMMA",	KEYS['in'])
input.bind("Key",0,		"PERIOD",	KEYS['out'])

input.bind("Key",0,		"SPACE",	KEYS['click'])
input.bind("Key",0,		"RETURN",	KEYS['click'])



input.bind("Mouse",0,	"Z",		input.inout)
input.bind("Mouse",0,	"B2",		KEYS['grab'])
input.bind("Mouse",0,	"B1",		KEYS['menu'])
input.bind("Mouse",0,	"B0",		KEYS['click'])



input.bind("Joy",0,		"X",		input.p1_leftright)
input.bind("Joy",0,		"Y",		input.p1_updown)

