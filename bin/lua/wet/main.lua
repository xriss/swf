
--
-- Wet test main start code
--
-- arg[1] is set to the raw commandline as this program is invoked
--
-- need to setup windows etc and run whatever app or state is requested
--
-- print will also output to the debug console under windows as no console may be available
--

print("start\n")

print( main_next or "" ) -- start state
print( arg[1] or "" ) -- command
print( arg[2] or "" ) -- hwnd

--print( main.test() or "" )



lanes=require("lanes")
local f=function()

-- special datas for state to use...

wet_setup_comandline=arg[1]
wet_setup_hwnd=arg[2]

	local f=loadfile("lua/wet/state/main.lua")
	f()
	
end

thread={}
	thread.linda=lanes.linda()
	thread.worker=lanes.gen("*",{["globals"]={
		arg=arg,
		oldmain=main,
		main_next=main_next
	}},f)(thread.linda,1)

-- wait for thread? not if this is running under moz...
	if not arg[2] then 
		local t=thread.worker[1]
	end
	
