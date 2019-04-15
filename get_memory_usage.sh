#/bin/bash

function get_memory_usage {
  mem_readings=`cat /proc/meminfo | grep "MemTotal\|MemFree\|Buffers\|Cached\|SReclaimable\|Shmem\|SwapTotal\|SwapFree"`
  values=(`(IFS=' '; for mem_reading in $mem_readings; do echo "$mem_reading" | grep "[0-9]"; done)`)
  ## MemTotal: MemFree: Buffers: Cached: SwapCached: SwapTotal: SwapFree: Shmem: SReclaimable: 
  ## All in kB
  swap=$(expr ${values[5]} - ${values[6]})
  cached=$(expr ${values[3]} + ${values[8]} - ${values[7]})
  buffers=$(expr ${values[2]})
  usage=$(expr ${values[0]} - ${values[1]} - ${buffers} - ${cached})
  ## Convert into GB
  usage_gb=$(echo "scale=2; $usage/1024./1024." | bc)
  total_bg=$(echo "scale=2; ${values[0]}/1024./1024." | bc)
}

# Get the usage
get_memory_usage
echo "Memory : $usage_gb GB [used] / $total_bg [total]"
