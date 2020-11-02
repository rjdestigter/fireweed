defmodule FireweedWeb.Token do
  @namespace "user salt"

  def sign(data) do
    Phoenix.Token.sign(FireweedWeb.Endpoint, @namespace, data)
  end

  def verify(token) do
    Phoenix.Token.verify(
      FireweedWeb.Endpoint,
      @namespace,
      token,
      max_age: 365 * 24 * 3600
    )
  end
end
