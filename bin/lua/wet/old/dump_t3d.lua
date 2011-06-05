--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2003 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--






dump.t3d_object_data=function(obj)

local info

	info=obj:info()

	for i=1,info.numof_surfaces do
	local surface

		surface=obj:surface(i)

		dump.string("Surface={}")

		dump.string("{"..i)
		dump.indent_add()

			dump.tree(surface)

		dump.indent_sub()
		dump.string("}"..i)

	end


	for i=1,info.numof_bones do
	local bone

		bone=obj:bone(i)

		dump.string("Bone={}")

		dump.string("{"..i)
		dump.indent_add()

			dump.tree(bone)

		dump.indent_sub()
		dump.string("}"..i)

	end


	for i=1,info.numof_points do
	local point

		point=obj:point(i)

		dump.string("Point={}")

		dump.string("{"..i)
		dump.indent_add()

			dump.tree(point)

		dump.indent_sub()
		dump.string("}"..i)

	end


	for i=1,info.numof_maps do
	local map

		map=obj:map(i)

		dump.string("map={}")

		dump.string("{"..i)
		dump.indent_add()

			dump.tree(map)

		dump.indent_sub()
		dump.string("}"..i)

	end

	for i=1,info.numof_polys do
	local poly

		poly=obj:poly(i)

		dump.string("poly={}")

		dump.string("{"..i)
		dump.indent_add()

			dump.tree(poly)

		dump.indent_sub()
		dump.string("}"..i)

	end


end




