# configure-dmesg
This role creates the service and log file for dmesg


### Example playbook
You can deploy with one source:
```
---

- hosts: obj
  become: yes
  roles:
    - configure-dmesg


```
