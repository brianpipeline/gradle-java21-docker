#!/usr/bin/env bats

load $(pwd)/utils.sh
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

@test "getGradleProjectName should successfully return a project name." {
    # Stub gcloud builds submit command to return success
    stub grep "echo name"
    # Run your function
    run getGradleProjectName
    # Check if it succeeds
    [ "$status" -eq 0 ]
    [ "$output" = "name" ]
}

@test "getGradleProjectName should exit 1 when it can't find a project name." {
    # Stub gcloud builds submit command to return success
    stub grep "exit 0"
    # Run your function
    run getGradleProjectName
    # Check if it succeeds
    [ "$status" -eq 1 ]
    [ "$output" = "Failed to find project name from settings.gradle." ]
}

@test "getGradleProjectVersion should successfully return a project version." {
    # Stub gcloud builds submit command to return success
    stub grep "echo version"
    # Run your function
    run getGradleProjectVersion
    # Check if it succeeds
    [ "$status" -eq 0 ]
    [ "$output" = "version" ]
}

@test "getGradleProjectVersion should exit 1 when it can't find a project version." {
    # Stub gcloud builds submit command to return success
    stub grep "exit 0"
    # Run your function
    run getGradleProjectVersion
    # Check if it succeeds
    [ "$status" -eq 1 ]
    [ "$output" = "Failed to find project version from build.gradle." ]
}

