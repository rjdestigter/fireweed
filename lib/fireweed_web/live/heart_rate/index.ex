defmodule FireweedWeb.HeartRateLive.Index do
  use FireweedWeb, :live_view
  alias FireweedWeb.Components

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    current_user = Fireweed.Accounts.get_user!(user_id)
    admin_user = FireweedWeb.Auth.is_admin?(current_user)

    {:ok,
     socket
     |> assign(current_user: current_user, admin_user: admin_user)}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(current_user: nil, admin_user: nil)}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <%= live_component(@socket, Components.Navigation, id: :navigation, page: :heartrate, current_user: @current_user, admin_user: @admin_user)%>
      <%= live_component(@socket, Components.UnderConstruction, page: "Heart Rate")%>
    """
  end
end
