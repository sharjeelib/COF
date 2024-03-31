## Version Control using Git

<br>


For each exercise,
- Take screenshots or record their attempts to perform the allowed actions and the denial of disallowed actions.

<br>

---
### Exercise 1: Initialize a Git Repository

**Objective**: Initialize a new Git repository in a directory of your choice.

```bash
mkdir cost-optimization-framework-exercise

cd cost-optimization-framework-exercise

git init
```

<br>

---
### Exercise 2: Add and Commit Changes
**Objective**: Create a new file and add some content to it. Add the file to the staging area and commit the changes with an appropriate commit message.

```bash
echo "# cost-optimization-framework-exercise" > README.md
echo "I'm content of the file which will be first commit of this repository" > commit_me.txt

git status 

git add README.md commit_me.txt

git commit -m "initial commit"
```

<br>

---
### Exercise 3: Remove specific file from stage area

**Objective**:
 - Create a new file and add it to the staging area using git add.
 - Realize that you don't want to include this file in the commit.
 - Remove the file from the staging area without deleting it from your working directory.

```bash
echo "New file content that will be removed from stage area" > dontcommit_me.txt
echo "New file that content that will be commited" > commit_me_too.txt

git status 

git add .

git status 

git restore --staged dontcommit_me.txt

git commit -m "adding second commit meant to be file"

git status 
```

<br>


---
### Exercise 5: Remove specific file from commited changes (uncommit changes)

**Objective**:
 - Create a new file, add it to the staging area, and commit the changes.
 - Realize that you mistakenly included the wrong file in the commit.
 - Uncommit the last commit, keeping the changes in your working directory but removing them from the commit history.

```bash
```

<br>

---
### Exercise 6: Clone a public remote repository

**Objective**:  
 - Clone a remote Git repository from a URL of your choice. 
 - Public repository URL: https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
 - Verify that the clone is successful by checking the commit history or file content.

```bash
git clone https://github.com/terraform-aws-modules/terraform-aws-ec2-instance

cd terraform-aws-ec2-instance

git log 
git log --oneline
git log --name-only

# More git log optoins
git log --help
```
