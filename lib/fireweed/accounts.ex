defmodule Fireweed.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]
  import Ecto.Query, warn: false
  alias Fireweed.Repo

  alias Fireweed.Accounts.User
  alias Fireweed.Accounts.Token

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Fireweed.PubSub, @topic)
  end

  def subscribe(user_id) do
    Phoenix.PubSub.subscribe(Fireweed.PubSub, @topic <> "#{user_id}")
  end

  def unsubscribe do
    Phoenix.PubSub.unsubscribe(Fireweed.PubSub, @topic)
  end

  def unsubscribe(user_id) do
    Phoenix.PubSub.unsubscribe(Fireweed.PubSub, @topic <> "#{user_id}")
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_from_id(id) when is_nil(id), do: nil

  def get_user_from_id(id) do
    case Repo.get(User, id) do
      nil -> nil
      %User{} -> get_user!(id)
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers([:user, :created])
  end

  def create_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs \\ %{}) do
    changeset =
      if attrs["password"] == "" || attrs["password"] == nil do
        &User.changeset/2
      else
        &User.registration_changeset/2
      end

    user
    |> changeset.(attrs)
    |> Repo.update()
    |> notify_subscribers([:user, :updated])
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
    |> notify_subscribers([:user, :deleted])
  end

  @spec change_user(Fireweed.Accounts.User.t(), nil | maybe_improper_list | map) :: any
  def change_user(%User{} = user, attrs \\ %{}) do
    changeset =
      if attrs["password"] == "" do
        &User.changeset/2
      else
        &User.registration_changeset/2
      end

    changeset.(user, attrs)
  end

  defp notify_subscribers({:ok, result}, event) do
    Phoenix.PubSub.broadcast(Fireweed.PubSub, @topic, {__MODULE__, event, result})

    Phoenix.PubSub.broadcast(
      Fireweed.PubSub,
      @topic <> "#{result.id}",
      {__MODULE__, event, result}
    )

    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _), do: {:error, reason}

  @doc """
  Authenticates a user via email and password
  returns a tuple pair with a status and either a user or an error atom
  """
  def authenticate_by_email_password(email, given_pass) do
    user = get_user_by_email(email)

    cond do
      email in Fireweed.Accounts.Email.banned() ->
        dummy_checkpw()
        {:error, :unauthorized}

      user && checkpw(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        dummy_checkpw()
        {:error, :not_found}
    end
  end

  @doc """
  Authenticates a user via "magic login link"
  returns a tuple pair with a status and either a user or an error atom
  """
  def authenticate_by_email_token(email, token) do
    tokens = get_tokens_by_email(email)
    Fireweed.log("tokens", tokens)

    cond do
      email in Fireweed.Accounts.Email.banned() ->
        dummy_checkpw()
        {:error, :unauthorized}

      tokens && length(tokens) > 0 ->
        match = tokens |> Enum.find(fn t -> checkpw(token, t.token) end)

        cond do
          match ->
            delete_token(match)

            {:ok,
             %User{
               id: match.user_id,
               email: email
             }}

          true ->
            dummy_checkpw()
            {:error, :unauthorized}
        end

      true ->
        dummy_checkpw()
        {:error, :unauthorized}
    end
  end

  @spec get_user_by_email(any) :: any
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_tokens_by_email(email) do
    Repo.all(from t in Token, join: u in assoc(t, :users), where: u.email == ^email)
  end

  def delete_token(%{id: id}) do
    Repo.delete(%Token{id: id})
  end
end
