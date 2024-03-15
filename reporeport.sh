#!/bin/bash

# Check if bare repo directory is provided.
if [ -z "$1" ]; then
    echo "Usage: $0 <bare repo dir> [-t | --t <temp dir>] [-o | --output]"
    exit 1
fi

# Assign bare repo variable
bare_repo_dir="$1"
shift

# Create Optional Argument Defaults
temp_dir="/tmp"

# Parse Optional Argument from Command Line 
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -t|--temp)
            temp_dir="$2"
            shift
            ;;
        -o|--output)
            # Check whether $2 is path or filename
            if [[ $2 == *"/"* ]]; then
                output="$2"
            else
                output=$(pwd)/"$2"
            fi
            # Check whether $output file exists or not
            if [ -a $output ]; then
                echo "Error: Output file exists. Exiting.";
                exit 1;
            fi
            shift
            ;;
        *)
            echo "Error: Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# Set outputfile to default if not set
if [ -z $output ]; then
    output="/tmp/reporeport.data"
    rm -rf $output;
fi

# Main
for gitdir in $(find $bare_repo_dir -type d -name "*.git"); do
    repo_name=$(basename "$gitdir");
    git clone $gitdir $temp_dir/$repo_name > /dev/null 2>&1;
    cd $temp_dir/$repo_name;
    if git rev-list --count HEAD > /dev/null 2>&1; then
        git --no-pager log --all --pretty=format:"%ad" --date=short | cut -d' ' -f1 >> $output;
    fi
    cd /;
    rm -rf $temp_dir/$repo_name;
done

sort $output | uniq -c
