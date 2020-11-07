defmodule FireweedWeb.NutritionLive.Index do
  @withuser %{assigns: %{current_user: %{}}}

  use FireweedWeb, :surface_live_view
  alias FireweedWeb.Nutrition.Components.{SearchResponse,Servings}

  prop current_user, :any, required: true
  prop admin_user, :boolean, required: true

  data foods, :any
  data food_id, :integer
  data food, :any
  data query, :string, default: ""

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
       foods: :idle,
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
    socket |> assign(page_title: "Nutrition", food: nil)
  end

  def apply_action(socket, :show, %{"food_id" => food_id}) do
    send(self(), {:fetch, food_id})
    socket |> assign(food: :fetching, page_title: "Nutrition: #{food_id}", food: :fetching)
  end

  def apply_action(socket, _action, _params) do
    socket
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    send(self(), {:search, query})

    {:noreply, socket |> assign(query: query, foods: :searching)}
  end

  @impl true
  def handle_event("show", %{"id" => id}, socket) do
    {:noreply, push_patch(socket, to: FireweedWeb.Router.Helpers.nutrition_index_path(:show, id))}
  end

  @impl true
  def handle_info({:search, query}, socket) do
    foods = FatSecret.search(query)

    {:noreply, socket |> assign(:foods, foods)}
  end

  def handle_info({:fetch, food_id}, socket) do
    {:noreply, socket |> assign(food: FatSecret.food_get_v2(food_id))}
  end

  @impl true
  def render(assigns) do
    detail =
      case assigns.food do
        nil -> ~H""
        {:ok, food} ->
          ~H"""
            <Servings food={{food}} />
          """

        :fetching ->
          ~H"""
            <span>Cooking up a storm...</span>
          """

        _ ->
          ~H"""
          <span>An unexped error has occurred.</span>
          """
      end

    search_class = case assigns.food do
      nil -> "flex w-full md:w-2/5"
      _ -> "hidden md:flex"
    end

    servings_class = case assigns.food do
      nil -> "hidden md:block"
      _ -> ""
    end

    ~H"""
    <Navigation
      page={{:nutrition}}
      current_user={{@current_user}}
      admin_user={{@admin_user}}
    />
    <section>
      <div class={{search_class}}>
        <section>
          <form :on-change="search" onsubmit="return false;">
            <input type="text" placeholder="Search for foods" aria-label="Search for foods" phx-debounce="250" name="query" value="{{@query}}" />
          </form>
        </section>
        <section>
          <SearchResponse foods={{@foods}} food_id={{@food_id}} />
        </section>
      </div>
       <div class={{servings_class}}>
      <section>{{detail}}</section>
    </div>
    </section>
    """
  end
end
