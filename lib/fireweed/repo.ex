defmodule Fireweed.Repo do
  use Ecto.Repo,
    otp_app: :fireweed,
    adapter: Ecto.Adapters.Postgres
end
