--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--



-- the translation table, we load strings in and store them here

xlate.t={}


-- the missing translation table
-- if we cant find a translation for something it gets added  here

xlate.n={}

-- and where it was defined, ie the lua module, gets added here

xlate.f={}



------------------------------------------------------------------------
--
-- reset all translation tables and load them up
--
------------------------------------------------------------------------

function xlate.reset()

	xlate.t={}
	xlate.n={}
	xlate.f={}

	xlate.load( tdata.dir_local() .. "xlate/wettest.csv" , "EN" , opt.lang() , opt.lang_alt() )

end


------------------------------------------------------------------------
--
-- load a translation csv into the main translation table , pick to_a if it exists otherwise pick to_b
--
------------------------------------------------------------------------

function xlate.load( filename , from , to_a , to_b )

local coll

local line_count
local data
local head

local idx_from
local idx_to_a
local idx_to_b

local str,tran

	coll={}
	line_count=1

	for line in io.lines(filename) do
	

		if line_count==1 then -- parse table header

			head=tdata.parse_csv_line(line)

			idx_from=0
			idx_to_a=0
			idx_to_b=0



			for i,v in ipairs(head) do

--print(i,v)

				if v==from then idx_from=i end
				if v==to_a then idx_to_a=i end
				if v==to_b then idx_to_b=i end

			end


		else

			data=tdata.parse_csv_line(line)

			str=data[idx_from]

			if str and str~="" then

				tran=data[idx_to_a]

				if not tran or tran=="" then

					tran=data[idx_to_b]

				end
				
				if tran and tran~="" then

					xlate.t[str]=tran

				else

					if not xlate.t[str] then

						xlate.t[str]=str

					end

				end

			end


		end

		line_count=line_count+1

	end


end


------------------------------------------------------------------------
--
-- call on exit to dump out any new strings that need translating
--
------------------------------------------------------------------------

function xlate.onexit()

local head
local line

local file
local filename

local idx_from
local from

local idx_comm
local comm

local count

	count=0

	for i,v in pairs(xlate.n) do

		count=count+1

	end

	if count==0 then return end -- check we have something to add to table



	from="EN"
	comm="COMMENT"

	filename= tdata.dir_local() .. "xlate/wettest.csv"

	file=io.open(filename,"r+")

	if file then

		line=file:read()

		head=tdata.parse_csv_line(line)

		idx_from=null
		idx_comm=null

		for i,v in ipairs(head) do

			if v==from then idx_from=i end
			if v==comm then idx_comm=i end

		end

		file:seek("end")

		if idx_comm then

			for i=2,idx_comm do

				file:write(",")

			end

				file:write('"Autodump of new strings"\n')
		end

		if idx_from then

			if idx_comm and (idx_comm<idx_from) then -- include comment as well

				for i,v in pairs(xlate.n) do

					for i=2,idx_comm do

						file:write(",")

					end

					file:write( string.format('"%s",',xlate.f[i]) )

					for i=idx_comm+2,idx_from do

						file:write(",")

					end

					file:write( string.format('"%s"\n',i) )

				end

			else

				for i,v in pairs(xlate.n) do

					for i=2,idx_from do

						file:write(",")

					end

					file:write( string.format('"%s"\n',i) )

				end

			end

		end

		file:close()

	end

end

------------------------------------------------------------------------
--
-- translate a string
--
------------------------------------------------------------------------

function xlate.str( str )

local tran
local dbginfo

	tran=xlate.t[str]
	
	if tran then
	
		return tran

	end

-- remember strings we couldn't translate

	xlate.n[str]=str

-- include the first place it was referenced for dumping out in the comment
-- so we can track it down easily if it is spurious,
-- or just sort by module when it comes to translating stuff

	dbginfo=debug.getinfo(2,'Sl')

	xlate.f[str]=dbginfo.source..'('..dbginfo.currentline..')'

	return str
end



------------------------------------------------------------------------
--
-- use XLT("string to translate")
--
-- this should done with explicite strings to help with any tools that may want to skim through the source
-- so try not to do XLT(str) always use XLT("string to translate") and pass that result down
--
-- also its intended that each string is not a fragment or a paragraph but a full sentence or a single word.
--
------------------------------------------------------------------------
if global then global.XLT=xlate.str else XLT=xlate.str end


--print("Testing XLT")
--print(XLT("test"))
--print(global.XLT("test"))


--
-- load in default translation tables
--

xlate.reset()

