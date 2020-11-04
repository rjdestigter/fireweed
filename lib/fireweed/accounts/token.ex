defmodule Fireweed.Accounts.Token do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Argon2

  schema "tokens" do
    field :token, :string
    field :user_id, :id
    belongs_to :users, Fireweed.Accounts.User, foreign_key: :user_id, references: :id, define_field: false

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :user_id])
    |> validate_required([:token, :user_id])
    |> unique_constraint([:token, :user_id])
    |> hash_login_token()
  end

  def generate_login_token do
    :crypto.strong_rand_bytes(40) |> Base.url_encode64()
  end

  defp hash_login_token(%{valid?: false} = changeset), do: changeset

  defp hash_login_token(%{changes: %{token: nil}} = changeset) do
    put_change(changeset, :token, nil)
  end

  defp hash_login_token(%{changes: %{token: token}} = changeset) do
    put_change(changeset, :token, Argon2.hashpwsalt(token))
  end

  defp hash_login_token(%{valid?: true} = cset), do: put_change(cset, :token, nil)
end
