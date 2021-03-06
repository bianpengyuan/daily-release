#!/bin/bash

# Copyright 2018 Istio Authors

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


# /workspace is the working directory for the scripts
mkdir /workspace 
cp "build/build_env.sh" "/workspace/gcb_env.sh"
source "/workspace/build_env.sh"

SCRIPTS_IN_DAILY_RELEASES="true"
if [[ -z SCRIPTS_IN_DAILY_RELEASES ]]; then

  echo using scripts from $CB_GITHUB_ORG/istio
  # checkout the build tools and copy them for later steps
  git clone "https://github.com/$CB_GITHUB_ORG/istio" -b $CB_BRANCH --depth 1
  cp istio/release/gcb/*sh /workspace

else

  echo using scripts from daily-releases repo
  cp rel_scripts/gcb/*sh /workspace

fi

cd /workspace
gsutil -qm cp -P /workspace/*sh "gs://$CB_GCS_RELEASE_TOOLS_PATH/*"
# /output is used to store release artifacts
mkdir /output

# start actual build steps
./generate_manifest.sh
./istio_checkout_code.sh

./cloud_builder.sh
./store_artifacts.sh
./rel_push_docker_build_version.sh
./modify_values.sh
./helm_charts.sh
