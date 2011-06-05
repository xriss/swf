--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--





------------------------------------------------------------------------
--
-- auto journal save, make sure the required dir structure exists
-- then write a journal with the current time / version / profile info
--
------------------------------------------------------------------------
function journal.save_journal_auto( j , name_state , name_set , name_level )

local info=wet[name_state]

local timestamp

local dir

-- make sure directory structure exists, it wont do the first time we are called

	dir=wet.local_dir..'replay/'						;	xtra.makedir(dir)
	dir=dir..info.name_str..'_'..info.version_str..'/'	;	xtra.makedir(dir)
	dir=dir..name_set..'/'								;	xtra.makedir(dir)
	dir=dir..name_level..'/'							;	xtra.makedir(dir)

local name

-- build name using date/time and profile name for a unique flename

	timestamp=wet.date_time_now()

	name=timestamp .. '_' .. profile.name .. '.xml'


-- fill in some simple info

	j.info.name=info.name_str
	j.info.version=info.version_str
	j.info.owner=profile.name
	j.info.timestamp=timestamp

--	print( name )

	journal.save_journal(j,dir..name)

end



------------------------------------------------------------------------
--
-- save as xml 
--
------------------------------------------------------------------------
function journal.save_journal( j , filename )

local fp

	fp=io.open(filename,"w")

	fp:write( tdata.xml_basic_header )
	fp:write( '<!-- http://www.wetgenes.com/xml/journal -->\n' )

	fp:write( string.format( "<%s>\n" , 'journal' ) )

	fp:write( string.format( " <%s " , 'info' ) )
	for i,v in pairs(j.info) do

		if type(i) == "string" then

			fp:write( i..'="'..v..'" ' )

		end

	end
	fp:write( string.format( "/>\n" ) )

	for i,v in ipairs(j) do

		fp:write( string.format( " <%s>\n" , 'stream' ) )

		fp:write( v.read_str() )

		fp:write( string.format( " </%s>\n" , 'stream' ) )

	end

	fp:write( string.format( "</%s>\n" , 'journal' ) )

	fp:close()

end


------------------------------------------------------------------------
--
-- load from xml 
--
------------------------------------------------------------------------
function journal.load_journal( filename )

local x
local j
local s

	x=tdata.load_xml(filename)

	j={}
	j.info={}
	j.v={}

	s=1

	for i,v in ipairs(x[1]) do

		if		v[0]=='info'		then	-- copy values into j.info

			for i,v in pairs(v) do

				if type(i) == "string" then
				
					j.info[i]=v

				end

			end

		elseif	v[0]=='stream'		then	-- allocate a stream and fill

			j[s]=journal.alloc_stream()

			j[s].write_str(v[1])

			s=s+1

		end

	end

	j.autosaved=true	-- flag not to save after playing

	return j

end


------------------------------------------------------------------------
--
-- scan a directory and load all xml files into a sorted highscores table 
-- only the info part of the journal xml is used
--
-- the full filename is added into the xml info
--
------------------------------------------------------------------------
function journal.get_scores( dirname )

local tab={}
local list

	list = xtra.dir(dirname..'*.xml')

	for i,v in ipairs(list) do

		table.insert(tab,journal.get_info(dirname..v))

	end

	table.sort(tab,function(a,b)

		if a.time <  b.time then return true end

		if a.time == b.time then

			if a.timestamp <  b.timestamp then return true end

		end

		return false
	end)

	return tab

end


------------------------------------------------------------------------
--
-- an xml journal is loaded and the info part extracted and returned
-- the filename used to load this info chunk is inserted as 'filename'
--
------------------------------------------------------------------------
function journal.get_info( filename )

local x

	x=tdata.load_xml(filename)

	for i,v in ipairs(x) do

		if		v[0]=='journal'		then	-- we have a valid journal

			for i,v in ipairs(v) do

				if		v[0]=='info'		then	-- we have an info chunk

					v.filename=filename

					return v

				end

			end

		end

	end

end