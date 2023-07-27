# configure-firewalld
This role is used to configure firewalld ports to open. The role disables all the ports that aren't listed in the firewall_ports variable and enables the ones that are listed. 

Role Variables
--------------
`firewall_ports` - A list of the only ports that will be opened in firewalld.

Usage
----------------

### Requirements file
Import the next requirements file:
```
- src: https://gitlab.example.com/idfcts/storage/configure-firewalld.git
  scm: git
  name: configure-firewalld
```

### Example group_vars
```
firewall_ports:
  - "443/tcp"
  - "9094/tcp"
```