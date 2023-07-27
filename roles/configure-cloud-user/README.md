# configure-cloud-user

This role is used on physical servers in the cts network to create a user named cloud-user, with passowrdless sudo access and configure 
key-pair SSH connection to the server from the bastion the automation ran in. Finally the role configures the root password for the server.

**Variable** -
- **private_id_key:** The private ssh key.
- **public_id_key:** The public ssh key.

**Example Group Vars:**
```
public_id_key: "ssh-rsa Some_SSH_Public_Key"

private_id_key: | 
  -----BEGIN RSA PRIVATE KEY-----
  A Private SSH Key
  -----END RSA PRIVATE KEY-----
```

**Example Playbook:**
```
- hosts: blk-mm
  roles:
    - configure-cloud-user
  vars:
    ansible_ssh_user: root      # These are the user and passord 
    ansible_ssh_pass: qwe123    # the blk-mm servers are initially booted with
  become: yes
  ignore_unreachable: yes       # So the play won't fail after the initial run

```