#!/bin/bash
error_message=""
echo ${CIRCLE_PULL_REQUEST}
CIRCLE_PR_NUMBER=$(echo ${CIRCLE_PULL_REQUEST} |  awk -F 'pull/' '{print $2}')
if [[ -n "$CIRCLE_PR_NUMBER" ]]; then
    PR_TITLE=$(gh pr view $CIRCLE_PULL_REQUEST --json title --jq '.title')
    branch_regex="^((feat|bugfix|hotfix|revert)\/([A-Z0-9]+)-([0-9]+)\/(.+))|(merge\/no-ref\/(.+))$"
    commit_regex="^(feat|bugfix|hotfix|merge|revert):(.+)$"
    if [[ ! "$PR_TITLE" =~ $branch_regex ]]; then
    # pr title doesn't follow convention
    error_message="### [Invalid PR title]\nPR title does not follow convention.\nAllowed regex is ${branch_regex}\n \
                    *Example* :\n \`feat/DEVX-00/pr title summary\`"
    error_report="{\"body\":\""${error_message//\"/\\\"}"\"}"
    curl -X POST \
        -H "Authorization: token $GH_TOKEN" \
        -H "Accept: application/vnd.github.html+json" \
        "https://api.github.com/repos/hevoio/hermes/issues/$CIRCLE_PR_NUMBER/comments" \
        -d "$error_report"
    fi
    if [[ ! "$CIRCLE_BRANCH" =~ $branch_regex ]]; then
    # invalid branch name
    error_message="### [Invalid Branch name]\nBranch name does not follow convention.\nAllowed regex is ${branch_regex}\n \
                    *Example* :\n \`feat/DEVX-00/short-branch-name\`"
    error_report="{\"body\":\""${error_message//\"/\\\"}"\"}"
    curl -X POST \
        -H "Authorization: token $GH_TOKEN" \
        -H "Accept: application/vnd.github.html+json" \
        "https://api.github.com/repos/hevoio/hermes/issues/$CIRCLE_PR_NUMBER/comments" \
        -d "$error_report"
    fi
fi