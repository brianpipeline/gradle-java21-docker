#!/usr/bin/env bats

load $(pwd)/send-message.sh
load $(pwd)/build-and-push-image.sh
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

@test "buildAndPushImage should build image on feature branches but not push." {
    stub docker "exit 0"
    stub grep "echo test-repo"
    # Run your function
    run buildAndPushImage "replyTopic" "refs/heads/featureBranch" "projectId"
    # Check if it succeeds
    [ "$status" -eq 0 ]
    [[ "$output" == *"Not on main or release branch, so not going to push to image."* ]]
}

@test "buildAndPushImage should build and push image on main." {
    stub docker "exit 0"
    stub grep "echo test-repo"
    # Run your function
    run buildAndPushImage "replyTopic" "refs/heads/main" "projectId"
    # Check if it succeeds
    [ "$status" -eq 0 ]
    [[ "$output" == *"Docker image built and pushed."* ]]
}