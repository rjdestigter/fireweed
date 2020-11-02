defmodule Fireweed.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :token, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:tokens, [:token])
    create index(:tokens, [:user_id])
  end
end
