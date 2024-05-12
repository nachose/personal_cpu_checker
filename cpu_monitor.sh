#!/usr/bin/env sh

######################################################################
# @author      : Jose Ignacio Seco Sanz (joseignacio.secosanz@outpayce.com)
# @file        : cpu_monitor
# @created     : Sunday May 12, 2024 21:26:23 CEST
#
# @description : 
######################################################################


#!/usr/bin/env sh

######################################################################
# @author      : Jose Ignacio Seco Sanz (joseignacio.secosanz@outpayce.com)
# @file        : cpu_monitor
# @created     : Sunday May 12, 2024 19:14:33 CEST
#
# @description : 
######################################################################


#!/bin/bash

round() {
  printf "%.${2}f" "${1}"
}

# Function to check CPU load
check_cpu_load() {
    local threshold=90  # Adjust this threshold as needed
    local consecutive=3  # Number of consecutive checks with high load

    # local cpu_count=$(nproc)  # Get the number of CPU cores
    # local -a cpu_load=()

    # for ((i = 0; i < cpu_count; i++)); do
    #     cpu_load[$i]=0  # Initialize load for each CPU core
    # done

    while true; do
        # Get the current CPU load for each core
        cpu_load_nac=$(round $(top -bn1 | awk '/Cpu/ {print $2}'))

        echo "Current CPU Load: ${cpu_load_nac}"

        if [ ${cpu_load_nac} -ge ${threshold} ]; then
            ((consecutive--))
            echo "High CPU load detected ($consecutive checks left)"

            if [ $consecutive -eq 0 ]; then
                echo "High CPU load for consecutive checks. Terminating processes..."

                # Kill the specified processes
                pkill chrome
                pkill chromium
                pkill firefox
                pkill virtualbox

                echo "Processes terminated."
                consecutive=3  # Reset consecutive count after terminating processes
            fi
        else
            echo "Load is not high, reseting counter"
            consecutive=3  # Reset consecutive count if all cores are not consistently high
        fi

        sleep 10  # Wait for 15 seconds before the next check
    done
}

# Run the function as a background process
check_cpu_load &

