#!/bin/bash

cd /root

#updates
apt update && apt upgrade -y
apt install -y unattended-upgrades apt-config-auto-update

#update script
cat >> update.sh << 'END'
#!/bin/bash

cd /root
docker compose pull
docker compose up --detach --force-recreate --pull always
docker image prune -f
END

chmod +x update.sh
ln -s /root/update.sh /etc/cron.weekly/update_docker

#docker
apt install -y curl
curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh
touch docker-compose.yml
