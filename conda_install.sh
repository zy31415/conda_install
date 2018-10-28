#!/bin/sh

# Help messages:
usage="$(basename "$0") [-h] -- program to install conda packages based on requirements.txt file.

Use the following commenting line:
# -c conda-forge
to ask to install the following package from conda-forge channel.

Arguments:
    -h  show this help text"

seed=42
while getopts ':hs:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    s) seed=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

# The main program starts from here:
while read line; do
  if [[ ${line} =~ ^\#[[:space:]]+-c[[:space:]]+conda-forge ]];then
    chanel=${line:1}
  elif [[ ${line} =~ ^\# ]];then
    continue
  else
    echo "conda install $chanel ${line}"
    conda install ${chanel} ${line}
    chanel=""
  fi
done <requirements.txt