
local table=table
local string=string

local ipairs=ipairs

local type=type

module("simpxml")


-----------------------------------------------------------------------------
--
-- some old simple xml parsing code, found here and fixed up a little :)
--
-- http://lua-users.org/lists/lua-l/2002-06/msg00040.html
--
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
--
-- auxiliar function to parse tag attributes
--
-----------------------------------------------------------------------------
function parse_args(s,label)
  local arg = {}
  arg[0]=label or "?"
  string.gsub(s, "([%w_]+)%s*=%s*([\"'])(.-)%2", function (w, _, a)
    arg[string.lower(w)] = a
  end)
  return arg
end

-----------------------------------------------------------------------------
--
-- string "s" is a string with XML marks. This function parses the string
-- and returns the resulting tree.
--
-- simple but will parse small simple data xml files just fine and thats what im using it for
--
-- it is however very easy to produce a valid xml file that will break this
-- however as long as you are just using tags/data then this is fine
--
-- by putting the tag name in [0] we can use the string namespace for all attributes
--
-- [0] == tag name
-- [1++] == contained strings or tables (sub tags)
-- [stringnames] == attributes IE all string keys
--
-----------------------------------------------------------------------------
function parse(s)
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local i = 1
  local ni,j,c,label,args, empty = string.find(s, "<%?(%/?)([%w_]+)(.-)(%/?)%?>")
  
  while ni do
    local text = string.sub(s, i, ni-1)
    if not string.find(text, "^%s*$") then
      table.insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      table.insert(top, parse_args(args,label) )
    elseif c == "" then   -- start tag
      top = parse_args(args,label)
      table.insert(stack, top)   -- new level
    else  -- end tag
      local toclose = table.remove(stack)  -- remove top
      top = stack[#stack]
      if #stack < 1 then
        assert(false,"Tag <"..label.."> not matched ")
      end
      if toclose[0] ~= label then
	    assert(false,"Tag <"..(toclose[0] or "?").."> doesnt match <"..(label or "?")..">.")
      end
      table.insert(top, toclose)
    end 
    i = j+1
    ni,j,c,label,args, empty = string.find(s, "<(%/?)([%w_]+)(.-)(%/?)>", j)
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
    table.insert(stack[#stack], text)
  end
  return stack[2]
end


-----------------------------------------------------------------------------
--
-- find the first child tag of the given type
--
-----------------------------------------------------------------------------
function child(parent,name)

	name=string.lower(name)

	for i,v in ipairs(parent) do
		if type(v)=="table" and v[0] and string.lower(v[0])==name then return v end
	end
	
	return nil

end



