############################### Backup #########################################
BACKUP_PREFIX="mc_"
BACKUP_PATH="s3://minecraft-on-aws-ec2-spots-bucket/backups/"
TMP_PATH="/home/ubuntu/"

################################## HARDWARE ####################################
INSTANCE_NAME="minecraft"

INSTANCE_TYPE=t3.medium
PRICE=0.02

AMI=ami-0d359437d1756caa8

REGION=eu-central-1
ZONE=a
VPC=vpc-3a19bc50
SUBNET=subnet-d9f77bb3

SECURITY_GROUP=minecraft-security-group

VOL_SIZE=8

######################### NoIp Dynamic DNS #####################################
DDNS_HOST_NAME=awsminecraft.ddns.net
DDNS_USERNAME=dm1.f3d@gmail.com
DDNS_PASSWORD=52Tns3zVQtaYLW33UXCDmDLli6zAWVza

######################### Load custom config ###################################
if [ -f config.local ]; then
    . config.local
fi
