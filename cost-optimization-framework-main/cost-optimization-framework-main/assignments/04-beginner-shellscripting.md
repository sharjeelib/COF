
## Shellscripting Beginner Level

<br>

For each exercise,
- Take screenshots or record their attempts to perform the allowed actions and the denial of disallowed actions.

<br>

---
### Exercise 1: Check User Existence

**Objective**: Write a script that checks if a given username exists in the system.

```bash
#!/bin/bash

# User to check
USERNAME_TO_CHECK="myuser"

# Check if the user exists
if id "${USERNAME_TO_CHECK}" >/dev/null; then
  echo "INFO: User ${USERNAME_TO_CHECK} exists."
else
  echo "ERROR: User ${USERNAME_TO_CHECK} does not exist."
  exit 1
fi

# Exit the script with a success status code
exit 0
```

<br>

---
### Exercise 2: Compare Two Numbers

**Objective**: Create a script that takes two numbers as input and prints whether they are equal or which one is greater.

```bash
#!/bin/bash

# Read two numbers from user input
read -p "Enter the first number: " NUMBER_ONE
read -p "Enter the second number: " NUMBER_TWO

# Compare the numbers
if [ "$NUMBER_ONE" -eq "$NUMBER_TWO" ]; then
  echo "The numbers are equal."
elif [ "$NUMBER_ONE" -gt "$NUMBER_TWO" ]; then
  echo "The first number ($NUMBER_ONE) is greater than the second number ($NUMBER_TWO)."
else
  echo "The second number ($NUMBER_TWO) is greater than the first number ($NUMBER_ONE)."
fi

# Exit the script with a success status code
exit 0
```

<br>

---
### Exercise 3: Backup File Creation

**Objective**: Write a script that creates a backup of a file if it exists.

a. Create a file for backup
```bash
echo "File for backup $(date)" > /tmp/dev-application.txt
```

b. Backup script
```bash
#!/bin/bash

# Backup location
BACKUP_LOCATION="~/backups"

# The file to backup
FILE_TO_BACKUP="/tmp/dev-application.txt"

# Backup file name
BACKUP_FILE="${BACKUP_LOCATION}/${FILE_TO_BACKUP}-$(date %Y%m%d%H%M%S).bak"

# Check if the file exists and create a backup
if [ -f "${FILE_TO_BACKUP}" ]; then
  cp "${FILE_TO_BACKUP}" "${BACKUP_FILE}"
  echo "Backup of $FILE_TO_BACKUP created as $BACKUP_FILE."
else
  echo "The file $FILE_TO_BACKUP does not exist, no backup created."
fi

# Exit the script with a success status code
exit 0
```

<br>

---
### Exercise 4: Check Disk Space Usage and Report

**Objective**: Write a shell script that checks the free disk space on the root partition. If the free space is less than a specified threshold, it should print a warning message; otherwise, it should print an "All clear" message. The script should then exit with a status code indicating success or error based on the disk space check.


Script uses `df` command to get the free space on the root partition and extract the percentage using `awk`.


**Full Script:**

```bash
#!/bin/bash

# Define the minimum free disk space threshold.
THRESHOLD=20

# Get the current free disk space on the root partition using df command and extract the percentage.
FREE_SPACE=$(df / | awk 'NR==2 {print $(NF-2)}' | sed 's/%//')

# Compare the free space with the threshold.
if [ "$FREE_SPACE" -lt "$THRESHOLD" ]; then
    echo "Warning: Free disk space on root partition is less than $THRESHOLD%."
    exit 1 # Exit with an error status code
else
    echo "All clear: Free disk space on root partition is sufficient."
    exit 0 # Exit with a success status code
fi
```
