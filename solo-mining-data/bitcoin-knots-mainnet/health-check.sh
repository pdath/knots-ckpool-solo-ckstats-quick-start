#!/bin/sh

# Get blockchain info
INFO=$(bitcoin-cli getblockchaininfo)

# Check 1: initialblockdownload must be false
if ! echo "$INFO" | grep -q '"initialblockdownload": false'; then
  exit 1
fi

# Check 2: blocks must equal headers (fully synced)
BLOCKS=$(echo "$INFO" | sed -n 's/.*"blocks": \([0-9]*\).*/\1/p')
HEADERS=$(echo "$INFO" | sed -n 's/.*"headers": \([0-9]*\).*/\1/p')

if [ "$BLOCKS" != "$HEADERS" ]; then
  exit 1
fi

exit 0
