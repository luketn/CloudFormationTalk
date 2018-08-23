#!/usr/bin/env bash
# Show all events for CF stack until update completes or fails.
cf_tail() {
  local stack="$1"
  local current
  local final_line
  local output
  local previous
  until echo "$current" | egrep -q "${stack}.*_(COMPLETE|FAILED)" ; do
    if ! output=$(cf_events $stack); then
      return 1
    fi
    if [ -z "$output" ]; then sleep 1; continue; fi
    current=$(echo "$output" | sed '$d')
    final_line=$(echo "$output" | tail -1)
    if [ -z "$previous" ]; then
      echo "$current" | GREP_COLOR='1;32' egrep --color "\b(CREATE_COMPLETE)\b|$"
    elif [ "$current" != "$previous" ]; then
      comm -13 <(echo "$previous") <(echo "$current")
    fi
    previous="$current"
    sleep 1
  done
  echo $final_line
}

cf_events() {
  local stack="$1"
  shift
  local output

  if output=$(aws cloudformation describe-stack-events --stack-name $stack \
    --query 'sort_by(StackEvents, &Timestamp)[].{Resource: LogicalResourceId, Type: ResourceType, Status: ResourceStatus}' \
    --output table $@); then
    echo "$output" | uniq -u | awk -F\| '{ print $0 }' | tail -n +2 | grep -v 'DescribeStackEvents'
  else
    return $?
  fi
}

cf_outputs() {
  local stack="$1"
  aws cloudformation describe-stacks --stack-name $stack --query 'Stacks[].Outputs[]' --output table
}

cf_failure() {
  local stack="$1"
  aws cloudformation describe-stack-events --stack-name $stack \
    --query 'StackEvents[?contains(ResourceStatus,`FAILED`)].[LogicalResourceId, ResourceStatus, ResourceType, ResourceStatusReason]'
}

cf_status() {
  local stack="$1"
  aws cloudformation describe-stacks --stack-name "$stack" --query "Stacks[0].StackStatus" --output text
}

cf_tail $1
cf_outputs $1