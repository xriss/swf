--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--

xlate=xlate or {}

-- the translation table, we load strings in and store them here

xlate.t={}


-- the missing translation table
-- if we cant find a translation for something it gets added here

xlate.n={}

-- and where it was defined, ie the lua module, gets added here

xlate.f={}


local xlate_filename="src/xlate.csv"


-----------------------------------------------------------------------------
--
-- split a string into a table
--
-----------------------------------------------------------------------------
local function str_split(div,str)

  if (div=='') or not div then error("div expected", 2) end
  if (str=='') or not str then error("str expected", 2) end
  
  local pos,arr = 0,{}
  
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
	table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
	pos = sp + 1 -- Jump past current divider
  end
  
  if pos~=0 then
	table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  else
	table.insert(arr,str) -- return entire string
  end
  
  return arr
end

-----------------------------------------------------------------------------
--
-- split a csv line into a table
--
-----------------------------------------------------------------------------
local function parse_csv_line(s)
--print(s)
    s = s..','          -- ending comma
    local t = {}     -- table to collect fields
    local fieldstart = 1
    repeat
      if string.find(s, '^"', fieldstart) then    -- quoted field?
        local a, c
        local i  = fieldstart
        repeat
          a, i, c = string.find(s, '"("?)', i+1)  -- find closing quote
        until c ~= '"'    -- repeat if quote is followed by quote
        if not i then error('unmatched "') end
        table.insert(t, (string.gsub(string.sub(s, fieldstart+1, i-1), '""', '"')) )
        fieldstart = string.find(s, ',', i) + 1
      else                -- unquoted; find next comma
        local nexti = string.find(s, ',', fieldstart)
        table.insert(t, string.sub(s, fieldstart, nexti-1) )
        fieldstart = nexti+1
      end
    until fieldstart > string.len(s)
    return t
  end


------------------------------------------------------------------------
--
-- reset all translation tables and load them up
--
------------------------------------------------------------------------

function xlate.reset()

	xlate.t={}
	xlate.n={}
	xlate.f={}

	xlate.load( xlate_filename , "EN" )

end



local idx_from



------------------------------------------------------------------------
--
-- load a translation csv into the main translation table , pick to_a if it exists otherwise pick to_b
--
------------------------------------------------------------------------

function xlate.load( filename , from )

local coll

local line_count
local data
local head

local str,tran

local to_a="EN"
local to_b="EN"

	coll={}
	line_count=1

	for line in io.lines(filename) do
	

		if line_count==1 then -- parse table header

			head=parse_csv_line(line)

			idx_from=0

			for i,v in ipairs(head) do

				if v==from then idx_from=i end

			end

		else

			data=parse_csv_line(line)

			str=data[idx_from]

			if str and str~="" then

				xlate.t[str]=data

			end

		end

		line_count=line_count+1

	end

end

xlate.reset()


------------------------------------------------------------------------
--
-- call on exit to dump out any new strings that need translating
--
------------------------------------------------------------------------

function xlate.onexit()

local head
local line

local file

local idx_from
local from

local count

	count=0

	for i,v in pairs(xlate.n) do

		count=count+1

	end

	if count==0 then return end -- check we have something to add to table

print("Autodump of "..count.." new strings")

	from="EN"
	comm="COMMENT"


	file=io.open(xlate_filename,"r+")

	if file then

		line=file:read()

		head=parse_csv_line(line)

		idx_from=null

		for i,v in ipairs(head) do

			if v==from then idx_from=i end

		end

		file:seek("end")

		if idx_from then

			for i,v in pairs(xlate.n) do

				for i=2,idx_from do

					file:write(",")

				end

				file:write( string.format('"%s"\n',v) )

			end

		end

		file:close()

	end

end

------------------------------------------------------------------------
--
-- translate a string, well check translation table for string
--
-- we dont actually translate here in this case, its done at runtime
--
------------------------------------------------------------------------

function xlate.str( str )

local tran
local dbginfo

	tran=xlate.t[str]
	
	if tran then
	
		return str

	end

-- remember strings we couldn't translate

	xlate.n[str]=str

	return str
end







