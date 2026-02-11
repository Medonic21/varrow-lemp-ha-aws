 ######### Make S3 Bucket to networking module & enable Versioning ############
echo "Starting Create S3 Networking Buckets... "
aws s3 mb s3://varrow-academy-cloud-networking-terraform-backend-us-east-1 --region us-east-1
aws s3api put-bucket-versioning --bucket varrow-academy-cloud-networking-terraform-backend-us-east-1 --versioning-configuration Status=Enabled
 
 
 
 ######### Make S3 Bucket to Compute module & enable Versioning ############
echo "Starting Create S3 Compute Buckets... "
aws s3 mb s3://varrow-academy-cloud-compute-terraform-backend-us-east-1 --region us-east-1
aws s3api put-bucket-versioning --bucket varrow-academy-cloud-compute-terraform-backend-us-east-1 --versioning-configuration Status=Enabled

  ####  Test Buckets after excuted #####
echo "Starting Test Buckets... "
 aws s3 ls
echo "Starting Test Versioning for Compute Bucket... "
 aws s3api get-bucket-versioning --bucket varrow-academy-cloud-compute-terraform-backend-us-east-1
echo "Starting Test Versioning for Network Bucket... "
 aws s3api get-bucket-versioning --bucket varrow-academy-cloud-networking-terraform-backend-us-east-1