--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2003 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--



--
-- This is included from a c module, so expect the global table tdata to be setup by that
--

assert( tdata , "this file should only be run after the binary module" )




tdata.xml_basic_header='<?xml version="1.0" standalone="no" ?>\n'



------------------------------------------------------------------------
--
-- save an xml table
--
------------------------------------------------------------------------
function tdata.save_xml_table( fp , tab , ins )

	for i,v in ipairs(tab) do

		if type(v) == "string" then

			fp:write( string.format( "%s%s\n" , ins , v ) )

		elseif type(v) == "table" then

			if v[0] then

				fp:write( string.format( "%s<%s " , ins , v[0] ) )

				for i,v in pairs(v) do

					if type(i) == "string" then

						fp:write( string.format( "%s=\"%s\" " , i , v ) )

					end

				end

				if v[1] == nil then

					fp:write( string.format( "/>\n" ) )

				else

					fp:write( string.format( ">\n" ) )

					tdata.save_xml_table( fp , v , ins .. " " )

					fp:write( string.format( "%s</%s>\n" , ins , v[0] ) )

				end
			end
		end

	end

end




------------------------------------------------------------------------
--
-- save an xml header and table
--
------------------------------------------------------------------------
function tdata.save_xml( tab , filename , head )

local fp

	fp=io.open(filename,"w")

	fp:write( head or tdata.xml_basic_header )

	tdata.save_xml_table(fp,tab,"")

	fp:close()

end

------------------------------------------------------------------------
--
-- load an xml table
--
------------------------------------------------------------------------
function tdata.load_xml( filename )

local fp
local buff

	fp=io.open(filename,"r")

	buff=fp:read("*a")

	fp:close()

	return tdata.parse_xml(buff)

end

------------------------------------------------------------------------
--
-- save a csv table
--
------------------------------------------------------------------------
function tdata.save_csv( tab , filename )

local fp

	fp=io.open(filename,"w")

	for i,v in ipairs(tab) do

		for i,v in ipairs(v) do

			if i~=1 then fp:write(",") end -- seperator

			if v~="" then

				fp:write('"')
				fp:write(v)
				fp:write('"')

			end

		end

		fp:write("\n")

	end

	fp:close()

end

------------------------------------------------------------------------
--
-- load a csv table
--
------------------------------------------------------------------------
function tdata.load_csv( filename )

local line_count
local coll

	coll={}
	line_count=1

	for line in io.lines(filename) do
	
		coll[line_count]=tdata.parse_csv_line(line)

		line_count=line_count+1

	end

	return coll

end

