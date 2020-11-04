defmodule FireweedWeb.UsersLive.SignUp do
  use FireweedWeb, :live_view
  alias Fireweed.Accounts
  alias Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, changeset: Accounts.change_user(%User{}))}
  end

  @impl true
  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      %User{}
      |> Accounts.change_user(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => params}, socket) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        token = Accounts.Token.generate_login_token()

        case Accounts.create_token(%{
               "token" => token,
               "user_id" => user.id
             }) do
          {:ok, _} ->
            {:noreply,
             socket
             |> redirect(
               to:
                 Routes.session_path(
                   socket,
                   :create_from_token,
                   token,
                   user.email
                 )
             )}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, changeset: changeset)}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
