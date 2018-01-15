# BitcoinRpc

Simple Crystal library for [Bitcoin's RPC API](https://en.bitcoin.it/wiki/Original_Bitcoin_client/API_calls_list).

All calls get proxied by a `method_missing` macro, so they have exactly the same names and arguments as specified in the official documentation.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  bitcoin_rpc:
    github: citizen428/bitcoin_rpc
```

## Usage

Usage is very simple:

```crystal
require "bitcoin_rpc"

# Testnet example
rpc = BitcoinRpc.new("http://localhost:18332", "username", "password")

rpc.getblockhash(0)
# or
rpc.get_block_hash(0)
#=> "000000000933ea01ad0ee984209779baaec3ced90fa3f408719526f8d77f4943"

rpc.getblockcount
#or 
rpc.get_block_count
#=> 486259

rpc.listaccounts
# or
rpc.list_accounts
#=> {"" => 0.0}
```

## Releases

# v2.0.0
- BitcoinRpc is finally thread safe (was unaware that client.post wasn't concurrrent)

## Contributing

1. Fork it ( https://github.com/citizen428/bitcoin_rpc/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [citizen428](https://github.com/citizen428) Michael Kohl - creator, maintainer
