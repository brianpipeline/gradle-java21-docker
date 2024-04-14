#!/bin/bash

source send-message.sh
source utils.sh

buildAndPushImage() {
    local replyTopic=$1
    local gitRef=$2
    local projectId=$3
    local gradleProjectName
    gradleProjectName=$(getGradleProjectName)
    local gradleProjectVersion
    gradleProjectVersion=$(getGradleProjectVersion)
    local projectTag="$gradleProjectVersion"
    local hash
    hash=$(echo $RANDOM | md5sum | head -c 8)
    local jarFileName="$gradleProjectName-$gradleProjectVersion"
    if [[ $gitRef != "refs/heads/main" ]]; then
        projectTag="$projectTag-$hash"
    elif [[ $gitRef == *"release"* ]]; then
        projectTag=${projectTag%-SNAPSHOT}
    fi

    # Build
    if ! (docker build \
        -f /dockerfiles/Dockerfile \
        -t us-central1-docker.pkg.dev/"$projectId"/"$gradleProjectName"/"$gradleProjectName":"$projectTag" \
        --build-arg APP_NAME="$jarFileName" \
        .); then
        echo "Docker build failed."
        sendMessage "$replyTopic" "Pipeline failed."
        exit 1
    fi

    # Push
    if [[ $gitRef != "refs/heads/main" && $gitRef != *"release"* ]]; then
        echo "Not on main or release branch, so not going to push to image."
        exit 0
    fi

    if ! docker push us-central1-docker.pkg.dev/"$projectId"/"$gradleProjectName"/"$gradleProjectName":"$projectTag"; then
        echo "Docker push failed."
        sendMessage "$replyTopic" "Pipeline failed."
        exit 1
    fi

    echo "Docker image built and pushed."
}
