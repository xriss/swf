CC= gcc
AR= ar rcu
RANLIB= ranlib
CFLAGS= -O3 -Wall -fno-strict-aliasing -I../../src/mesa/include -I../../src/mesa/src/mesa -I../../src/mesa/src/mesa/main -I../../src/mesa/src/glu/sgi/include

default:libmesa.a

driverfuncs.o:../../src/mesa/src/mesa/drivers/common/driverfuncs.c
	$(CC) $(CFLAGS) $? -c -o $@

osmesa.o:../../src/mesa/src/mesa/drivers/osmesa/osmesa.c
	$(CC) $(CFLAGS) $? -c -o $@

glapi.o:../../src/mesa/src/mesa/glapi/glapi.c
	$(CC) $(CFLAGS) $? -c -o $@

glapi_getproc.o:../../src/mesa/src/mesa/glapi/glapi_getproc.c
	$(CC) $(CFLAGS) $? -c -o $@

glthread.o:../../src/mesa/src/mesa/glapi/glthread.c
	$(CC) $(CFLAGS) $? -c -o $@

accum.o:../../src/mesa/src/mesa/main/accum.c
	$(CC) $(CFLAGS) $? -c -o $@

api_arrayelt.o:../../src/mesa/src/mesa/main/api_arrayelt.c
	$(CC) $(CFLAGS) $? -c -o $@

api_exec.o:../../src/mesa/src/mesa/main/api_exec.c
	$(CC) $(CFLAGS) $? -c -o $@

api_loopback.o:../../src/mesa/src/mesa/main/api_loopback.c
	$(CC) $(CFLAGS) $? -c -o $@

api_noop.o:../../src/mesa/src/mesa/main/api_noop.c
	$(CC) $(CFLAGS) $? -c -o $@

api_validate.o:../../src/mesa/src/mesa/main/api_validate.c
	$(CC) $(CFLAGS) $? -c -o $@

arrayobj.o:../../src/mesa/src/mesa/main/arrayobj.c
	$(CC) $(CFLAGS) $? -c -o $@

attrib.o:../../src/mesa/src/mesa/main/attrib.c
	$(CC) $(CFLAGS) $? -c -o $@

blend.o:../../src/mesa/src/mesa/main/blend.c
	$(CC) $(CFLAGS) $? -c -o $@

bufferobj.o:../../src/mesa/src/mesa/main/bufferobj.c
	$(CC) $(CFLAGS) $? -c -o $@

buffers.o:../../src/mesa/src/mesa/main/buffers.c
	$(CC) $(CFLAGS) $? -c -o $@

clear.o:../../src/mesa/src/mesa/main/clear.c
	$(CC) $(CFLAGS) $? -c -o $@

clip.o:../../src/mesa/src/mesa/main/clip.c
	$(CC) $(CFLAGS) $? -c -o $@

colortab.o:../../src/mesa/src/mesa/main/colortab.c
	$(CC) $(CFLAGS) $? -c -o $@

context.o:../../src/mesa/src/mesa/main/context.c
	$(CC) $(CFLAGS) $? -c -o $@

convolve.o:../../src/mesa/src/mesa/main/convolve.c
	$(CC) $(CFLAGS) $? -c -o $@

debug.o:../../src/mesa/src/mesa/main/debug.c
	$(CC) $(CFLAGS) $? -c -o $@

depth.o:../../src/mesa/src/mesa/main/depth.c
	$(CC) $(CFLAGS) $? -c -o $@

depthstencil.o:../../src/mesa/src/mesa/main/depthstencil.c
	$(CC) $(CFLAGS) $? -c -o $@

dispatch.o:../../src/mesa/src/mesa/main/dispatch.c
	$(CC) $(CFLAGS) $? -c -o $@

dlist.o:../../src/mesa/src/mesa/main/dlist.c
	$(CC) $(CFLAGS) $? -c -o $@

dlopen.o:../../src/mesa/src/mesa/main/dlopen.c
	$(CC) $(CFLAGS) $? -c -o $@

drawpix.o:../../src/mesa/src/mesa/main/drawpix.c
	$(CC) $(CFLAGS) $? -c -o $@

enable.o:../../src/mesa/src/mesa/main/enable.c
	$(CC) $(CFLAGS) $? -c -o $@

enums.o:../../src/mesa/src/mesa/main/enums.c
	$(CC) $(CFLAGS) $? -c -o $@

eval.o:../../src/mesa/src/mesa/main/eval.c
	$(CC) $(CFLAGS) $? -c -o $@

execmem.o:../../src/mesa/src/mesa/main/execmem.c
	$(CC) $(CFLAGS) $? -c -o $@

extensions.o:../../src/mesa/src/mesa/main/extensions.c
	$(CC) $(CFLAGS) $? -c -o $@

fbobject.o:../../src/mesa/src/mesa/main/fbobject.c
	$(CC) $(CFLAGS) $? -c -o $@

feedback.o:../../src/mesa/src/mesa/main/feedback.c
	$(CC) $(CFLAGS) $? -c -o $@

ffvertex_prog.o:../../src/mesa/src/mesa/main/ffvertex_prog.c
	$(CC) $(CFLAGS) $? -c -o $@

fog.o:../../src/mesa/src/mesa/main/fog.c
	$(CC) $(CFLAGS) $? -c -o $@

framebuffer.o:../../src/mesa/src/mesa/main/framebuffer.c
	$(CC) $(CFLAGS) $? -c -o $@

get.o:../../src/mesa/src/mesa/main/get.c
	$(CC) $(CFLAGS) $? -c -o $@

getstring.o:../../src/mesa/src/mesa/main/getstring.c
	$(CC) $(CFLAGS) $? -c -o $@

hash.o:../../src/mesa/src/mesa/main/hash.c
	$(CC) $(CFLAGS) $? -c -o $@

hint.o:../../src/mesa/src/mesa/main/hint.c
	$(CC) $(CFLAGS) $? -c -o $@

histogram.o:../../src/mesa/src/mesa/main/histogram.c
	$(CC) $(CFLAGS) $? -c -o $@

image.o:../../src/mesa/src/mesa/main/image.c
	$(CC) $(CFLAGS) $? -c -o $@

imports.o:../../src/mesa/src/mesa/main/imports.c
	$(CC) $(CFLAGS) $? -c -o $@

light.o:../../src/mesa/src/mesa/main/light.c
	$(CC) $(CFLAGS) $? -c -o $@

lines.o:../../src/mesa/src/mesa/main/lines.c
	$(CC) $(CFLAGS) $? -c -o $@

matrix.o:../../src/mesa/src/mesa/main/matrix.c
	$(CC) $(CFLAGS) $? -c -o $@

mipmap.o:../../src/mesa/src/mesa/main/mipmap.c
	$(CC) $(CFLAGS) $? -c -o $@

mm.o:../../src/mesa/src/mesa/main/mm.c
	$(CC) $(CFLAGS) $? -c -o $@

multisample.o:../../src/mesa/src/mesa/main/multisample.c
	$(CC) $(CFLAGS) $? -c -o $@

pixel.o:../../src/mesa/src/mesa/main/pixel.c
	$(CC) $(CFLAGS) $? -c -o $@

pixelstore.o:../../src/mesa/src/mesa/main/pixelstore.c
	$(CC) $(CFLAGS) $? -c -o $@

points.o:../../src/mesa/src/mesa/main/points.c
	$(CC) $(CFLAGS) $? -c -o $@

polygon.o:../../src/mesa/src/mesa/main/polygon.c
	$(CC) $(CFLAGS) $? -c -o $@

queryobj.o:../../src/mesa/src/mesa/main/queryobj.c
	$(CC) $(CFLAGS) $? -c -o $@

rastpos.o:../../src/mesa/src/mesa/main/rastpos.c
	$(CC) $(CFLAGS) $? -c -o $@

rbadaptors.o:../../src/mesa/src/mesa/main/rbadaptors.c
	$(CC) $(CFLAGS) $? -c -o $@

readpix.o:../../src/mesa/src/mesa/main/readpix.c
	$(CC) $(CFLAGS) $? -c -o $@

renderbuffer.o:../../src/mesa/src/mesa/main/renderbuffer.c
	$(CC) $(CFLAGS) $? -c -o $@

scissor.o:../../src/mesa/src/mesa/main/scissor.c
	$(CC) $(CFLAGS) $? -c -o $@

shaders.o:../../src/mesa/src/mesa/main/shaders.c
	$(CC) $(CFLAGS) $? -c -o $@

state.o:../../src/mesa/src/mesa/main/state.c
	$(CC) $(CFLAGS) $? -c -o $@

stencil.o:../../src/mesa/src/mesa/main/stencil.c
	$(CC) $(CFLAGS) $? -c -o $@

texcompress.o:../../src/mesa/src/mesa/main/texcompress.c
	$(CC) $(CFLAGS) $? -c -o $@

texcompress_fxt1.o:../../src/mesa/src/mesa/main/texcompress_fxt1.c
	$(CC) $(CFLAGS) $? -c -o $@

texcompress_s3tc.o:../../src/mesa/src/mesa/main/texcompress_s3tc.c
	$(CC) $(CFLAGS) $? -c -o $@

texenv.o:../../src/mesa/src/mesa/main/texenv.c
	$(CC) $(CFLAGS) $? -c -o $@

texenvprogram.o:../../src/mesa/src/mesa/main/texenvprogram.c
	$(CC) $(CFLAGS) $? -c -o $@

texformat.o:../../src/mesa/src/mesa/main/texformat.c
	$(CC) $(CFLAGS) $? -c -o $@

texgen.o:../../src/mesa/src/mesa/main/texgen.c
	$(CC) $(CFLAGS) $? -c -o $@

teximage.o:../../src/mesa/src/mesa/main/teximage.c
	$(CC) $(CFLAGS) $? -c -o $@

texobj.o:../../src/mesa/src/mesa/main/texobj.c
	$(CC) $(CFLAGS) $? -c -o $@

texparam.o:../../src/mesa/src/mesa/main/texparam.c
	$(CC) $(CFLAGS) $? -c -o $@

texrender.o:../../src/mesa/src/mesa/main/texrender.c
	$(CC) $(CFLAGS) $? -c -o $@

texstate.o:../../src/mesa/src/mesa/main/texstate.c
	$(CC) $(CFLAGS) $? -c -o $@

texstore.o:../../src/mesa/src/mesa/main/texstore.c
	$(CC) $(CFLAGS) $? -c -o $@

varray.o:../../src/mesa/src/mesa/main/varray.c
	$(CC) $(CFLAGS) $? -c -o $@

vtxfmt.o:../../src/mesa/src/mesa/main/vtxfmt.c
	$(CC) $(CFLAGS) $? -c -o $@

m_debug_clip.o:../../src/mesa/src/mesa/math/m_debug_clip.c
	$(CC) $(CFLAGS) $? -c -o $@

m_debug_norm.o:../../src/mesa/src/mesa/math/m_debug_norm.c
	$(CC) $(CFLAGS) $? -c -o $@

m_debug_xform.o:../../src/mesa/src/mesa/math/m_debug_xform.c
	$(CC) $(CFLAGS) $? -c -o $@

m_eval.o:../../src/mesa/src/mesa/math/m_eval.c
	$(CC) $(CFLAGS) $? -c -o $@

m_matrix.o:../../src/mesa/src/mesa/math/m_matrix.c
	$(CC) $(CFLAGS) $? -c -o $@

m_translate.o:../../src/mesa/src/mesa/math/m_translate.c
	$(CC) $(CFLAGS) $? -c -o $@

m_vector.o:../../src/mesa/src/mesa/math/m_vector.c
	$(CC) $(CFLAGS) $? -c -o $@

m_xform.o:../../src/mesa/src/mesa/math/m_xform.c
	$(CC) $(CFLAGS) $? -c -o $@

arbprogparse.o:../../src/mesa/src/mesa/shader/arbprogparse.c
	$(CC) $(CFLAGS) $? -c -o $@

arbprogram.o:../../src/mesa/src/mesa/shader/arbprogram.c
	$(CC) $(CFLAGS) $? -c -o $@

atifragshader.o:../../src/mesa/src/mesa/shader/atifragshader.c
	$(CC) $(CFLAGS) $? -c -o $@

nvfragparse.o:../../src/mesa/src/mesa/shader/nvfragparse.c
	$(CC) $(CFLAGS) $? -c -o $@

nvprogram.o:../../src/mesa/src/mesa/shader/nvprogram.c
	$(CC) $(CFLAGS) $? -c -o $@

nvvertparse.o:../../src/mesa/src/mesa/shader/nvvertparse.c
	$(CC) $(CFLAGS) $? -c -o $@

program.o:../../src/mesa/src/mesa/shader/program.c
	$(CC) $(CFLAGS) $? -c -o $@

programopt.o:../../src/mesa/src/mesa/shader/programopt.c
	$(CC) $(CFLAGS) $? -c -o $@

prog_cache.o:../../src/mesa/src/mesa/shader/prog_cache.c
	$(CC) $(CFLAGS) $? -c -o $@

prog_debug.o:../../src/mesa/src/mesa/shader/prog_debug.c
	$(CC) $(CFLAGS) $? -c -o $@

prog_execute.o:../../src/mesa/src/mesa/shader/prog_execute.c
	$(CC) $(CFLAGS) $? -c -o $@

prog_instruction.o:../../src/mesa/src/mesa/shader/prog_instruction.c
	$(CC) $(CFLAGS) $? -c -o $@

prog_noise.o:../../src/mesa/src/mesa/shader/prog_noise.c
	$(CC) $(CFLAGS) $? -c -o $@

prog_parameter.o:../../src/mesa/src/mesa/shader/prog_parameter.c
	$(CC) $(CFLAGS) $? -c -o $@

prog_print.o:../../src/mesa/src/mesa/shader/prog_print.c
	$(CC) $(CFLAGS) $? -c -o $@

prog_statevars.o:../../src/mesa/src/mesa/shader/prog_statevars.c
	$(CC) $(CFLAGS) $? -c -o $@

prog_uniform.o:../../src/mesa/src/mesa/shader/prog_uniform.c
	$(CC) $(CFLAGS) $? -c -o $@

shader_api.o:../../src/mesa/src/mesa/shader/shader_api.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_builtin.o:../../src/mesa/src/mesa/shader/slang/slang_builtin.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_codegen.o:../../src/mesa/src/mesa/shader/slang/slang_codegen.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_compile.o:../../src/mesa/src/mesa/shader/slang/slang_compile.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_compile_function.o:../../src/mesa/src/mesa/shader/slang/slang_compile_function.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_compile_operation.o:../../src/mesa/src/mesa/shader/slang/slang_compile_operation.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_compile_struct.o:../../src/mesa/src/mesa/shader/slang/slang_compile_struct.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_compile_variable.o:../../src/mesa/src/mesa/shader/slang/slang_compile_variable.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_emit.o:../../src/mesa/src/mesa/shader/slang/slang_emit.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_ir.o:../../src/mesa/src/mesa/shader/slang/slang_ir.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_label.o:../../src/mesa/src/mesa/shader/slang/slang_label.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_link.o:../../src/mesa/src/mesa/shader/slang/slang_link.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_log.o:../../src/mesa/src/mesa/shader/slang/slang_log.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_mem.o:../../src/mesa/src/mesa/shader/slang/slang_mem.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_preprocess.o:../../src/mesa/src/mesa/shader/slang/slang_preprocess.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_print.o:../../src/mesa/src/mesa/shader/slang/slang_print.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_simplify.o:../../src/mesa/src/mesa/shader/slang/slang_simplify.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_storage.o:../../src/mesa/src/mesa/shader/slang/slang_storage.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_typeinfo.o:../../src/mesa/src/mesa/shader/slang/slang_typeinfo.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_utility.o:../../src/mesa/src/mesa/shader/slang/slang_utility.c
	$(CC) $(CFLAGS) $? -c -o $@

slang_vartable.o:../../src/mesa/src/mesa/shader/slang/slang_vartable.c
	$(CC) $(CFLAGS) $? -c -o $@

s_aaline.o:../../src/mesa/src/mesa/swrast/s_aaline.c
	$(CC) $(CFLAGS) $? -c -o $@

s_aatriangle.o:../../src/mesa/src/mesa/swrast/s_aatriangle.c
	$(CC) $(CFLAGS) $? -c -o $@

s_accum.o:../../src/mesa/src/mesa/swrast/s_accum.c
	$(CC) $(CFLAGS) $? -c -o $@

s_alpha.o:../../src/mesa/src/mesa/swrast/s_alpha.c
	$(CC) $(CFLAGS) $? -c -o $@

s_atifragshader.o:../../src/mesa/src/mesa/swrast/s_atifragshader.c
	$(CC) $(CFLAGS) $? -c -o $@

s_bitmap.o:../../src/mesa/src/mesa/swrast/s_bitmap.c
	$(CC) $(CFLAGS) $? -c -o $@

s_blend.o:../../src/mesa/src/mesa/swrast/s_blend.c
	$(CC) $(CFLAGS) $? -c -o $@

s_blit.o:../../src/mesa/src/mesa/swrast/s_blit.c
	$(CC) $(CFLAGS) $? -c -o $@

s_buffers.o:../../src/mesa/src/mesa/swrast/s_buffers.c
	$(CC) $(CFLAGS) $? -c -o $@

s_context.o:../../src/mesa/src/mesa/swrast/s_context.c
	$(CC) $(CFLAGS) $? -c -o $@

s_copypix.o:../../src/mesa/src/mesa/swrast/s_copypix.c
	$(CC) $(CFLAGS) $? -c -o $@

s_depth.o:../../src/mesa/src/mesa/swrast/s_depth.c
	$(CC) $(CFLAGS) $? -c -o $@

s_drawpix.o:../../src/mesa/src/mesa/swrast/s_drawpix.c
	$(CC) $(CFLAGS) $? -c -o $@

s_feedback.o:../../src/mesa/src/mesa/swrast/s_feedback.c
	$(CC) $(CFLAGS) $? -c -o $@

s_fog.o:../../src/mesa/src/mesa/swrast/s_fog.c
	$(CC) $(CFLAGS) $? -c -o $@

s_fragprog.o:../../src/mesa/src/mesa/swrast/s_fragprog.c
	$(CC) $(CFLAGS) $? -c -o $@

s_imaging.o:../../src/mesa/src/mesa/swrast/s_imaging.c
	$(CC) $(CFLAGS) $? -c -o $@

s_lines.o:../../src/mesa/src/mesa/swrast/s_lines.c
	$(CC) $(CFLAGS) $? -c -o $@

s_logic.o:../../src/mesa/src/mesa/swrast/s_logic.c
	$(CC) $(CFLAGS) $? -c -o $@

s_masking.o:../../src/mesa/src/mesa/swrast/s_masking.c
	$(CC) $(CFLAGS) $? -c -o $@

s_points.o:../../src/mesa/src/mesa/swrast/s_points.c
	$(CC) $(CFLAGS) $? -c -o $@

s_readpix.o:../../src/mesa/src/mesa/swrast/s_readpix.c
	$(CC) $(CFLAGS) $? -c -o $@

s_span.o:../../src/mesa/src/mesa/swrast/s_span.c
	$(CC) $(CFLAGS) $? -c -o $@

s_stencil.o:../../src/mesa/src/mesa/swrast/s_stencil.c
	$(CC) $(CFLAGS) $? -c -o $@

s_texcombine.o:../../src/mesa/src/mesa/swrast/s_texcombine.c
	$(CC) $(CFLAGS) $? -c -o $@

s_texfilter.o:../../src/mesa/src/mesa/swrast/s_texfilter.c
	$(CC) $(CFLAGS) $? -c -o $@

s_texstore.o:../../src/mesa/src/mesa/swrast/s_texstore.c
	$(CC) $(CFLAGS) $? -c -o $@

s_triangle.o:../../src/mesa/src/mesa/swrast/s_triangle.c
	$(CC) $(CFLAGS) $? -c -o $@

s_zoom.o:../../src/mesa/src/mesa/swrast/s_zoom.c
	$(CC) $(CFLAGS) $? -c -o $@

ss_context.o:../../src/mesa/src/mesa/swrast_setup/ss_context.c
	$(CC) $(CFLAGS) $? -c -o $@

ss_triangle.o:../../src/mesa/src/mesa/swrast_setup/ss_triangle.c
	$(CC) $(CFLAGS) $? -c -o $@

t_context.o:../../src/mesa/src/mesa/tnl/t_context.c
	$(CC) $(CFLAGS) $? -c -o $@

t_draw.o:../../src/mesa/src/mesa/tnl/t_draw.c
	$(CC) $(CFLAGS) $? -c -o $@

t_pipeline.o:../../src/mesa/src/mesa/tnl/t_pipeline.c
	$(CC) $(CFLAGS) $? -c -o $@

t_rasterpos.o:../../src/mesa/src/mesa/tnl/t_rasterpos.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vb_cull.o:../../src/mesa/src/mesa/tnl/t_vb_cull.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vb_fog.o:../../src/mesa/src/mesa/tnl/t_vb_fog.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vb_light.o:../../src/mesa/src/mesa/tnl/t_vb_light.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vb_normals.o:../../src/mesa/src/mesa/tnl/t_vb_normals.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vb_points.o:../../src/mesa/src/mesa/tnl/t_vb_points.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vb_program.o:../../src/mesa/src/mesa/tnl/t_vb_program.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vb_render.o:../../src/mesa/src/mesa/tnl/t_vb_render.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vb_texgen.o:../../src/mesa/src/mesa/tnl/t_vb_texgen.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vb_texmat.o:../../src/mesa/src/mesa/tnl/t_vb_texmat.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vb_vertex.o:../../src/mesa/src/mesa/tnl/t_vb_vertex.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vertex.o:../../src/mesa/src/mesa/tnl/t_vertex.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vertex_generic.o:../../src/mesa/src/mesa/tnl/t_vertex_generic.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vertex_sse.o:../../src/mesa/src/mesa/tnl/t_vertex_sse.c
	$(CC) $(CFLAGS) $? -c -o $@

t_vp_build.o:../../src/mesa/src/mesa/tnl/t_vp_build.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_context.o:../../src/mesa/src/mesa/vbo/vbo_context.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_exec.o:../../src/mesa/src/mesa/vbo/vbo_exec.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_exec_api.o:../../src/mesa/src/mesa/vbo/vbo_exec_api.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_exec_array.o:../../src/mesa/src/mesa/vbo/vbo_exec_array.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_exec_draw.o:../../src/mesa/src/mesa/vbo/vbo_exec_draw.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_exec_eval.o:../../src/mesa/src/mesa/vbo/vbo_exec_eval.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_rebase.o:../../src/mesa/src/mesa/vbo/vbo_rebase.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_save.o:../../src/mesa/src/mesa/vbo/vbo_save.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_save_api.o:../../src/mesa/src/mesa/vbo/vbo_save_api.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_save_draw.o:../../src/mesa/src/mesa/vbo/vbo_save_draw.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_save_loopback.o:../../src/mesa/src/mesa/vbo/vbo_save_loopback.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_split.o:../../src/mesa/src/mesa/vbo/vbo_split.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_split_copy.o:../../src/mesa/src/mesa/vbo/vbo_split_copy.c
	$(CC) $(CFLAGS) $? -c -o $@

vbo_split_inplace.o:../../src/mesa/src/mesa/vbo/vbo_split_inplace.c
	$(CC) $(CFLAGS) $? -c -o $@

error.o:../../src/mesa/src/glu/sgi/libutil/error.c
	$(CC) $(CFLAGS) $? -c -o $@

glue.o:../../src/mesa/src/glu/sgi/libutil/glue.c
	$(CC) $(CFLAGS) $? -c -o $@

mipmap2.o:../../src/mesa/src/glu/sgi/libutil/mipmap2.c
	$(CC) $(CFLAGS) $? -c -o $@

project.o:../../src/mesa/src/glu/sgi/libutil/project.c
	$(CC) $(CFLAGS) $? -c -o $@

quad.o:../../src/mesa/src/glu/sgi/libutil/quad.c
	$(CC) $(CFLAGS) $? -c -o $@

registry.o:../../src/mesa/src/glu/sgi/libutil/registry.c
	$(CC) $(CFLAGS) $? -c -o $@

libmesa.a:driverfuncs.o osmesa.o glapi.o glapi_getproc.o glthread.o accum.o api_arrayelt.o api_exec.o api_loopback.o api_noop.o api_validate.o arrayobj.o attrib.o blend.o bufferobj.o buffers.o clear.o clip.o colortab.o context.o convolve.o debug.o depth.o depthstencil.o dispatch.o dlist.o dlopen.o drawpix.o enable.o enums.o eval.o execmem.o extensions.o fbobject.o feedback.o ffvertex_prog.o fog.o framebuffer.o get.o getstring.o hash.o hint.o histogram.o image.o imports.o light.o lines.o matrix.o mipmap.o mm.o multisample.o pixel.o pixelstore.o points.o polygon.o queryobj.o rastpos.o rbadaptors.o readpix.o renderbuffer.o scissor.o shaders.o state.o stencil.o texcompress.o texcompress_fxt1.o texcompress_s3tc.o texenv.o texenvprogram.o texformat.o texgen.o teximage.o texobj.o texparam.o texrender.o texstate.o texstore.o varray.o vtxfmt.o m_debug_clip.o m_debug_norm.o m_debug_xform.o m_eval.o m_matrix.o m_translate.o m_vector.o m_xform.o arbprogparse.o arbprogram.o atifragshader.o nvfragparse.o nvprogram.o nvvertparse.o program.o programopt.o prog_cache.o prog_debug.o prog_execute.o prog_instruction.o prog_noise.o prog_parameter.o prog_print.o prog_statevars.o prog_uniform.o shader_api.o slang_builtin.o slang_codegen.o slang_compile.o slang_compile_function.o slang_compile_operation.o slang_compile_struct.o slang_compile_variable.o slang_emit.o slang_ir.o slang_label.o slang_link.o slang_log.o slang_mem.o slang_preprocess.o slang_print.o slang_simplify.o slang_storage.o slang_typeinfo.o slang_utility.o slang_vartable.o s_aaline.o s_aatriangle.o s_accum.o s_alpha.o s_atifragshader.o s_bitmap.o s_blend.o s_blit.o s_buffers.o s_context.o s_copypix.o s_depth.o s_drawpix.o s_feedback.o s_fog.o s_fragprog.o s_imaging.o s_lines.o s_logic.o s_masking.o s_points.o s_readpix.o s_span.o s_stencil.o s_texcombine.o s_texfilter.o s_texstore.o s_triangle.o s_zoom.o ss_context.o ss_triangle.o t_context.o t_draw.o t_pipeline.o t_rasterpos.o t_vb_cull.o t_vb_fog.o t_vb_light.o t_vb_normals.o t_vb_points.o t_vb_program.o t_vb_render.o t_vb_texgen.o t_vb_texmat.o t_vb_vertex.o t_vertex.o t_vertex_generic.o t_vertex_sse.o t_vp_build.o vbo_context.o vbo_exec.o vbo_exec_api.o vbo_exec_array.o vbo_exec_draw.o vbo_exec_eval.o vbo_rebase.o vbo_save.o vbo_save_api.o vbo_save_draw.o vbo_save_loopback.o vbo_split.o vbo_split_copy.o vbo_split_inplace.o error.o glue.o mipmap2.o project.o quad.o registry.o
	$(AR) $@ $?
	$(RANLIB) $@

