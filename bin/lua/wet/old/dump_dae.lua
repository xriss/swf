--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2003 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--





dump.dae_find=function(tab,find,ret)


	ret=ret or {}
	
	for i,v in pairs(tab) do
	
		if		type(v) == 'table' then
		
			if v[0]==find then
			
				ret[#ret+1]=v
				
				dump.dae_find(v,find,ret)
			
			else
		
				dump.dae_find(v,find,ret)
				
			end			
			
		end
		
		
	
	end

	return ret

end



dump.dae_scene_nodes=function(tab,indent)

	indent=indent or ''
	

	for i,v in ipairs(tab) do
	
		if		type(v) == 'table' then
		
			if v[0]=='node' then
			
				print(indent..v.id)
			
			end
			
			dump.dae_scene_nodes(v,indent..'-')
			
		end
	
	end

	
end

dump.dae_anim_nodes=function(tab,indent)

	indent=indent or ''
	

	for i,v in ipairs(tab) do
	
		if		type(v) == 'table' then
		
			if v[0]=='sampler' then
			
				print(indent..v.id)
			
			end
			
			dump.dae_anim_nodes(v,indent..'-')
			
		end
	
	end

	
end

dump.dae_morph_nodes=function(tab,indent)

	indent=indent or ''
	

	for i,v in ipairs(tab) do
	
		if		type(v) == 'table' then
		
			if v[0]=='controller' then
			
				print(indent..v.id)
			
			end
			
			dump.dae_morph_nodes(v,indent..'-')
			
		end
	
	end

	
end

dump.dae_mat_nodes=function(tab,indent)

	indent=indent or ''
	

	for i,v in ipairs(tab) do
	
		if		type(v) == 'table' then
		
			if v[0]=='material' then
			
				print(indent..v.id)
			
			end
			
			dump.dae_mat_nodes(v,indent..'-')
			
		end
	
	end

	
end

dump.dae_mesh_nodes=function(tab,indent)

	indent=indent or ''
	

	for i,v in ipairs(tab) do
	
		if		type(v) == 'table' then
		
			if v[0]=='geometry' then
			
				print(indent..v.id)
			
			end
			
			dump.dae_mesh_nodes(v,indent..'-')
			
		end
	
	end

	
end


dump.dae_info=function(tab)


--	ret=dump.dae_find(tab,'visual_scene')
	
	print('\nheirachy\n')
	
	dump.dae_scene_nodes(tab)

	print('\nstreams\n')
	
	dump.dae_anim_nodes(tab)
	
	print('\nmorphs\n')
	
	dump.dae_morph_nodes(tab)
	
	print('\nmaterials\n')
	
	dump.dae_mat_nodes(tab)
	
	print('\nmeshs\n')
	
	dump.dae_mesh_nodes(tab)
	
end