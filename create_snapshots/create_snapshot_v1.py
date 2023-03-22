import boto3
from botocore.exceptions import ClientError


def create_snapshots():
    try:
        ec2 = boto3.client('ec2')

        # Get the list of all the instances
        instances = ec2.describe_instances()
        instance_ids = []
        for reservation in instances['Reservations']:
            for instance in reservation['Instances']:
                instance_ids.append(instance['InstanceId'])
            
        all_snapshots = []

        for instance_id in instance_ids:
            # Get the list of all the volumes attached to the instance
            instance_details = ec2.describe_instances(InstanceIds=[instance_id])
            block_device_mappings = instance_details['Reservations'][0]['Instances'][0]['BlockDeviceMappings']
            for device in block_device_mappings:
                volume_id = device['Ebs']['VolumeId']
                snapshot_description = f"Snapshot for {instance_id} - {volume_id}"

                # Create the snapshots
                snapshot = ec2.create_snapshot(VolumeId=volume_id, Description=snapshot_description)
                all_snapshots.append(snapshot)
        return all_snapshots        

    except ClientError as e:
        print(f"An error occurred while creating the snapshots: {e}")
        return None
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return None


if __name__ == "__main__":

    snapshots = create_snapshots()

    if snapshots:
        print("Snapshots created successfully:")
        for snapshot in snapshots:
            print(f"Snapshot ID: {snapshot['SnapshotId']}, Description: {snapshot['Description']}")
    else:
        print("Failed to create snapshots.")