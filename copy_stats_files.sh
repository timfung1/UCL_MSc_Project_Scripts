#!/bin/bash

# Define base directories
base_src_dir="/data/msc-scratch/tfung/data"
base_dest_dir="/data/msc-scratch/tfung/data/all_stats_files"

# List of subjects and sessions
# create list of sub dirs and sessions
subjects=()
sessions=("ses-1" "ses-2")

# Loop through each subject
for subject in "${subjects[@]}"; do
  # Loop through each session for the subject
  for session in "${sessions[@]}"; do
    # Define the source directory for the current subject and session
    src_dir="$base_src_dir/$subject/$session/anat/freesurfer_6_t1Only/stats/"

    # Check if the source directory exists
    if [ -d "$src_dir" ]; then
      # Rename and copy lh.aparc.stats
      if [ -f "$src_dir/lh.aparc.stats" ]; then
        cp "$src_dir/lh.aparc.stats" "$base_dest_dir/${subject}_${session}_lh.aparc.stats"
        echo "Copied and renamed $subject $session lh.aparc.stats"
      fi
      
      # Rename and copy rh.aparc.stats
      if [ -f "$src_dir/rh.aparc.stats" ]; then
        cp "$src_dir/rh.aparc.stats" "$base_dest_dir/${subject}_${session}_rh.aparc.stats"
        echo "Copied and renamed $subject $session rh.aparc.stats"
      fi
    else
      echo "Source directory $src_dir does not exist for $subject $session. Skipping."
    fi
  done
done
