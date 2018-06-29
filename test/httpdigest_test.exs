defmodule HttpdigestTest do
  use ExUnit.Case
  doctest Httpdigest

  test "add_opaque(response, [nil, \"\"])" do
    res =
      Httpdigest.create_response("iZZZZZZ", "test", "GET", "/", %{
        "realm" => "API",
        "nonce" => "MTUzMDI2OTExOTo1ZmYwODVlNzY0MTM5OWVmZWI3M2NiZmNkZTdmYzQ5YQ==",
        "qop" => "auth"
      })

    # Shouldn't have an opaque field
    assert not String.contains?(res, "opaque")
  end

  test "add_opaque(response, \"b816d4d26130bed8ccf5149e855000ad\")" do
    res =
      Httpdigest.create_response("iZZZZZZ", "test", "GET", "/", %{
        "realm" => "API",
        "nonce" => "MTUzMDI2OTExOTo1ZmYwODVlNzY0MTM5OWVmZWI3M2NiZmNkZTdmYzQ5YQ==",
        "qop" => "auth",
        "opaque" => "b816d4d26130bed8ccf5149e855000ad"
      })

    # Should have an opaque field
    assert String.contains?(res, "opaque")
  end
end
