defmodule FireweedWeb.Components.UnderConstruction do
  use FireweedWeb, :surface_component

  prop(page, :atom)

  def render(assigns) do
    ~H"""
    <div class="flex flex-grow flex-shrink items-center justify-center">
      <section class="text-center">
        <Logo class="inline" />
        <br />
        <h1 class="text-4xl font-black">{{@page}}</h1>
        <p>is under construction</p>
      </section>
    </div>
    """
  end
end
