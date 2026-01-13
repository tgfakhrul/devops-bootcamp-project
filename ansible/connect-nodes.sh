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
  # Trim whitespace
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"

  # Skip comments & empty lines
  [[ -z "$line" || "$line" =~ ^# ]] && continue

  # Detect group headers
  if [[ "$line" =~ ^\[(.+)\]$ ]]; then
    current_group="${BASH_REMATCH[1]}"
    continue
  fi

  # Only parse real host definitions (with ec2_id)
  if [[ "$line" =~ ec2_id=([^[:space:]]+) ]]; then
    host_name=$(awk '{print $1}' <<< "$line")
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

if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
  echo "❌ Invalid choice"
  exit 1
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

if [[ -z "$instance_id" ]]; then
  echo "❌ Could not resolve instance ID"
  exit 1
fi

echo
echo "Connecting to $host ($instance_id) ..."
echo

aws ssm start-session \
  --region "$REGION" \
  --target "$instance_id"
