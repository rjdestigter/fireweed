defmodule FireweedWeb.UsersLive.Components.List do
  use FireweedWeb, :surface_component

  prop users, :list, required: true

  defmodule Row do
    use FireweedWeb, :surface_component

    prop user, :map, required: true

    @impl true
    def render(assigns) do
      is_admin_class = FireweedWeb.Auth.is_admin?(assigns.user) && "text-secondary" || "text-white-softer"

      ~H"""
        <tr id={{"user-#{@user.id}"}} class="border-b-1 border-white-softest border-opacity-25 hover:bg-black-dark hover:bg-opacity-25">
          <td class="py-2">
            <span class={{"text-lg font-black font-flaticon flaticon-user px-2 " <> is_admin_class}}></span>
            {{@user.name}}
          </td>
          <td class="py-2">{{@user.email}}</td>
          <td class="py-2">
            <input type="checkbox" readonly onclick="return false;" />
          </td>
          <td>
            <span class="px-1 pt-1">
              <LivePatch to={{Routes.users_index_path(@socket, :show, @user)}}>
                <span class="text-lg font-black font-flaticon flaticon-pencil hover:text-secondary"></span>
              </LivePatch>
            </span>
          </td>
        </tr>
      """
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
      <table class="text-left text-base w-full">
        <thead>
          <tr>
          <th>Name</th>
          <th>Email</th>
          <th>Verified</th>
          <th></th>
          </tr>
        </thead>
        <tbody id="users">
          <Row :for={{user <- @users}} user={{user}} />
        </tbody>
      </table>
    """
  end
end
