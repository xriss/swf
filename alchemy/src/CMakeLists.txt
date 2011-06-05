
cmake_minimum_required(VERSION 2.6)


PROJECT(alc)


INCLUDE_DIRECTORIES(

	${CMAKE_CURRENT_SOURCE_DIR}
	${CMAKE_CURRENT_SOURCE_DIR}/mesa/include
)


LINK_DIRECTORIES(

	${CMAKE_CURRENT_SOURCE_DIR}
)

#./configure --disable-asm --with-driver=osmesa --disable-shared



SUBDIRS(

	mesa
	test
)

