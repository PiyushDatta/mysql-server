#!/bin/bash

# Download mysql-server (trunk branch)
# echo "Download MySQL server from github."
# git clone https://github.com/mysql/mysql-server.git

# Compile and build MySQL (client and server and util)
# cd mysql-server
# mkdir -p build
BUILD_PATH_DIR='build'
[ ! -d "$BUILD_PATH_DIR" ] && echo "Directory '$BUILD_PATH_DIR' DOES NOT exists." && exit 1
cd build
# If you have boost already then you can just do "cmake .."
echo "Running cmake."
cmake .. -DDOWNLOAD_BOOST=1 -DWITH_BOOST=.
echo "Running make."
make -j$(nproc)
echo "Done downloading and building MySQL from github."
