# deploy-ceph-5
---
### configure-pxe.yml

This playbook is used to PXE boot server .

**Ansible Workflow**

The playbook calls the next roles:

`install_xmljson` - https://gitlab.example.com/idfcts/install_xmljson.git 

This role is installing the xmljson which is required by the imc_rest ansible module.

`add-pxe-target` - - src: https://gitlab.example.com/idfcts/storage/add-pxe-target.git

The role purpose is to add pxe target to cobbler, in order to allow the host to PXE boot.

`pxe_boot` - - src: https://gitlab.example.com/idfcts/storage/pxe_boot.git

This role is used to do one time pxe boot on ilo or cimc servers.

**Running the playbook** - Run the next command:
```
ansible-playbook configure-pxe.yml
```

**Example group_vars:**
Create a directory called group_vars on the same relative path of your playbook and create these variables.
```yaml
---
pxe_configuration:
  properties:
    profile: rhel-8.4-x86_64
    gateway: 192.168.3.254
    kickstart: /var/lib/cobbler/kickstarts/rhel8swraid.ks
  interfaces:
    eno1: # can be any interfacee name you want, eno1 for workstations for example
      static: yes
      macaddress: "{{ mac }}"
      ipaddress: "{{ ip }}"
      netmask: 255.255.255.0

cimc_or_ilo: cimc
site: 

```

**Example inventory file:**

```
[pxe_targets]
example01 mac="c4:65:16:bd:47:ae" ip="192.168.10.9"
```
