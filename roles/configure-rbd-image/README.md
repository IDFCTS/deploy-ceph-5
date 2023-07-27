# Configure-RBD-Image

This role creates RBD image's and map's them to the server. 

**Variables in the role**  
- {+ mon_hostname +} - The name of the mon that the role works with.
- {+ pool_name +} - The name of the pool where the image is created in.
- {+ image_list +} - A list of dictionary's of images, it containes the name of the image, and the size. 
- {+ mount_points +} - A list of dictionary's of mount points to each image.
- {+ user_name +} - The name of the user that the role creates in ceph and uses to create and access the image.
- {+ ceph_version +} - The version of the ceph cluster you are working with (default: 4).

Example
-------
**Example Playbook:**
This role can only run on one host at a time , because you can't map the same image to two hosts.
```yaml
 ---
- name: "configure rbd"
  hosts: rbd-host
  become: true
  roles:
    - configure-rbd-image
```

Create a directory called group_vars on the same relative path of your playbook and configure your vm parameters there:  

without lvm:
```yaml
---
mon_hostname: pre-blk01
pool_name: cassandra
image_list:
- name: test-cas02_1
  size: 30G
- name: test-cas02_2
  size: 30G
- name: test-cas02_3
  size: 30G
- name: test-cas02_4
  size: 10G

mount_points:
- path: /var/lib/cassandra/data-1
  device: /dev/rbd/{{ pool_name }}/test-cas02_1
- path: /var/lib/cassandra/data-2
  device: /dev/rbd/{{ pool_name }}/test-cas02_2
- path: /var/lib/cassandra/data-3
  device: /dev/rbd/{{ pool_name }}/test-cas02_3
- path: /var/lib/cassandra/control
  device: /dev/rbd/{{ pool_name }}/test-cas02_4

user_name: cassandra

```

with lvm: 
Remember when configuring with lvm, if there is a service that uses this mount point, you should add to the service's configuration file `After=mount_point_with_"-"_instead_of_"/".mount`, [there is an automation for that](https://gitlab.example.com/idfcts/storage/configure-service-rbd-usage)
```yaml
---
mon_hostname: monblk01
pool_name: prometheus
ceph_version: 4
image_list:
- name: prom01-01
  size: 6T

mount_points:
- path: /var/lib/prometheus
  device: /dev/rbd/{{ pool_name }}/prom01-01
  lv_name: prometheuslv
  vg_name: prometheus_vg

user_name: prometheus


```

