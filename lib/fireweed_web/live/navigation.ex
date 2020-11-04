defmodule FireweedWeb.Components.Navigation do
  use FireweedWeb, :live_component
  alias FireweedWeb.Router.Helpers, as: R

  @menus [
    {"Menu",
     [
       {"Home", :home, &R.page_path/2, :index},
       {"Nutrition", :nutrition, &R.nutrition_index_path/2, :index, :protected},
       {"Heart Rate", :heartrate, &R.heart_rate_index_path/2, :index, :protected},
       {"Map", :map, &R.map_index_path/2, :index, :protected}
     ]},
    {"Admin",
     [
       :dashboard,
       {"Users", :users, &R.users_index_path/2, :index}
     ], :admin}
  ]

  def render_menu_item(assigns, :dashboard) do
    ~L"""
      <%= if function_exported?(Routes, :live_dashboard_path, 2) do %>
      <li>
        <%= link to: Routes.live_dashboard_path(@socket, :home) do %>
          <img src="/icons/heartrate.svg" title="Heart Rate" alt="" />
          <span>Dashboard</span>
        <% end %>
      </li>
    <% end %>
    """
  end

  def render_menu_item(assigns, menu_item = {_label, _id, _path_fn, _action, :admin}) do
    render_menu_item(assigns, menu_item, assigns.admin_user)
  end

  def render_menu_item(assigns, menu_item = {_label, _id, _path_fn, _action, :protected}) do
    render_menu_item(assigns, menu_item, assigns.current_user != nil)
  end

  def render_menu_item(assigns, {label, id, pathfn, action}) do
    render_menu_item(assigns, {label, id, pathfn, action, :noop})
  end

  def render_menu_item(assigns, {label, id, path_fn, action, _}, has_access \\ true) do
    if has_access do
      ~L"""
        <li data-active="<%= @page == id %>">
          <%= live_redirect to: path_fn.(@socket, action) do %>
            <img src="/icons/tableware.svg" title="<%=label%>" alt="" />
            <span><%=label%></span>
          <% end %>
        </li>
      """
    end
  end

  def render_menu(assigns, menu = {_label, _items, :protected}) do
    render_menu(assigns, menu, assigns.current_user != nil)
  end

  def render_menu(assigns, menu = {_label, _items, :admin}) do
    render_menu(assigns, menu, assigns.admin_user)
  end

  def render_menu(assigns, {label, items}) do
    render_menu(assigns, {label, items, :noop})
  end

  def render_menu(assigns, {label, items, _}, has_access \\ true) do
    if has_access do
      ~L"""
        <h3 class="text-base font-black px-6 py-2 text-white-softer"><%=label%></h3>
        <ul class="whitespace-no-wrap mb-3">
          <%= for item <- items do %>
            <%= render_menu_item(assigns, item) %>
          <% end %>
        </ul>
      """
    end
  end

  def render_menus(assigns) do
    menus = @menus

    ~L"""
      <%= for menu <- menus do %>
        <%=render_menu(assigns, menu)%>
      <% end %>
    """
  end
end
