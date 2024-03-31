# Cost Optimization Framework


## Overview
Schedule non-production instances to shutdown on schedule, Cost Optimization Framework (COF) will allow you to schedule the instance shutdown and startup time. COF also provide ability to re-size instances based on their current utilization pattner.

<br>

## Pre-requisite

### 1. Instance tagging
Add tag to all the instances which will be shutdown/start using cost optimization framework pipeline.
```
shutdown: true
```

### 2. Authentication configuration
Development authentication is performed via a local YAML configuration file. Stored at default location `~/.cof/csp_auth.yaml` or `.cof/csp_auth.yaml`, however, authentication file path can be supplied at the runtime as script parameter to `csp-authentication.sh` script.

Authentication YAML format:
```
auth_configs:
  aws:
    access_key: xxxxxxxxxxxxxxxxxxxxxx
    secret_access_key: xxxxxxxxxxxxxxxxxxxxxx
    region: <region-name>
    output: json
  azure:
    tenant: "xxxxxxxxxxxxxxxxxxxxxx"
    subscription_id: "xxxxxxxxxxxxxxxxxxxxxx"
    client_id: "xxxxxxxxxxxxxxxxxxxxxx"
    client_secret: "xxxxxxxxxxxxxxxxxxxxxx"
```

> NOTE: You should have AWS and Azure account with appropriate permissions.


### 3. Configure mail server 

Ensure mail server is configured on runner instance to send email. Follow instruction documented in [configure-gmail-stmp.md](./docs/configure-gmail-stmp.md) for configuring gmail stmp.

<br>

## Usage

### 1. Local execution 
Local execution cost optimization framework is managed via init wrapper script

i. To shutdown the instances
```
bash bootstrap.sh --action stop
```

ii. To start the instances
```
bash bootstrap.sh --action start
```

### 2. Schedule the start/shutdown framework using cron entry

Instance Shutdown job everyday at 9 PM Mon to Friday.
```
0 8 * * 1-5 /home/vscodeuser/cost-optimization-framework/bootstrap.sh --action start
```

Instance Start job everyday 
```
0 21 * * 1-5 /home/vscodeuser/cost-optimization-framework/bootstrap.sh --action stop
```

### 3. Schedule the start/shutdown framework using CI/CD pipelines

1. [GitLab Schedule Pipelines](https://docs.gitlab.com/ee/ci/pipelines/schedules.html)

2. [GitHub Action Schedule Event](https://docs.gitlab.com/ee/ci/pipelines/schedules.html)

<br>

## Supported Cloud Vendors & Services Matrix
| CSP | Resource | Scheduled based | Event based | Resizing | Remark |
| --- | -------- | --------------- | ----------- | -------- | ------ | 
| AWS | EC2      | Yes             | No          | No       | N/A    | 
| AWS | ASG      | No              | No          | No       | N/A    | 
| AWS | RDS        | No              | No          | No       | N/A    | 
| Azure | VM       | Yes              | No          | No       | N/A    | 
| Azure | VMSS     | No              | No          | No       | N/A    | 
| Azure | AzureSQL | No              | No          | No       | N/A    | 



## Contributor


## Future support


## License

