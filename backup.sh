#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1]
# Assign command line arguments to meaningful variable names
targetDirectory=$1      # First argument: directory to be backed up
destinationDirectory=$2 # Second argument: where to store the backup

# [TASK 2]
# Display the provided directory paths for user confirmation
echo "Argument 1 (target directory): $targetDirectory"
echo "Argument 2 (destination directory): $destinationDirectory"

# [TASK 3]
# Get current timestamp in seconds since epoch (for comparison and backup naming)
currentTS=$(date +%s)

# [TASK 4]
# Create backup file name with timestamp to ensure uniqueness
backupFileName="backup-[$currentTS].tar.gz"

# We're going to:
  # 1: Go into the target directory
  # 2: Create the backup file
  # 3: Move the backup file to the destination directory

# To make things easier, we will define some useful variables...

# [TASK 5]
# Store the original absolute path to return to later
origAbsPath=$(pwd)

# [TASK 6]
# Change to destination directory and get its absolute path
# Fixed: Added $ before destinationDirectory
cd "$destinationDirectory" || exit
destDirAbsPath=$(pwd) 

# [TASK 7]
# Return to original directory, then navigate to target directory
# Fixed: Added quotes around variable for paths with spaces
cd "$origAbsPath" || exit
cd "$targetDirectory" || exit

# [TASK 8]
# Calculate timestamp for 24 hours ago (86400 seconds in a day)
yesterdayTS=$((currentTS - 86400 ))

# Initialize an array to store files that need to be backed up
declare -a toBackup

# [TASK 9]
# Loop through all files in the current directory (target directory)
for file in *
do
  # [TASK 10]
  # Check if the file was modified within the last 24 hours
  # Fixed: Added quotes around $file to handle filenames with spaces
  if (( $(date -r "$file" +%s) > yesterdayTS ))
  then
    # [TASK 11]
    # Add file to the backup array
    toBackup+=("$file")
  fi
done

# [TASK 12]
# Create compressed tar archive containing all files to backup
# Fixed: Added quotes around array expansion to handle spaces in filenames
tar -czvf "$backupFileName" "${toBackup[@]}"

# [TASK 13]
# Move the backup file to the destination directory
# Return to original directory and provide success message
mv "$backupFileName" "$destDirAbsPath/"
cd "$origAbsPath" || exit
echo "Backup file created: $destDirAbsPath/$backupFileName"

# Congratulations! You completed the final project for this course!