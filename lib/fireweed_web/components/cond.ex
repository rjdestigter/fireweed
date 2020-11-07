defmodule FireweedWeb.Components.Cond do
  use FireweedWeb, :surface_component

  prop visible, :boolean, required: true

  @impl true
  def render(%{ visible: true } = assigns) do
    ~H"""
      <slot />
    """
  end

  def render(assigns) do
    ~H""
  end
end
