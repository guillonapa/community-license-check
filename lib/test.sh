#!/bin/sh

sh update-repos.sh
ruby /home/community-license-check/test/test_community_license_check.rb /home/tibco-streaming-community
sh license-check-pom.sh