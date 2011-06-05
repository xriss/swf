--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2003 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--





dump.fbx_info=function(proj)

dump.tree(
{
	["GlobalLightSettings"]		=	proj:GlobalLightSettings(),
	["GlobalTimeSettings"]		=	proj:GlobalTimeSettings(),
	["Hierarchy"]				=	proj:Hierarchy(),
}
)

end





dump.fbx_meshs=function(proj)

local proj_tree

local meshs
local mesh

	proj_tree=proj:Hierarchy()

	meshs=tree.find_pairs(proj_tree,"Type","MESH")
	dump.string("Mesh={}")
	dump.indent_add()
	for i,v in ipairs(meshs) do

		mesh=proj:Mesh(v.Name)

		dump.tree(mesh)

	end
	dump.indent_sub()


end

dump.t3d_object_info=function(obj)

local info

	info=obj:info()

	dump.string("")
	dump.string("T3D object info={}")
	dump.indent_add()
		dump.tree(info)
	dump.indent_sub()


end
