IFS=$IFS
echo "Searching for commit(s) with messages containing text $1" 
commitIdsRaw=$(git log --grep=$1 --pretty="%h"| tr '\n' ';')
IFS=';'
commitIds=($commitIdsRaw)
IFS=$OIFS
commitsCount = ${#commitIds[@]}
if [ commitsCount -gt "0" ] then
	echo "Commit(s) with id ${commitIds[@]} found" 
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
		echo "They build is not available yet. Make sure your repo is updated and try again\n"
	else
		echo "The commit is present in the build version - ${buildVersions[$versionsCount-1]}\n"
	fi
	done
else
	echo "No commits found"
fi
latestVersion=$(git describe --abbrev=0)
echo "Available Latest build version is $latestVersion"
echo "Enjoy! Have a nice day !"
