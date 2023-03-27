import boto3
import datetime
import argparse


def rotate_iam_keys(max_key_age):
    try:
        iam = boto3.client("iam")

        # Get the list of all IAM users
        response = iam.list_users()
        users = response['Users']

        # Get the list of all IAM users
        for user in users:
            user_name = user['UserName']

            # Get the list of user access key
            response = iam.list_access_keys(UserName=user_name)
            access_keys = response['AccessKeyMetadata']

            # Rotate the Key as it's older than max_key_age
            for access_key in access_keys:
                create_date = access_key['CreateDate']
                key_age = (datetime.datetime.now(datetime.timezone.utc) - create_date).days

                if key_age > max_key_age:
                    response = iam.create_access_key(UserName=user_name)
                    new_access_key = response['AccessKey']
                    print(f"New access key created for user {user_name}: Access key ID: {new_access_key['AccessKeyId']}, Secret access key: {new_access_key['SecretAccessKey']}")

                    # Ask for user confirmation before deactivating old access key
                    confirm = input(f"Do you want to deactivate the access key {access_key['AccessKeyId']} for user {user_name}? (y/n) ")
                    if confirm.lower() == 'y':
                        iam.update_access_key(UserName=user_name, AccessKeyId=access_key['AccessKeyId'], Status='Inactive')
                        print(f"Deactivated access key {access_key['AccessKeyId']} for user {user_name}")
    
    except Exception as e:
        print(f"Error rotating key: {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Rotate IAM key for the user if it's more than specified number of days")
    parser.add_argument("--max-key-age", type=int, help="The maximum key age")
    args = parser.parse_args()

    if not args.max_key_age:
        parser.print_help()
    else:
        rotate_iam_keys(args.max_key_age)