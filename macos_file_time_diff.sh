#!/bin/bash

# Function to convert seconds to hours
convert_to_hours() {
    local seconds=$1
    local hours=$((seconds / 3600))
    echo "$hours"
}

# check if the script is being run with more than one command-line argument
if [ $# -gt 2 ]; then
    echo "Invalid number of arguments."
    echo "Usage: bash file_time_diff.sh [directory] [-h]"
    exit 1
fi

# Variables for directory and time format
directory=". " # Default directory is the current directory
time_format="seconds" # Default time format is seconds

# check if the -h flag is provided to display time in hours
if [ $# -eq 2 ] && [ "$2" == "-h" ]; then
    time_format="hours"
fi

# check if the directory is provided as a command-line argument
if [ $# -gt 0 ]; then
    directory=$1

    # check if the specified directory exists
    if [ ! -d "$directory" ]; then
        echo "Invalid directory: $directory"
        exit 1
    fi
fi

# enable nullglob to handle the case when there are no files in the directory
shopt -s nullglob

# iterate over all files in the specified directory
for file in "$directory"/*; do
    # check if it is a regular file or a directory
    if [[ -f $file || -d $file ]]; then
        # get the creation and modification times in seconds since 1970-01-01 00:00:00 UTC
        createTime=$(stat -f %B "$file")
        modTime=$(stat -f %m "$file")

        # calculate the difference in times
        diffTime=$((modTime - createTime))

        # check the time format and convert if necessary
        if [ "$time_format" == "hours" ]; then
            diffTime=$(convert_to_hours $diffTime)
        fi

        # print the file name and the time difference
        echo "File: $file"
        echo "Time difference between creation and last modification: $diffTime $time_format"
        echo ""
    fi
done

# disable nullglob
shopt -u nullglob

# Usage example:
# Suppose you have this script saved as "file_time_diff.sh".
# Open a terminal and navigate to the directory where the script is located.
# To check the file time differences in the current directory and display in seconds (default), run the script without any arguments:
# bash file_time_diff.sh
# To check the file time differences in a specific directory and display in seconds, provide the directory path as the argument:
# bash file_time_diff.sh /path/to/directory
# To check the file time differences in a specific directory and display in hours, provide the directory path as the first argument and use the -h flag as the second argument:
# bash file_time_diff.sh /path/to/directory -h
