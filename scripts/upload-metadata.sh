#!/bin/bash

# Upload a metadata file to Testshib.org

set -e

# Require an argument for the metadata file
MD_FILE="$1"
if [ -z "${MD_FILE}" ]; then
  echo "Usage: upload-metadata.sh metadata-file"
  exit 1
fi

# Echo in yellow
warn () {
  echo -e "\033[93m$1\033[0m"
}

# Confirm an action
# Prompts the user for a yes/no answer
# Returns 0/success if the answer is 'y', 'yes', or ''
confirm () {
  read -p "Are you sure you want to continue? (y/n) " RESPONSE # Prompt and read response
  RESPONSE=$(echo "${RESPONSE}" | tr '[:upper:]' '[:lower:]')  # Convert to lower case
  [[ $RESPONSE =~ ^(yes|y) || -z $RESPONSE ]]                  # Test for positive responses
}

# Testshib.org requires you to use the same filename for metadata when uploading changes
# See http://www.testshib.org/register.html
# Cache the filename so that any attempt to upload metadata with a different filename
# will warn and prompt for confirmation
MD_FILENAME_CACHE="/etc/vagrant-testshib-sp/testshib-metadata-filename"
MD_FILENAME=$(basename "${MD_FILE}")
if [ -f "${MD_FILENAME_CACHE}" ]; then
  CACHED_MD_FILENAME=$(cat "${MD_FILENAME_CACHE}" | tr -d '[[:space:]]')
  if [ ! "${CACHED_MD_FILENAME}" == "${MD_FILENAME}" ]; then
    warn "Testshib requires using the same filename to change uploaded metadata"
    warn "See http://www.testshib.org/register.html"
    warn "Metadata was last uploaded as '${CACHED_MD_FILENAME}'"
    if ! confirm; then
      exit 1
    fi
  fi
else
  # If we haven't uploaded metadata yet, check Testshib's entity list to make sure
  # we're not using a conflicting hostname.
  SCRIPTS_DIR=$(cd $(dirname $0); pwd -P)
  MD_ENTITY_ID=$(grep -o 'entityID="[^"]\+' "${MD_FILE}" | sed 's/^entityID="//')
  echo "entityID = ${MD_ENTITY_ID}"
  echo "Checking for conflicting entities..."
  if "${SCRIPTS_DIR}/testshib-entity-list.sh" | grep --quiet "${MD_ENTITY_ID}"; then
    warn "${MD_ENTITY_ID} is already present in Testshib.org's entity list"
    if ! confirm; then
      exit 1
    fi
  else
    echo "None found"
  fi
fi
echo "${MD_FILENAME}" > "${MD_FILENAME_CACHE}"
chown vagrant:vagrant "${MD_FILENAME_CACHE}"
chmod 664 "${MD_FILENAME_CACHE}"

echo "Uploading metadata to testshib..."
curl --form userfile=@"${MD_FILE}" "https://www.testshib.org/procupload.php"

echo -e "\033[32mMetadata uploaded. Restart shibd and Apache.\033[0m"
