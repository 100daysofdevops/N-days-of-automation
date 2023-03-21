# AWS IAM Key Rotation with Python and Boto3

This is a Python script that allows you to rotate access keys for IAM users in your AWS account using the Boto3 library. Access keys are rotated based on the maximum age you specify.

## Getting Started

Before running the script, you need to make sure you have the following:

* An AWS account
* AWS credentials with permission to rotate access keys
* Python 3 installed

To install the required dependencies, run the following command:

```
pip install boto3 argparse
```

## Usage

To rotate access keys for IAM users, run the script with the --max-key-age option:

```
python rotate_iam_keys.py --max-key-age 60
```

This will rotate any access keys that are older than 60 days for all IAM users in your account.

## Options

```--max-key-age```:The maximum number of days an access key can be active before it needs to be rotated.



## Contributing

Contributions to this script are welcome. If you find any bugs or have suggestions for improvement, feel free to open an issue or submit a pull request.
