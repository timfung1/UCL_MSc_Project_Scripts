#!/bin/bash

data_root=/data/msc-scratch/tfung/data
output_csv=/data/msc-scratch/tfung/data/all_stats_files/output/output.csv  # Specify the path where you want to save the CSV file

# Initialize an associative array to store ROI names with hemisphere prefixes
declare -A roi_names

# First pass: Collect all unique ROI names with hemisphere prefixes
echo "Collecting ROI names..."
for file in $data_root/all_stats_files/*aparc.stats; do
    echo "Processing file: $file"
    if [ ! -f "$file" ]; then
        echo "File not found: $file"
        continue
    fi
    hemi=$(basename "$file" | cut -d _ -f 3 | cut -d . -f 1)  # Extract "rh" or "lh"
    echo "Hemisphere: $hemi"

    # Extract ROI names with hemisphere prefix directly into an array
    while read -r roi; do
        if [ -n "$roi" ]; then
            roi_names["$roi"]=1
            echo "Found ROI: $roi"
        fi
    done < <(awk -v hemi="$hemi" 'NR > 60 && NF {print hemi "." $1}' "$file")
done

# Debugging: Print contents of roi_names array
echo "Checking roi_names array:"
if [ "${#roi_names[@]}" -eq 0 ]; then
    echo "roi_names array is empty."
else
    echo "roi_names array is populated."
    echo "Contents of roi_names array:"
    for roi in "${!roi_names[@]}"; do
        echo "ROI: $roi"
    done
fi

# Exit script if roi_names array is empty
if [ "${#roi_names[@]}" -eq 0 ]; then
    echo "No ROI names found. Exiting."
    exit 1
fi


# Convert ROI names to a sorted list and join with commas for the header
rois=$(echo "${!roi_names[@]}" | tr ' ' '\n' | sort | tr '\n' ',' | sed 's/,$//')
echo "ROI names collected: $rois"

# Header for CSV file
echo "Subject,Session,metric,$rois" > "$output_csv"

# Second pass: Extract data and format it into CSV
echo
echo
echo "Extracting data..."
echo 
echo

for file in $data_root/all_stats_files/*aparc.stats; do
    echo "Processing file: $file"

    sub=$(basename "$file" | cut -d _ -f 1)
    ses=$(basename "$file" | cut -d _ -f 2)
    hemi=$(basename "$file" | cut -d _ -f 3 | cut -d . -f 1)
    echo "Subject: $sub"
    echo "Session: $ses"
    echo "Hemisphere: $hemi"

    # Initialize an associative array to store thickness values for the current file
    declare -A thickness_values

    # Use awk to extract ROI and cortical thickness and store in the array with hemisphere prefix
    while read -r roi thickness; do
        if [ -n "$roi" ]; then
            thickness_values["$roi"]="$thickness"
        fi
    done < <(awk -v hemi="$hemi" 'NR > 60 && NF {print hemi "." $1, $5}' "$file")

    # Construct the CSV row
    row="$sub,$ses,thickness"
    echo "CSV row:"
    echo "$row"

    # Append thickness values for each ROI in the correct order
    for roi in $(echo "${!roi_names[@]}" | tr ' ' '\n' | sort); do
        row+=","${thickness_values["$roi"]}
    done
    
   # Debug: Print final row with thickness values
    echo "Final CSV row with thickness values:"
    echo "$row"

    # Append the row to the CSV file
    echo "$row" >> "$output_csv"
done
echo "CSV file saved to: $output_csv"
