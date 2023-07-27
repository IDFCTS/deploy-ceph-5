# add-cmic-A-record

This role was created to automate dns record creation for new servers.

clone this repo, and run the playbook with your own domain user:

"ansible-playbook add-cimc-a-record.yml --ask-pass"

When prompted, use your domain password.

NOTE: Make sure your user has priviliges to create DNS records on the idm.

WARNING: Do not use admin/<idm_admin_pass> as your credentials. We want to be able to check idm logs and see which user added records.

noteable variable:

in defaults:
```

idm_zone: "example.com." 
#dns zone for A records

ptr_zone: "201.255.192.168in-addr.arpa"
#dns zone for PTR records in site

ptr_zone: "255.192.168in-addr.arpa"
#dns zone for PTR records in site

```

in host_vars/localhost.yml

notes regarding localhost variables:

- All dict items are MANDATORY, the role is designed to fail otherwise. Make sure all values are correct to avoid mishaps.
- list name is "iservers" since the role should suit every baremetal server that uses the prefix "i" naming convention.
- server_name: Use the short, non-fqdn name. do not add "i" before the hostname, this is handled by the role.
- cimc_ip: cimc/iLO ip address, all 4 octats. splitting/joining is handled by the role.
- site: "site" or "site"
- action: "create" or "delete"
- type: "ilo" or "cimc"


Playbook example (just include the role, can also put the vars here if you don't want to use host vars)
```
---
- hosts: localhost
  roles:
  - add-cimc-a-record
```

notable role options:

    ipa_prot: "https" 
    #Toggle https/http
    
    validate_certs: "yes" 
    #If https is used and certificate is untrusted, you can toggle to "no"
    
    record_type: "A" or "PTR"
    #choose type, tested only with A and PTR
    
    record_ttl: "86400" 
    #Some older ansible versions require this option, I set it to the same value as the idm default 
    


