# Httpdigest

Implements HTTP digest authentication by returning an Authorization header given
a WWW-Authenticate header, username, password, and path. Currently only
implements the "auth" type not the "auth-int" digest type.

```
{:ok,
  %HTTPoison.Response{body: _,
  headers: headers, status_code: 401}} = HTTPoison.get(url)

authorization = Httpdigest.create_header(headers, "username", "password", path)
{:ok,
  %HTTPoison.Response{body: _,
  headers: _, status_code: 200}} = HTTPoison.get(url, authorization)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add httpdigest to your list of dependencies in `mix.exs`:

        def deps do
          [{:httpdigest, "~> 0.0.1"}]
        end

  2. Ensure httpdigest is started before your application:

        def application do
          [applications: [:httpdigest]]
        end
