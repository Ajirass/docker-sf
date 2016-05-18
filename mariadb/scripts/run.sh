#!/bin/bash

# Stop on error
set -e
set -u
source /root/scripts/functions.sh

# Other variables
VOLUME_HOME="/var/lib/mysql"
MYSQLD_PID_FILE="$VOLUME_HOME/mysql.pid"

#pre_start_action
install_db
start_and_check_mysql
create_custom_database
create_admin_user
#import_database

tail -f /dev/null
