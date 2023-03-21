import boto3
from botocore.exceptions import ClientError


def cleanup_unused_ebs_vol():
    ec2 = boto3.client('ec2')

    try:
        response = ec2.describe_volumes(Filters=[{'Name': 'status', 'Values': ['available']}])
        unused_volumes = response['Volumes']
    except Exception as e:
        print(f"Error getting the list of unused EBS volumes: {e}")
        return


    for volume in unused_volumes:
        volume_id = volume["VolumeId"]
        print(f"These are the unused volumes: {volume_id} ")

        confirm = input(f"Are you sure want to delete these volumes {volume_id}?  (y/n) ")

        if confirm.lower() == 'y':
            try:
                ec2.delete_volume(VolumeId=volume_id)
                print(f"The following Volume is deleted {volume_id}")
            except ClientError as e:
                print(f"Error deleting the ebs volume with volume id {volume_id}: {e}")
        else:
            print(f"Skipping deleting volume: {volume_id}")


if __name__ == '__main__':
    cleanup_unused_ebs_vol()




