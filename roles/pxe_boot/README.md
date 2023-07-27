# Pxe Boot

This automation is used to do one time pxe boot on ilo or cimc servers.

**Variables in the role**  
- {+ servers +} - A list of servers you want to pxe boot

Example
-------
**Example Playbook:**
```yaml
---

- hosts: localhost
  gather_facts: False
  connection: local
  vars_prompt:
    - name: username
      prompt: "Enter your mgmt username"
    - name: user_pass
      prompt: "Enter your user password"

  roles:
    - pxe_boot
  become: true

...
```

**Example group_vars:**
Create a directory called group_vars on the same relative path of your playbook and create these variables.
```yaml
---
cimc_or_ilo: ilo
ilo_version: 5

````




