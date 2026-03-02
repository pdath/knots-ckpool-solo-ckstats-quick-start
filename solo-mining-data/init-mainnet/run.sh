generate_password() {
  local password_file=$1
  
  echo "Creating $password_file"
  tr -dc A-Za-z0-9 </dev/urandom | head -c 32 > "$password_file"
}

# Update ckpool.conf with the RPC password
update_ckpool() {
  echo "Updating ckpool.conf with new RPC password"
  python3 -c '
  import json, sys
  with open("/ckpool.conf", "r") as f:
    data = json.load(f)
  data["btcd"][0]["pass"] = sys.argv[1].strip()
  with open("/ckpool.conf", "w") as f:
    json.dump(data, f, indent=4)
  ' "$(cat /secrets/.rpc_mainnet_password)"
}

# Generate passwords
if [ ! -f "/secrets/.postgres_mainnet_password" ]; then
  generate_password "/secrets/.postgres_mainnet_password"
fi

if [ ! -f "/secrets/.rpc_mainnet_password" ] || [ ! -f "/secrets/.rpcauth_mainnet" ]; then
  generate_password "/secrets/.rpc_mainnet_password"
  update_ckpool

  # Generate rpcauth
  echo "Creating /secrets/.rpcauth_mainnet"
  python3 -c 'from urllib.request import urlretrieve; urlretrieve("https://raw.githubusercontent.com/bitcoinknots/bitcoin/master/share/rpcauth/rpcauth.py", "rpcauth.py")'
  python3 rpcauth.py rpcadmin $(cat /secrets/.rpc_mainnet_password) --output /secrets/.rpcauth_mainnet >/dev/null

  # Update bitcoin.conf with the new rpcauth line
  echo "Updating bitcoin.conf with new RPC password"
  sed "s|^rpcauth=.*|rpcauth=$(cat /secrets/.rpcauth_mainnet)|" /bitcoin.conf > /tmp/bitcoin.conf
  cp /tmp/bitcoin.conf /bitcoin.conf
  rm /tmp/bitcoin.conf
fi