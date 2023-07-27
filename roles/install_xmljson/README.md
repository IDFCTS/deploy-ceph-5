# instal xmljson for python
This role is installing the xmljson which is required by the **imc_rest** ansible module

Execute this role on localhost before executing any other role.

## Example playbook
```
---

- hosts: localhost
  become: true
  roles:
    - install_xmljson
```
To execute:
```
ansible-playbook install_xmljson.yml
```