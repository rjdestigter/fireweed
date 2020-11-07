defmodule FireweedWeb.PageLive do
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
        page={{:home}}
        current_user={{@current_user}}
        admin_user={{@admin_user}}
      />
      <section>
        <div class="flex-grow flex items-center justify-center">
          <Logo />
          <br />
          <h1>Welcome</h1>
        </div>
      </section>
    """
  end
end
