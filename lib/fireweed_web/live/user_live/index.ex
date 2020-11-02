defmodule FireweedWeb.UserLive.Index do
  use FireweedWeb, :live_view

  alias Fireweed.Accounts
  alias Fireweed.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Fireweed.Accounts.subscribe()
    {:ok, assign(socket, :users, list_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, Accounts.get_user!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users")
    |> assign(:user, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)

    {:noreply, assign(socket, :users, list_users())}
  end

  defp list_users do
    Accounts.list_users()
  end

  defp fetch(socket) do
    users = list_users()
    assign(socket, users: users, page_title: "Listing Users")
  end

  @impl true
  def handle_info({Accounts, [:user, _], _}, socket) do
    {:noreply, fetch(socket)}
  end
end
