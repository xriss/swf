INCLUDE(CMakeForceCompiler)

# this one is important
SET(CMAKE_SYSTEM_NAME alchemy)

# specify the cross compiler
CMAKE_FORCE_C_COMPILER(/cygdrive/c/wet/swf/_alchemy/achacks/gcc GNU)
CMAKE_FORCE_CXX_COMPILER(/cygdrive/c/wet/swf/_alchemy/achacks/g++ GNU)

# where is the target environment 
SET(CMAKE_FIND_ROOT_PATH  /cygdrive/c/wet/swf/_alchemy/_alchemy )

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)