defmodule FireweedWeb.Nutrition.Components.Servings do
  use FireweedWeb, :surface_component
  alias FireweedWeb.Nutrition.Components.{Fact}

  prop(food, :any, required: true)

  def render(assigns) do
    ~H"""
      <LivePatch to={{Routes.nutrition_index_path(@socket, :index)}} class="float-right md:hidden">
      close
      </LivePatch>
      <h1 class="text-4xl font-normal pl-4 pointer-events-none">{{@food["food_name"]}}</h1>
      <ul class="flex flex-wrap">
        <li class="p-4 flex-grow flex-shrink" style="min-width:255px" :for={{ serving <- @food["servings"] }}>
          <Fact serving={{serving}} />
        </li>
      </ul>
    """
  end
end
