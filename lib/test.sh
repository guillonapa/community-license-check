#!/bin/bash

bash /usr/src/app/lib/update-repos.sh
ruby /usr/src/app/test/test_community_license_check.rb /usr/src/app/tibco-streaming-community
