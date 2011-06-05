
local dump					= require 'dump'
local tree					= require 'tree'


local data_file				= require 'data_file'





require 'mathxtra'



require 'dump_fbx'
require 'dump_t3d'
require 'dump_dae'







if true then

print ("\nTesting minion\n\n")


--local tab = tdata.load_xml("test/minion.dae")
local tab = tdata.load_xml("test/bb.dae")


dump.dae_info(tab)


end










if false then


require 'nds'



do_nds_scene( "data/omi_monk.FBX" , sets.bones_biped , "data/" , "" )
do_nds_anim()


write_nds_image_u16( grd.create(0,"data/omi_monk.png")		,	"data/omi_monk_img"			,	"omi_monk_img"		)
write_nds_image_u16( grd.create(0,"data/omi_monk_head.png") ,	"data/omi_monk_head_img"	,	"omi_monk_head_img"	)


end







if false then

local t3d_scene
local t3d_tree
local t3d_info
local t3d_mesh

local obj_info

local fbx_scene
local fbx_tree
local fbx_meshs

local xaf_scene

local links

	fbx_scene=fbx.create("data/omi_monk.FBX")

-- get list of all meshs

	fbx_tree=fbx_scene:Hierarchy()
	meshs=tree.find_pairs(fbx_tree,"Type","MESH")

-- convert first fbx mesh into my internal format

	obj=t3d.create_object()
	obj:fbx(fbx_scene,meshs[1].Name)
	obj:build()
	obj:sort()

	obj_info=obj:info()
	dump.tree(obj_info)

--	dump.t3d_object_info(obj)
--	dump.t3d_object_data(obj)




	t3d_scene=t3d.create_scene()
	t3d_scene:fbx(fbx_scene)

	dump.string( "\nScene Info\n" )
	t3d_info=t3d_scene:info()
	dump.tree(t3d_info)

	dump.string( "\nScene Tree T3D\n" )
	t3d_tree=t3d_scene:tree()
--	dump.tree(t3d_tree)


	dump.string( "\nScene Tree XAF\n" )
	xaf_scene=tdata.load_xml("data/omi_monk_anim_export.xml.xaf")
--	dump.tree(xaf_scene)



	dump.fbx_info(fbx_scene)
--	dump.fbx_meshs(fbx_scene)



	print( "\nLinks\n" )

	links=find_t3d_xaf_links(t3d_tree,xaf_scene,t3d_xaf_links)
	for i,v in pairs(links) do
		apply_xaf_item_to_t3d_item(t3d_scene,i,v)
	end
	execute_xaf_commands(xaf_scene)
	t3d_scene.segments=nds_anim_commands.segments


	dump.tree(nds_anim_commands.segments)


	write_nds_tree(t3d_scene,sets.bones_biped,"data/test_tree","test_tree")

	write_nds_anim(t3d_scene,sets.bones_biped,"data/test_anim","test_anim")

	fbx_scene=fbx.create("data/bone.fbx")
	fbx_tree=fbx_scene:Hierarchy()
	fbx_meshs=tree.find_pairs(fbx_tree,"Type","MESH")

	t3d_mesh=t3d.create_object()
	t3d_mesh:fbx(fbx_scene,fbx_meshs[1].Name)
	t3d_mesh:build()
	t3d_mesh:sort()
	write_nds_mesh(t3d_mesh,"data/test_bone_mesh","test_bone")

end

























if false then

local proj
local tree

local meshs
local mesh

local obj
local info


	tree=tdata.load_xml("testbox2.xaf")
	dump.tree(tree)
	tree=tdata.load_xml("testbox.xaf")
	dump.tree(tree)

reduce=function(tree,depth)

		if depth==3  then

			if tree.classOf~="Bezier Float" then
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

--	tree=tdata.load_xml("C:/robs_top_secret_pr0n_stash/omi_run_reduced_keys.xaf")
--	reduce(tree,0)
--	tdata.save_xml(tree,"C:/robs_top_secret_pr0n_stash/omi_run_reduced_keys_.xaf")




	bmp=grd.create(0,"omi_monk.png")

	write_nds_image_u16(bmp,"test_img","test")

	dump.tree(bmp)




	proj=fbx.create("omi_08.FBX")

	dump.fbx_info(proj)
--	dump.fbx_meshs(proj)


	tree=proj:Hierarchy()
	meshs=tree.find_pairs(tree,"Type","MESH")


-- convert first fbx mesh into my internal format

	obj=t3d.create_object()
	obj:fbx(proj,meshs[1].Name)
	obj:build()
	obj:sort()


	info=obj:info()

	dump.t3d_object_info(obj)
--	dump.t3d_object_data(obj)



	write_nds_mesh(obj,"test_ndsl","test")

end

