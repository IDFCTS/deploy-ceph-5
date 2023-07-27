#!/bin/bash

#Location of system binaries
AWK=$(command -v awk)
DATE=$(command -v date)
GREP=$(command -v grep)
OPENSSL=$(command -v openssl)
PRINTF=$(command -v printf)
SED=$(command -v sed)
FIVE_WEEKS="3024000"
THREE_WEEKS="1814400"

#Create empty file for certificates monitoring - 1 for alerting and 1 for details 
> /var/lib/custom-metrics/certificates-metrics.prom.$$
> /var/lib/custom-metrics/certificates-metrics-pretty.$$

### Check the certificate 
check_file_status(){
   CERTFILE="${1}"
   HOST=$(hostname)

   ### Check to make sure the certificate file exists
   if [ ! -r "${CERTFILE}" ] || [ ! -s "${CERTFILE}" ]; then 
        echo "${1}" >> /var/lib/custom-metrics/certificates-metrics-pretty.$$
        echo "ERROR: The file named ${CERTFILE} is unreadable or doesn't exist" >> /var/lib/custom-metrics/certificates-metrics-pretty.$$
        echo "ERROR: Please check to make sure the certificate for ${HOST} is valid" >> /var/lib/custom-metrics/certificates-metrics-pretty.$$
        echo "" >> /var/lib/custom-metrics/certificates-metrics-pretty.$$
        rc=2 
        return 

   ### Extract details from the certificate 
   else
      # Extract the expiration date from the certificate
      CERTDATE=$("${OPENSSL}" x509 -in "${CERTFILE}" -enddate -noout | "${SED}" 's/notAfter\=//')
      
      # Extract the issuer from the certificate 
      CERTISSUER=$("${OPENSSL}" x509 -in "${CERTFILE}" -issuer -noout | "${AWK}" 'BEGIN {FS="issuer="} { print $2}')

      # Extract the common name (CN) from the X.509 certificate
      COMMONNAME=$("${OPENSSL}" x509 -in "${CERTFILE}" -subject -noout | "${SED}" -e 's/.*CN = //')
 
      # Extract the serial number from the X.509 certificate
      SERIAL=$("${OPENSSL}" x509 -in "${CERTFILE}" -serial -noout | "${SED}" -e 's/serial=//')

   fi

  ### Check the expiration date 
  epoch_certdate=$(date -d "${CERTDATE}" +"%s")
  epoch_currentdate=$(date +%s)
  epoch_diff=`expr ${epoch_certdate} - ${epoch_currentdate}`
  if [ $epoch_diff -le $THREE_WEEKS ]; then
     echo certificate_three_weeks{cert=\"$CERTFILE\"} 1 >> /var/lib/custom-metrics/certificates-metrics.prom.$$
     echo certificate_five_weeks{cert=\"$CERTFILE\"} 1 >> /var/lib/custom-metrics/certificates-metrics.prom.$$

  elif [ $epoch_diff -le $FIVE_WEEKS ]; then
     echo certificate_three_weeks{cert=\"$CERTFILE\"} 0 >> /var/lib/custom-metrics/certificates-metrics.prom.$$
     echo certificate_five_weeks{cert=\"$CERTFILE\"} 1 >> /var/lib/custom-metrics/certificates-metrics.prom.$$

  else
     echo certificate_three_weeks{cert=\"$CERTFILE\"} 0 >> /var/lib/custom-metrics/certificates-metrics.prom.$$
     echo certificate_five_weeks{cert=\"$CERTFILE\"} 0 >> /var/lib/custom-metrics/certificates-metrics.prom.$$
  fi
  
  echo "" >> /var/lib/custom-metrics/certificates-metrics.prom.$$
} 

### Print the details from the cert file
print_heading() {
   echo "${1}" >> /var/lib/custom-metrics/certificates-metrics-pretty.$$ 
   ${PRINTF} "\n%-28s %-55s %-55s %-28s %-28s\n" "Host" "Issuer" "Common Name" "Expires" "Serial #" >> /var/lib/custom-metrics/certificates-metrics-pretty.$$
   echo "---------------------------- ----------------------------------------------------- ------------------------------------------------------- -------------------------- ------------------------" >> /var/lib/custom-metrics/certificates-metrics-pretty.$$
   ${PRINTF} "\n%-28s %-55s %-55s %-28s %-28s\n" "${HOST}" "${CERTISSUER}" "${COMMONNAME}" "${CERTDATE}" "${SERIAL}" >> /var/lib/custom-metrics/certificates-metrics-pretty.$$
   echo "" >> /var/lib/custom-metrics/certificates-metrics-pretty.$$
}


### Run the check for each certificate
for CERT in "$@"; do
  rc=0
  check_file_status $CERT
  if [ "$rc" -ne 2 ]; then 
    print_heading $CERT
  fi
done

# Commit the changes so that node_exporter could know them
  mv /var/lib/custom-metrics/certificates-metrics.prom.$$ /var/lib/custom-metrics/certificates-metrics.prom
  mv /var/lib/custom-metrics/certificates-metrics-pretty.$$ /var/lib/custom-metrics/certificates-metrics-pretty

exit 0
