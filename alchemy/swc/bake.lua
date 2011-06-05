
filesbase="/mnt/hgfs/wet/swf/alchemy/src/"
filesbase="/cygdrive/c/wet/swf/alchemy/src/"

relbase="../../src/"

allfile=
[[
mesa/src/mesa/drivers/common/driverfuncs.c
mesa/src/mesa/drivers/common/driverfuncs.h
mesa/src/mesa/drivers/osmesa/osmesa.c
mesa/src/mesa/glapi/glapi.c
mesa/src/mesa/glapi/glapi_getproc.c
mesa/src/mesa/glapi/glthread.c
mesa/src/mesa/glapi/dispatch.h
mesa/src/mesa/glapi/glapi.h
mesa/src/mesa/glapi/glapioffsets.h
mesa/src/mesa/glapi/glapitable.h
mesa/src/mesa/glapi/glapitemp.h
mesa/src/mesa/glapi/glprocs.h
mesa/src/mesa/glapi/glthread.h
mesa/src/mesa/main/accum.c
mesa/src/mesa/main/api_arrayelt.c
mesa/src/mesa/main/api_exec.c
mesa/src/mesa/main/api_loopback.c
mesa/src/mesa/main/api_noop.c
mesa/src/mesa/main/api_validate.c
mesa/src/mesa/main/arrayobj.c
mesa/src/mesa/main/attrib.c
mesa/src/mesa/main/blend.c
mesa/src/mesa/main/bufferobj.c
mesa/src/mesa/main/buffers.c
mesa/src/mesa/main/clear.c
mesa/src/mesa/main/clip.c
mesa/src/mesa/main/colortab.c
mesa/src/mesa/main/context.c
mesa/src/mesa/main/convolve.c
mesa/src/mesa/main/debug.c
mesa/src/mesa/main/depth.c
mesa/src/mesa/main/depthstencil.c
mesa/src/mesa/main/dispatch.c
mesa/src/mesa/main/dlist.c
mesa/src/mesa/main/dlopen.c
mesa/src/mesa/main/drawpix.c
mesa/src/mesa/main/enable.c
mesa/src/mesa/main/enums.c
mesa/src/mesa/main/eval.c
mesa/src/mesa/main/execmem.c
mesa/src/mesa/main/extensions.c
mesa/src/mesa/main/fbobject.c
mesa/src/mesa/main/feedback.c
mesa/src/mesa/main/ffvertex_prog.c
mesa/src/mesa/main/fog.c
mesa/src/mesa/main/framebuffer.c
mesa/src/mesa/main/get.c
mesa/src/mesa/main/getstring.c
mesa/src/mesa/main/hash.c
mesa/src/mesa/main/hint.c
mesa/src/mesa/main/histogram.c
mesa/src/mesa/main/image.c
mesa/src/mesa/main/imports.c
mesa/src/mesa/main/light.c
mesa/src/mesa/main/lines.c
mesa/src/mesa/main/matrix.c
mesa/src/mesa/main/mipmap.c
mesa/src/mesa/main/mm.c
mesa/src/mesa/main/multisample.c
mesa/src/mesa/main/pixel.c
mesa/src/mesa/main/pixelstore.c
mesa/src/mesa/main/points.c
mesa/src/mesa/main/polygon.c
mesa/src/mesa/main/queryobj.c
mesa/src/mesa/main/rastpos.c
mesa/src/mesa/main/rbadaptors.c
mesa/src/mesa/main/readpix.c
mesa/src/mesa/main/renderbuffer.c
mesa/src/mesa/main/scissor.c
mesa/src/mesa/main/shaders.c
mesa/src/mesa/main/state.c
mesa/src/mesa/main/stencil.c
mesa/src/mesa/main/texcompress.c
mesa/src/mesa/main/texcompress_fxt1.c
mesa/src/mesa/main/texcompress_s3tc.c
mesa/src/mesa/main/texenv.c
mesa/src/mesa/main/texenvprogram.c
mesa/src/mesa/main/texformat.c
mesa/src/mesa/main/texgen.c
mesa/src/mesa/main/teximage.c
mesa/src/mesa/main/texobj.c
mesa/src/mesa/main/texparam.c
mesa/src/mesa/main/texrender.c
mesa/src/mesa/main/texstate.c
mesa/src/mesa/main/texstore.c
mesa/src/mesa/main/varray.c
mesa/src/mesa/main/vtxfmt.c
mesa/src/mesa/main/accum.h
mesa/src/mesa/main/api_arrayelt.h
mesa/src/mesa/main/api_exec.h
mesa/src/mesa/main/api_loopback.h
mesa/src/mesa/main/api_noop.h
mesa/src/mesa/main/api_validate.h
mesa/src/mesa/main/arrayobj.h
mesa/src/mesa/main/attrib.h
mesa/src/mesa/main/bitset.h
mesa/src/mesa/main/blend.h
mesa/src/mesa/main/bufferobj.h
mesa/src/mesa/main/buffers.h
mesa/src/mesa/main/clear.h
mesa/src/mesa/main/clip.h
mesa/src/mesa/main/colormac.h
mesa/src/mesa/main/colortab.h
mesa/src/mesa/main/config.h
mesa/src/mesa/main/context.h
mesa/src/mesa/main/convolve.h
mesa/src/mesa/main/dd.h
mesa/src/mesa/main/debug.h
mesa/src/mesa/main/depth.h
mesa/src/mesa/main/depthstencil.h
mesa/src/mesa/main/dlist.h
mesa/src/mesa/main/dlopen.h
mesa/src/mesa/main/drawpix.h
mesa/src/mesa/main/enable.h
mesa/src/mesa/main/enums.h
mesa/src/mesa/main/eval.h
mesa/src/mesa/main/extensions.h
mesa/src/mesa/main/fbobject.h
mesa/src/mesa/main/feedback.h
mesa/src/mesa/main/ffvertex_prog.h
mesa/src/mesa/main/fog.h
mesa/src/mesa/main/framebuffer.h
mesa/src/mesa/main/get.h
mesa/src/mesa/main/glheader.h
mesa/src/mesa/main/hash.h
mesa/src/mesa/main/hint.h
mesa/src/mesa/main/histogram.h
mesa/src/mesa/main/image.h
mesa/src/mesa/main/imports.h
mesa/src/mesa/main/light.h
mesa/src/mesa/main/lines.h
mesa/src/mesa/main/macros.h
mesa/src/mesa/main/matrix.h
mesa/src/mesa/main/mfeatures.h
mesa/src/mesa/main/mipmap.h
mesa/src/mesa/main/mm.h
mesa/src/mesa/main/mtypes.h
mesa/src/mesa/main/multisample.h
mesa/src/mesa/main/pixel.h
mesa/src/mesa/main/pixelstore.h
mesa/src/mesa/main/points.h
mesa/src/mesa/main/polygon.h
mesa/src/mesa/main/queryobj.h
mesa/src/mesa/main/rastpos.h
mesa/src/mesa/main/rbadaptors.h
mesa/src/mesa/main/readpix.h
mesa/src/mesa/main/renderbuffer.h
mesa/src/mesa/main/scissor.h
mesa/src/mesa/main/shaders.h
mesa/src/mesa/main/simple_list.h
mesa/src/mesa/main/state.h
mesa/src/mesa/main/stencil.h
mesa/src/mesa/main/texcompress.h
mesa/src/mesa/main/texenv.h
mesa/src/mesa/main/texenvprogram.h
mesa/src/mesa/main/texformat.h
mesa/src/mesa/main/texformat_tmp.h
mesa/src/mesa/main/texgen.h
mesa/src/mesa/main/teximage.h
mesa/src/mesa/main/texobj.h
mesa/src/mesa/main/texparam.h
mesa/src/mesa/main/texrender.h
mesa/src/mesa/main/texstate.h
mesa/src/mesa/main/texstore.h
mesa/src/mesa/main/varray.h
mesa/src/mesa/main/version.h
mesa/src/mesa/main/vtxfmt.h
mesa/src/mesa/main/vtxfmt_tmp.h
mesa/src/mesa/math/m_debug_clip.c
mesa/src/mesa/math/m_debug_norm.c
mesa/src/mesa/math/m_debug_xform.c
mesa/src/mesa/math/m_eval.c
mesa/src/mesa/math/m_matrix.c
mesa/src/mesa/math/m_translate.c
mesa/src/mesa/math/m_vector.c
mesa/src/mesa/math/m_xform.c
mesa/src/mesa/math/mathmod.h
mesa/src/mesa/math/m_clip_tmp.h
mesa/src/mesa/math/m_copy_tmp.h
mesa/src/mesa/math/m_debug.h
mesa/src/mesa/math/m_debug_util.h
mesa/src/mesa/math/m_dotprod_tmp.h
mesa/src/mesa/math/m_eval.h
mesa/src/mesa/math/m_matrix.h
mesa/src/mesa/math/m_norm_tmp.h
mesa/src/mesa/math/m_translate.h
mesa/src/mesa/math/m_trans_tmp.h
mesa/src/mesa/math/m_vector.h
mesa/src/mesa/math/m_xform.h
mesa/src/mesa/math/m_xform_tmp.h
mesa/src/mesa/shader/arbprogparse.c
mesa/src/mesa/shader/arbprogram.c
mesa/src/mesa/shader/atifragshader.c
mesa/src/mesa/shader/nvfragparse.c
mesa/src/mesa/shader/nvprogram.c
mesa/src/mesa/shader/nvvertparse.c
mesa/src/mesa/shader/program.c
mesa/src/mesa/shader/programopt.c
mesa/src/mesa/shader/prog_cache.c
mesa/src/mesa/shader/prog_debug.c
mesa/src/mesa/shader/prog_execute.c
mesa/src/mesa/shader/prog_instruction.c
mesa/src/mesa/shader/prog_noise.c
mesa/src/mesa/shader/prog_parameter.c
mesa/src/mesa/shader/prog_print.c
mesa/src/mesa/shader/prog_statevars.c
mesa/src/mesa/shader/prog_uniform.c
mesa/src/mesa/shader/shader_api.c
mesa/src/mesa/shader/arbprogparse.h
mesa/src/mesa/shader/arbprogram.h
mesa/src/mesa/shader/arbprogram_syn.h
mesa/src/mesa/shader/atifragshader.h
mesa/src/mesa/shader/nvfragparse.h
mesa/src/mesa/shader/nvprogram.h
mesa/src/mesa/shader/nvvertparse.h
mesa/src/mesa/shader/program.h
mesa/src/mesa/shader/programopt.h
mesa/src/mesa/shader/prog_cache.h
mesa/src/mesa/shader/prog_debug.h
mesa/src/mesa/shader/prog_execute.h
mesa/src/mesa/shader/prog_instruction.h
mesa/src/mesa/shader/prog_noise.h
mesa/src/mesa/shader/prog_parameter.h
mesa/src/mesa/shader/prog_print.h
mesa/src/mesa/shader/prog_statevars.h
mesa/src/mesa/shader/prog_uniform.h
mesa/src/mesa/shader/shader_api.h
mesa/src/mesa/shader/slang/slang_builtin.c
mesa/src/mesa/shader/slang/slang_codegen.c
mesa/src/mesa/shader/slang/slang_compile.c
mesa/src/mesa/shader/slang/slang_compile_function.c
mesa/src/mesa/shader/slang/slang_compile_operation.c
mesa/src/mesa/shader/slang/slang_compile_struct.c
mesa/src/mesa/shader/slang/slang_compile_variable.c
mesa/src/mesa/shader/slang/slang_emit.c
mesa/src/mesa/shader/slang/slang_ir.c
mesa/src/mesa/shader/slang/slang_label.c
mesa/src/mesa/shader/slang/slang_link.c
mesa/src/mesa/shader/slang/slang_log.c
mesa/src/mesa/shader/slang/slang_mem.c
mesa/src/mesa/shader/slang/slang_preprocess.c
mesa/src/mesa/shader/slang/slang_print.c
mesa/src/mesa/shader/slang/slang_simplify.c
mesa/src/mesa/shader/slang/slang_storage.c
mesa/src/mesa/shader/slang/slang_typeinfo.c
mesa/src/mesa/shader/slang/slang_utility.c
mesa/src/mesa/shader/slang/slang_vartable.c
mesa/src/mesa/shader/slang/slang_builtin.h
mesa/src/mesa/shader/slang/slang_codegen.h
mesa/src/mesa/shader/slang/slang_compile.h
mesa/src/mesa/shader/slang/slang_compile_function.h
mesa/src/mesa/shader/slang/slang_compile_operation.h
mesa/src/mesa/shader/slang/slang_compile_struct.h
mesa/src/mesa/shader/slang/slang_compile_variable.h
mesa/src/mesa/shader/slang/slang_emit.h
mesa/src/mesa/shader/slang/slang_ir.h
mesa/src/mesa/shader/slang/slang_label.h
mesa/src/mesa/shader/slang/slang_link.h
mesa/src/mesa/shader/slang/slang_log.h
mesa/src/mesa/shader/slang/slang_mem.h
mesa/src/mesa/shader/slang/slang_preprocess.h
mesa/src/mesa/shader/slang/slang_print.h
mesa/src/mesa/shader/slang/slang_simplify.h
mesa/src/mesa/shader/slang/slang_storage.h
mesa/src/mesa/shader/slang/slang_typeinfo.h
mesa/src/mesa/shader/slang/slang_utility.h
mesa/src/mesa/shader/slang/slang_vartable.h
mesa/src/mesa/swrast/s_aaline.c
mesa/src/mesa/swrast/s_aatriangle.c
mesa/src/mesa/swrast/s_accum.c
mesa/src/mesa/swrast/s_alpha.c
mesa/src/mesa/swrast/s_atifragshader.c
mesa/src/mesa/swrast/s_bitmap.c
mesa/src/mesa/swrast/s_blend.c
mesa/src/mesa/swrast/s_blit.c
mesa/src/mesa/swrast/s_buffers.c
mesa/src/mesa/swrast/s_context.c
mesa/src/mesa/swrast/s_copypix.c
mesa/src/mesa/swrast/s_depth.c
mesa/src/mesa/swrast/s_drawpix.c
mesa/src/mesa/swrast/s_feedback.c
mesa/src/mesa/swrast/s_fog.c
mesa/src/mesa/swrast/s_fragprog.c
mesa/src/mesa/swrast/s_imaging.c
mesa/src/mesa/swrast/s_lines.c
mesa/src/mesa/swrast/s_logic.c
mesa/src/mesa/swrast/s_masking.c
mesa/src/mesa/swrast/s_points.c
mesa/src/mesa/swrast/s_readpix.c
mesa/src/mesa/swrast/s_span.c
mesa/src/mesa/swrast/s_stencil.c
mesa/src/mesa/swrast/s_texcombine.c
mesa/src/mesa/swrast/s_texfilter.c
mesa/src/mesa/swrast/s_texstore.c
mesa/src/mesa/swrast/s_triangle.c
mesa/src/mesa/swrast/s_zoom.c
mesa/src/mesa/swrast/swrast.h
mesa/src/mesa/swrast/s_aaline.h
mesa/src/mesa/swrast/s_aalinetemp.h
mesa/src/mesa/swrast/s_aatriangle.h
mesa/src/mesa/swrast/s_aatritemp.h
mesa/src/mesa/swrast/s_accum.h
mesa/src/mesa/swrast/s_alpha.h
mesa/src/mesa/swrast/s_atifragshader.h
mesa/src/mesa/swrast/s_blend.h
mesa/src/mesa/swrast/s_context.h
mesa/src/mesa/swrast/s_depth.h
mesa/src/mesa/swrast/s_feedback.h
mesa/src/mesa/swrast/s_fog.h
mesa/src/mesa/swrast/s_fragprog.h
mesa/src/mesa/swrast/s_lines.h
mesa/src/mesa/swrast/s_linetemp.h
mesa/src/mesa/swrast/s_logic.h
mesa/src/mesa/swrast/s_masking.h
mesa/src/mesa/swrast/s_points.h
mesa/src/mesa/swrast/s_span.h
mesa/src/mesa/swrast/s_spantemp.h
mesa/src/mesa/swrast/s_stencil.h
mesa/src/mesa/swrast/s_texcombine.h
mesa/src/mesa/swrast/s_texfilter.h
mesa/src/mesa/swrast/s_triangle.h
mesa/src/mesa/swrast/s_trispan.h
mesa/src/mesa/swrast/s_tritemp.h
mesa/src/mesa/swrast/s_zoom.h
mesa/src/mesa/swrast_setup/ss_context.c
mesa/src/mesa/swrast_setup/ss_triangle.c
mesa/src/mesa/swrast_setup/ss_context.h
mesa/src/mesa/swrast_setup/ss_triangle.h
mesa/src/mesa/swrast_setup/ss_tritmp.h
mesa/src/mesa/swrast_setup/ss_vb.h
mesa/src/mesa/swrast_setup/swrast_setup.h
mesa/src/mesa/tnl/t_context.c
mesa/src/mesa/tnl/t_draw.c
mesa/src/mesa/tnl/t_pipeline.c
mesa/src/mesa/tnl/t_rasterpos.c
mesa/src/mesa/tnl/t_vb_cull.c
mesa/src/mesa/tnl/t_vb_fog.c
mesa/src/mesa/tnl/t_vb_light.c
mesa/src/mesa/tnl/t_vb_normals.c
mesa/src/mesa/tnl/t_vb_points.c
mesa/src/mesa/tnl/t_vb_program.c
mesa/src/mesa/tnl/t_vb_render.c
mesa/src/mesa/tnl/t_vb_texgen.c
mesa/src/mesa/tnl/t_vb_texmat.c
mesa/src/mesa/tnl/t_vb_vertex.c
mesa/src/mesa/tnl/t_vertex.c
mesa/src/mesa/tnl/t_vertex_generic.c
mesa/src/mesa/tnl/t_vertex_sse.c
mesa/src/mesa/tnl/t_vp_build.c
mesa/src/mesa/tnl/tnl.h
mesa/src/mesa/tnl/t_context.h
mesa/src/mesa/tnl/t_pipeline.h
mesa/src/mesa/tnl/t_vb_cliptmp.h
mesa/src/mesa/tnl/t_vb_lighttmp.h
mesa/src/mesa/tnl/t_vb_rendertmp.h
mesa/src/mesa/tnl/t_vertex.h
mesa/src/mesa/tnl/t_vp_build.h
mesa/src/mesa/vbo/vbo_context.c
mesa/src/mesa/vbo/vbo_exec.c
mesa/src/mesa/vbo/vbo_exec_api.c
mesa/src/mesa/vbo/vbo_exec_array.c
mesa/src/mesa/vbo/vbo_exec_draw.c
mesa/src/mesa/vbo/vbo_exec_eval.c
mesa/src/mesa/vbo/vbo_rebase.c
mesa/src/mesa/vbo/vbo_save.c
mesa/src/mesa/vbo/vbo_save_api.c
mesa/src/mesa/vbo/vbo_save_draw.c
mesa/src/mesa/vbo/vbo_save_loopback.c
mesa/src/mesa/vbo/vbo_split.c
mesa/src/mesa/vbo/vbo_split_copy.c
mesa/src/mesa/vbo/vbo_split_inplace.c
mesa/src/mesa/vbo/vbo.h
mesa/src/mesa/vbo/vbo_attrib.h
mesa/src/mesa/vbo/vbo_attrib_tmp.h
mesa/src/mesa/vbo/vbo_context.h
mesa/src/mesa/vbo/vbo_exec.h
mesa/src/mesa/vbo/vbo_save.h
mesa/src/mesa/vbo/vbo_split.h
mesa/src/glu/sgi/libutil/error.c
mesa/src/glu/sgi/libutil/glue.c
mesa/src/glu/sgi/libutil/mipmap2.c
mesa/src/glu/sgi/libutil/project.c
mesa/src/glu/sgi/libutil/quad.c
mesa/src/glu/sgi/libutil/registry.c
mesa/src/glu/sgi/libutil/gluint.h
test/src/test.c
]]

--print(allfile)

files={}

for line in string.gmatch(allfile, "[^\r\n]+") do

local relative=relbase..line

	line=filesbase..line
	local tab={}

	local parts={}
	for part in string.gmatch(line, "[^/\\]+") do
		table.insert(parts,part)
	end
	
	tab.parts=parts
	tab.pathname=line
	tab.pathrel=relative
	tab.filename=parts[ #parts ]
	
	local parts={}
	for part in string.gmatch(tab.filename, "[^.]+") do
		table.insert(parts,part)
	end
	tab.dots=parts
	tab.ext=parts[ #parts ]
	tab.name=parts[ #parts-1 ]
	
	table.insert(files,tab)

-- print("*"..line.."*")

end

	local names={}

local total_c=0	
for i,v in ipairs(files) do

	if string.lower( v.ext ) == "c" then
		total_c=total_c+1
	end
	
end

local function write_file(fnam,dat)
	local fp=io.open(fnam,"w")
	fp:write(dat)
	fp:close()
end
local function append_file(fnam,dat)
	local fp=io.open(fnam,"a")
	fp:write(dat)
	fp:close()
end

write_file("mesa/makefile",[[
CC= gcc
AR= ar rcu
RANLIB= ranlib
CFLAGS= -O2 -Wall -fno-strict-aliasing -I../../src/mesa/include -I../../src/mesa/src/mesa -I../../src/mesa/src/mesa/main -I../../src/mesa/src/glu/sgi/include

default:libmesa.a

]])

write_file("test/makefile",[[
CC= gcc
AR= ar rcu
RANLIB= ranlib
CFLAGS= -O2 -Wall -fno-strict-aliasing -I../../src/mesa/include -I../../src/mesa/src/glu/sgi/include

default:test.swc

test.o:../../src/test/src/test.c
	$(CC) $(CFLAGS) $? -c -o $@
	
test.swc:test.o ../mesa/libmesa.a
	$(CC) $? -swc -o $@
]])

local count=0
local pct=""
for i,v in ipairs(files) do

	if string.lower( v.ext ) == "c" then
	
		count=count+1
		pct=string.format("%3d%%",math.floor(100*count/total_c) )
		
		local echo_progress=string.format( "echo \"%s : %s\"",pct,v.pathrel )
		
--		print( echo_progress )
		
--		write_file(v.name..".sh",string.format( "gcc -g0 -Wall -fno-strict-aliasing %s -I../../mesa/include -I../../mesa/src/mesa -I../../mesa/src/mesa/main -I../../mesa/src/glu/sgi/include -c\n",v.pathname ))
		
--		print( string.format( "./%s",v.name..".sh" ) )
		
		if v.name~="test" then
			table.insert(names,v.name..".o")
			
			append_file("mesa/makefile",string.format("%s:%s\n\t$(CC) %s\n\n",v.name..".o",v.pathrel,"$(CFLAGS) $? -c -o $@"))
		end
	end
	
end
append_file("mesa/makefile",string.format("libmessa.a:%s\n\t$(AR) $@ $?\n\t$(RANLIB) $@\n\n",table.concat(names," ")))

--		print( string.format( "echo \"building libs\"" ) )
--		write_file("ar.sh",string.format( "ar rcs libmesa.a %s\n",table.concat(names," ") ) )
		
--print( string.format( "./ar.sh" ) )

--		print( string.format( "echo \"Linking\"" ) )
		
--		write_file("test/swc.sh","gcc test.o libmessa.a -swc -o test.swc\ncp test.swc ../../../as3/test/test.swc\n" )
		
--print( string.format( "./swc.sh" ) )


--[[
	${CMAKE_CURRENT_SOURCE_DIR}/include
	${CMAKE_CURRENT_SOURCE_DIR}/src/mesa
	${CMAKE_CURRENT_SOURCE_DIR}/src/mesa/main
	${CMAKE_CURRENT_SOURCE_DIR}/src/glu/sgi/include

gcc -Wall -O3 ../src/test.c -I../../mesa/include -c
gcc -Wall -O3 test.o -swc -o test.swc
cp test.swc ../../../as3/test/test.swc
]]


