
#!bin/sh

rm -rf build

meson setup build \
    -Dbuildtype=debug \
    -Dprefix=`pwd`/install
    
cd build
ninja -j32 -t compdb 
ninja install
cp compile_commands.json ..
cd ..

