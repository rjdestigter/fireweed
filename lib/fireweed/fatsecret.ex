defmodule FatSecret do
  # @access_token "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEzRTFGRDgwMTQ0Q0IwQTI4NDRFMzI4REZCNUU4NTQyRDE0QUI2RUYiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFLUg5Z0JSTXNLS0VUaktOLTE2RlF0Rkt0dTgifQ.eyJuYmYiOjE2MDQxODI1MzksImV4cCI6MTYwNDI2ODkzOSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJjMTRlYmM5ZmMxNTE0YWI3ODE0NDgxY2E5NzY4MDE2YiIsInNjb3BlIjpbImJhc2ljIl19.X3u1MK4KR_kIKaW3Z8nwZzUML3jPlMuZrsHCyHBePO2OkOy4AvBcnWX6ETf7xEKC4uw_qZD7kjDJXaTVQHv93aYSM1eAI376p3BoDB_sDB-wpKkaEMzlRHCPdXcS4HPc5iAiffIwXcwcu_BPKUw5SePz_sOs0_X5fNSVOJjFdkJxPDSzJgdkVGEbHm36mJQmKcQrlPeDOI8UFpmC_5BLbv3POTpfz895dexcHZ9rVENcFidXHZcJZ7BWNeu5n6D8gH6rVgt3VbRVup8uwwWWeVkyPo8dLy7pkRf7x6JkXnao6-LjgRb9lFVw8DvzTRRLkfmQdTzIWX4cmZBmlAOk3A"
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

    get(url)
  end

  def food_get_v2(food_id) do
    url = @api <> "?food_id=#{food_id}&method=food.get.v2&format=json"

    get(url)
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
            {:ok, Poison.decode(response.body)}
          error -> error
        end
      access_token -> access_token
    end
  end
end
