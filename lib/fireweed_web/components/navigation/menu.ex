defmodule FireweedWeb.Components.Navigation.Menu do
  use FireweedWeb, :surface_component
  alias FireweedWeb.Components.Navigation.MenuItem

  prop items, :list, required: true
  prop label, :string, required: true
  prop current, :atom, required: true
  prop has_access, :boolean, required: true
  prop is_authenticated, :boolean, required: true
  prop is_admin, :boolean, required: true

  defp has_access?(_, nil), do: true
  defp has_access?(%{is_authenticated: true}, :protected), do: true
  defp has_access?(%{is_admin: true}, :admin), do: true
  defp has_access?(_, _), do: false

  def render(%{ has_access: true } = assigns) do
    ~H"""
      <h3 class="text-base font-black px-6 py-2 text-white-softer">{{@label}}</h3>
      <ul class="whitespace-no-wrap mb-3">
        <MenuItem
          :for={{ {label, id, to, action, access} <- @items}}
          active={{id == @current}}
          to={{is_function(to) && to.(@socket, action) || to}}
          label={{label}}
          has_access={{has_access?(assigns, access)}}
        />
      </ul>
    """
  end

  def render(assigns) do
    ~H""
  end
end
