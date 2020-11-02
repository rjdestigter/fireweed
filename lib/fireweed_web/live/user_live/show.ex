defmodule FireweedWeb.UserLive.Show do
  use FireweedWeb, :live_view

  alias Fireweed.Accounts
  alias FireweedWeb.{UserLive, UserView}
  alias FireweedWeb.Router.Helpers, as: Routes
  alias Phoenix.LiveView.Socket

  def mount(_params, %{"user_id" => user_id}, socket) do
    current_user = Accounts.get_user!(user_id)
    admin_user = FireweedWeb.Auth.is_admin?(current_user)

    {:ok,
     socket
     |> assign(current_user: current_user, admin_user: admin_user)
     |> assign(:page_title, page_title(socket.assigns.live_action))}
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(current_user: nil, admin_user: nil)
     |> assign(:page_title, page_title(socket.assigns.live_action))}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    if connected?(socket), do: Accounts.subscribe(id)
    {:noreply, socket |> assign(id: id) |> fetch()}
  end

  def fetch(%Socket{assigns: %{id: id}} = socket) do
    assign(socket, user: Accounts.get_user!(id))
  end

  def handle_info({Accounts, [:user, :updated], _}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_info({Accounts, [:user, :deleted], _}, socket) do
    {:noreply,
     socket
     # |> put_flash(:error, "This user has been deleted.")
     |> push_redirect(to: Routes.live_path(socket, UserLive.Index))}
  end

  defp page_title(:show), do: "Show User"
  defp page_title(:edit), do: "Edit User"
end
