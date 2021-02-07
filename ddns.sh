# IP=18.157.246.5
DDNS_HOST_NAME=awsminecraft.ddns.net
DDNS_USERNAME=dm1.f3d@gmail.com
DDNS_PASSWORD=52Tns3zVQtaYLW33UXCDmDLli6zAWVza

# Update DNS
IP=$(docker-machine ip ${INSTANCE_NAME})
URL="https://dynupdate.no-ip.com/nic/update?hostname=${DDNS_HOST_NAME}"
AUTH=$(echo -n ${DDNS_USERNAME}:${DDNS_PASSWORD} | base64)
curl curl -H "Authorization: Basic ${AUTH}" -X GET ${URL}