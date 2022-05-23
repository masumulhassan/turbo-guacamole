#!/bin/bash

#Usage bash google-photos-partner-sharing-separator.sh -i {Input Google Photos Folder Path} -o {Output path where partner shared file will be moved}

#Reading input and output flags
while getopts i:o: flag
do
  case "${flag}" in
    i) inputpath=${OPTARG};;
    o) outputpath=${OPTARG};;
  esac
done

find_partner_share_and_move() {
  echo "Original Metadata file: $1";
  if grep -q fromPartnerSharing "$1"; then
      current_file=$(jq '.title' "$1" | sed -r 's/^"|"$//g';);
      echo "Moving -> $current_file";
	  DIR="$(dirname "${1}")";
	  
      mkdir -p "${outputpath}/${DIR}";
	  mv "${1}" "${outputpath}/${DIR}/.";
      mv "${DIR}/${current_file}" "${outputpath}/${DIR}/.";
  fi
}

find "$inputpath" -type f -name "*.json" -print0 | while read -d $'\0' file; do
    find_partner_share_and_move "$file"
done