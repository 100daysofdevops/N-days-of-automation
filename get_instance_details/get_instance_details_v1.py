import argparse
import boto3

def get_instance_details(instance_type):
    client = boto3.client('ec2')
    
    # Describe the instance types
    response = client.describe_instance_types(InstanceTypes=[instance_type])
    instance_details = response['InstanceTypes'][0]
    
    return instance_details

def print_comparison(instance_details1, instance_details2):
    print(f"{'Attribute':<15} {'Instance 1':<15} {'Instance 2':<15}")
    print("-" * 45)
    print(f"{'Instance Type':<15} {instance_details1['InstanceType']:<15} {instance_details2['InstanceType']:<15}")
    print(f"{'vCPUs':<15} {instance_details1['VCpuInfo']['DefaultVCpus']:<15} {instance_details2['VCpuInfo']['DefaultVCpus']:<15}")
    print(f"{'Memory (MiB)':<15} {instance_details1['MemoryInfo']['SizeInMiB']:<15} {instance_details2['MemoryInfo']['SizeInMiB']:<15}")
    print()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Fetch and compare instance details')
    parser.add_argument('instance_type1', type=str, help='First instance type')
    parser.add_argument('instance_type2', type=str, help='Second instance type')
    args = parser.parse_args()
    
    try:
        instance_details1 = get_instance_details(args.instance_type1)
        instance_details2 = get_instance_details(args.instance_type2)
        
        print("Instance Comparison:")
        print("--------------------")
        print_comparison(instance_details1, instance_details2)
    except Exception as e:
        print(f"Error: {e}")