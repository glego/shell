#!/bin/sh
set -e # Error Sensitive Mode, which will break out of the script in case of unexpected errors.
#set noclobber # Noclobber mode which protects accidental file clobbering. Use >| operator to force the file to be overwritten.

args="$@" # Catch all arguments
printf "Script arguments: $args \n" 

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

printf "Current work directory '$(pwd)'\n"

# Initialize the arguments variables within the script scope.
# This will allow the variables to be passed between functions.
name=""
version=""
has_content=""

print_help() {
cat <<-HELP
#
# Arguments Script
#

This will be the help text for your arguments.

  1) --name (Required): Provide name argument
  2) --version (Optional): Provide version optional argument
  3) --has_content (Flag): Provide extra content when enabled
  
## Examples
# 1) Pass all arguments
./arguments.sh --name=hello --version=1.0.2 --has_content

# 2) Name only
./arguments.sh --name=hello

# 3) Error
./arguments.sh

# 4) Help
./arguments.sh --help

HELP
    exit 0
}

parse_arguments() {
    while [ "$#" -gt 0 ]; do
    case "$1" in
        --name=*)
            name="${1#*=}"
            ;;
        --version=*)
            version="${1#*=}"
            ;;
        --has_content)
            has_content="yes"
            ;;
        --help) print_help;;
        *)
        >&2 printf "Error: Invalid argument, run --help for valid arguments.\n"
        exit 1
    esac
    shift
    done
}

check_arguments(){

    # Required
    if [ "$name" = "" ];then
        >&2 printf "Error: Please provide a valid name.\n" # >&2: Redirect printf to stderr
        exit 1
    else
        name=${name// /} # Replace all spaces
        name=$(echo "$name" | awk '{print tolower($0)}') # Set all to lower case
        printf "name: $name\n"
    fi

    # Optional
    printf "version: $version\n"
    printf "has_content: $has_content\n"
}

main()
{
    parse_arguments $args   # Parse all arguments
    check_arguments         # Check if the argument values are correct 
    # Do script...
}

main
