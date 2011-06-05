
PROJECT(mesa)


INCLUDE_DIRECTORIES(

	${CMAKE_CURRENT_SOURCE_DIR}/include
	${CMAKE_CURRENT_SOURCE_DIR}/src/mesa
	${CMAKE_CURRENT_SOURCE_DIR}/src/mesa/main
	${CMAKE_CURRENT_SOURCE_DIR}/src/glu/sgi/include
	${ALL_INC}
)

LINK_DIRECTORIES(

	${CMAKE_CURRENT_SOURCE_DIR}
	${ALL_LIB}
)



#ADD_DEFINITIONS(-D__MINGW32__)
#ADD_DEFINITIONS(-D__VMS)

#ADD_DEFINITIONS(-D__asm__=broken)
#ADD_DEFINITIONS(-D__asm=broken)
#ADD_DEFINITIONS(-D_asm=broken)
#ADD_DEFINITIONS(-Dasm=broken)


FOREACH(dir

	src/mesa/drivers/common
	src/mesa/drivers/osmesa
	src/mesa/glapi
	src/mesa/main
	src/mesa/math
	src/mesa/shader
	src/mesa/shader/slang
	src/mesa/swrast
	src/mesa/swrast_setup
	src/mesa/tnl
	src/mesa/vbo
	src/glu/sgi/libutil
)

	STRING(REGEX REPLACE "/" "_" name ${dir} )

	MESSAGE(STATUS "--Building " ${name} " from " ${dir} )
	MESSAGE(STATUS "--" )

	FILE(GLOB globs
		${dir}/*.cpp
		${dir}/*.c
		${dir}/*.h
		)

	SET(files )

	FOREACH(file ${globs} )

		GET_FILENAME_COMPONENT( file_abs ${file} ABSOLUTE )
		MESSAGE(STATUS "--Found source " ${file_abs} )

		SET(files ${files} ${file_abs} )

	ENDFOREACH(file)

	SOURCE_GROUP(	${name} FILES ${files} )

	SET(mesa_SRCS ${mesa_SRCS} ${files} )
	

	MESSAGE(STATUS "--" )
	MESSAGE(STATUS "--Done" )
	MESSAGE(STATUS "--" )
	MESSAGE(STATUS "--" )

ENDFOREACH(dir)


SET(name src_mesa_shader_grammar )
SET(files
	src/mesa/shader/grammar/grammar_mesa.c
)
SOURCE_GROUP( ${name} FILES ${files} )
SET(mesa_SRCS ${mesa_SRCS} ${files} )



ADD_LIBRARY(mesa ${mesa_SRCS} )


TARGET_LINK_LIBRARIES(mesa

)



IF(WIN32)

	
ELSE(WIN32)

TARGET_LINK_LIBRARIES(mesa

	m
)

ENDIF(WIN32)
