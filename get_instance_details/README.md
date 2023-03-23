# AWS EC2 Instance Comparison

This script allows you to fetch and compare the details of two AWS EC2 instance types using the boto3 library. It displays the instance type, number of vCPUs, and memory size side by side in a tabular format.

## Prerequisites

Before running the script, you need to make sure you have the following:

* Python 3.6 or later
* boto3 library installed
* AWS credentials configured (either as environment variables or in the AWS credentials file)

## Usage

To use this script, follow these steps:

```
python instance_comparison.py <instance_type1> <instance_type2>
```

## Output
```
Instance Comparison:
--------------------
Attribute       Instance 1      Instance 2     
---------------------------------------------
Instance Type   r6i.32xlarge    r6i.24xlarge   
vCPUs           128             96             
Memory (MiB)    1048576         786432 

```

## Contributing

Contributions to this script are welcome. If you find any bugs or have suggestions for improvement, feel free to open an issue or submit a pull request.
