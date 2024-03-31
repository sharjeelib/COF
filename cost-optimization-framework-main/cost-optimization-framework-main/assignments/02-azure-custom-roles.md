## Create AWS Customer Managed Policy for EC2 Admins

<br>


For each exercise,
- Take screenshots of the custom policy definition including the included actions.
- Document the steps taken to create the policy and assign it to a IAM user.
- Take screenshots or record their attempts to perform the allowed actions and the denial of disallowed actions.

<br>

---
### 1. Virtual Machine Restricted Admin
Role Name: RestrictedVMAdmin
Role Definition: Create a custom RBAC role that grants access to VM, disk, snapshot and images.

```JSON
{
    "Name": "RestrictedVMAdmin",
    "IsCustom": true,
    "Description": "Can manage virtual machines with restricted permissions.",
    "Actions": [
        "Microsoft.Compute/virtualMachines/*",
        "Microsoft.Compute/virtualMachineScaleSets/*",
        "Microsoft.Compute/disks/*",
        "Microsoft.Compute/snapshots/*",
        "Microsoft.Compute/images/*",
    ],
    "NotActions": [],
    "AssignableScopes": [
        "/subscriptions/<SUBSCRIPTION_ID>"
    ]
}

```
<br>

---
### 2. Virtual Machine Reader
Role Name: VirtualMachineReader
Role Definition: Create a custom RBAC role that grants read-only access to all Virtual Machine properties and settings within a specified subscription.

```JSON
{
    "Name": "VirtualMachineReader",
    "IsCustom": true,
    "Description": "Can view all virtual machine properties and settings but cannot make changes.",
    "Actions": [
        "Microsoft.Compute/virtualMachines/read"
    ],
    "NotActions": [],
    "DataActions": [],
    "NotDataActions": [],
    "AssignableScopes": [
        "/subscriptions/<SUBSCRIPTION_ID>"
    ]
}
```

<br>

---
### 3. Start/Stop VMs in a Specific Resource Group
Role Name: RestrictedVMPowerOperator
Role definition: Create a custom RBAC role that permits a user to start and stop Virtual Machines in a specific resource group.

```JSON
{
    "Name": "RestrictedVMPowerOperator",
    "IsCustom": true,
    "Description": "Can start and stop virtual machines in the specified resource group.",
    "Actions": [
        "Microsoft.Compute/virtualMachines/start/action",
        "Microsoft.Compute/virtualMachines/deallocate/action",
        "Microsoft.Compute/virtualMachines/read"
    ],
    "NotActions": [],
    "DataActions": [],
    "NotDataActions": [],
    "AssignableScopes": [
        "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>"
    ]
}
```
