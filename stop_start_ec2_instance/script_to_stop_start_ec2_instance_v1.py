import boto3
import argparse

ec2 = boto3.client('ec2')

def ec2_stop_start(instance_id, action):
    try:
        if action == 'stop':
            print(f"Stopping Instance with instance id {instance_id} ....")
            ec2.stop_instances(InstanceIds=[instance_id])
            waiter = ec2.get_waiter('instance_stopped')
            waiter.wait(InstanceIds=[instance_id])
        elif action == 'start':
            print(f"Starting Instance with instance id {instance_id} ...")
            ec2.start_instances(InstanceIds=[instance_id])
            waiter = ec2.get_waiter('instance_running')
            waiter.wait(InstanceIds=[instance_id])
        else:
            print("Please enter a valid action: stop/start")
            return

        print(f"{action.capitalize()}ped Instance with instance id {instance_id}")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Stop or start an EC2 instance')
    parser.add_argument('instance_id', type=str, help='The ID of the EC2 instance')
    parser.add_argument('action', type=str, choices=['stop', 'start'], help='Action to perform (stop or start)')

    args = parser.parse_args()
    ec2_stop_start(args.instance_id, args.action)