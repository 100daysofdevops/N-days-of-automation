import boto3
import datetime
from dateutil import parser
import argparse

def cleanup_old_ami(ami_age):
    try:
        ec2 = boto3.client('ec2')

        response = ec2.describe_images(Owners=['self'])

        current_date = datetime.datetime.now(datetime.timezone.utc)

        for image in response['Images']:
            ami_creation_date = parser.parse(image['CreationDate'])
            ami_age_in_days = (current_date - ami_creation_date).days

            if ami_age_in_days > ami_age:
                try:
                    print(f"Deleting AMI ID {image['ImageId']} created {ami_age_in_days} day ago ")
                    ec2.deregister_image(ImageId=image['ImageId'])
                except Exception as e:
                    print(f"Error deleting AMI ID {image['ImageId']}: {e} ")    
    except Exception as e:
        print(f"Error occured while describing ami: {e}")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Delete AWS AMIs older than specified days")
    parser.add_argument("ami_age", type=int, help="Age of AMIs in days")
    args = parser.parse_args()

    cleanup_old_ami(args.ami_age)