rm -R cygwin
mkdir cygwin
cd cygwin

mkdir debug
cd debug
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug ../../src
cd ..

mkdir release
cd release
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ../../src
cd ..

cd ..
