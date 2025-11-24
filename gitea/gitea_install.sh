#!/usr/bin/env bash
set -euo pipefail
set -o xtrace

export DEBIAN_FRONTEND=noninteractive
DB_PASSWORD="$1"

########################################
# Root check
########################################
if [ "$EUID" -ne 0 ]; then
  echo "This script needs root privileges" >&2
  exec sudo "$0" "$@"
fi

########################################
# Args validation
########################################
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <DB_PASSWORD>" >&2
    exit 1
fi

if [ "${#DB_PASSWORD}" -lt 12 ]; then
    echo "Error: DB password must be at least 12 characters long." >&2
    exit 1
fi

########################################
# Install dependencies
########################################
apt-get update
apt-get install -y gpg git postgresql

########################################
# PostgreSQL configuration
########################################
sed -i "s/^#*password_encryption *= *.*/password_encryption = scram-sha-256/" \
  /etc/postgresql/15/main/postgresql.conf

grep -q "^local\s\+giteadb\s\+gitea" /etc/postgresql/15/main/pg_hba.conf || \
  sed -i "/^# \"local\" connections:/a local   giteadb   gitea   scram-sha-256" \
  /etc/postgresql/15/main/pg_hba.conf

systemctl restart postgresql

########################################
# Create DB + user
########################################
sudo -u postgres psql <<EOF
CREATE ROLE gitea WITH LOGIN PASSWORD '$DB_PASSWORD';
CREATE DATABASE giteadb
  WITH OWNER gitea
       TEMPLATE template0
       ENCODING 'UTF8'
       LC_COLLATE 'C.UTF-8'
       LC_CTYPE 'C.UTF-8';
EOF

########################################
# Download Gitea + signature
########################################
wget -O /tmp/gitea     https://dl.gitea.com/gitea/1.25.1/gitea-1.25.1-linux-amd64
wget -O /tmp/gitea.asc https://dl.gitea.com/gitea/1.25.1/gitea-1.25.1-linux-amd64.asc

########################################
# GPG signature verification
########################################
gpg --keyserver keys.openpgp.org --recv-key 7C9E68152594688862D62AF62D9AE806EC1592E2
gpg --verify /tmp/gitea.asc /tmp/gitea

########################################
# Create git user
########################################
adduser \
   --system \
   --shell /bin/bash \
   --gecos 'Git Version Control' \
   --group \
   --disabled-password \
   --home /home/git \
   git

########################################
# Gitea directories
########################################
mkdir -p /var/lib/gitea/{custom,data,log}
chown -R git:git /var/lib/gitea/
chmod -R 750 /var/lib/gitea/

mkdir /etc/gitea
chown root:git /etc/gitea
chmod 770 /etc/gitea

########################################
# Install Gitea binary
########################################
mv /tmp/gitea /usr/local/bin/gitea
chmod +x /usr/local/bin/gitea

########################################
# Systemd unit
########################################
cat <<EOF >/etc/systemd/system/gitea.service
[Unit]
Description=Gitea
After=network.target

[Service]
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/local/bin/gitea web --config /etc/gitea/app.ini
Restart=always
RestartSec=2s
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

########################################
# Gitea config file
########################################
cat <<EOF >/etc/gitea/app.ini
[database]
DB_TYPE  = postgres
HOST     = 127.0.0.1:5432
NAME     = giteadb
USER     = gitea
PASSWD   = $DB_PASSWORD
SSL_MODE = disable

[repository]
ROOT = /var/lib/gitea/data/gitea-repositories

[server]
DOMAIN        = $(hostname -I | awk '{print $1}')
SSH_PORT      = 22
HTTP_PORT     = 3000
APP_DATA_PATH = /var/lib/gitea/data

[security]
INSTALL_LOCK   = true
SECRET_KEY     = $(openssl rand -hex 32)
INTERNAL_TOKEN = $(openssl rand -hex 32)
EOF

########################################
# Start Gitea
########################################
systemctl enable gitea --now

chmod 750 /etc/gitea
chmod 640 /etc/gitea/app.ini
