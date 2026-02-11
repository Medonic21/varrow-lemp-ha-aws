 
 #!/bin/bash
 ######### Make S3 Bucket to Backend & enable Versioning ############

 echo " ------- Starting Create S3 Buckets... "
 read -p "Enter the (( number )) of buckets : " num
 count="$num"
 name_backets=()
while [ 1 -le $num ]
do
    read -p "Enter the bucket name : " bucket_name 
    read -p "Enter the region : " region_name 

    aws s3 mb s3://$bucket_name-terraform-backend-$region_name --region $region_name

      read -p "Do you enable Versioning in this Bucket (yes / no): " yes_no

           if [ $yes_no = "yes" ]; then

              aws s3api put-bucket-versioning --bucket $bucket_name-terraform-backend-$region_name --versioning-configuration Status=Enabled

           elif [  $yes_no = "no" ]; then
              echo " ---- No versioning in this bucket ---- "
           else
              aws s3 rb s3://$bucket_name-terraform-backend-$region_name
              break
           fi

     name_backets+=("$bucket_name-terraform-backend-$region_name")      

    ((num--)) 
done

  ################  Test Buckets after excuted #################

echo "Starting List & Test Buckets... "
 aws s3 ls
       while [ $num -le $((count - 1)) ]
       do
          
           echo "Starting Test Versioning for ${name_backets[$num]}... "
           aws s3api get-bucket-versioning --bucket ${name_backets[$num]}

          ((num++))

       done