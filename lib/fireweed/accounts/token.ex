defmodule Fireweed.Accounts.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :token, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :user_id])
    |> validate_required([:token, :user_id])
    |> unique_constraint(:token, :user_id)
  end

  defp generate_login_token do
    :crypto.strong_rand_bytes(40) |> Base.url_encode64()
  end
end
