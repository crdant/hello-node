#!/bin/sh

inputDir= moduleCache=

hostname="${CF_HOST}"  # default to env variable from pipeline
domain="${CF_DOMAIN}"

while [ $# -gt 0 ]; do
  case $1 in
    -i | --input-dir )
      inputDir=$2
      shift
      ;;
    -m | --module-cache )
        moduleCache=$2
        shift
      ;;
    * )
      echo "Unrecognized option: $1" 1>&2
      exit 1
      ;;
  esac
  shift
done

error_and_exit() {
  echo $1 >&2
  exit 1
}

if [ ! -d "$inputDir" ]; then
  error_and_exit "missing input directory: $inputDir"
fi
if [ ! -d "$moduleCache" ]; then
  error_and_exit "missing module cache directory: $moduleCache"
fi

cd $inputDir
mv ${moduleCache}/node_modules .
npm run integration -- https://${hostname}.${domain}/
