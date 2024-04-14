#!/bin/bash

getGradleProjectName() {
    local name
    name=$(grep -Po "rootProject.name\s*=\s*['\"]\K[^'\"]+" settings.gradle)
    if [[ -z "$name" ]]; then
        echo "Failed to find project name from settings.gradle."
        exit 1
    fi
    echo "$name"
}

getGradleProjectVersion() {
    local version
    version=$(grep -Po "version\s*=\s*['\"]\K[^'\"]+" build.gradle)
    if [[ -z "$version" ]]; then
        echo "Failed to find project version from build.gradle."
        exit 1
    fi
    echo "$version"
}
