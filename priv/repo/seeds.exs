# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fireweed.Repo.insert!(%Fireweed.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Fireweed.Accounts

Accounts.create_user(%{
  email: "johndestigter2@gmail.com",
  name: "John de Stigter",
  is_verified: true,
  password: "foobar",
  password_confirmation: "foobar"
})
