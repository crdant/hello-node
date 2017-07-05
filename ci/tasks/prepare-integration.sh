#!/bin/bash

baseName="hello-node"

inputDir=     # required
outputDir=    # required
versionFile=  # optional
inputManifest=  # optional
packaging= # optional

#
hostname=$CF_MANIFEST_HOST # default to env variable from pipeline


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
    -v | --version-file )
      versionFile=$2
      shift
      ;;
    -f | --input-manifest )
      inputManifest=$2
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


if [ ! -f "$versionFile" ]; then
  error_and_exit "missing version file: $versionFile"
fi

if [ -f "$versionFile" ]; then
  version=`cat $versionFile`
  baseName="${baseName}-${version}"
fi

if [ ! -f "$inputManifest" ]; then
  error_and_exit "missing input manifest: $inputManifest"
fi

if [ -z "$packaging" ]; then
  error_and_exit "missing packaging!"
fi

package=`find $inputDir -name "*.{$packaging}"`

echo "Extracting application from ${package} to ${outputDir}"
cd ${outputDir}
tar -xzf ${package}

#Manifest
echo "Host Name: "$hostname
outputManifest=$outputDir/manifest.yml
cp $inputManifest $outputManifest
echo $hostname
# the path in the manifest is always relative to the manifest itself
sed -i -- "s|path: .*$|path: ${baseName}.war|g" $outputManifest
sed -i "s|host: .*$|host: $hostname|g" $outputManifest

cat $outputManifest

echo "Finished"
