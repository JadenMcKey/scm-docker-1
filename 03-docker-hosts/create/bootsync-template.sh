# Disable DHCP and set fixed IP on this Docker host
kill $(cat /var/run/udhcpc.eth1.pid)
ifconfig eth1 192.168.99.${ip} netmask 255.255.255.0 broadcast 192.168.99.255 up

# Install and configure REX-Ray driver on this Docker host
curl -sSL https://dl.bintray.com/emccode/rexray/install | sh
echo \
"libstorage:
  service: virtualbox
virtualbox:
  volumePath: ${SCM_DOCKER_1_DATA_VOLUMES_DIR}" > /etc/rexray/config.yml
rexray start

# Hack to ensure REX-Ray driver is detected on this Docker host
# See: https://github.com/Azure/azurefile-dockervolumedriver/issues/81
docker volume create --driver=rexray --name tmp-${host} --opt=size=1
docker volume rm tmp-${host}
