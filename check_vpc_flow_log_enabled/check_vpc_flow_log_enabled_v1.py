import boto3
from botocore.exceptions import ClientError, NoCredentialsError

DELIVER_LOGS_PERMISSION_ARN = 'REPLACE IT WITH YOUR ROLE ARN'

def enable_vpc_flowlogs():
    try:
        ec2 = boto3.client('ec2')
        logs = boto3.client('logs')
        vpcs = ec2.describe_vpcs()

        for vpc in vpcs['Vpcs']:
            vpc_id = vpc['VpcId']
            log_group_name = f"{vpc_id}-cloudwatch-lg"

            try:
                logs.create_log_group(logGroupName=log_group_name)
                print(f"Create log group: {log_group_name}")
            except logs.exceptions.ResourceAlreadyExistsException:
                print(f"Log group with name: {log_group_name} already exist")

            flow_logs = ec2.describe_flow_logs(
                Filters=[
                    {
                        'Name': 'resource-id',
                        'Values': [vpc_id]
                    }
                ]
            )

            vpc_flow_logs_enabled = False
            for flow_log in flow_logs['FlowLogs']:
                if 'LogGroupName' in flow_log and flow_log['LogGroupName'] == log_group_name:
                    vpc_flow_logs_enabled = True
                    break
            if vpc_flow_logs_enabled:
                print(f"VPC Flow log enabled for VPC {vpc_id}")
            else:
                print(f"Enabling VPC Flow logs for VPC {vpc_id}")
                try:
                    response = ec2.create_flow_logs(
                        ResourceIds=[vpc_id],
                        ResourceType='VPC',
                        TrafficType='ALL',
                        LogDestinationType='cloud-watch-logs',
                        LogGroupName=log_group_name,
                        DeliverLogsPermissionArn=DELIVER_LOGS_PERMISSION_ARN
                    )
                    if response.get('Unsuccessful'):
                        error_msg = response['Unsuccessful'][0]['Error']['Message']
                        print(f"Failed to enable VPC Flow Logs for VPC {vpc_id}: {error_msg}")
                    else:
                        print(f"Successfully enabled VPC Flow logs for VPC: {vpc_id}")
                except ClientError as e:
                    if e.response['Error']['Code'] == 'FlowLogAlreadyExists':
                        print(f"Flow Log with the same configuration and log destination already exists for VPC {vpc_id}")
                    else:
                        print(f"Unexpected error: {e}")

    except NoCredentialsError:
        print("Credentials not found. Please ensure your AWS credentials are configured correctly.")
    except ClientError as e:
        print(f"Unexpected error: {e}")



if __name__ == '__main__':
    enable_vpc_flowlogs()
