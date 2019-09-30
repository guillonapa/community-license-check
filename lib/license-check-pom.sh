#!/bin/bash
#
# generate index files from maven metadata
#
# FIX THIS - we need to do better here .. really for proof of concept
#

# set -x

# Text formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color
BOLD='\033[1m' # Bold text
INFO="${BLUE}[INFO]${NC}"
WARNING="${ORANGE}[WARNING]${NC}"
ERROR="${RED}[ERROR]${NC}"
SUCCESS="${GREEN}[SUCCESS]${NC}"

MVN="${MVN3_5_4_HOME}/bin/mvn --global-settings ${SETTINGS} -Dmaven.repo.local=${WORKSPACE}/.repository ${mavenExtras}"
# MVN=mvn

here=$(pwd)

declare -i SAMPLE_PASSED=0
declare -i SAMPLE_FAILED=0

declare -i AGG_PASSED=0
declare -i AGG_FAILED=0

echo ""
echo -e "${INFO} Verifying license declaration in all pom.xml files..."

for dir in $(${MVN} -Dexec.executable='echo' -Dexec.args='${project.basedir}/' exec:exec -q)
do

	cd ${dir}

	# artifactId=$(${MVN} -N -Dexec.executable='echo' -Dexec.args='${project.artifactId}' exec:exec -q)
	# name=$(${MVN} -N -Dexec.executable='echo' -Dexec.args='${project.name}' exec:exec -q | sed -e "s+TIBCO Streaming +TIBCO\&reg; Streaming +" -e "s+TIBCO StreamBase +TIBCO StreamBase\&reg; +")
	# description=$(${MVN} -N -Dexec.executable='echo' -Dexec.args='${project.description}' exec:exec -q | sed -e "s+TIBCO Streaming +TIBCO\&reg; Streaming +" -e "s+TIBCO StreamBase +TIBCO StreamBase\&reg; +")
	# parentversion=$(${MVN} -N -Dexec.executable='echo' -Dexec.args='${project.parent.version}' exec:exec -q)
	tibcosample=$(${MVN} -N -Dexec.executable='echo' -Dexec.args='${com.tibco.ep.sb.studio.sample}' exec:exec -q)
	reldir=$(echo "${dir}" | sed -e s+^${here}/++)

	licenses=$(echo "cat //*[local-name()='project']/*[local-name()='licenses']/*[local-name()='license']" | xmllint --shell pom.xml | sed '/^\/ >/d' | sed 's/<[^>]*.//g')
	licenses2=$(echo "cat //*[local-name()='project']/*[local-name()='licenses']/*[local-name()='license']" | xmllint --shell pom.xml | sed '/^\/ >/d' | sed 's/<[^>]*.//g' | xargs echo -n)

	if [ "${tibcosample}" = "true" ]
	then

		if [ "${licenses}" = "" ]
		then
			echo -e "${WARNING} No license specified in sample pom.xml (${dir})"
			((SAMPLE_FAILED++))
		elif [ "${licenses2}" != "BSD 3-Clause License https://raw.githubusercontent.com/TIBCOSoftware/tibco-streaming-community/master/docs/Components-LICENSE repo" ]
		then
			echo -e "${WARNING} The license for the sample at ${dir} was not recognized..."
			echo ""
			echo "     Expecting: BSD 3-Clause License https://raw.githubusercontent.com/TIBCOSoftware/tibco-streaming-community/master/docs/Components-LICENSE repo"
			echo "     Actual: ${licenses}"
			((SAMPLE_FAILED++))
		else
			echo -e "${SUCCESS} Validation succeeded for ${dir}"
			((SAMPLE_PASSED++))
		fi

	else

		if [ "${licenses}" != "" ]
		then
			echo -e "${WARNING} Licenses specified outside of sample pom (${dir})"
			((AGG_FAILED++))
		else
			echo -e "${SUCCESS} Validation succeeded for ${dir}"
			((AGG_PASSED++))
		fi	

	fi

	cd ${here}

done

FAILURE_HIGHLIGHTING_SAMPLES=${NC}
if [ $SAMPLE_FAILED -gt 0 ]
then
	FAILURE_HIGHLIGHTING_SAMPLES=${RED}${BOLD}
fi

FAILURE_HIGHLIGHTING_AGG=${NC}
if [ $AGG_FAILED -gt 0 ]
then
	FAILURE_HIGHLIGHTING_AGG=${RED}${BOLD}
fi

echo ""
echo -e "${INFO} Samples tagged as Studio samples (Passed: ${GREEN}${BOLD}${SAMPLE_PASSED}${NC}, Failed: ${FAILURE_HIGHLIGHTING_SAMPLES}${SAMPLE_FAILED}${NC})"
echo -e "${INFO} Maven aggregators (Passed: ${GREEN}${BOLD}${AGG_PASSED}${NC}, Failed: ${FAILURE_HIGHLIGHTING_AGG}${AGG_FAILED}${NC})"
echo ""

if [ $SAMPLE_FAILED -ne 0 -o $AGG_FAILED -ne 0 ]
then
	exit 1
fi

exit 0

