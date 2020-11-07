defmodule FireweedWeb.UsersLive.Index do
  use FireweedWeb, :surface_live_view
  # alias FireweedWeb.Components
  alias Fireweed.Accounts
  alias Fireweed.Accounts.User
  alias FireweedWeb.UsersLive.Components.{List, EditUser}

  @withuser %{assigns: %{current_user: %{}}}

  prop current_user, :any, required: true
  prop admin_user, :boolean, required: true

  data user, :any
  data users, :list, default: []
  data changeset, :any

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    if connected?(socket), do: Accounts.subscribe()

    current_user = Fireweed.Accounts.get_user!(user_id)
    admin_user = FireweedWeb.Auth.is_admin?(current_user)
    users = list_users()
    {:ok,
     socket
     |> assign(
       current_user: current_user,
       admin_user: admin_user,
       user: nil,
       users: users
     )}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, push_redirect(socket, FireweedWeb.Router.Helpers.page_path(socket, :index))}
  end

  @impl true
  def handle_params(params, _uri, socket = @withuser) do
    {:noreply, socket |> apply_action(socket.assigns.live_action, params)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket = cleanup(socket)
    {:ok, push_redirect(socket, FireweedWeb.Router.Helpers.page_path(socket, :index))}
  end

  defp cleanup(%{assigns: %{user: %{id: id}}} = socket) do
    Accounts.unsubscribe(id)
    socket |> assign(user: nil)
  end

  defp cleanup(socket), do: socket

  defp apply_action(socket, :show, %{"id" => id}) do
    if connected?(socket), do: Accounts.subscribe(id)

    user = Accounts.get_user!(id)

    socket
    |> assign(:page_title, "Show User")
    |> assign(:user, user)
    |> assign(:changeset, Accounts.change_user(user))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    if connected?(socket), do: Accounts.subscribe(id)

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
  def handle_event("validate", %{"user" => %{ "password" => _ }}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    send(self(), {:save, user_params})

    changeset =
      socket.assigns.user
      |> Accounts.change_user(user_params)
      # |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
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
    assign(socket, users: list_users())
  end

  @impl true
  def handle_info({Accounts, [:user, _], user = %User{}}, socket) do
    user = (socket.assigns.user && user) || nil
    changeset = Accounts.change_user(user || %{})

    {:noreply, fetch(socket) |> assign(user: user, changeset: changeset)}
  end

  @impl true
  def handle_info({Accounts, [:user, _], _result}, socket) do
    {:noreply, fetch(socket)}
  end

  @impl true
  def handle_info({:save, user}, socket) do
     socket = case Accounts.update_user(socket.assigns.user, user) do
      {:error, changeset} -> socket |> assign(changeset: changeset)
      _ -> socket
     end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Navigation
      page={{:users}}
      current_user={{@current_user}}
      admin_user={{@admin_user}}
    />
    <section>
      <div class="flex-grow flex-shrink p-6">
        <h1 class="text-4xl mb    -4">Users</h1>
        <br />
        <List users={{@users}} />
      </div>
      <Cond visible={{@live_action == :show}}>
        <EditUser changeset={{@changeset}} />
      </Cond>
    </section>
    """
  end
end
