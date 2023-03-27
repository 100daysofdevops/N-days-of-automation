import boto3
from botocore.exceptions import ClientError
import argparse


def cleanup_unused_ebs_vol(volume_id):
    ec2 = boto3.client('ec2')

    try:
        response = ec2.describe_volumes(VolumeIds=[volume_id])
        unused_volumes = response['Volumes'][0]
    except Exception as e:
        print(f"Error getting the list of unused EBS volumes: {e}")
        return


    if unused_volumes['State'] == 'available':
        confirm = input(f"Are you sure want to delete these volumes {volume_id}?  (y/n) ")
        if confirm.lower() == 'y':
            try:
                ec2.delete_volume(VolumeId=volume_id)
                print(f"The following Volume is deleted {volume_id}")
            except ClientError as e:
                print(f"Error deleting the ebs volume with volume id {volume_id}: {e}")
        else:
            print(f"Skipping deleting volume: {volume_id}")
    else:
        print(f"The following volume id {volume_id} is not available for deletion")        


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Cleanup unused EBS volumes")
    parser.add_argument('volume_id',help="The EBS volume id need to be cleaned up")
    args = parser.parse_args()
    cleanup_unused_ebs_vol(args.volume_id)




