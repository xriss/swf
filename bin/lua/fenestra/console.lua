

local hex=function(str) return tonumber(str,16) end

local string=string
local table=table
local ipairs=ipairs
local math=math
local loadstring=loadstring
local pcall=pcall

-- imported global functions
local sub = string.sub
local match = string.match
local find = string.find
local push = table.insert
local pop = table.remove
local append = table.insert
local concat = table.concat
local floor = math.floor
local write = io.write
local read = io.read
local type = type
local setfenv = setfenv
local tostring=tostring
local pairs=pairs
local ipairs=ipairs
local unpack=unpack

local _G = _G

module("fenestra.console")


-----------------------------------------------------------------------------
--
-- split a string into a table
--
-----------------------------------------------------------------------------
local function split(div,str)

  if (div=='') or not div then error("div expected", 2) end
  if (str=='') or not str then error("str expected", 2) end
  
  local pos,arr = 0,{}
  
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,false) end do
	table.insert(arr,sub(str,pos,st-1)) -- Attach chars left of current divider
	pos = sp + 1 -- Jump past current divider
  end
  
  if pos~=0 then
	table.insert(arr,sub(str,pos)) -- Attach chars right of last divider
  else
	table.insert(arr,str) -- return entire string
  end
  
  
  return arr
end




function setup(fenestra)

	local function print(...)
		fenestra._g.print(...)
	end

	local ogl=fenestra.ogl

	local it={}
	
	local history={}
	local history_idx=0
	local lines={}
	local lines_display={}
	local line=""
	local line_idx=0
	
	local throb=255
	
	it.x=0
	it.y=0
	it.y_show=8*8
	
	it.show=false

	function it.clean()

	end
	
	-- print out lua data in a somewhat sensible way, returns a string
	it.dump_limit = 20
	it.dump_depth = 7
	it.dump_stack = {}

	it.call = {} -- name -> function : functions that should be easily to call on the console command line
	
	it.call.help=function()
		return "There is no enape"
	end
	
	function it.dump_table(tbl,delim)
		local n = #tbl
		local res = ''
		local k = 0
		-- very important to avoid disgracing ourselves with circular referencs...
		if #it.dump_stack > it.dump_depth then
			return "..."
		end
		for i,t in ipairs(it.dump_stack) do
			if tbl == t then
				return "<self>"
			end
		end
		push(it.dump_stack,tbl)
		
		for key,v in pairs(tbl) do
			if type(key) == 'number' then
				key = '['..tostring(key)..']'
			else
				key = tostring(key)
			end
			res = res..delim..key..'='..it.dump_string(v)
			k = k + 1
			if k > it.dump_limit then
				res = res.." ... "
				break
			end
		end
		
		pop(it.dump_stack)
		return sub(res,2)
	end



	function it.dump_string(val)
		local tp = type(val)
		if tp == 'function' then
			return tostring(val)
		elseif tp == 'table' then
			if val.__tostring  then
				return tostring(val)
			else
				return '{'..it.dump_table(val,',\n')..'}'
			end
		elseif tp == 'string' then
			return val--"'"..val.."'"
		elseif tp == 'number' then
			return tostring(val)
		else
			return tostring(val)
		end
	end
	
-- based on ilua.lua
	function it.dump_eval(line)
	
		local function compile(line)
			local f,err = loadstring(line,'local')
			return err,f
		end
		
		
		local err,chunk
		local ret={}
		local args={}
		
		
		if line~="" then args=split("%s",line) end -- split input on whitespace
		
		if args[1] then
		
			function lookup(tab,name)
				local names=split("%.",name)
				for i,v in ipairs(names) do
--				print(i.." "..v)
					if type(tab)=="table" then
						tab=tab[v]
					else
						tab=nil
					end
				end
				return tab
			end
			
			chunk=lookup(it.call,args[1]) -- check special console functions
			
			if chunk and type(chunk)=="function" then -- must be a function
			
				table.remove(args,1) -- remove the function name
			
				setfenv(chunk,fenestra._g) -- call with master environment?
			else
			
				chunk=lookup(fenestra._g,args[1]) -- check for functions in master environment
				
				if chunk and type(chunk)=="function" then -- must be a function
				
					table.remove(args,1) -- remove the function name
				
				else
					chunk=nil
				end
				
				-- do not try and change the fenv of a function in the main envronment...
			
			end
			
		end
		
		if not chunk then
		
			args={} -- no arguments
			
			-- is it an expression?
			err,chunk = compile('print('..line..')')
			if err then
				-- otherwise, a statement?
				err,chunk = compile(line)
			end
			
			if chunk then
				setfenv(chunk,fenestra._g) -- compile in master environment will have an overloaded print
			end
		end

		-- if compiled ok, then evaluate the chunk
		if not err and chunk then
		
			ret = { pcall(chunk,unpack(args)) }
			
			if not ret[1] then
				err=ret[2]
				ret={}
			else
				table.remove(ret,1)
			end
			
		end
		
		-- if there was any error, print it out
		if err then
			fenestra._g.print(err)
		else
			for i,v in ipairs(ret) do
				fenestra._g.print(v)
			end
		end
	end

	function it.update()
	
		throb=throb-4
		if throb<0 then throb=255 end
		
		if it.show then
			if it.y~=it.y_show then
			
				local d=(it.y_show-it.y)/4
				if d>0 then d=math.ceil(d) else d=math.floor(d) end
				it.y= math.floor( it.y + d )
			
			end
		else
			if it.y~=0 then
			
				local d=(0-it.y)/4
				if d>0 then d=math.ceil(d) else d=math.floor(d) end
				it.y= math.floor( it.y + d )
			
			end
		end
		
	end
	
	function it.draw()
	
		fenestra.debug_begin()
		
		local w=fenestra.get("width")
		local h=it.y
		fenestra.debug_polygon_begin()
		fenestra.debug_polygon_vertex(0,0,hex"8800ff00")
		fenestra.debug_polygon_vertex(w,0,hex"8800ff00")
		fenestra.debug_polygon_vertex(w,h,hex"88008800")
		fenestra.debug_polygon_vertex(0,h,hex"88008800")
		fenestra.debug_polygon_end()
		
--		fenestra.debug_rect(0,0,fenestra.get("width"),it.y,hex"8800ff00")		
		
		local i=#lines
		local y=it.y-16
		while y>-8 and i>0 do
		
			fenestra.debug_print({x=0,y=y,size=8,color=hex"ff00ff00",s=lines[i]})
			
			y=y-8
			i=i-1
		end
		
		for i,v in ipairs(lines_display) do
		
			fenestra.debug_print({x=0,y=it.y+i*8-8,size=8,color=hex"ff00ff00",s=v})
		
		end
		
		
		fenestra.debug_print({x=0,y=it.y-8,size=8,color=hex"ff00ff00",s=">"..line})
		
		fenestra.debug_rect((line_idx+1)*8,it.y-8,(line_idx+2)*8,it.y,hex"00ff00"+throb*256*256*256)
		
			
		fenestra.debug_end()

		lines_display={}

	end
	
	function it.print(s)
	
		s=it.dump_string(s)
	
		table.insert(lines,s)
		
		while #lines > 64 do
		
			table.remove(lines,1)
		
		end
		
	end
	
	function it.display(s)
	
		s=it.dump_string(s)
		
		table.insert(lines_display,s)
	
	end
	
	function it.mouse(act,x,y,key)
--		print(act.." "..x..","..y.." "..key)
	end
	
	function it.keypress(ascii,key,act)

		if act=="down" then
--			fenestra._g.print(ascii.." "..(key or ""))
		end

		if it.show then
		
			if act=="down" or act=="repeat" then
			
				if key=="left" then

					line_idx=line_idx-1
					if line_idx<0 then line_idx=0 end
					
					throb=255
								
				elseif key=="right" then
			
					line_idx=line_idx+1
					if line_idx>#line then line_idx=#line end
					
					throb=255
					
				elseif key=="home" then
				
					line_idx=0
				
				elseif key=="end" then
				
					line_idx=#line
				
				elseif key=="backspace" then
			
					if line_idx >= #line then -- at end
					
						line=line:sub(1,-2)
						line_idx=#line
					
					elseif line_idx == 0 then -- at start
					
					elseif line_idx == 1 then -- near start
					
						line=line:sub(2)
						line_idx=line_idx-1
					
					else -- somewhere in the line
					
						line=line:sub(1,line_idx-1) .. line:sub(line_idx+1)
						line_idx=line_idx-1
						
					end
					
					throb=255
					
				elseif key=="delete" then
			
					if line_idx >= #line then -- at end
					

					elseif line_idx == 0 then -- at start
					
						line=line:sub(2)
						line_idx=0
					
					else -- somewhere in the line
					
						line=line:sub(1,line_idx) .. line:sub(line_idx+2)
						line_idx=line_idx
						
					end
					
					throb=255
					
				elseif key=="enter" or key=="return" then
				
					if act=="down" then -- ignore repeats on enter key
					
						local f=line
						fenestra._g.print(">"..f)
						
						table.insert(history,line)
						
						while #history > 64 do
							table.remove(history,1)
						end
				
						history_idx=#history+1
					
						line=""
						line_idx=0
						
						if f then
						
							it.dump_eval(f)
							
						end
						
					end
					
				elseif key=="page up" or key=="prior" then
				
					it.y_show=it.y_show-8
				
				elseif key=="page down" or key=="next" then
				
					it.y_show=it.y_show+8

				elseif key=="up" then
				
					history_idx=history_idx-1
					if history_idx<0 then history_idx=#history end
					line=history[history_idx] or ""
					line_idx=#line
				
				elseif key=="down" then
				
					history_idx=history_idx+1
					if history_idx>#history then history_idx=0 end
					line=history[history_idx] or ""
					line_idx=#line
					
				elseif ascii~="" then -- not a blank string
					local c=string.byte(ascii)
					
					if act=="down" and ascii=="`" then
					
						it.show= not it.show
						
						throb=255

					else
						if c>=32 and c<128 then
						
							if line_idx >= #line then -- put at end
							
								line=line..ascii
								line_idx=#line
								
							elseif line_idx == 0 then -- put at start
							
								line=ascii..line
								line_idx=line_idx+1
								
							else -- need to insert into line
							
								line=line:sub(1,line_idx) .. ascii .. line:sub(line_idx+1)
								line_idx=line_idx+1
								
							end
							
							throb=255
							
						end
					end
				end
			end
			
			return true
			
		else
			if act=="down" and ascii=="`" then
			
				it.show= not it.show
				
				throb=255

				return true
			end
		end
	end
	
-- overload print function in the given (global) tab
-- returns a function to undo this act (however this function may fail...)
	function it.replace_print(g)
	
		local print_old=g.print
		it.print_old=g.print
		local print_new=function(...)
		
			local t={}
			for i,v in ipairs(arg) do
				table.insert(t, it.dump_string(v) )
			end
			if not t[1] then t[1]="nil" end
			
			it.print( unpack(t) )
			if print_old then
				print_old( unpack(t) )
			end
		end
		g.print=print_new
		
		return function()
			if g.print==print_new then -- only change back if noone else changed it
				g.print=print_old
				return true
			end
		end
	end

	
	return it
end
