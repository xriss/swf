
PROJECT(test)


INCLUDE_DIRECTORIES(

	${CMAKE_CURRENT_SOURCE_DIR}/src
	${ALL_INC}
)

LINK_DIRECTORIES(

	${CMAKE_CURRENT_SOURCE_DIR}
	${ALL_LIB}
)





FOREACH(dir

	src
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

	SET(test_SRCS ${test_SRCS} ${files} )
	

	MESSAGE(STATUS "--" )
	MESSAGE(STATUS "--Done" )
	MESSAGE(STATUS "--" )
	MESSAGE(STATUS "--" )

ENDFOREACH(dir)



#if(CMAKE_SYSTEM_NAME==alchemy)
#ENDIF(CMAKE_SYSTEM_NAME==alchemy)

ADD_EXECUTABLE(test.swc ${test_SRCS} )


TARGET_LINK_LIBRARIES(test.swc

	mesa
	
	-swc

)

#	ADD_CUSTOM_COMMAND( TARGET test POST_BUILD COMMAND ${CMAKE_COMMAND} ARGS -E copy
#		${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/test
#		${CMAKE_CURRENT_SOURCE_DIR}/../../as3/test/test.swc
#	)


IF(WIN32)

	
ELSE(WIN32)


ENDIF(WIN32)
