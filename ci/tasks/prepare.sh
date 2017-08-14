#!/bin/bash

baseName="hello-node"

inputDir=     # required
outputDir=    # required
packaging= # optional

while [ $# -gt 0 ]; do
  case $1 in
    -i | --input-dir )
      inputDir=$2
      shift
      ;;
    -o | --output-dir )
      outputDir=$2
      shift
      ;;
    -p | --packaging )
      packaging=$2
      shift
      ;;
    * )
      echo "Unrecognized option: $1" 1>&2
      exit 1
      ;;
  esac
  shift
done

if [ ! -d "$inputDir" ]; then
  echo "missing input directory!"
  exit 1
fi

if [ ! -d "$outputDir" ]; then
  echo "missing output directory!"
  exit 1
fi

if [ ! -f "$inputManifest" ]; then
  error_and_exit "missing input manifest: $inputManifest"
fi

if [ -z "$packaging" ]; then
  error_and_exit "missing packaging!"
fi

package=`find $inputDir -name "*.${packaging}"`
echo "Extracting application from ${package} to ${outputDir}"
tar -C ${outputDir} -xzf ${package}
ls ${outputDir}

echo "Finished"
