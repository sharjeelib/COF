## Create AWS Customer Managed Policy for EC2 Admins

<br>


For each exercise,
- Take screenshots of the custom policy definition including the included actions.
- Document the steps taken to create the policy and assign it to a IAM user.
- Take screenshots or record their attempts to perform the allowed actions and the denial of disallowed actions.

<br>

---
### 1. Regional Admin Policy
Policy Name: EC2RestrictedRegionalAdmin 
Policy Definition: Restrict access to all ec2 instances of us-east-1 region only.

```JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:*",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ec2:Region": "us-east-1"
                }
            }
        }
    ]
}

```

<br>

---
### 2. Restricted Admin Policy
Policy Name: EC2RestrictedAdmin
Policy definition: Describe, launch, stop, start, and terminate all instances

```JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:RunInstances",
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances"
            ],
            "Resource": "*"
        }
    ]
}
```
<br>

---
### 3. Project Specific Policy
Policy Name: EC2StripeDevOperator
Policy Definition: Describe all instances, and stop, start, and terminate only particular instances

```JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:DescribeInstances",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ec2:ResourceTag/env": "dev"
                }
            }
        }
    ]
}

```
