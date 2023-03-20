import boto3
import argparse
import sys
import random
import string

def random_password(length=12):
    # Generate a random password with specified length
    chars = string.ascii_letters + string.digits + '!@#$%^&*'
    password = ""
    for i in range(length):
        password += random.choice(chars)
    return password


def create_iam_user(username, password=None, attach_policy=None):
    iam = boto3.client("iam")


    try:
        # Check if the user already exists
        iam.get_user(UserName=username)
        print(f'User {username} already exists')
    except iam.exceptions.NoSuchEntityException:
        try:
            # If no password is provided, generate a random password
            if password is None:
                password = random_password()
            iam.create_user(UserName=username)
            iam.create_login_profile(UserName=username, Password=password, PasswordResetRequired=True )
            print(f'User {username} created sucessfully with password {password}')
            # If no policy is provided, attach an administrator policy
            if attach_policy is None:
                iam.attach_user_policy(UserName=username, PolicyArn='arn:aws:iam::aws:policy/AdministratorAccess')
                print(f"Administrator Policy attached to the user: {username} ")


        except Exception as e:
            print(f"Error creating {username}: {e}")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Creating an IAM user")
    parser.add_argument('--username', type=str, help="The name of the IAM user, user want to create")
    parser.add_argument('--password', type=str, help="The password for the IAM user(default is to generate the random password")
    parser.add_argument('--attach_policy', help="Attach an IAM Admin policy to the user")
    parser.add_argument('--filename', type=str, help="Filename that contain IAM user, seperated by line")

    args = parser.parse_args()
    # If no argumnent is provided, print help and exit
    if not any(vars(args).values()):
        parser.print_help()
        sys.exit() 

    if args.filename:
        with open(args.filename, 'r') as file:
            usernames = file.read().splitlines()
        for username in usernames:
            create_iam_user(username, password=args.password, attach_policy=args.attach_policy)
    else:
        create_iam_user(args.username, password=args.password, attach_policy=args.attach_policy)            