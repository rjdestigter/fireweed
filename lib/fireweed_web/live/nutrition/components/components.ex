defmodule Lib do
  import Phoenix.HTML
  import Phoenix.HTML.Tag

  def logo(attrs \\ []) do
    svg_attrs = [
      {:height, "60"},
      {:width, "121"},
      {:viewBox, "0 0 1210 600"},
      {:class, "text-primary " <> Keyword.get(attrs, :class, "")} | Keyword.delete(attrs, :class)
    ]

    path = ~E"""
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
      l0,175
    " />
    """

    ~E"""
    <%= content_tag(:svg, svg_attrs) do %>
      <%=path%>
      <% end %>
    """
  end
end
