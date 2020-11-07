defmodule FatSecret do
  @api "https://platform.fatsecret.com/rest/server.api"

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, :anonymous}
  end

  @impl true
  def handle_call(_, _from, {:authenticated, _} = state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:authenticate, _from, _state) do
    state = login()
    {:reply, state, state}
  end

  def get_access_token do
    GenServer.call(__MODULE__, :authenticate)
  end

  def search(term) do
    url = @api <> "?search_expression=#{term}&method=foods.search&max_results=50&format=json"

    case get(url) do
      {:ok, %{"foods" => %{"total_results" => "0"}}} ->
        :noresults

      {:ok, %{"foods" => %{"total_results" => total, "page_number" => page, "food" => food}}}
      when is_map(food) ->
        {:ok, [food], [total: total, page: page]}

      {:ok, %{"foods" => %{"total_results" => total, "page_number" => page, "food" => food}}}
      when is_list(food) ->
        {:ok, food, [total: total, page: page]}

      {:ok, data} ->
        {:baddata, data}

      other ->
        other
    end
  end

  def food_get_v2(food_id) do
    url = @api <> "?food_id=#{food_id}&method=food.get.v2&format=json"

    case get(url) do
      {:ok, %{"food" => food}} ->
        {
          :ok,
          case food do
            %{"servings" => %{ "serving" => servings}} when is_map(servings) ->
              food |> Map.delete("servings") |> Map.put("servings", [servings])
            %{"servings" => %{ "serving" => servings}} when is_list(servings) ->
              food |> Map.delete("servings") |> Map.put("servings", servings)
          end
        }

      other ->
        other
    end
  end

  def login() do
    [client_secret: secret, client_id: id] = Application.get_env(:fireweed, __MODULE__)

    case HTTPoison.post(
           "https://oauth.fatsecret.com/connect/token",
           "grant_type=client_credentials&scope=basic&client_id=" <>
             id <> "&client_secret=" <> secret,
           [{"content-type", "application/x-www-form-urlencoded"}]
         ) do
      {:ok, response} ->
        case Poison.decode(response.body) do
          {:ok, %{"access_token" => access_token}} -> {:authenticated, "Bearer " <> access_token}
          response -> {:error, :decode, response}
        end

      error ->
        error
    end
  end

  def get(url) do
    url = url |> URI.encode()

    case get_access_token() do
      {:authenticated, access_token} ->
        case HTTPoison.get(url, [
               {"Content-Type", "application/json"},
               {"Authorization", access_token}
             ]) do
          {:ok, response} ->
            case Poison.decode(response.body) do
              {:ok, %{"error" => %{"code" => 13}}} -> "Oops"
              ok -> ok
            end

          error ->
            error
        end

      access_token ->
        access_token
    end
  end
end
