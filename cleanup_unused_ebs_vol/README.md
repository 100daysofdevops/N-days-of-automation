# AWS EBS Volume Cleanup Script

This Python script helps you clean up specified unused AWS EBS (Elastic Block Store) volumes. It takes an EBS volume ID as an argument and checks if the volume is available for deletion. If the volume is available, the script prompts the user for confirmation before deleting the volume.

## Prerequisites

Before running the script, you need to make sure you have the following:

* Python 3.6 or later
* boto3 library installed
* AWS credentials configured (either as environment variables or in the AWS credentials file)

To install the required dependencies, run the following command:

```
pip install -r requirements.txt

```

## Usage

Run the script by passing an EBS volume ID as an argument:

```
python cleanup_unused_ebs_vol.py vol-1234567890abcdef0
```

## Contributing

Contributions to this script are welcome. If you find any bugs or have suggestions for improvement, feel free to open an issue or submit a pull request.
