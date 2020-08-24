#!/bin/bash

./formatter.sh
rm -rf build
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ..
make -j9
sudo make install
cd ..
