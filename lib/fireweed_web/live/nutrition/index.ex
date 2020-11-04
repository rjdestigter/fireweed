defmodule FireweedWeb.NutritionLive.Index do
  @withuser %{assigns: %{current_user: %{}}}

  use FireweedWeb, :live_view
  alias FireweedWeb.Components

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    current_user = Fireweed.Accounts.get_user!(user_id)
    admin_user = FireweedWeb.Auth.is_admin?(current_user)

    {:ok,
     socket
     |> assign(
       current_user: current_user,
       admin_user: admin_user,
       query: "",
       foods: [],
       food: nil,
       food_id: nil
     )}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, FireweedWeb.Router.Helpers.page_path(socket, :index)}
  end

  @impl true
  def handle_params(params, _uri, socket = @withuser) do
    {:noreply, socket |> apply_action(socket.assigns.live_action, params)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:ok, socket |> FireweedWeb.Router.Helpers.page_path(:index)}
  end

  def apply_action(socket, :index, _params) do
    socket |> assign(page_title: "Nutrition")
  end

  def apply_action(socket, :show, %{"food_id" => food_id}) do
    send(self(), {:fetch, food_id})
    socket |> assign(page_title: "Nutrition: #{food_id}")
  end

  def apply_action(socket, _action, _params) do
    socket
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    send(self(), {:search, query})

    {:noreply, socket |> assign(query: query)}
  end

  @impl true
  def handle_event("show", %{"id" => id}, socket) do
    {:noreply, push_patch(socket, to: FireweedWeb.Router.Helpers.nutrition_index_path(:show, id))}
  end

  @impl true
  def handle_info({:search, query}, socket) do
    foods =
      case FatSecret.search(query) do
        {:ok, {:ok, %{"foods" => %{"food" => food}}}} ->
          food

        _ ->
          []
      end

    {:noreply, socket |> assign(:foods, foods)}
  end

  def handle_info({:fetch, food_id}, socket) do
    socket =
      case FatSecret.food_get_v2(food_id) do
        {:ok, {:ok, %{"food" => food}}} ->
          socket
          |> assign(
            page_title: "Nutrition - #{food["food_name"]}",
            food: food
          )

        error ->
          socket |> assign(error: error)
      end

    {:noreply, socket}
  end
end
