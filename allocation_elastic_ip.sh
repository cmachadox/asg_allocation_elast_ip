#!/bin/bash
PROXY_IP1="seu_elastic_ip1"
PROXY_IP2="seu_elastic_ip2"
VALIDATION_IP=`aws ec2 --region us-east-1 describe-addresses --public-ips $PUBLIC_IP $PROXY_IP1 | grep  AssociationId | cut -d'"' -f2`

if [ -z "$VALIDATION_IP" ]
then

   echo "ALOCANDO ELASTIC_IP $PROXY_IP1"
   FIRST_IP=`aws ec2 --region us-east-1 describe-addresses --public-ips $PROXY_IP1 | grep -oP '(?<=\"AllocationId\"\: ")[a-zA-Z0-9_\-]+'`
   aws ec2 associate-address --instance-id `curl http://169.254.169.254/latest/meta-data/instance-id` --allocation-id $FIRST_IP --region us-east-1

else

   echo "ALOCANDO ELASTIC_IP $PROXY_IP2"
   SECOND_IP=$(aws ec2 --region us-east-1 describe-addresses --public-ips $PROXY_IP2 | grep -oP '(?<=\"AllocationId\"\: ")[a-zA-Z0-9_\-]+')
   aws ec2 associate-address --instance-id `curl http://169.254.169.254/latest/meta-data/instance-id` --allocation-id $SECOND_IP --region us-east-1

fi
