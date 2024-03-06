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
output="/tmp/reporeport.data"

# Parse Optional Argument from Command Line 
while [[ "$#" -gt 0 ]]; do
	case $1 in
		-t|--temp)
			temp_dir="$2"
			shift
			;;
		-o|--output)
			output="$2"
			shift
			;;
		*)
			echo "Unknown option: $1"
			exit 1
			;;
	esac
	shift
done

# Clears output so that script can be run multiple times in same session
rm -rf $output

# Main
for gitdir in $(find $bare_repo_dir -type d -name "*.git"); do
	repo_name=$(basename "$gitdir");
	git clone --quiet $gitdir $temp_dir/$repo_name;
	cd $temp_dir/$repo_name;
	if git rev-list --count HEAD > /dev/null 2>&1; then
		git --no-pager log --pretty=format:"%ad" --date=short | cut -d' ' -f1 >> $output;
	fi
	cd /;
	rm -rf $temp_dir/$repo_name;
done

sort $output | uniq -c
