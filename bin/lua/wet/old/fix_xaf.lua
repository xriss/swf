--
-- Load in an xal file and then spit it out again
--
-- input == filename.xaf
-- output == filename.xml.xaf or arg[2] if supplied
--
--


reduce=function(tree,depth)

	depth=depth or 0

		if depth==3  then

			if ( tree.classOf~="Bezier Float" ) and ( tree.classOf~="Animatable" ) then
			local i

				print( "kill" , tree.classOf )

				repeat
					i=next(tree)
					if i then tree[i]=null end
				until i==null

			else

				print( "live" , tree.classOf )

			end

		else
			for i,v in ipairs(tree) do

				reduce(v,depth+1)

			end
		end

		return true -- keep
	end



local xml_force_order=
{
	"t",
	"xB",
	"yB",
	"zB",
	"wB",
	"cVel",
	"unconHan",
	"inTan",
	"outTan",
	"v",
	"inTanVal",
	"outTanVal",
	"inLen",
	"outLen",
}



------------------------------------------------------------------------
--
-- save an xml table, speshial fixup for max retardedness
--
------------------------------------------------------------------------
function tdata_save_xml_table( fp , tab , ins )

	for i,v in ipairs(tab) do

		if type(v) == "string" then

			fp:write( string.format( "%s%s\n" , ins , v ) )

		elseif type(v) == "table" then

			if v[0] then

				fp:write( string.format( "%s<%s " , ins , v[0] ) )

				for ii,vv in ipairs(xml_force_order) do

					if v[vv] then

						fp:write( string.format( "%s=\"%s\" " , vv , v[vv] ) )

					end

				end

				for i,v in pairs(v) do
				local i_do

					i_do=i

					for ii,vv in ipairs(xml_force_order) do

						if i_do==vv then i_do=null break end -- already written

					end

					if type(i_do) == "string" then

						fp:write( string.format( "%s=\"%s\" " , i_do , v ) )

					end


				end

				if v[1] == nil then

					fp:write( string.format( "/>\n" ) )

				else

					fp:write( string.format( ">\n" ) )

					tdata_save_xml_table( fp , v , ins .. " " )

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
function tdata_save_xml( tab , filename , head )

local fp

	fp=io.open(filename,"w")

	fp:write( head or tdata.xml_basic_header )

	tdata_save_xml_table(fp,tab,"")

	fp:close()

end





local tree

local fname_in,fname_out


	if	arg[1]==null then

		print( "Need to specify an input xaf file to convert.\n" )
		return(20)

	end 


	fname_in=arg[1]
	fname_out=arg[2]


	if	fname_out==null then

		fname_out=string.gsub(arg[1],".xaf",".xml.xaf")

	end

print( "Today we will be reducing and reformating a .xaf file." )



print( "loading " .. fname_in )

	tree=tdata.load_xml(fname_in)


print( "Reducing data" )

	reduce(tree)


print( "Saving " .. fname_out )

	tdata_save_xml(tree,fname_out)


print( "Finished." )




