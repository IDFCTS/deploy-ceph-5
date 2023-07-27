#!/bin/bash

output_file='/var/lib/custom-metrics/users-usage.prom.$$'
prod_file='/var/lib/custom-metrics/users-usage.prom'

rm -f $output_file
touch $output_file
for user in $(radosgw-admin user list | sed -e 's\,\\g' | sed -e '1d;$d' | sed -e 's\ \\g' | sed -e 's\"\\g'); do
    echo $user
    echo ${user} | grep -F '$'
    if [ $? == 0 ]; then
        user=$(echo $user | sed -e 's/$.*//')
        echo $user
        bytes=$(radosgw-admin user stats --uid=${user} --tenant=${user} | grep total_bytes_rounded | sed -e 's\ \\g' | sed -e 's\"total_bytes_rounded":\\g')
        objects=$(radosgw-admin user stats --uid=${user} --tenant=${user} | grep total_entries | sed -e 's\ \\g' | sed -e 's\,\\g' | sed -e 's\"total_entries":\\g')
        display_name=$(radosgw-admin user info --uid=${user} --tenant=${user} | grep display_name | sed -e 's\ \\g' | sed -e 's\"display_name":\\g' | sed -e 's\"\\g' | sed -e 's\,\\g')
    else
        bytes=$(radosgw-admin user stats --uid=${user} | grep total_bytes_rounded | sed -e 's\ \\g' | sed -e 's\"total_bytes_rounded":\\g')
        objects=$(radosgw-admin user stats --uid=${user} | grep total_entries | sed -e 's\ \\g' | sed -e 's\,\\g' | sed -e 's\"total_entries":\\g')
        display_name=$(radosgw-admin user info --uid=${user} | grep display_name | sed -e 's\ \\g' | sed -e 's\"display_name":\\g' | sed -e 's\"\\g' | sed -e 's\,\\g')
    fi
    if [ -z "$bytes" ]; then
        bytes=0
        objects=0
    fi
    echo total_used_bytes\{user=\"$user\",display_name=\"$display_name\"} $bytes >> $output_file
    echo total_used_objects\{user=\"$user\",display_name=\"$display_name\"} $objects >> $output_file
done

mv $output_file $prod_file
