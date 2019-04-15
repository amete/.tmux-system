#/bin/bash

function get_memory_usage {
  mem_readings=`cat /proc/meminfo | grep "MemTotal\|MemFree\|Buffers\|Cached\|SReclaimable\|Shmem\|SwapTotal\|SwapFree"`
  values=(`(IFS=' '; for mem_reading in $mem_readings; do echo "$mem_reading" | grep "[0-9]"; done)`)
  ## Computation a la htop : https://stackoverflow.com/questions/41224738/how-to-calculate-system-memory-usage-from-proc-meminfo-like-htop 
  ## MemTotal: MemFree: Buffers: Cached: SwapCached: SwapTotal: SwapFree: Shmem: SReclaimable: 
  ##        0:       1:       2:      3:          4:         5:        6:     7:            8:
  ## All in kB
  swap=$(expr ${values[5]} - ${values[6]})
  cached=$(expr ${values[3]} + ${values[8]} - ${values[7]})
  buffers=$(expr ${values[2]})
  usage=$(expr ${values[0]} - ${values[1]} - ${buffers} - ${cached})
  ## Convert into GB
  usage_gb=$(echo "scale=2; $usage/1024./1024." | bc)
  total_bg=$(echo "scale=2; ${values[0]}/1024./1024." | bc)
  ## Here usage doesn't account for SReclaimable, which can be released by the system
  ## Another way would be to compute the usage as (MemTotal - MemFree - Buffers - Cached)
}

# Get the usage
get_memory_usage
echo "Memory : $usage_gb GB [non-cache/buffer] / $total_bg GB [total]"
