#!/usr/bin/env bash

# set -x  # Un-comment to debug this script

#TF_LOG=DEBUG; TF_LOG_PATH=~tf.log  # Un-comment to debug terraform

if [ -z "${BASH_VERSINFO[*]}" ] || [ -z "${BASH_VERSINFO[0]}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
  echo "This script requires Bash version >= 4"
  exit 1
fi

programname=$0
SCRIPT_REL_DIR=$(dirname "${0}")
ROOT=$(realpath "$SCRIPT_REL_DIR/../")
cd "$ROOT" || exit

TERRAFORM_OPTS=()

# echo 'pull latest code ...'
# git pull origin master

usage() {
  echo "usage: $programname [-e environment] [-o operation]"
  echo "MANDATORY:"
  echo "  -e, --environment   VAL  specify environment [global sandbox staging production management ops new_sandbox]"
  echo "  -o, --operation     VAL  specify operation [plan print_output apply]"
  echo "OPTIONAL:"
  echo "  -a, --auto-approve       TERRAFORM_OPTS: auto-approve on apply"
  exit 1
}

parse_params() {
  while [ ! $# -eq 0 ]; do
    case "$1" in
      --help | -h)
        usage
        exit
        ;;
      --environment | -e)
        ENV=$2
        if [[ $ENV != "global" && $ENV != "sandbox" && $ENV != "staging" && $ENV != "production" && $ENV != "management" && $ENV != "ops" && $ENV != "new_sandbox" ]]; then
          echo "Wrong environment: $ENV. Valid options: global sandbox staging production management ops"
          exit 1
        fi
        ;;
      --operation | -o)
        OPER=$2
        if [[ $OPER != "plan" && $OPER != "print_output" && $OPER != "apply" ]]; then
          echo "Wrong operation: $OPER. Valid options: plan print_output apply"
          exit 1
        fi
        ;;
      --auto-approve | -a)
        if [[ $OPER == "apply" ]]; then
          TERRAFORM_OPTS+=('-auto-approve')
        fi
        ;;
    esac
    shift
  done
}

print_params() {
  echo "-------------------------------"
  echo "ENV          : $ENV"
  echo "OPER         : $OPER"
  echo "-------------------------------"
}

select_environment() {
  ENVS=("global" "sandbox" "staging" "production" "management" "ops")
  echo "Select environment:"
  select var in "${ENVS[@]}"; do
    ENV=$var
    break
  done
}

select_oper() {
  OPERS=("apply" "plan" "print_output")
  echo "Select operation:"
  select oper in "${OPERS[@]}"; do
    OPER=$oper
    break
  done
}

release_notes() {
  RELEASE="RELEASES.md"
  if ! grep -q "$PROJECT" $RELEASE; then
    echo "#$PROJECT" >>$RELEASE
  fi
  DATE=$(date +%Y-%m-%d)
  sed -i "/$PROJECT/a * **$DATE** - $DESCRIPTION" $RELEASE
}

get_output_var() {
  terraform output -json | jq -r ".$1.value"
}

# Display output
display_output() {
  terraform output
}

do_project() {
  # cd to env folder
  cd "environments/$ENV" || exit

  # Deploy architecture
  if [[ $OPER == "print_output" ]]; then
    display_output
  else
    echo "Performing $OPER"
    terraform "$OPER" "${TERRAFORM_OPTS[@]}" || exit 1
  fi
}

update_shared_json() {
  if [[ $ENV == "global" ]]; then
    echo "[Skipping] Uploading shared.json to S3 - global env does not expose shared.json"
  elif [[ $OPER != "apply" ]]; then
    echo "[Skipping] Uploading shared.json to S3 - terraform outputs are updated only on apply"
  else
    echo 'Uploading shared.json to S3 ...'

    output=$(terraform output -json)
    echo "$output" >shared.json

    aws s3 cp shared.json "s3://lambda-$ENV.spire.io/shared.json"
  fi
}

# execution sequence:
[[ $# -eq 0 ]] && usage
parse_params "$@"
print_params
# select_project
# select_environment
# select_oper
do_project
update_shared_json

echo ''
echo 'done.'
