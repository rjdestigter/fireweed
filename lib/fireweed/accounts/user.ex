defmodule Fireweed.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Argon2

  schema "users" do
    field :email, :string
    field :is_verified, :boolean, default: false
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    has_many :tokens, Fireweed.Accounts.Token

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :is_verified])
    |> validate_required([:name, :email], message: "This field is required.")
    |> validate_format(:email, ~r/@/, message: "Please provide a valid email address.")
    |> validate_format(:email, ~r/^[^\s]+$/, message: "Please provide a valid email address.")
    |> unique_constraint(:email, message: "Not available")
  end

  def registration_changeset(struct, attrs \\ %{}) do
    struct
    |> changeset(attrs)
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> hash_password()
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset

  defp hash_password(%{valid?: true, changes: %{password: pass}} = changeset) do
    put_change(changeset, :password_hash, Argon2.hashpwsalt(pass))
  end
end
