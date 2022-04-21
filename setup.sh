#!/usr/bin/env bash

###
# Bash script to setup environment for deploying
# virtual TDP cluster using the TDP-getting-started repo
###

TDP_ROLES_PATH=ansible_roles/collections/ansible_collections/tosit/tdp
TDP_ROLES_EXTRA_PATH=ansible_roles/collections/ansible_collections/tosit/tdp-extra

# Create directories
mkdir -p logs
mkdir -p files

# Quick fix for file lookup related to the Hadoop role refactor (https://github.com/TOSIT-FR/ansible-tdp-roles/pull/57)
[[ -d $TDP_ROLES_PATH/playbooks/files ]] || ln -s $PWD/files $TDP_ROLES_PATH/playbooks

# Copy the default tdp_vars
[[ -d $PWD/inventory/tdp_vars ]] || cp -r $TDP_ROLES_PATH/tdp_vars_defaults $PWD/inventory/tdp_vars

# Read the TDP releases from file
tdp_release_uris=$(sed -E '/^[[:blank:]]*(#|$)/d; s/#.*//' $PWD/tdp-release-uris)

# Fetch the TDP .tar.gz releases
for tdp_release_uri in $tdp_release_uris; do
    release_name=$(basename $tdp_release_uri)
    # Fetch the TDP .tar.gz releases
    [[ -f "$PWD/files/$release_name" ]] || wget $tdp_release_uri -nc -nd -O $PWD/files/$release_name
done
