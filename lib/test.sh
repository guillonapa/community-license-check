#!/bin/bash

bash /home/community-license-check/lib/update-repos.sh
ruby /home/community-license-check/test/test_community_license_check.rb /home/tibco-streaming-community
cp /home/community-license-check/lib/license-check-pom.sh /home/tibco-streaming-community/license-check-pom.sh

which bash

bash /home/tibco-streaming-community/license-check-pom.sh
rm /home/tibco-streaming-community/license-check-pom.sh