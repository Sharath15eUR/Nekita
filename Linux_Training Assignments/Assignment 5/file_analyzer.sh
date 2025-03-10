#!/bin/bash

# Function to recursively search for a keyword in a directory
search_files() {                         
    directory=$1
    keyword=$2

    if [[ ! -d "$directory" ]]; then                  
        echo "Error: Directory does not exist" >&2 | tee -a errors.log
        return 1
    fi

    if [[ -z "$keyword" ]]; then                    
        echo "Error: Provide a keyword" >&2 | tee -a errors.log
        return 1                                                                                        
    fi

    for file in "$directory"/*; do               
        if [[ -d "$file" ]]; then
            search_files "$file" "$keyword"
        elif [[ -f "$file" ]]; then
            if grep -q "$keyword" "$file"; then        
                grep -n "$keyword" "$file"
                echo "Match Found in \"$file\"!"
            fi
        fi
    done
}

# Function to display help menu
display_help() {                                     
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
  -d <directory>  Search for a keyword in a directory (recursive).
  -k <keyword>    Keyword to search for.
  -f <file>       Search for a keyword in a specific file.
  --help          Display this help menu.

Examples:
  $0 -d logs -k error      # Search for 'error' in 'logs' directory
  $0 -f script.sh -k TODO  # Search for 'TODO' in 'script.sh'
EOF
    exit 0
}

# Function to search for a keyword in a file
search_in_file() {                                              
    file=$1
    keyword=$2

    if [[ ! -f "$file" ]]; then
        echo "Error: File does not exist" >&2 | tee -a errors.log
        return 1
    fi

    if [[ -z "$keyword" ]]; then
        echo "Error: Provide a keyword" >&2 | tee -a errors.log
        return 1
    fi

    grep -n "$keyword" "$file"  # Using grep directly
}

# Command-line argument handling using getopts
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d) 
            dir="$2"
            shift 2
            ;;
        -k) 
            key="$2"
            shift 2
            ;;
        -f) 
            file="$2"
            shift 2
            ;;
        --help)
            display_help
            ;;
        *)
            echo "Error: Invalid option '$1'" >&2 | tee -a errors.log
            exit 1
            ;;
    esac
done

# Execute appropriate function based on input
if [[ -n "$dir" && -n "$key" ]]; then
    search_files "$dir" "$key"
elif [[ -n "$file" && -n "$key" ]]; then
    search_in_file "$file" "$key"
else
    echo "Error: Missing required arguments. Use --help for usage details." >&2 | tee -a errors.log
    exit 1
fi
