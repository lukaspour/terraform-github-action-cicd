# This file is appended to user-data script provided by bastion module.

#################
# Download SSH key, which will be used to connect to instances from Bastion host
# Public key is placed in authorized_keys on each instance
#################
#aws s3 cp s3://${bucket_secrets}/ssh-keys/bastion_id_rsa /home/ubuntu/.ssh/id_rsa
#chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
#chmod 600 /home/ubuntu/.ssh/id_rsa

#################
# Assign EIP fetched from EC2 tag to the current instance, so that single instance in ASG always have same IP
#################

#pip install aws-ec2-assign-elastic-ip

#INSTANCE_ID=$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)
#REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
#EIP=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$${INSTANCE_ID}" "Name=key,Values=EIP" --output text --region $${REGION} --query 'Tags[*].Value')

#echo "Going to associate $${INSTANCE_ID} with EIP $${EIP}"

#aws-ec2-assign-elastic-ip --valid-ips $${EIP}

# this is here to ensure that EIP will get assigned eventually even thought it fialed to be assigned in first run
#echo "*/5 * * * * root /usr/local/bin/aws-ec2-assign-elastic-ip --valid-ips $${EIP}" > /etc/cron.d/set_eip

#################
# Load additional userdata for telia environmets
#################

${custom_additional_user_data_script}
