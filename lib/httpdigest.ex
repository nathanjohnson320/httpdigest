defmodule Httpdigest do
  def get_header(headers, key) do
    headers
    |> Enum.filter(fn {k, _} -> String.downcase(k) == String.downcase(key) end)
    |> hd()
    |> elem(1)
  end

  def parse_auth(auth) do
    String.replace(auth, "Digest ", "")
    |> String.split(",")
    |> Enum.reduce(%{}, fn string, acc ->
      parse_map = Regex.named_captures(~r/\s*(?<key>.+?)\s*=\s*"(?<val>.+)"/, string)
      item = %{parse_map["key"] => parse_map["val"]}
      Map.merge(acc, item)
    end)
  end

  def create_response(username, password, method \\ "GET", path, auth) do
    ha1 = md5(username <> ":" <> auth["realm"] <> ":" <> password)
    ha2 = md5("#{method}:#{path}")
    client_nonce = cnonce()
    nc = "00000001"
    response = md5("#{ha1}:#{auth["nonce"]}:#{nc}:#{client_nonce}:#{auth["qop"]}:#{ha2}")

    result =
      Map.to_list(%{
        "username" => username,
        "realm" => auth["realm"],
        "nonce" => auth["nonce"],
        "uri" => path,
        "qop" => auth["qop"],
        "nc" => nc,
        "cnonce" => client_nonce,
        "response" => response
      })
      |> add_opaque(auth["opaque"])
      |> Enum.reduce([], fn {key, val}, acc ->
        case key do
          "nc" -> acc ++ ["#{key}=#{val}"]
          _ -> acc ++ ["#{key}=\"#{val}\""]
        end
      end)
      |> Enum.join(",")

    "Digest #{result}"
  end

  defp cnonce() do
    :crypto.strong_rand_bytes(4)
    |> Base.encode16(case: :lower)
  end

  def md5(data) do
    Base.encode16(:erlang.md5(data), case: :lower)
  end

  def create_header(headers, username, password, method \\ "GET", path) do
    auth = Httpdigest.get_header(headers, "WWW-Authenticate")
    parsed_auth = Httpdigest.parse_auth(auth)
    response = Httpdigest.create_response(username, password, method, path, parsed_auth)
    %{"Authorization" => response}
  end

  defp add_opaque(response, opaque) when opaque in [nil, ""], do: response

  defp add_opaque(response, opaque) do
    response ++ [{"opaque", opaque}]
  end
end
