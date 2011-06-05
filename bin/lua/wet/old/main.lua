
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

print( arg[1] or "" )

--print( main.test() or "" )




-- simple old main loop setup
main.test_pre()

-- check windows msgs
local n=0
while n==0 do
	n=main.test_msg()
end


main.test_post()




print("end\n")


