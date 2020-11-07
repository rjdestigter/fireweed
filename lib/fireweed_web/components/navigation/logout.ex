defmodule FireweedWeb.Components.Navigation.Logout do
  use FireweedWeb, :surface_component

  prop name, :string, required: true
  prop email, :string, required: true

  def render(assigns) do
    ~H"""
      <section class="p-3 flex items-center text-nutrition border-t-1 border-black-light">
        <div class="rounded-full bg-black-light" style="width:40px;height:40px">
          <div class="rounded-full bg-primary" style="width:10px;height:10px;left:1px;top:1px">
          </div>
        </div>

        <div class="text-sm px-2 text-white-softer">
          <span class="font-bold">{{@name}}</span>
          <br />
          {{@email}}

          <div class="text-white-softest">
            <LivePatch to={{Routes.session_path(@socket, :delete)}}>
              <span class="font-flaticon flaticon-logout"></span>
              <span>Logout</span>
            </LivePatch>
          </div>
        </div>
      </section>
    """
  end
end
