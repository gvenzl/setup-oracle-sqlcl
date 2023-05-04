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

echo "::group::📦 Download SQLcl"

# download
java "${GITHUB_ACTION_PATH}/get_sqlcl.java" "${VERSION}"

# extract
PWD=$(pwd)
SQLCLDIR="${PWD}/.sqlcl"
export SQLCL_HOME="${SQLCLDIR}/sqlcl-${VERSION}"
unzip -qo -d "${SQLCLDIR}" "${SQLCLDIR}/sqlcl.zip"
mv "${SQLCLDIR}/sqlcl" "${SQLCL_HOME}"

echo "SQLCL_HOME=${SQLCL_HOME}" >> "$GITHUB_ENV"

# eval version
CMD="${SQLCL_HOME}/bin/sql -version"
eval "${CMD}"

# export
echo "${SQLCL_HOME}/bin" >> "$GITHUB_PATH"

echo "::endgroup::"
