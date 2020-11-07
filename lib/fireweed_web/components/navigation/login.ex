defmodule FireweedWeb.Components.Navigation.Login do
  use FireweedWeb, :surface_component

  def render(assigns) do
    ~H"""
      <section class="p-3 flex items-center text-nutrition border-t-1 border-black-light">
        <div class="text-base px-2 text-white-softer">
          <div class="text-white-softest">
            <LiveRedirect to={{Routes.session_path(@socket, :login)}}>
              <span class="font-flaticon flaticon-login"></span>
              <span>Login</span>
            </LiveRedirect>
          </div>
        </div>
      </section>
    """
  end
end
