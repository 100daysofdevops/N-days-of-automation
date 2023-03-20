# Creating IAM Users with Python and Boto3

This is a simple Python script that allows you to create IAM users in your AWS account using the Boto3 library. You can create a single user or multiple users by providing a filename with a list of usernames.

## Getting Started

Before running the script, you need to make sure you have Python 3 and the Boto3 library installed. You also need to have AWS credentials configured on your system, either by setting environment variables or using a credentials file.

To install the required dependencies, run the following command:

```
pip install boto3 argparse
```

## Usage

To create a single user, run the script with the --username option:

```
python create_iam_user.py --username prashant --password secretpassword --attach_policy
```

This will create a new IAM user with the username ```prashant```, set their password to ```secretpassword```, and attach the S3 Readonly Policy to their account.

If you don't provide a password, the script will generate a random password for you.

To create multiple users at once, you can provide a filename with a list of usernames:

```
python create_iam_user.py --filename users.txt --password secretpassword --attach_policy
```

This will create one IAM user for each line in the "users.txt" file.

## Options

```--username```: The name of the IAM user to create.

```--password```: The password for the IAM user. If not provided, a random password will be generated.

```--attach_policy```: Attach an IAM policy to the user. If not provided, the script will attach the S3 Readonly Policy by default.

```--filename```: A filename that contains a list of IAM usernames to create, one per line.

## Contributing

Contributions to this script are welcome. If you find any bugs or have suggestions for improvement, feel free to open an issue or submit a pull request.
