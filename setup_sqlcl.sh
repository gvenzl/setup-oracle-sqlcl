#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
#
# Copyright 2025 Gerald Venzl, Andres Almiray
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

echo "::group::⬇️ Download SQLcl"

# Download well-known latest version of SQLcl
if [[ ${VERSION} == "latest" ]]; then
  curl -s -o "sqlcl.zip" "https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip"
else
  # Version download page
  download_page="https://www.oracle.com/sqlcl/download/sqlcl-downloads-${VERSION}.html"

  # Check whether download page exists
  http_code=$(curl -s -L -o /dev/null -w "%{http_code}" "${download_page}")

  if [[ "${http_code}" != "200" ]]; then
    echo "❌ SQLcl version '${VERSION}' could not be resolved."
    echo "Make sure that the version exists!"
    exit 1;
  fi;

  # Getting the download page based on the version
  download_link=$(curl -L -s "${download_page}" | grep "https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-${VERSION}" | grep -oP 'href="\K[^"]+')

  # Download SQLcl
  curl -s -o "sqlcl.zip" "${download_link}"

fi;

echo "::endgroup::"

echo "::group::📦 Extract SQLcl"

# Extract sqlcl
unzip -qo "sqlcl.zip"

echo "SQLCL_HOME=${PWD}/sqlcl" >> "$GITHUB_ENV"

# State version
${PWD}/sqlcl/bin/sql -version

echo "${PWD}/sqlcl/bin" >> "$GITHUB_PATH"

echo "::endgroup::"
