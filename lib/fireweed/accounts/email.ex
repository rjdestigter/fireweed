defmodule Fireweed.Accounts.Email do
  # The contents of this module will depend on which mailing service and library you choose

  @doc """
  Returns a list of users banned from using App
  """
  def banned() do
    ~w{
      notorious_spammer@example.com
      rabid_troll@example.com
      nefarious_user@example.com
    }
  end
end
