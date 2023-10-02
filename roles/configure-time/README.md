Ansible Role: Configure Time
=================================

Description
-----------
This role installs and configures chrony on the client. Also, this role sets the right timezone.

Parameters
----------

- **Variable:** `domain_timezone`.  
      - Description: The desired timezone  
      - Default value: `Asia/Jerusalem`  

- **Variable:** `ntpd_system_path`.  
      - Description: The ntpd configuration file  
      - Default value: `/usr/lib/systemd/system/ntpd.service`  
      
Example
-------
Your playbook should just include a call to the role:
```
---
- hosts: localhost
  roles:
  - configure-time
...
```
