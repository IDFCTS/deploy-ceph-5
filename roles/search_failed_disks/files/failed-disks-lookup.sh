#!/bin/bash

# That script looks for hardware errors in dmesg log of the last NUMBER_OF_DAYS days.
# A Hardware error means that the specified storage disk is in failed state and needs to be replaced.

NUMBER_OF_DAYS=3

# Collect all hardware errors from dmesg of the last NUMBER_OF_DAYS days.
echo "dmesg -T | grep 'blk_update_request' | grep $(date +%Y) | grep $(seq $NUMBER_OF_DAYS -1 0 | xargs -I {} date --date="$(date +%Y-%m-%d) -{} day" +"%a %b %-d" | sed 's/ /\\s*/g' | xargs -I {} -d'\n' printf "-e \"{}\" ")" | bash > /tmp/dmesg_medium_error.tmp

# This is the list of disks who have suffered from hardware error in the last NUMBER_OF_DAYS days.
disks_medium_error=$(cat /tmp/dmesg_medium_error.tmp | cut -d ',' -f 2 | awk '{print $2}' | uniq)

# This will eventually hold the list of disks that have hardware error and are still in the cluster.
disks_to_be_shown=""

for dev in $disks_medium_error
do
        # Check if the specified disk is still in the cluster, if so add it the final disks list that we want to present.
        # Otherwise, the disk has been already removed from the cluster.
        dev_still_in_cluster=$(ls /dev | grep -w data_vg_$dev | cut -d "_" -f 3)
        disks_to_be_shown+="$dev_still_in_cluster "
done
disks_to_be_shown=$(echo $disks_to_be_shown | sed 's/ /, /g')

# Count the number of the failed disks.
if [ "$disks_to_be_shown" == "" ]
then
        disks_to_be_shown="none"
        num_of_failed_disks=0
else
        num_of_failed_disks=$(echo $disks_to_be_shown | wc -w)
fi

# Write the metric prometheus-style.
echo dmesg_medium_errors_count{failed_disks=\"$disks_to_be_shown\"} $num_of_failed_disks > /var/lib/custom-metrics/dmesg_medium_errors.prom

# Delete temporary file
rm -f /tmp/dmesg_medium_error.tmp
