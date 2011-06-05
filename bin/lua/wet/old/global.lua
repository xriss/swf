--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--


--
-- Simple lock on the global table to stop accidental creation of new gobals
--
-- if you really want to create a new global use global.name=value which bypasses this lock
--
-- locks globals by default the first time it is run but this lock can be turned on/off later on
-- using
--
-- global.__newindex_lock()
-- global.__newindex_unlock()
--
-- this assumes you are not using the newindex metamethod on your global table already or
-- doing anything with function environment so I'm free to set or clear it at will
-- 
-- 


if not global then -- multiple runs

local g = {

	__newindex_lock = function ()	-- set error function
		local mt=getmetatable(_G)
			if not mt then
				mt={}
				setmetatable(_G,mt)
			end
			mt.__newindex = function(t,i,v)
				error("cannot create global variable `"..i.."'",2)
			end
		end
	,
	__newindex_unlock = function ()	-- clear error function
		local mt=getmetatable(_G)
			if mt then
				mt.__newindex = null
			end
		end

	}

    setmetatable(g, {
      __index=function(t,i) return rawget(_G,i) end,
      __newindex=function(t,i,v) rawset(_G,i,v) end,
    })

global=g
global.__newindex_lock()

end


return global



