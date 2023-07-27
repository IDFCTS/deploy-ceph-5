#!/bin/bash

output_file='/var/lib/custom-metrics/users-quotas.prom.$$'
prod_file='/var/lib/custom-metrics/users-quotas.prom'

rm -f $output_file
touch $output_file
for user in $(radosgw-admin user list | sed -e 's\,\\g' | sed -e '1d;$d' | sed -e 's\ \\g' | sed -e 's\"\\g'); do
    echo $user
    echo ${user} | grep -F '$'
    if [ $? == 0 ]; then
        user=$(echo $user | sed -e 's/$.*//')
        echo $user
        bytes=$(radosgw-admin user info --uid=${user} --tenant=${user} | grep user_quota -A 5 | grep '"max_size"' | sed -e 's\ \\g' | sed -e 's\,\\g' | sed -e 's\"max_size":\\g')
        objects=$(radosgw-admin user info --uid=${user} --tenant=${user} | grep user_quota -A 5 | grep '"max_objects"' | sed -e 's\ \\g' | sed -e 's\,\\g' | sed -e 's\"max_objects":\\g')
        display_name=$(radosgw-admin user info --uid=${user} --tenant=${user} | grep display_name | sed -e 's\ \\g' | sed -e 's\"display_name":\\g' | sed -e 's\"\\g' | sed -e 's\,\\g')
    else
        bytes=$(radosgw-admin user info --uid=${user} | grep user_quota -A 5 | grep '"max_size"' | sed -e 's\ \\g' | sed -e 's\,\\g' | sed -e 's\"max_size":\\g')
        objects=$(radosgw-admin user info --uid=${user} | grep user_quota -A 5 | grep '"max_objects"' | sed -e 's\ \\g' | sed -e 's\,\\g' | sed -e 's\"max_objects":\\g')
        display_name=$(radosgw-admin user info --uid=${user} | grep display_name | sed -e 's\ \\g' | sed -e 's\"display_name":\\g' | sed -e 's\"\\g' | sed -e 's\,\\g')
    fi
    if [ -z "$bytes" ]; then
        bytes=-1
        objects=-1
    fi
    echo user_quota_bytes\{user=\"$user\",display_name=\"$display_name\"} $bytes >> $output_file
    echo user_quota_objects\{user=\"$user\",display_name=\"$display_name\"} $objects >> $output_file
done

mv $output_file $prod_file
