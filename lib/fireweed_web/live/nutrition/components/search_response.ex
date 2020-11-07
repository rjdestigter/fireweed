defmodule FireweedWeb.Nutrition.Components.SearchResponse do
  alias FireweedWeb.Nutrition.Components.{SearchList}

  use Surface.Component
  @doc "The response "
  prop(foods, :any, required: true)
  prop(food_id, :integer, required: true)

  def render(assigns) do
    case assigns.foods do
      :idle -> ~H""
      :searching -> ~H"Painting the town red..."
      {:ok, _foods, _meta} -> render_list(assigns)
      :noresults -> render_noresults(assigns)
      _ -> render_error(assigns)
    end
  end

  def render_list(assigns) do
    ~H"""
      <SearchList selected={{@food_id}} foods={{@foods}} />
    """
  end

  def render_noresults(assigns) do
    ~H"""
      <span>No results</span>
    """
  end

  def render_error(assigns) do
    ~H"""
      <span>An unexpected error has occurred</span>
    """
  end
end
