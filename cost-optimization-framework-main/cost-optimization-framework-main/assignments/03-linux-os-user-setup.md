## Create Linux OS Users

<br>

For each exercise,
- Take screenshots or record their attempts to perform the allowed actions and the denial of disallowed actions.

<br>

---
###  **Exercise 1: Create a Basic User**

**Scenario:** Create a basic Linux user with minimal permissions.

**Instructions:**

1. Log in to your Linux system as a superuser or with sudo privileges.

2. Use the `useradd` command to create a new user. For example:

   ```bash
   sudo useradd basicuser
   ```

3. Set a password for the user using the `passwd` command:

   ```bash
   sudo passwd basicuser
   ```

4. Create a home directory for the user:

   ```bash
   sudo mkdir /home/basicuser
   ```

5. Assign ownership of the home directory to the new user:

   ```bash
   sudo chown basicuser:basicuser /home/basicuser
   ```

6. Test the user account by switching to it:

   ```bash
   sudo su - basicuser
   ```

<br>

---
###  **Exercise 2: Create a User with Specific Shell and Group**

**Scenario:** Create a Linux user with a specific shell and group assignment.

**Instructions:**

1. Log in to your Linux system as a superuser or with sudo privileges.

2. Use the `useradd` command to create a new user with a specific shell (e.g., `/bin/bash`) and assign the user to a specific group (e.g., `developers`). For example:

   ```bash
   sudo useradd -s /bin/bash -G developers devuser
   ```

3. Set a password for the new user:

   ```bash
   sudo passwd devuser
   ```

4. Verify that the user was added to the specified group:

   ```bash
   groups devuser
   ```

<br>

---
###  **Exercise 3: Create a User with SSH Key Authentication**

**Scenario:** Create a new Linux user account, configure SSH key-based authentication, and test logging in using a private key.

**Instructions:**

1. Generate ssh keypair on your system
   ```
   ssh-keygen
   ```

   Follow the prompts to create a key pair. This will generate a public key (`id_rsa.pub`) and a private key (`id_rsa`) in the user's home directory.

2. Log in to your Linux system as a superuser or with sudo privileges.

3. Use the `useradd` command to create a new user account (e.g., `sshuser`):

   ```bash
   sudo useradd vscodeuser
   ```


4. Configure SSH key-based authentication for the user:

   a. Create an `~/.ssh` directory in the user's home directory if it doesn't exist:

      ```bash
      sudo su - vscodeuser
      
      mkdir -p ~/.ssh
      ```

   b. Copy the user's public key to the `~/.ssh/authorized_keys` file:


   c. Set the correct permissions and ownership for the `~/.ssh` directory and the `authorized_keys` file:

      ```bash
      chmod 700 ~/.ssh
      chmod 600 ~/.ssh/authorized_keys
      chown vscodeuser:vscodeuser -R ~/.ssh
      ```

6. Test SSH key-based login by connecting to the system using the private key. 

   ```bash
   ssh -i /path/to/private/key vscodeuser@your_server_ip
   ```

   You should be able to log in without being prompted for a password, using the private key.

<br>

---
### **Exercise 4: Create a User with Password and Login using SSH**

**Scenario:** Create a user on Linux system and allow it to log in using SSH with a password.

**Instructions:**

1. Create a New User:
   - Create a new user named 'sshpasswduser' using the `useradd` command:
     ```
     sudo useradd -m -s /bin/bash sshpasswduser 
     ```

2. Set password for user
   - Use passwd command to set a password for a 'sshpasswduser' user:
     ```
     sudo passwd sshpasswduser
     ```
   - Enter your password twice

3. Validate password authentication locally from the server:
   - From same machine/server use `sudo su` command to switch user
   ```
   sudo su - sshpasswduser
   ```
   - When prompted, enter the password you set for 'sshpasswduser'.

4. Update SSHD Configuration:
   - Open the SSHD configuration file using vi/vim:
     ```
     sudo vi /etc/ssh/sshd_config
     ```
   - Find the line that says `PasswordAuthentication`:
     - If it says `PasswordAuthentication no`, change it to `PasswordAuthentication yes`.
     - If the line is commented out (starts with a `#`), remove the `#` and set the line to `PasswordAuthentication yes`.
     - If you can't find the line, you can add it at the end of the file: `PasswordAuthentication yes`.

5. **Reload the SSHD Service**:
   - For the changes to take effect, you need to reload the SSHD service. Do this with:
     ```
     sudo systemctl reload sshd
     ```

6. **Test Password Authentication**:
   - From another machine or your laptop, try to SSH into the server using the 'sshpasswduser' credentials:
     ```
     ssh sshpasswduser@your_server_ip_or_hostname
     ```
   - When prompted, enter the password you set for 'sshpasswduser'.
   - If everything was set up correctly, you should be logged in as 'sshpasswduser'.

