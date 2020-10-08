#!/bin/bash

imagename='community-license-check'
taSec=$(date -v -7d +'%s')

## build docker image if not exist
if [[ "$(docker images -q $imagename 2> /dev/null)" == "" ]]; then
        docker build -t $imagename .
fi

## remove and build new docker image if it is too old
datetime=$(docker inspect -f '{{ .Created }}' $imagename)
dtSec=$(date -j -f "%Y-%m-%dT%H:%M:%S.%sZ" "$datetime" +'%s')

[ $dtSec -lt $taSec ] && docker rmi -f $imagename && docker build -t $imagename .

## send email and fail build if the image could not be created
if [[ "$(docker images -q $imagename 2> /dev/null)" == "" ]]; then
	echo "An error occurred while creating the docker image. Restart the job manually to try again." | mailx -s "[FAILURE] Community license check results" "gunarvae@tibco.com" && exit 1
fi

## run docker image, save results
docker run --rm  -i $imagename > results.txt
returncode=$?
dos2unix results.txt

## send email and fail build if tests didn't pass
if [[ $returncode > 0 ]]; then
   mailx -s "[FAILURE] Community license check results" "gunarvae@tibco.com" < results.txt && exit 1
fi
