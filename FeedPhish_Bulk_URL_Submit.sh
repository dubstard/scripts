#!/usr/bin/env bash

# @FeedPhish bulk URL Uploader script.
# Want a key? Message us on twitter: https://twitter.com/FeedPhish
# Usage:
# ./PhishFeed.sh --submit urls.txt



set -Eeuo pipefail

endpoint="https://api.phishfeed.com/submissions/v1/submit-url"
MAX_URLS_PER_REQUEST=10000

declare -A client_keys

# Insert your API key
client_keys["main"]="YOUR_API_KEY_HERE"


need-jq() {
    echo "'jq' is required."
    echo
    echo "If you are running Ubuntu, you can install it with:"
    echo "sudo apt-get install jq"
    exit 1
}

usage() {
    echo "Usage: ${0} <CLIENT> [--submit] [FILE]..."
    echo
    echo "  --submit    Post data to the API."
    echo "  --help      Show this message."
    echo
    echo "Default behavior is to dry-run and show what would be sent."
    echo
    echo "FILE          A file with URL data to post"
    echo
}

declare -A flags
declare -a incoming_files

jq_file() {
    infile="$1"
    outfile="$2"
    jq -R "." < "${infile}" | jq -s '{"urls": .}' > "${outfile}"
}

submit_file() {
    datafile="$1"
    if [ "${flags['SUBMIT']:-0}" -eq 1 ]; then
        curl -X POST \
             -H "x-api-key: ${client_keys[${CLIENTNAME}]}" \
             "${endpoint}" \
             --data-binary @"${datafile}"
    else
    	usage
    fi
}

process_file() {
    file="$1"
    jq_file "${file}" "${file}.json"
    submit_file "${file}.json"
}

if [ $# -eq 0 ]; then
    echo "No arguments provided."
    usage
    exit 1
fi

CLIENTNAME="main"
if [ "${1}" == "--help" ]; then
    usage
    exit 0
fi

for arg in "$@"; do
    case $arg in
        --submit)
            flags["SUBMIT"]=1
            ;;
        --help)
            usage
            exit 0
            ;;
        -*)
            echo "Unsupported argument '${arg}'."
            flags["ABORT"]=1
            ;;
        *)
            if [ -f "${arg}" ]; then
                incoming_files+=("${arg}")
            else
                echo "Not a valid file: '${arg}'"
            fi
            ;;
    esac
done

if [ "${flags['ABORT']:-0}" -eq 1 ]; then
    echo "Invalid arguments provided, aborting."
    exit 1
fi

if [ -z "${incoming_files[*]}" ]; then
    echo "No files provided to process, aborting."
    exit 1
fi

cleanup_on_exit() {
    for file in "${incoming_files[@]}"; do
        if [ "${flags['DEBUG']:-0}" -eq 1 ]; then
            echo "Cleaning up for '${file}'"
            ls -l "${file}"{.json,.split*} 2>/dev/null || true
        fi
        rm -f "${file}"{.json,.split*}
    done
}

trap 'cleanup_on_exit' EXIT
for file in "${incoming_files[@]}"; do
    if [ "$(wc -l < "${file}")" -gt "${MAX_URLS_PER_REQUEST}" ]; then
        echo "big file"
        split \
            --suffix-length 3 \
            --numeric-suffixes=1 \
            --lines="${MAX_URLS_PER_REQUEST}" \
            "${file}" \
            "${file}.split"
        for smaller_file in "${file}.split"*; do
            process_file "${smaller_file}"
        done
    else
        process_file "${file}"
    fi
done
