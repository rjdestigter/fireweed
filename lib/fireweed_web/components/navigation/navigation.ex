defmodule FireweedWeb.Components.Navigation do
  use FireweedWeb, :surface_component
  alias FireweedWeb.Components.Navigation.{Menu, Logout, Login}

  @menus [
    {"Menu",
     [
       {"Home", :home, &Routes.page_path/2, :index, nil},
       {"Nutrition", :nutrition, &Routes.nutrition_index_path/2, :index, :protected},
       {"Heart Rate", :heartrate, &Routes.heart_rate_index_path/2, :index, :protected},
       {"Map", :map, &Routes.map_index_path/2, :index, :protected}
     ], nil},
    {"Admin",
     [
       {"Dashboard", :dashboard, nil, :dashboard, :admin},
       {"Users", :users, &Routes.users_index_path/2, :index, :admin}
     ], :admin}
  ]

  prop current_user, :any, required: true
  prop admin_user, :boolean, required: true
  prop page, :atom, required: true

  defp has_access?(_, nil), do: true
  defp has_access?(%{current_user: user}, :protected), do: user != nil
  defp has_access?(%{admin_user: is_admin}, :admin), do: is_admin
  defp has_access?(_, _), do: false

  @impl true
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    menus = @menus

    ~H"""
      <nav class="flex flex-col">
        <Menu
          :for={{ {label, items, access} <- menus}}
          label={{label}}
          items={{items}}
          current={{@page}}
          has_access={{has_access?(assigns, access)}}
          is_authenticated={{@current_user != nil}}
          is_admin={{@admin_user}}
        />
         <div class="flex-grow flex-shrink"></div>
        <Cond visible={{@current_user != nil}}>
          <Logout name={{@current_user.name}} email={{@current_user.email}} />
        </Cond>
        <Cond visible={{@current_user == nil}}>
          <Login />
        </Cond>
      </nav>
    """
  end
end
