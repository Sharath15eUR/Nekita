#!/bin/bash

# Checking if exactly one argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"
output_file="output.txt"

# Clearing output file before writing
> "$output_file"

# Using awk for efficient extraction and formatting
awk '
/"frame\.time":/ {frame_time = substr($0, index($0, ":") + 3)}
/"wlan\.fc\.type":/ {wlan_type = substr($0, index($0, ":") + 3)}
/"wlan\.fc\.subtype":/ {wlan_subtype = substr($0, index($0, ":") + 3)}

(frame_time && wlan_type && wlan_subtype) {
    print "\"frame.time\": \"" frame_time "\"," > "'$output_file'"
    print "\"wlan.fc.type\": \"" wlan_type "\"," > "'$output_file'"
    print "\"wlan.fc.subtype\": \"" wlan_subtype "\"" > "'$output_file'"
    print "" > "'$output_file'"  # Blank line for readability

    # Reset variables after writing
    frame_time = wlan_type = wlan_subtype = ""
}
' "$input_file"

echo "Processing completed! Output saved in $output_file"

