#!/bin/bash

# Function to check CPU load
check_cpu_load() {
    local threshold=75  # Adjust this threshold as needed
    local consecutive=2  # Number of consecutive checks with high load

    local cpu_count=$(nproc)  # Get the number of CPU cores
    local -a cpu_load=()

    for ((i = 0; i < cpu_count; i++)); do
        cpu_load[$i]=0  # Initialize load for each CPU core
    done

    while true; do
        # Get the current CPU load for each core
        mapfile -t load < <(top -bn1 | awk '/Cpu/ {print $2}' | grep -o '[0-9]\+')

        echo "Current CPU Loads: ${load[@]}"

        # Update load for each core
        for ((i = 0; i < cpu_count; i++)); do
            cpu_load[$i]=${load[$i]}
        done

        high_load_count=0

        for ((i = 0; i < cpu_count; i++)); do
            if [ ${cpu_load[$i]} -ge $threshold ]; then
                ((high_load_count++))
            fi
        done

        echo "High CPU Count: $high_load_count"

        if [ $high_load_count -eq $cpu_count ]; then
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
                consecutive=2  # Reset consecutive count after terminating processes
            fi
        else
            consecutive=2  # Reset consecutive count if all cores are not consistently high
        fi

        sleep 15  # Wait for 15 seconds before the next check
    done
}

# Run the function as a background process
check_cpu_load &

