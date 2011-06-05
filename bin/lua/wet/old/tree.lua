--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2004 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--



--
-- A tree is a table that must not self reference, so it is safe to recurse through
--




local ipairs = ipairs
local type = type

local table = table



module 'tree' 

--
-- return table of all tree nodes that contain the idx=val pair 
--

find_pairs=function(tab,idx,val,ret)

	if ret==null then

		ret={n=0}

	end

	if tab[idx]==val then

		table.insert(ret,tab)

	end

	for i,v in ipairs(tab) do

		if type(v)=="table" then

			find_pairs(v,idx,val,ret)

		end

	end

	return ret

end 


