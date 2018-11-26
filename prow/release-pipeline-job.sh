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


set -x

echo $PWD

changed_files=$(git show --pretty="" --name-only)
echo $changed_files

case ${changed_files} in
    *"build/build_env.sh"*)
      ./rel_scripts/trigger_test.sh;;
    *"test/build_env.sh"*)
      ./rel_scripts/trigger_release.sh;;
    *)
      ./rel_scripts/trigger_build.sh;;
esac
