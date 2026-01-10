#!/usr/bin/env bash

set -e

INVENTORY_FILE="inventory.ini"
REGION="ap-southeast-1"

if [[ ! -f "$INVENTORY_FILE" ]]; then
  echo "❌ inventory.ini not found"
  exit 1
fi

declare -A HOSTS
declare -a MENU

current_group=""

# Parse inventory.ini
while IFS= read -r line; do
  # Skip comments & empty lines
  [[ -z "$line" || "$line" =~ ^# ]] && continue

  # Detect group
  if [[ "$line" =~ ^\[(.*)\]$ ]]; then
    current_group="${BASH_REMATCH[1]}"
    continue
  fi

  # Parse host lines
  if [[ "$line" =~ ansible_host=([^[:space:]]+) ]]; then
    host_name=$(echo "$line" | awk '{print $1}')
    instance_id="${BASH_REMATCH[1]}"
    key="${current_group}:${host_name}"

    HOSTS["$key"]="$instance_id"
    MENU+=("$current_group - $host_name")
  fi
done < "$INVENTORY_FILE"

# Show menu
echo "======================================"
echo " Select a server to connect via SSM"
echo "======================================"

i=1
for item in "${MENU[@]}"; do
  echo "$i) $item"
  ((i++))
done
echo "q) Quit"
echo

read -rp "Enter choice: " choice

if [[ "$choice" =~ ^[Qq]$ ]]; then
  echo "Bye 👋"
  exit 0
fi

index=$((choice - 1))
if [[ "$index" -lt 0 || "$index" -ge "${#MENU[@]}" ]]; then
  echo "❌ Invalid choice"
  exit 1
fi

selected="${MENU[$index]}"
group="${selected%% - *}"
host="${selected##* - }"
instance_id="${HOSTS["$group:$host"]}"

echo
echo "Connecting to $host ($instance_id) ..."
echo

aws ssm start-session \
  --region "$REGION" \
  --target "$instance_id"
