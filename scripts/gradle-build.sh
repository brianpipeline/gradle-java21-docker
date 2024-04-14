#!/bin/bash

source send-message.sh

gradleBuild() {
    local replyTopic=$1
    if ! gradle build; then
        echo "Gradle build failed."
        sendMessage "$replyTopic" "Pipeline failed."
        exit 1
    fi
    echo "Gradle build succeeded."
}
