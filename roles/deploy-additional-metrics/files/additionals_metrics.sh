#!/bin/bash

output_file='/var/lib/custom-metrics/additionals_metrics.prom.$$'
prod_file='/var/lib/custom-metrics/additionals_metrics.prom'

###########################################################################################
# Recovery metric
recovery_percentage=$(ceph -s | grep misplaced | head -n1 | cut -d '(' -f 2 | sed -e 's\%)\\g')
if [$recovery_percentage eq '']; then
    recovery_percentage=0
fi
echo recovery_percentage $recovery_percentage > $output_file
###########################################################################################


###########################################################################################
# Blocked request metric
blocked_requests=$(ceph -s | grep blocked | awk '{print $1}')
if [$blocked_requests eq '']; then
    blocked_requests=0
fi
echo slow_requests $blocked_requests >> $output_file
###########################################################################################


###########################################################################################
# Ceph health metric
ceph_health="$(ceph health detail | head -n 1 | awk '{print $1}')"
health_detail=$(ceph health detail | head -n 1)

if [[ "$ceph_health" == 'HEALTH_ERR' ]]; then
    health_status=2
elif [[ "$ceph_health" == 'HEALTH_WARN' ]]; then
    health_status=1
else
    health_status=0
fi

echo ceph_health_detail{details=\"$health_detail\"} $health_status >> $output_file
###########################################################################################
# Commit the changes so that node_exporter could know them
mv $output_file $prod_file
