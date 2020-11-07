defmodule FireweedWeb.Components.Logo do
  use FireweedWeb, :surface_component

  prop height, :number, default: 60
  prop width, :number, default: 120
  prop class, :string, default: ""

  # {:class, "text-primary " <> Keyword.get(attrs, :class, "")} | Keyword.delete(attrs, :class)
  def render(assigns) do
      ~H"""
      <svg height={{@height}} width={{@width}} viewBox="0 0 1210 600" class={{"text-primary " <> @class}}>
        <path fill="none" class="stroke-current" stroke-width="50"d="
          M25,150
          l0,250
          a1,1,0,0,0,100,0
          l0,-175
          a1,1,0,0,1,100,0
          l0,250
          m100, -75
          a1,1,0,0,0,100,0
          l0,-175
          a1,1,0,0,0,-100,0
          l0,175
          m200,-400
          l0,600
          m100,-450
          l0,250
          a1,1,0,0,0,100,0
          l0,-175
          a1,1,0,0,1,100,0
          l0,200
          a1,1,0,0,0,0,0
          l0,-200
          a1,1,0,0,1,100,0
          l0,250
          m100, -75

          a1,1,0,0,0,100,0
          l0,-175
          a1,1,0,0,0,-100,0
          l0,175"
        />
      </svg>
    """
  end
end
