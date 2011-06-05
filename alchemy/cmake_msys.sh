rm -R msys
mkdir msys
cd msys

mkdir debug
cd debug
cmake -G "MSYS Makefiles" -DCMAKE_BUILD_TYPE=Debug ../../src
cd ..

mkdir release
cd release
cmake -G "MSYS Makefiles" -DCMAKE_BUILD_TYPE=Release ../../src
cd ..

cd ..
