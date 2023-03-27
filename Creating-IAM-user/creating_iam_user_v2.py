import boto3
import argparse
import sys

def create_iam_user(username):
    iam = boto3.client("iam")


    try:
        iam.get_user(UserName=username)
        print(f'User {username} already exists')
    except iam.exceptions.NoSuchEntityException:
        try:
            iam.create_user(UserName=username)
            print(f'User {username} created sucessfully')
        except Exception as e:
            print(f"Error creating {username}: {e}")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Creating an IAM user")
    parser.add_argument('--username', type=str, help="The name of the IAM user, user want to create")
    args = parser.parse_args()
    if not any(vars(args).values()):
        parser.print_help()
        sys.exit()    

    create_iam_user(args.username)               

