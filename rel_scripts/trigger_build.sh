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


if [[ -z "$CB_BRANCH" ]]; then
  export CB_BRANCH=$GIT_BRANCH
  if [[ -z "$CB_BRANCH" ]]; then
    echo "CB_BRANCH not set please set it"
    exit 1
  fi
fi
if [[ -z "$CB_VERSION" ]]; then
  export CB_VERSION=$CB_BRANCH-$(date '+%Y%m%d-%H-%M')
fi
if [[ -z "$CB_PIPELINE_TYPE" ]]; then
  export CB_PIPELINE_TYPE=daily
fi

GOPATH=$PWD/go
mkdir -p go/bin
GOBIN=$GOPATH/bin

time go get -u istio.io/test-infra/toolbox/githubctl

# this setting is required by githubctl, which runs git commands
git config --global user.name "TestRunnerBot"	
git config --global user.email "testrunner@istio.io"

"$GOBIN/githubctl" \
    --token_file="$GITHUB_TOKEN_FILE" \
    --op=relPipelineBuild \
    --base_branch="$CB_BRANCH"
