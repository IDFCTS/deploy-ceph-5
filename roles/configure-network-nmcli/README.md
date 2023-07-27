# configure-network-8

This automation is used to configure team on a RHEL 8 architecture using the nmcli utility.

**Example Group_Vars :**

The following storage team will be assigned an ip address 
starting with "raw_subnet" whose final octet is the final 
octet in the ssh connection ip address.

The sync bond however is assigned an ip address manually.
```
teams:
  - name: "storage"
    raw_subnet: "192.168.30"
    prefix: 24
    gw4: "192.168.30.254"
    mtu: 9000
    ifs:
      - "ens4f0"
      - "ens1f0"
    runner: "lacp"
    
  - name: "sync"
    prefix: 24
    ip4: 192.168.40.96
    gw4: "192.168.40.254"
    mtu: 9000
    ifs:
      - "ens4f1"
      - "ens1f1"
    runner: "lacp"
```


**Other Team Options:**
- **Variable:** `runner`.
    - **Description:** lacp/active-backup, correlates to the nmcli connection team.runner property
    - **Default Value:** lacp
 
- **Variable:** `method`.
    - **Description:** auto/manual, correlates to the nmcli connection ipv4.method property
    - **Default Value:** manual

**Example Playbook:**
```
- hosts: blk
  strategy: free
  become: true
  roles:
    - configure-network-8

```