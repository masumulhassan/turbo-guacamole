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
      current_file=$(echo "$1" | sed 's/\.[^.]*$//');
      echo "Moving -> $current_file";
      mv "$1" "$outputpath";
      mv "$current_file" "$outputpath";
  fi
}

find "$inputpath" -type f -name "*.json" -print0 | while read -d $'\0' file; do
    find_partner_share_and_move "$file"
done



