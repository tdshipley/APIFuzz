# API Fuzzer

A Ruby script to fuzz your API using [Big List of Naughty Strings](https://github.com/minimaxir/big-list-of-naughty-strings).

Given an example URL complete with query parameters the script will replace the query parameters in the string with each
of the strings in the Naughty List and report a JSON object with the results of each request.

Query parameters are sent unencoded so will cause illegal/malformed requests.

## Usage

```bash
API Fuzz
Fuzz your API with bad strings.

Control options:
    -t, --target PATH                Example Url to fuzz with params
```

Example usage:

```bash
ruby apifuzz.rb -t "https://example.com/api/v0/get-product?sku=foo&product=bar"
```
