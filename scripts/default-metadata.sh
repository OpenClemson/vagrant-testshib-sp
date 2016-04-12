#!/bin/bash

# Fetch the default metadata from the local SP's metadata service

set -e

curl --insecure "https://$(hostname)/Shibboleth.sso/Metadata"
