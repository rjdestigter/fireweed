defmodule FireweedWeb.Nutrition.Components.SearchList do
  use FireweedWeb, :surface_component

  prop(foods, :any, required: true)
  prop(selected, :integer, required: true)

  def render(%{foods: {:ok, items, _meta}} = assigns) do
    ~H"""
    <ul>
      <li
        role="button"
        data-selected={{id == @selected}}
        class="border-b-1 border-black-light"
        :for={{ %{"food_name" => name, "food_description" => desc, "food_id" => id } = food <- items }}
      >
        <LivePatch to={{FireweedWeb.Router.Helpers.nutrition_index_path(@socket, :show, id)}}>
          <h6>
            <span class="text-sm" data-brand-id={{id}}>{{id}}</span>
            <span class="text-sm text-secondary">{{Map.get(food, "brand_name")}}</span>
          </h6>
          <h4>{{name}}</h4>
        </LivePatch>
      </li>
    </ul>
    """
  end
end
