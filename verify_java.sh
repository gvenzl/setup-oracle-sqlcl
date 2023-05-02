#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
#
# Copyright 2023 Andres Almiray
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

set -e

echo "::group::☕️ Verifying Java Version"
if [ -z "$JAVA_HOME" ]; then
    echo "❌ JAVA_HOME is undefined"
    echo "::endgroup::"
    exit 1
fi

if [ ! -f "${JAVA_HOME}/release" ]; then
    echo "❌ ${JAVA_HOME}/release does not exist"
    echo "::endgroup::"
    exit 1
fi

RELEASE=$(grep "JAVA_VERSION=" "${JAVA_HOME}/release")
REGEX='JAVA_VERSION="([0-9]+).*"'
if [[ "${RELEASE}" =~ $REGEX ]]; then
    MAJOR_VERSION=$((${BASH_REMATCH[1]}))
else
    echo "❌ Invalid ${JAVA_HOME}/release"
    echo "::endgroup::"
    exit 1
fi

if [ $MAJOR_VERSION -lt 11 ]; then
    echo "❌ Java 11 is required as a minimum"
    echo "::endgroup::"
    exit 1
fi

echo "✅ Found Java ${MAJOR_VERSION} at ${JAVA_HOME}"
echo "::endgroup::"
