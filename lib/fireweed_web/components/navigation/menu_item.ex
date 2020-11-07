defmodule FireweedWeb.Components.Navigation.MenuItem do
  use FireweedWeb, :surface_component

  prop has_access, :boolean, required: true
  prop active, :boolean, required: true
  prop label, :string, required: true
  prop to, :string, required: true

  def render(%{ has_access: true } = assigns) do
    ~H"""
      <li data-active={{"#{@active}"}}>
        <LiveRedirect to={{@to}}>
          <img src="/icons/tableware.svg" title={{@label}} alt="" />
          <span>{{@label}}</span>
        </LiveRedirect>
      </li>
    """
  end

  def render(assigns) do
    ~H"""
    """
  end
end
