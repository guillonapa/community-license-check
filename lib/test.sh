#!/bin/bash

bash /home/community-license-check/lib/update-repos.sh
ruby /home/community-license-check/test/test_community_license_check.rb /home/tibco-streaming-community