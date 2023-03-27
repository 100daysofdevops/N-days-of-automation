import boto3
import argparse

def get_bucket_size(bucket_name):
    try:
        s3 = boto3.client('s3')
        paginator = s3.get_paginator('list_objects_v2')

        size = 0
        for page in paginator.paginate(Bucket=bucket_name):
            for obj in page.get('Contents', []):
                size += obj['Size']

        return size

    except Exception as e:
        print(f"An error occured: {e}")
        return None

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Get the size of S3 bucket")
    parser.add_argument('bucket_name', type=str, help="The name of S3 bucket")
    args = parser.parse_args()

    bucket_size = get_bucket_size(args.bucket_name)
    if bucket_size is not None:
        print(f"Size of {args.bucket_name} with bucket size in {bucket_size} bytes")