# PiyushDatta's notes

## How to build

1. `mkdir -p build`
2. `cd build`
3. `cmake .. -DDOWNLOAD_BOOST=1 -DWITH_BOOST=.`
4. make -j`nproc`

One liner if boost downloaded:
cd build && cmake .. && make -j`nproc`

One liner if boost downloaded and in build dir:
cmake .. && make -j`nproc`

## How to start

`./piydatta_notes/start_mysqld.sh -c`

## How to connect

`./piydatta_notes/connect_mysqld.sh`

## Public gist to make it easier:

https://gist.github.com/PiyushDatta/e4471ce8f088eab6a471a5e6725aa53f
