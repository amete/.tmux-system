#/bin/bash

function get_load_averages {
  load_values=`cut -d " " -f 1-3 /proc/loadavg`
}

# Get the usage
get_load_averages
echo "System Load : $load_values"
