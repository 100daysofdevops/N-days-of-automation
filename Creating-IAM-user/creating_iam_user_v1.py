import boto3

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


username=input("Please enter a IAM user you want to create: ")
create_iam_user(username)                   

