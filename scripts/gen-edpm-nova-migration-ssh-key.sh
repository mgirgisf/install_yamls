#!/bin/bash
#
# Copyright 2023 Red Hat Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
set -ex

function create_migration_key {
    pushd "$(mktemp -d)"
    ssh-keygen -f ./id -t ecdsa-sha2-nistp521 -N ''
    oc create secret generic nova-migration-ssh-key \
    -n openstack \
    --from-file=ssh-privatekey=id \
    --from-file=ssh-publickey=id.pub \
    --type kubernetes.io/ssh-auth

    rm id*
    popd
}

oc get secret nova-migration-ssh-key -n openstack || create_migration_key
