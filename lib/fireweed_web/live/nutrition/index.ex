defmodule FireweedWeb.Nutrition.Index do
  use FireweedWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(
       nutrition: %{
         foods: [],
         food_id: nil,
         food: nil,
         query: ""
       }
     )}
  end

  def apply_action(socket, action, params) do
    case {action, params} do
      {:nutrition_detail, %{"food_id" => food_id}} ->
        send(self(), {:nutrition, :fetch, food_id})
        socket |> assign(nutrition: Map.put(socket.assigns.nutrition, :food_id, food_id))

      _ ->
        socket
    end
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    send(self(), {:nutrition, :search, query})

    {:noreply, socket |> assign(nutrition: Map.put(socket.assigns.nutrition, :query, query))}
  end

  @impl true
  def handle_event("select-food", %{"id" => id}, socket) do
    {:noreply, push_patch(socket, to: "/nutrition/#{id}")}
  end

  def handle_info({:nutrition, :search, term}, socket) do
    Fireweed.log("message", term)

    foods =
      case FatSecret.search(term) do
        {:ok, {:ok, %{"foods" => %{"food" => food}}}} ->
          food

        _ ->
          []
      end

    Fireweed.log("foods", foods)
    {:noreply, socket |> assign(nutrition: Map.put(socket.assigns.nutrition, :foods, foods))}
  end

  def handle_info({:nutrition, :fetch, food_id}, socket) do
    food =
      case FatSecret.food_get_v2(food_id) do
        {:ok, food} ->
          food

        _ ->
          :error
      end

    {:noreply, socket |> assign(nutrition: Map.put(socket.assigns.nutrition, :food, food))}
  end
end
