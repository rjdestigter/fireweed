defmodule FireweedWeb.SessionController do
  use FireweedWeb, :controller

  alias Fireweed.Accounts

  # Uncommend these after configuring a mailer
  # alias Fireweed.Accounts.Email
  # alias Fireweed.Mail er

  def new(conn, _) do
    render(conn, "new.html", page_title: "Login")
  end

  def create(conn, %{"user" => %{"email" => "", "password" => ""}}) do
    conn
    |> put_flash(:error, "Please fill in an email address and password")
    |> redirect(to: Routes.session_path(conn, :new))
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_by_email_password(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Bad email/password combination")
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, :not_found} ->
        conn
        |> put_flash(:error, "Account not found")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def create_from_token(conn, %{"email" => email, "token" => token}) do
    case Accounts.authenticate_by_email_token(email, token) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: Routes.user_index_path(conn, :show))

      _ ->
        conn
        |> put_flash(:error, "Invalid login")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def token_login(conn, params) do
    case FireweedWeb.Token.verify(params["token"]) do
      {:ok, %{id: user_id}} ->
        user = Accounts.get_user!(user_id)

        conn
        |> FireweedWeb.Auth.login(user)
        |> put_flash(:info, "User created successfully.")
        # |> redirect(to: Routes.user_index_path(conn, FireweedWeb.UserLive.Show, user))

      _ ->
        conn
        |> put_flash(:info, "Please login.")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def forgot(conn, _) do
    render(conn, "forgot.html")
  end

  def reset_pass(conn, %{"credential" => %{"email" => email}}) do
    # case Accounts.get_cred_by_email(email) do
    #   nil ->
    #     conn
    #     |> put_flash(:error, "Email not found")
    #     |> redirect(to: Routes.session_path(conn, :forgot))

    #   cred ->
    #     token = Accounts.Credential.generate_login_token()
    #     {:ok, cred} = Accounts.update_login_token(cred, token)

    #     link =
    #       FireweedWeb.Endpoint.url() <>
    #         Routes.session_path(conn, :create_from_token, token, cred.email)

    #     if Fireweedlication.get_env(:Fireweed, :mix_env) in [:dev, :prod] do
    #       user = Accounts.get_user!(cred.user_id)
    #       IO.puts("Configure a transactional mail service to send password reset mail for")
    #       IO.puts("User: #{inspect(user)}")
    #       IO.puts("Link: #{inspect(link)}")
    #       # Function to send password reset link goes here.
    #       # It will depend on your transactional mail service
    #       # and look something like the following:
    #       #
    #       # Email.password_reset(user, link) |> Mailer.deliver()
    #     end

    #     conn
    #     |> put_flash(:info, "A sign-in link has been sent to your email address")
    #     |> redirect(to: Routes.session_path(conn, :forgot))
    # end
    IO.inspect(email)
    conn
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:success, "Successfully signed out")
    |> redirect(to: "/")
  end
end
