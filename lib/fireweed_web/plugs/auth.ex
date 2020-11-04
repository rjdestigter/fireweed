defmodule FireweedWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias FireweedWeb.Router.Helpers, as: Routes
  alias Fireweed.Accounts

  @site_admins ~w[johndestigter@gmail.com]

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    user =
      cond do
        assigned = conn.assigns[:current_user] -> assigned
        true -> Accounts.get_user_from_id(user_id)
      end

    put_current_user(conn, user)
  end

  def authenticate_admin(conn = %{assigns: %{admin_user: true}}, _), do: conn

  # not admin
  def authenticate_admin(conn = %{private: %{phoenix_format: "json"}}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> halt()
    |> json(%{error: "unauthorized"})
  end

  def authenticate_admin(conn, _opts) do
    conn
    |> put_flash(:error, "You do not have access to that page")
    |> halt()
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def is_admin?(%{email: email}), do: email in @site_admins
  def is_admin(_), do: false

  @doc """
  Logs in the `user` passed in and puts the user in the conn.

  An entire user object must be passed in.
  """
  def login(conn, user) do
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  @doc """
  Logs out the user and drops the session.
  """
  def logout(conn) do
    drop_current_user(conn)
  end

  def logged_in_user(conn = %{assigns: %{current_user: %{}}}, _), do: conn

  # not logged in
  def logged_in_user(conn = %{private: %{phoenix_format: "json"}}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> halt()
    |> json(%{error: "unauthorized"})
  end

  def logged_in_user(conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in to access that page")
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end

  def put_current_user(conn, user) do
    token = user && FireweedWeb.Token.sign(%{id: user.id})

    conn
    |> assign(:current_user, user)
    |> assign(
      :admin_user,
      (user && user.email) in @site_admins
    )
    |> assign(:user_token, token)
  end

  def drop_current_user(conn) do
    conn
    |> delete_req_header("authorization")
    |> configure_session(drop: true)
  end
end
