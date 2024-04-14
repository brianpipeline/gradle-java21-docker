#!/usr/bin/env bats

load $(pwd)/send-message.sh
load $(pwd)/create-gradle-artifact-repository.sh
BATS_TEST_DIRNAME=$(pwd)
export PATH="$BATS_TEST_DIRNAME/stub:$PATH"

stub() {
    if [ ! -d $BATS_TEST_DIRNAME/stub ]; then
        mkdir $BATS_TEST_DIRNAME/stub
    fi
    echo $2 >$BATS_TEST_DIRNAME/stub/$1
    chmod +x $BATS_TEST_DIRNAME/stub/$1
}

rm_stubs() {
    rm -rf $BATS_TEST_DIRNAME/stub
}

teardown() {
    rm_stubs
}

@test "createGradleArtifactRepository should try to create artifact registry." {
    # Stub gcloud builds submit command to return success
    stub gcloud "exit 0"
    stub grep "echo test-repo"
    # Run your function
    run createGradleArtifactRepository "replyTopic" "refs/heads/main"
    # Check if it succeeds
    [ "$status" -eq 0 ]
    [[ "$output" == *"Artifact Registry test-repo already exists."* ]]
}

@test "createGradleArtifactRepository should try to create artifact registry and print on failure." {
    # Stub gcloud builds submit command to return success
    stub gcloud "exit 1"
    stub grep "echo test-repo"
    # Run your function
    run createGradleArtifactRepository "replyTopic" "refs/heads/main"
    # Check if it succeeds
    [ "$status" -eq 1 ]
    echo $output
    [[ "$output" =~ "Creating Artifact Registry test-repo." ]]
    [[ "$output" =~ "Failed to create Artifact Registry test-repo." ]]
}

@test "createGradleArtifactRepository should not create artifact registry when on feature branch" {
    # Stub gcloud builds submit command to return success
    stub gcloud "exit 1"
    stub grep "echo test-repo"
    # Run your function
    run createGradleArtifactRepository "replyTopic" "refs/heads/whatever"
    # Check if it succeeds
    [ "$status" -eq 0 ]
    [[ "$output" == *"Not on main or release branch, skipping Artifact Registry creation."* ]]
}
