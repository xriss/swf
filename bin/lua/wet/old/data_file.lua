--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--


--
--
-- Some generic functions to aid with creating data files
--
--


local io=io
local string=string
local math=math
local ipairs=ipairs
local error=error
local type=type
local tonumber=tonumber


local print=print

module 'data_file'




-- a place to keep user generated structure maps
maps={}



--
-- Expand paterns in a string with vars data
--
expand=function(vars,str)

	return ( string.gsub(str,"%$([_%w]+)%$", function (v) return vars[v] end ) )

end



--
-- read/write floating point falues 
--
write_float=function(vars,file,chb,data,bits)

end

read_float=function(vars,file,chb,bits)

end



--
-- read/write integer values 
--
write_int=function(vars,file,chb,data,sign,bits)

local data_inrange
local data_bin

local scale
	
	if		bits==32 then	scale=2^24
	elseif	bits==16 then	scale=2^8
	elseif	bits==8 then	scale=2^0
	else
			error("bad number of bits ("..bits..") ")
	end


	if		sign=='s' then

		data_inrange=tonumber(data)
		if data_inrange >= 128*scale then data_inrange=128*scale-1 end
		if data_inrange < -128*scale then data_inrange=-128*scale  end

	elseif	sign=='u' then
		
		data_inrange=tonumber(data)
		if data_inrange >= 256*scale	then data_inrange=256*scale-1	end
		if data_inrange < 0				then data_inrange=0				end

	else
			error("bad sign")
	end


	if		chb=='c' then

		file:write( string.format("%d",data_inrange) )

	elseif	chb=='b' then

	local dx,d0,d1,d2,d3

		if data_inrange < 0 then

			dx=data_inrange+(256*256*256*256)

		else

			dx=data_inrange

		end

		d3=math.floor( dx/(256*256*256) )
		dx=dx-d3*(256*256*256)

		d2=math.floor( dx/(256*256) )
		dx=dx-d2*(256*256)

		d1=math.floor( dx/(256) )
		dx=dx-d1*(256)

		d0=math.floor( dx )
		dx=dx-d0

		if		bits>24 then	file:write( string.char(d0,d1,d2,d3) )
		elseif	bits>16 then	file:write( string.char(d0,d1,d2) )
		elseif	bits>8  then	file:write( string.char(d0,d1) )
		elseif	bits>0  then	file:write( string.char(d0) )
		end

	else
			error("bad chb")
	end

end


read_int=function(vars,file,chb,sign,bits)

end

--
-- read/write pointer values (this is a special u32) 
--
write_ptr=function(vars,file,chb,data)

	if type(data)=='table' then

		if chb=='c' then

			file:write( string.format("%s_%d",vars.name,data._ptr) )

		else

			write_int(vars,file,chb,data._ptr,'u',32)

		end

	else

		write_int(vars,file,chb,0,'u',32)

	end

end

read_ptr=function(vars,file,chb)

end



--
-- read/write fixed point falues 
--
write_fixed=function(vars,file,chb,data,sign,big_bits,small_bits)

local scale=2^small_bits

	write_int(vars,file,chb,data*scale,sign,big_bits+small_bits)

end

read_fixed=function(vars,file,chb,sign,big_bits,small_bits)

end




types=
{
	['ptr']=
				{
					write		=function(vars,file,chb,data)				write_ptr	(vars,file,chb,data	)					end,
					read		=function(vars,file,chb)			return	read_ptr	(vars,file,chb		)					end,
					size=4,
				},

	['s32']=
				{
					write		=function(vars,file,chb,data)				write_int	(vars,file,chb,data,	's',32)			end,
					read		=function(vars,file,chb)			return	read_int	(vars,file,chb,			's',32)			end,
					size=4,
				},
	['u32']=
				{
					write		=function(vars,file,chb,data)				write_int	(vars,file,chb,data,	'u',32)			end,
					read		=function(vars,file,chb)			return	read_int	(vars,file,chb,			'u',32)			end,
					size=4,
				},

	['s16']=
				{
					write		=function(vars,file,chb,data)				write_int	(vars,file,chb,data,	's',16)			end,
					read		=function(vars,file,chb)			return	read_int	(vars,file,chb,			's',16)			end,
					size=2,
				},
	['u16']=
				{
					write		=function(vars,file,chb,data)				write_int	(vars,file,chb,data,	'u',16)			end,
					read		=function(vars,file,chb)			return	read_int	(vars,file,chb,			'u',16)			end,
					size=2,
				},

	['s8']=
				{
					write		=function(vars,file,chb,data)				write_int	(vars,file,chb,data,	's',8)			end,
					read		=function(vars,file,chb)			return	read_int	(vars,file,chb,			's',8)			end,
					size=1,
				},
	['u8']=
				{
					write		=function(vars,file,chb,data)				write_int	(vars,file,chb,data,	'u',8)			end,
					read		=function(vars,file,chb)			return	read_int	(vars,file,chb,			'u',8)			end,
					size=1,
				},

	['s20x12']=
				{
					write		=function(vars,file,chb,data)				write_fixed	(vars,file,chb,data,	's',20,12)		end,
					read		=function(vars,file,chb)			return	read_fixed	(vars,file,chb,			's',20,12)		end,
					size=4,
				},
	['s16x16']=
				{
					write		=function(vars,file,chb,data)				write_fixed	(vars,file,chb,data,	's',16,16)		end,
					read		=function(vars,file,chb)			return	read_fixed	(vars,file,chb,			's',16,16)		end,
					size=4,
				},

}


--
-- how big is this table?
--
sizeof=function(tab)

local size=0

	for i,v in ipairs(tab._map) do

		if v.name==null then

			size=size+types[v.type].size*#tab

		else

			size=size+types[v.type].size

		end

	end

	return size
end


--
-- position all data within the file, fill in the _ptr of each table depending on the current size
--
layout=function(tab)

local size=0

	for i,v in ipairs(tab) do

			v._ptr=size
			size=size+sizeof(v)
	end

	tab.size=size

end

--
-- write a table descriptor of data into an open file
--
write_tab=function(vars,file,chb,tab)

	for i,v in ipairs(tab._map) do

		if chb=='c' then -- seperate

			if ( i>1 ) and ( tab._map.c_div ) then

				file:write(expand(vars,tab._map.c_div))

			end

		end

		if v.name==null then -- do a int table dump, var as this type

			for ii,vv in ipairs(tab) do

				if chb=='c' then -- seperate

					if ( ii>1 ) and ( tab._map.c_div ) then

						file:write(expand(vars,tab._map.c_div))

					end

				end

				types[v.type].write(vars,file,chb,vv)

			end

		else

--print(v.name)

			types[v.type].write(vars,file,chb,tab[v.name])

		end

	end

end


--
-- write an array of table structs describing data using dump maps
--
-- chb can be set too
--
-- 'c' to produce a c data file .c (not well tested)
-- 'h' to produce a c header file .h (not well tested)
-- 'b' to produce a binary file .b
-- 'b.c' to produce a binary file .b and a .b.c file which is just a simple hex dump of the binary file
--
write=function(base_file_name,name,chb,tab)


local file
local vars={}


	vars.base_file_name=base_file_name
	vars.name=name
	vars.tab_name=''
	vars.chb=chb

	if		chb=='c' then
		file=io.open(base_file_name .. ".c","w")
	elseif	chb=='b' then
		file=io.open(base_file_name .. ".b","wb")
	elseif	chb=='h' then
		file=io.open(base_file_name .. ".h","w")
	elseif	chb=='b.c' then
		file=io.open(base_file_name .. ".b","wb")
	else
			error("bad chb")
	end

	if chb=='c' then

		if tab.c_structs then

			for i,v in ipairs(tab.c_structs) do

				if v.c_struct then

					file:write(expand(vars,v.c_struct))

				end
				
			end

			file:write('\n\n')

		end
	end

	if (chb=='h') or (chb=='c') then

		vars.ptr=0
		vars.numof=0

		for i,v in ipairs(tab) do

			vars.tab_name=v.name
			vars.numof=#v

			if v._map.h_head then
				file:write(expand(vars,v._map.h_head))
			end

			vars.ptr=vars.ptr+sizeof(v)

			if v._map.h_tail then
				file:write(expand(vars,v._map.h_tail))
			end

		end

		file:write('\n\n')

	end


	if chb=='c' then

		vars.ptr=0
		vars.numof=0

		for i,v in ipairs(tab) do

			vars.tab_name=v.name
			vars.numof=#v

			if v._map.c_head then
				file:write(expand(vars,v._map.c_head))
			end

			write_tab(vars,file,chb,v)

			vars.ptr=vars.ptr+sizeof(v)

			if v._map.c_tail then
				file:write(expand(vars,v._map.c_tail))
			end

		end

		file:write('\n\n')

	end


	if chb=='b' then

		for i,v in ipairs(tab) do

			write_tab(vars,file,chb,v)

		end

	end

	if chb=='b.c' then
	local fp
	local c
	local d

		for i,v in ipairs(tab) do

			write_tab(vars,file,'b',v)

		end
		file:close()

		file=io.open(base_file_name .. ".b","rb")
		d=file:read("*a")
		file:close()


		file=io.open(base_file_name .. ".b.c","w")


		file:write( "unsigned char "..name.."[]={\n" )

		for i=1,string.len(d) do

			if i>1 then
				if ((i-1)%32)==0 then
					file:write( ",\n" )
				else
					file:write( "," )
				end
			end
		
			file:write( string.format("0x%02x",string.byte(d,i)) )

		end

		file:write( "\n};" )


	end


	file:close()

end

