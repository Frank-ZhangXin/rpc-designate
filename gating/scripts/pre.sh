#!/usr/bin/env bash
# Copyright 2014-2018, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## Shell Opts ----------------------------------------------------------------
set -xeuo pipefail

## Vars and Functions --------------------------------------------------------
source ${PWD}/gating/scripts/vars.sh
source ${PWD}/gating/scripts/functions.sh

## Main ----------------------------------------------------------------------
echo "Pre gate job started"
echo "+-------------------- START ENV VARS --------------------+"
env
echo "+-------------------- START ENV VARS --------------------+"

# If we're not using a pre-saved rpc-openstack image, then deploy the
# necessary OpenStack infrastructure and services.
if [[ ! ${RE_JOB_IMAGE} =~ _snapshot$ && ${RE_JOB_NAME} =~ ^PM.*$ && ! ${RE_JOB_IMAGE} =~ .*mnaio.* ]]; then

  # Install required prerequisites
  apt-get update
  apt-get -y install python-yaml

  case $RE_JOB_SCENARIO in
  "newton")
    gate_determine_branch
    export RPC_PRODUCT_RELEASE=${RE_JOB_SCENARIO}
    export OSA_BASE_DIR=${OS_BASE_DIR}/openstack-ansible
    clone_openstack
    gate_deploy_newton
  ;;
  "pike")
    gate_determine_branch
    export RPC_PRODUCT_RELEASE=${RE_JOB_SCENARIO}
    export OSA_BASE_DIR=${OS_BASE_DIR}/openstack-ansible
    clone_openstack
    gate_deploy_${RE_JOB_SCENARIO}
  ;;
  "queens")
    gate_determine_branch
    export RPC_PRODUCT_RELEASE=${RE_JOB_SCENARIO}
    export RPC_RELEASE=queens
    export OSA_BASE_DIR=${OS_BASE_DIR}/openstack-ansible
    clone_openstack
    gate_deploy_${RE_JOB_SCENARIO}
  ;;
  "rocky")
    gate_determine_branch
    export RPC_PRODUCT_RELEASE=${RE_JOB_SCENARIO}
    export RPC_RELEASE=rocky
    export OSA_BASE_DIR=${OS_BASE_DIR}/openstack-ansible
    clone_openstack
    gate_deploy_${RE_JOB_SCENARIO}
  esac
fi

cd ${MY_BASE_DIR}
${MY_BASE_DIR}/scripts/deploy.sh

echo "Pre gate job ended"
