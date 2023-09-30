#!/bin/bash

# CHANGE THIS TO THE ABSOLUTE PATH OF YOUR MYSQL SERVER BUILD DIRECTORY
SCRIPT_MYSQL_COMMUNITY_BUILD_DIR="/root/workspace/mysql-server/build"

# Default values.
SCRIPT_MYSQL_COMMUNITY_DIR="/tmp/mysql_community_server"
SCRIPT_MYSQL_DATA_DIR="$SCRIPT_MYSQL_COMMUNITY_DIR/data"
SCRIPT_MYSQL_COMMUNITY_CNF_FILE="$SCRIPT_MYSQL_COMMUNITY_DIR/mysql-config.cnf"
SCRIPT_MYSQL_COMMUNITY_ERR_FILE="$SCRIPT_MYSQL_COMMUNITY_DIR/mysql-error.log"
SCRIPT_MYSQL_COMMUNITY_SERVER_PID=/tmp/mysql.pid
SCRIPT_MYSQL_COMMUNITY_SERVER_SOCK=/tmp/mysql.sock
SCRIPT_MYSQL_COMMUNITY_SERVER_BIN_FILE="$SCRIPT_MYSQL_COMMUNITY_BUILD_DIR/bin/mysqld"
SCRIPT_MYSQL_COMMUNITY_LANG_ERR_MSG_FILE="$SCRIPT_MYSQL_COMMUNITY_BUILD_DIR/share/english/errmsg.sys"

# Function to display help.
display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -h, --help            Display this help message."
    echo "  -c, --clean-start     Start MySQL server with a clean fresh start. Delete and recreate the files/folders and call initialize again."
    exit 0
}

# Function to display verbose information.
display_verbose() {
    echo "======================================================================================"
    echo "SCRIPT_MYSQL_COMMUNITY_DIR: $SCRIPT_MYSQL_COMMUNITY_DIR"
    echo "SCRIPT_MYSQL_DATA_DIR: $SCRIPT_MYSQL_DATA_DIR"
    echo "SCRIPT_MYSQL_COMMUNITY_ERR_FILE: $SCRIPT_MYSQL_COMMUNITY_ERR_FILE"
    echo "SCRIPT_MYSQL_COMMUNITY_CNF_FILE: $SCRIPT_MYSQL_COMMUNITY_CNF_FILE"
    echo "SCRIPT_MYSQL_COMMUNITY_SERVER_BIN_FILE: $SCRIPT_MYSQL_COMMUNITY_SERVER_BIN_FILE"
    echo "SCRIPT_MYSQL_COMMUNITY_SERVER_PID: $SCRIPT_MYSQL_COMMUNITY_SERVER_PID"
    echo "SCRIPT_MYSQL_COMMUNITY_SERVER_SOCK: $SCRIPT_MYSQL_COMMUNITY_SERVER_SOCK"
    echo "======================================================================================"
}

# Process command line options
while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
        display_help
        ;;
    -c | --clean-start)
        CLEAN_START=true
        ;;
    *)
        echo "Unknown option: $1"
        display_help
        ;;
    esac
    shift
done

# Recreate all the files and directories before starting mysqld server.
if [ "$CLEAN_START" = true ]; then
    sudo rm -rf "$SCRIPT_MYSQL_COMMUNITY_DIR"

    sudo groupadd mysql
    sudo useradd -r -g mysql -s /bin/false mysql
    sudo cp

    sudo mkdir -p "$SCRIPT_MYSQL_COMMUNITY_DIR"
    sudo chown mysql:mysql "$SCRIPT_MYSQL_COMMUNITY_DIR"
    sudo chmod 777 "$SCRIPT_MYSQL_COMMUNITY_DIR"

    sudo mkdir -p "$SCRIPT_MYSQL_DATA_DIR"
    sudo chown mysql:mysql "$SCRIPT_MYSQL_DATA_DIR"
    sudo chmod 775 "$SCRIPT_MYSQL_DATA_DIR"

    sudo touch "$SCRIPT_MYSQL_COMMUNITY_ERR_FILE"
    sudo chown mysql:mysql "$SCRIPT_MYSQL_COMMUNITY_ERR_FILE"
    sudo chmod 777 "$SCRIPT_MYSQL_COMMUNITY_ERR_FILE"

    sudo touch "$SCRIPT_MYSQL_COMMUNITY_CNF_FILE"
    sudo chown mysql:mysql "$SCRIPT_MYSQL_COMMUNITY_CNF_FILE"
    sudo chmod 777 "$SCRIPT_MYSQL_COMMUNITY_CNF_FILE"

    sudo echo "[mysqld]
    basedir=$SCRIPT_MYSQL_COMMUNITY_DIR
    datadir=$SCRIPT_MYSQL_DATA_DIR
    pid-file=$SCRIPT_MYSQL_COMMUNITY_SERVER_PID
    socket=$SCRIPT_MYSQL_COMMUNITY_SERVER_SOCK
    port=3308
    lc_messages_dir=$SCRIPT_MYSQL_COMMUNITY_DIR
    lc_messages=en_US" >>$SCRIPT_MYSQL_COMMUNITY_CNF_FILE

    ls -l "$SCRIPT_MYSQL_COMMUNITY_DIR"
    cat "$SCRIPT_MYSQL_COMMUNITY_CNF_FILE"

    sudo chmod 775 "$SCRIPT_MYSQL_COMMUNITY_CNF_FILE"
    sudo cp $SCRIPT_MYSQL_COMMUNITY_LANG_ERR_MSG_FILE "$SCRIPT_MYSQL_COMMUNITY_DIR/"

    echo "Starting to initialize MySQL server data directory, read the error logs at $SCRIPT_MYSQL_COMMUNITY_ERR_FILE"
    sudo "$SCRIPT_MYSQL_COMMUNITY_SERVER_BIN_FILE" --defaults-file="$SCRIPT_MYSQL_COMMUNITY_CNF_FILE" --log-error="$SCRIPT_MYSQL_COMMUNITY_ERR_FILE" --user=root --initialize-insecure
fi

# Main
display_verbose
echo -e "Terminating any existing mysqld proccesses and sleeping for 1 second..."
killall -9 mysqld
sleep 1
echo "Starting mysqld"
sudo "$SCRIPT_MYSQL_COMMUNITY_SERVER_BIN_FILE" --defaults-file="$SCRIPT_MYSQL_COMMUNITY_CNF_FILE" --log-error="$SCRIPT_MYSQL_COMMUNITY_ERR_FILE" --user=root &
echo "MySql server has started! Read the error logs at $SCRIPT_MYSQL_COMMUNITY_ERR_FILE"
