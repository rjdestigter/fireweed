defmodule USDA do
  @api "https://api.nal.usda.gov/fdc/"
  @search_api @api <> "v1/foods/search"

  def search(query) do
    url = @search_api <> "?query=" <> query

    case get(url) do
      {:ok, %{"totalHits" => 0}} ->
        :noresults

      {:ok, json} ->
        {:ok, json}

      other ->
        other
    end
  end

  def get(url) do
    [usda_api_key: api_key] = Application.get_env(:fireweed, __MODULE__)

    url = (url <> "&api_key=" <> api_key) |> URI.encode()

    case HTTPoison.get(url) do
      {:ok, response} ->
        Poison.decode(response.body)

      error ->
        error
    end
  end
end
