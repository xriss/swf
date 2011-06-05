rm -R alc
mkdir alc
cd alc

mkdir debug
cd debug
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=../../alchemy.cmake ../../src
cd ..

#mkdir release
#cd release
#cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=../../alchemy.cmake ../../src
#cd ..

cd ..
