#!/bin/bash

source send-message.sh
source utils.sh

createGradleArtifactRepository() {
    local replyTopic=$1
    local gitRef=$2
    local gradleProjectName

    if [[ $gitRef != "refs/heads/main" && $gitRef != *"release"* ]]; then
        echo "Not on main or release branch, skipping Artifact Registry creation."
        exit 0
    fi
    gradleProjectName=$(getGradleProjectName)

    if ! gcloud artifacts repositories describe "$gradleProjectName" --location=us-central1; then
        echo "Creating Artifact Registry $gradleProjectName."
        if ! gcloud artifacts repositories create "$gradleProjectName" --repository-format=docker --location=us-central1; then
            echo "Failed to create Artifact Registry $gradleProjectName."
            sendMessage "$replyTopic" "Pipeline failed."
            exit 1
        fi
    else
        echo "Artifact Registry $gradleProjectName already exists."
    fi

    echo "Artifact Registry created."
}
