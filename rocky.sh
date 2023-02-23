#!/bin/bash

cd /root

#updates
dnf update -y
dnf install dnf-automatic -y

#update script
cat >> update.sh << 'END'
#!/bin/bash
cd /root
docker compose pull
docker compose up --detach --force-recreate
docker image prune -f
END

chmod +x update.sh
ln -s /root/update.sh /etc/cron.weekly/update_docker

touch docker-compose.yml

#docker
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
yum install -y yum-utils
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl start docker
systemctl enable docker

