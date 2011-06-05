--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--

--
-- Cache global functions in locals
--

local pairs=pairs
local ipairs=ipairs
local type=type
local tostring=tostring
local print=print




--
-- Handle simple dump functions with indent
--


module 'dump' 



local indent_str=""
local indent_num=0

	indent=function(num)

		if type(num)=="number" then

			indent_num=num

			indent_str=""
			for i=1,num do
				indent_str=indent_str.." "
			end

		end

		return indent_num
	end

	indent_add=function() indent(indent()+2) end
	indent_sub=function() indent(indent()-2) end


	function tree_pairs(tab,depth)	-- non ipairs contains attributes of this tree

		depth=depth or -1
		if depth==0 then return end

		for i,v in pairs(tab) do

			if type(i)~="number" then

				if type(v)~="table" then

					print( indent_str .. i .. "=" .. tostring(v) )

				end

			end

		end

		for i,v in pairs(tab) do

			if type(i)~="number" then

				if type(v)=="table" then

				local nam
				
					if v[0] then
						nam=" " .. v[0]
					else
						nam=""
					end
				
					print( indent_str .. "{"  .. i  .. nam )
					indent_add()
					tree(v,depth-1)
					indent_sub()
					print( indent_str .. "}"  .. i  .. nam )

				end

			end

		end

	end

	function tree_all(tab,depth)	-- all pairs contains attributes of this tree

		depth=depth or -1
		if depth==0 then return end

		for i,v in pairs(tab) do

			if type(v)~="table" then

				print( indent_str .. i .. "=" .. tostring(v) )

			end

		end

		for i,v in pairs(tab) do

			if type(v)=="table" then

			local nam
			
				if v[0] then
					nam=" " .. v[0]
				else
					nam=""
				end
			
				print( indent_str .. "{"  .. i  .. nam )
				indent_add()
				tree(v,depth-1)
				indent_sub()
				print( indent_str .. "}"  .. i  .. nam )

			end

		end

	end

	tree_ipairs=function(tab,depth)	-- number keys contain children

		depth=depth or -1
		if depth==0 then return end

		for i,v in ipairs(tab) do

			if type(v)=="table" then
			
			local nam
			
				if v[0] then
					nam=" " .. v[0]
				else
					nam=""
				end

				print( indent_str .. "{"  .. i .. nam )
				indent_add()
				tree(v,depth-1)
				indent_sub()
				print( indent_str .. "}"  .. i .. nam )

			else

				print( indent_str .. i .. "=" .. tostring(v) )

			end

		end

	end 

	tree=function(tab,depth)

		depth=depth or -1
		if depth==0 then return end

		tree_pairs(tab,depth)
		tree_ipairs(tab,depth)

	end 


	string=function(s)
		print(indent_str..s)
	end

