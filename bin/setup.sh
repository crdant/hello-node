#!/bin/bash

pipelineName= credentialsFile= concourseUrl= concourseTarget= teamName= username= password=

while [ $# -gt 0 ]; do
  case $1 in
    -p | --pipeline-name )
      pipelineName=$2
      shift
      ;;
    -l | --credentials-file )
      credentialsFile=$2
      shift
      ;;
    -c | --concourse-url )
      concourseUrl=$2
      shift
      ;;
    -t | --target )
      concourseTarget=$2
      shift
      ;;
    -n | --team-name )
      teamName=$2
      shift
      ;;
    -u | --username )
      username=$2
      shift
      ;;
    -d | --password )
      password=$2
      shift
      ;;
    * )
      echo "Unrecognized option: $1" 1>&2
      exit 1
      ;;
  esac
  shift
done

set -e

error_and_exit() {
  usage
  echo $1 >&2
  exit 1
}

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
export concourseUrl=${concourseUrl:-http://192.168.100.4:8080}
export concourseTarget=${concourseTarget:-lite}
export pipelineName=${pipelineName:-`basename $DIR`}
export teamName=${teamName:-main}

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

usage() {
  me=$(basename ${0})
  echo "USAGE: ${me} [-t <target>] -p <pipeline-name> -c <credentials-yml>"
}

loginFlags=
if [ -n "${username}" ]; then
  loginFlags="-u ${username}"
fi

if [ -n "${password}" ]; then
  loginFlags="${loginFlags} -p ${password}"
fi

if [ -z "${credentialsFile}" ]; then
  credentialsFile="${DIR}/credentials.yml"
fi
credentialsFile=$(realpath $credentialsFile)
if [ ! -f ${credentialsFile} ]; then
  usage
fi


fly -t ${concourseTarget} login -c ${concourseUrl} -n ${teamName} ${loginFlags}
$DIR/bin/update.sh --target ${concourseTarget} --pipeline-name ${pipelineName} --credentials-file ${credentialsFile}
