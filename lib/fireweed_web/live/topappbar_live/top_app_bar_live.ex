defmodule FireweedWeb.TopAppBarLive do
  use FireweedWeb, :live_view
  alias Fireweed.Accounts

  @impl true
  def mount(_params, %{"user_id" => user_id, "page_title" => page_title}, socket) do
    current_user = Accounts.get_user!(user_id)
    admin_user = FireweedWeb.Auth.is_admin?(current_user)

    {:ok, socket |> assign(current_user: current_user, admin_user: admin_user, page_title: page_title)}
  end

  def mount(_params, %{"page_title" => page_title}, socket) do
    {:ok, socket |> assign(page_title: page_title)}
  end
end
