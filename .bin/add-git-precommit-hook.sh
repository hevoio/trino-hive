#!/bin/bash
# Adds the git-hook described below. Appends to the hook file
# if it already exists or creates the file if it does not.
# Note: CWD must be inside target repository

HOOK_DIR=$(git rev-parse --show-toplevel)/.git/hooks
LOCAL_HOOKS_DIR=$(git rev-parse --show-toplevel)/bin/hooks/
# Create script file if doesn't exist
cp -R $LOCAL_HOOKS_DIR $HOOK_DIR
chmod -R 700 "$HOOK_DIR"