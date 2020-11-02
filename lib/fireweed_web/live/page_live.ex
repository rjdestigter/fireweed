defmodule FireweedWeb.PageLive do
  use FireweedWeb, :live_view

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    current_user = Fireweed.Accounts.get_user!(user_id)
    admin_user = FireweedWeb.Auth.is_admin?(current_user)

    {:ok,
     socket
     |> assign(current_user: current_user, admin_user: admin_user)
     |> set_initial_state()}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(current_user: nil, admin_user: nil)
     |> set_initial_state()}
  end

  defp set_initial_state(socket) do
    socket |> assign(page: :index, nutrition: %{})
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Home")
  end

  defp apply_action(socket, action, params) when action in [:nutrition, :nutrition_detail] do
    FireweedWeb.Nutrition.Index.apply_action(socket, action, params) |> assign(page: :nutrition)
  end

  @impl true
  def handle_info(message, socket) do
    case elem(message, 0) do
      :nutrition -> FireweedWeb.Nutrition.Index.handle_info(message, socket)
      _ -> {:noreply, socket}
    end
  end
end
