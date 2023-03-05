import boto3

def delete_iam_users(except_user):
    iam = boto3.client('iam')
    response = iam.list_users()
    for user in response['Users']:
        if user['UserName'] != except_user:
            user_name = user['UserName']
            print(f"Deleting IAM user: {user_name}")
            # Detach all policies from the user
            response = iam.list_attached_user_policies(UserName=user_name)
            for policy in response['AttachedPolicies']:
                iam.detach_user_policy(UserName=user_name, PolicyArn=policy['PolicyArn'])
            # Delete all access keys for the user
            response = iam.list_access_keys(UserName=user_name)
            for access_key in response['AccessKeyMetadata']:
                iam.delete_access_key(UserName=user_name, AccessKeyId=access_key['AccessKeyId'])
            # Delete all login profiles for the user
            try:
                response = iam.get_login_profile(UserName=user_name)
                iam.delete_login_profile(UserName=user_name)
            except iam.exceptions.NoSuchEntityException:
                pass
            # Delete the user
            iam.delete_user(UserName=user_name)
            print(f"IAM user {user_name} deleted successfully")

if __name__ == '__main__':
    except_user = input("Enter the username that should not be deleted: ")
    delete_iam_users(except_user)