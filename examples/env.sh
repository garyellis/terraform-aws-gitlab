KEY_NAME=garyellis
NAME=tf-module-gitlab
VPC_NAME=gellis
SUBNET_NAME="private-restricted-a"
AMI_ID=ami-3ecc8f46
DNS_NAME=gitlab-ee
DNS_DOMAIN=ews.works
DNS_ZONE_ID=Z1NMUGQLTLR1UM


function get_subnets(){
    aws ec2 describe-subnets --filters Name=vpc-id,Values=$1 | \
    jq -r '.Subnets[] | [.SubnetId, (.Tags[]|select(.Key=="Name").Value)] | @tsv' | \
    egrep "${2}" | awk '{print $1}'
}

export TF_VAR_key_name=$KEY_NAME
export TF_VAR_name=$NAME
export TF_VAR_ami_id=$AMI_ID
export TF_VAR_dns_name=$DNS_NAME
export TF_VAR_dns_domain=$DNS_DOMAIN
export TF_VAR_dns_zone_id=$DNS_ZONE_ID

tags=$(printf "%s" "environment_stage = \"$NAME\"")
export TF_VAR_tags={${tags}}


vpc_id=$(aws ec2 describe-vpcs --filter "Name=tag:Name,Values=$VPC_NAME"|jq -r '.Vpcs[].VpcId')
export TF_VAR_vpc_id=$vpc_id

subnet_id=$(get_subnets $vpc_id $SUBNET_NAME)
export TF_VAR_gitlab_subnet_id=$subnet_id

subnet_ids=$(printf '"%s",' $(get_subnets $vpc_id $SUBNET_NAME))
export TF_VAR_gitlab_runner_subnet_ids=[${subnet_ids}]


export TF_VAR_ssm_kms_key_arn="arn:aws:kms:us-west-2:529332856614:key/8beac6f0-4321-4c06-97e2-ad3980b07f9b"
