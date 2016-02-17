#!/usr/bin/env bash

install_db() {
    if [ ! -d $VOLUME_HOME/mysql ]; then
        echo "==> An empty or uninitialized MariaDB volume is detected in $VOLUME_HOME"
        echo "==> Installing MariaDB ..."
        mysql_install_db
        echo "==> Done!"
    else
        echo "==> Using an existing volume of MariaDB"
    fi
}
start_and_check_mysql() {
    /usr/bin/mysqld_safe &
    echo "==> Waiting for MariaDB service startup"
    sleep 15
    mysql -uroot -e "status"
}

create_custom_database() {
  if [ "$MARIADB_DATABASE" ]; then
    echo "==> Creating database $MARIADB_DATABASE..."
    echo ""
    mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`$MARIADB_DATABASE\`"
  fi
}

#########################################################
# Check in the loop (every 1s) if the database backend
# service is already available for connections.
# Globals:
#   $MARIADB_USER
#   $MARIADB_PASSWORD
#########################################################
function create_admin_user() {
  echo "==> Creating DB admin user..." && echo
  local users=$(mysql -s -e "SELECT count(User) FROM mysql.user WHERE User='$MARIADB_USER' AND host='%'")
  if [[ $users == 0 ]]; then
    echo "==> Creating MariaDB user '$MARIADB_USER' with '$MARIADB_PASSWORD' password."
    mysql -uroot -e "CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD'"
  else
    echo "==> User '$MARIADB_USER' already exists"
  fi;

  mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$MARIADB_USER'@'%' WITH GRANT OPTION"

  echo "========================================================================"
  echo "    You can now connect to this MariaDB Server using:                   "
  echo "    mysql -u$MARIADB_USER -p$MARIADB_PASSWORD -h<host>                  "
  echo "                                                                        "
  echo "    For security reasons, you might want to change the above password.  "
  echo "    The 'root' user has no password but only allows local connections   "
  echo "========================================================================"
}

import_database() {
    now=$(date +'%Y%m%d')
    RESULT=$(mysql -s -e "SELECT COUNT(DISTINCT table_name) FROM information_schema.columns WHERE table_schema = '${MARIADB_DATABASE}';")

    echo ""
    if [ "$RESULT" != "0" ]; then
        echo "==> Database ${MARIADB_DATABASE} already imported"
    else
        echo "==> Unzip prod.sql.tar.gz"
        pv prod.sql.tar.gz | tar xzf - -C .
        echo "==> Import database please wait done message"
        pv prod.sql | mysql -uroot ${MARIADB_DATABASE}
        rm prod.sql
        echo "========================= DONE =========================="
    fi

    echo "========= Your container is ready to use press ctrl + C to leave ========="
}