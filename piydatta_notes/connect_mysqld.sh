#!/bin/bash

# You can connect via this, if you have mysql client installed.
mysql -u root -S /tmp/mysql.sock

# ALTERNATIVE METHOD TO CONNECT - UNCOMMENT BELOW
# CHANGE THIS TO THE ABSOLUTE PATH OF YOUR MYSQL SERVER BUILD DIRECTORY
#SCRIPT_MYSQL_COMMUNITY_BUILD_DIR="/root/workspace/mysql-server/build"
#SCRIPT_MYSQL_COMMUNITY_CLIENT_BIN_FILE="$SCRIPT_MYSQL_COMMUNITY_BUILD_DIR/bin/mysql"
#$SCRIPT_MYSQL_COMMUNITY_CLIENT_BIN_FILE -u root -S /tmp/mysql.sock
