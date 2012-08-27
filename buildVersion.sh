#!/bin/bash

IFS=$IFS
latestVersion=$(git describe $branch --abbrev=0)
if [ $# -lt 1 ]; then
	echo "Available build version: $latestVersion"
	exit 0
fi
echo "Searching for commit(s) with messages containing text $1" 
branch=$2
commitIdsRaw=$(git log $branch --grep=$1 --pretty="%h"| tr '\n' ';')
IFS=';'
commitIds=($commitIdsRaw)
IFS=$OIFS
commitsCount=${#commitIds[@]}
if [ "$commitsCount" -gt "0" ]; then
	#echo "Commit(s) with id ${commitIds[@]} found" 
	for commitId in ${commitIds[@]}
	do
		commitMessage=$(git log $commitId...$commitId^ --pretty="%s")
		echo "Looking for build version containing commit <$commitMessage> "
		buildVersionsRaw=$(git log HEAD...$commitId^ --pretty="%h%d" | sed -n s/'.*\(([0-9\., ]*)\).*'/'\1'/gp | tr '\n' ';')
		IFS=';'
		buildVersions=($buildVersionsRaw)
		IFS=OIFS
		versionsCount=${#buildVersions[@]}
	if [ "$versionsCount" -lt "1" ]; then
		echo "They build is not available yet. Make sure your repo is updated and try again"
	else
		echo "The commit is present in the build version - ${buildVersions[$versionsCount-1]}"
	fi
	done
else
	echo "No commits found"
fi
echo "Available Latest build version is $latestVersion"
echo "Enjoy! Have a nice day !"
