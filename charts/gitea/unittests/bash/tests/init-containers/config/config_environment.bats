#!/usr/bin/env bats

function setup() {
  PROJECT_ROOT="$(git rev-parse --show-toplevel)"
  TEST_ROOT="$PROJECT_ROOT/unittests/bash"
  load "$TEST_ROOT/test_helper/common-setup"
  common_setup

  export GITEA_APP_INI="$BATS_TEST_TMPDIR/app.ini"
  export TMP_EXISTING_ENVS_FILE="$BATS_TEST_TMPDIR/existing-envs"
  export ENV_TO_INI_MOUNT_POINT="$BATS_TEST_TMPDIR/env-to-ini-mounts"
  export GITEA_EDIT_INI_EXPECTED=0
  export PATH="$BATS_TEST_TMPDIR/bin:$PATH"

  mkdir -p "$BATS_TEST_TMPDIR/bin"
  cat >"$BATS_TEST_TMPDIR/bin/gitea" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

case "$*" in
  'generate secret INTERNAL_TOKEN')
    echo 'mocked-internal-token'
    ;;
  'generate secret SECRET_KEY')
    echo 'mocked-secret-key'
    ;;
  'generate secret JWT_SECRET')
    echo 'mocked-jwt-secret'
    ;;
  'generate secret LFS_JWT_SECRET')
    echo 'mocked-lfs-jwt-secret'
    ;;
  "config edit-ini --apply-env --config $GITEA_APP_INI --out $GITEA_APP_INI")
    if [ "$GITEA_EDIT_INI_EXPECTED" -eq 1 ]; then
      echo 'Stubbed gitea config edit-ini was called!'
      exit 0
    fi

    echo 'Unexpected gitea config edit-ini invocation' >&2
    exit 127
    ;;
  *)
    echo "Unexpected gitea invocation: $*" >&2
    exit 127
    ;;
esac
EOF
  chmod +x "$BATS_TEST_TMPDIR/bin/gitea"
}

function teardown() {
  :
}

function expect_gitea_config_edit_ini_call() {
  export GITEA_EDIT_INI_EXPECTED=1
}

function execute_test_script() {
  currentEnvsBefore=$(env | sort)
  source $PROJECT_ROOT/scripts/init-containers/config/config_environment.sh
  local exitCode=$?
  currentEnvsAfter=$(env | sort)

  # diff as unified +/- output without context before/after
  diff --unified=0 <(echo "$currentEnvsBefore") <(echo "$currentEnvsAfter")

  exit $exitCode
}

function write_mounted_file() {
  # either "inlines" or "additionals"
  scope="${1}"
  file="${2}"
  content="${3}"

  mkdir -p "$ENV_TO_INI_MOUNT_POINT/$scope/..data/"
  echo "${content}" > "$ENV_TO_INI_MOUNT_POINT/$scope/..data/$file"
  ln -sf "$ENV_TO_INI_MOUNT_POINT/$scope/..data/$file" "$ENV_TO_INI_MOUNT_POINT/$scope/$file"
}

@test "works as expected when nothing is configured" {
  expect_gitea_config_edit_ini_call
  run $PROJECT_ROOT/scripts/init-containers/config/config_environment.sh

  assert_success
  assert_line '...Initial secrets generated'
  assert_line 'Reloading preset envs...'
  assert_line '=== All configuration sources loaded ==='
  assert_line 'Stubbed gitea config edit-ini was called!'
}

@test "exports initial secrets" {
  expect_gitea_config_edit_ini_call
  run execute_test_script

  assert_success
  assert_line '+GITEA__OAUTH2__JWT_SECRET=mocked-jwt-secret'
  assert_line '+GITEA__SECURITY__INTERNAL_TOKEN=mocked-internal-token'
  assert_line '+GITEA__SECURITY__SECRET_KEY=mocked-secret-key'
  assert_line '+GITEA__SERVER__LFS_JWT_SECRET=mocked-lfs-jwt-secret'
}

@test "does NOT export initial secrets when app.ini already exists" {
  expect_gitea_config_edit_ini_call
  touch $GITEA_APP_INI

  run execute_test_script

  assert_success
  assert_line --partial 'An app.ini file already exists.'
  refute_line '+GITEA__OAUTH2__JWT_SECRET=mocked-jwt-secret'
  refute_line '+GITEA__SECURITY__INTERNAL_TOKEN=mocked-internal-token'
  refute_line '+GITEA__SECURITY__SECRET_KEY=mocked-secret-key'
  refute_line '+GITEA__SERVER__LFS_JWT_SECRET=mocked-lfs-jwt-secret'
}

@test "ensures that preset environment variables take precedence over auto-generated ones" {
  expect_gitea_config_edit_ini_call
  export GITEA__OAUTH2__JWT_SECRET="pre-defined-jwt-secret"

  run execute_test_script

  assert_success
  refute_line '+GITEA__OAUTH2__JWT_SECRET=mocked-jwt-secret'
}

@test "ensures that preset environment variables take precedence over mounted ones" {
  expect_gitea_config_edit_ini_call
  export GITEA__OAUTH2__JWT_SECRET="pre-defined-jwt-secret"
  write_mounted_file "inlines" "oauth2" "$(cat << EOF
JWT_SECRET=inline-jwt-secret
EOF
)"

  run execute_test_script

  assert_success
  refute_line '+GITEA__OAUTH2__JWT_SECRET=mocked-jwt-secret'
  refute_line '+GITEA__OAUTH2__JWT_SECRET=inline-jwt-secret'
}

@test "ensures that additionals take precedence over inlines" {
  expect_gitea_config_edit_ini_call
  write_mounted_file "inlines" "oauth2" "$(cat << EOF
JWT_SECRET=inline-jwt-secret
EOF
)"
  write_mounted_file "additionals" "oauth2" "$(cat << EOF
JWT_SECRET=additional-jwt-secret
EOF
)"

  run execute_test_script

  assert_success
  refute_line '+GITEA__OAUTH2__JWT_SECRET=mocked-jwt-secret'
  refute_line '+GITEA__OAUTH2__JWT_SECRET=inline-jwt-secret'
  assert_line '+GITEA__OAUTH2__JWT_SECRET=additional-jwt-secret'
}

@test "ensures that dotted/dashed sections are properly masked" {
  expect_gitea_config_edit_ini_call
  write_mounted_file "inlines" "repository.pull-request" "$(cat << EOF
WORK_IN_PROGRESS_PREFIXES=WIP:,[WIP]
EOF
)"

  run execute_test_script

  assert_success
  assert_line '+GITEA__REPOSITORY_0X2E_PULL_0X2D_REQUEST__WORK_IN_PROGRESS_PREFIXES=WIP:,[WIP]'
}

###############################################################
##### THIS IS A BUG, BUT I WANT IT TO BE COVERED BY TESTS #####
###############################################################
@test "ensures uppercase section and setting names (🐞)" {
  expect_gitea_config_edit_ini_call
  export GITEA__oauth2__JwT_Secret="pre-defined-jwt-secret"
  write_mounted_file "inlines" "repository.pull-request" "$(cat << EOF
WORK_IN_progress_PREFIXES=WIP:,[WIP]
EOF
)"

  run execute_test_script

  assert_success
  assert_line '+GITEA__REPOSITORY_0X2E_PULL_0X2D_REQUEST__WORK_IN_PROGRESS_PREFIXES=WIP:,[WIP]'
  assert_line '+GITEA__OAUTH2__JWT_SECRET=pre-defined-jwt-secret'
}

@test "treats top-level configuration as section-less" {
  expect_gitea_config_edit_ini_call
  write_mounted_file "inlines" "_generals_" "$(cat << EOF
APP_NAME=Hello top-level configuration
RUN_MODE=dev
EOF
)"

  run execute_test_script

  assert_success
  assert_line '+GITEA____APP_NAME=Hello top-level configuration'
  assert_line '+GITEA____RUN_MODE=dev'
}

@test "fails on invalid setting" {
  write_mounted_file "inlines" "_generals_" "$(cat << EOF
some random invalid string
EOF
)"

  run execute_test_script

  assert_failure
}

@test "treats empty setting name as invalid setting" {
  write_mounted_file "inlines" "_generals_" "$(cat << EOF
=value
EOF
)"

  run execute_test_script

  assert_failure
}
