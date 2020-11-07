defmodule FireweedWeb.MapLive.Index do
  use FireweedWeb, :surface_live_view

  prop current_user, :any, required: true
  prop admin_user, :boolean, required: true

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
    ~H"""
       <Navigation
        page={{:map}}
        current_user={{@current_user}}
        admin_user={{@admin_user}}
      />
      <UnderConstruction page="Map" />
    """
  end
end
