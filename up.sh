#!/bin/bash

# Bail out on error
set -e

# Load configuration
. config.sh

echo "> Creating machine"
# Create machine
docker-machine create \
    --driver amazonec2 \
    --amazonec2-region ${REGION} \
    --amazonec2-zone ${ZONE} \
    --amazonec2-ami ${AMI} \
    --amazonec2-vpc-id ${VPC} \
    --amazonec2-subnet-id ${SUBNET} \
    --amazonec2-security-group ${SECURITY_GROUP} \
    --amazonec2-request-spot-instance \
    --amazonec2-instance-type ${INSTANCE_TYPE} \
    --amazonec2-spot-price ${PRICE} \
    --amazonec2-root-size ${VOL_SIZE} \
    ${INSTANCE_NAME}

echo "> Configuring machine"
eval $(docker-machine env ${INSTANCE_NAME})

# Create containers
echo "> Creating server"
docker-compose up --no-start

# Update DNS
IP=$(docker-machine ip ${INSTANCE_NAME})
URL="https://dynupdate.no-ip.com/nic/update?hostname=${DDNS_HOST_NAME}&myip=${IP}"
AUTH=$(echo -n ${DDNS_USERNAME}:${DDNS_PASSWORD} | base64)
curl -H "Authorization: Basic ${AUTH}" -X GET ${URL}

echo "> Restoring latest backup"
# Get latest backup from S3
BACKUP=$(aws s3 ls ${BACKUP_PATH} | awk '{print $4}' | grep -e "^${BACKUP_PREFIX}" | sort | tail -n 1)
aws s3 cp ${BACKUP_PATH}${BACKUP} cache/

# Upload it to the machine
docker-machine scp cache/${BACKUP} ${INSTANCE_NAME}:${TMP_PATH}

# Restore backup
MOUNTPOINT=$(docker volume inspect minecraft-ec2-spot_vol-minecraft --format='{{ .Mountpoint }}')
docker-machine ssh ${INSTANCE_NAME} sudo mkdir -p ${MOUNTPOINT}
docker-machine ssh ${INSTANCE_NAME} sudo tar --group=1000 --owner=1000 -xzf ${TMP_PATH}${BACKUP} -C ${MOUNTPOINT}

# Start server
echo "> Starting server"
docker-compose up -d

# Success!
echo "Server is up and running!"
echo "eval \$(docker-machine env ${INSTANCE_NAME})"
echo "docker-compose logs minecraft"
