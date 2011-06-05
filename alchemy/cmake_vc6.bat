echo off

mkdir vc6
cd vc6
cmake -G"Visual Studio 6" -D"BUILD_SHARED_LIBS:BOOL=OFF" ../src
cd ..

