defmodule SshChat.Auth do
  @moduledoc """
  The boundary for the Auth system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias SshChat.Repo

  alias SshChat.Auth.User
  alias SshChat.Auth.Key

  ### Users ###

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
    |> user_changeset(attrs)
    |> Repo.insert()
  end

  def create_user_with_keys(user_attrs \\ %{}, keys \\ []) do
    %User{}
    |> user_changeset(user_attrs)
    |> put_assoc(:keys, Enum.map(keys, &key_changeset(%Key{}, &1)))
    |> Repo.insert()
  end


  @doc """
  Creates a user given an ueberauth struct.
  """
  def get_or_create_user_by_ueberauth(%Ueberauth.Auth{} = auth) do
    user = Repo.get_by(User, token: auth.credentials.token)

    unless is_nil(user)  do
      # we got the user already
      user
    else
      # We actually have to create the user
      token = auth.credentials.token
      username = auth.info.nickname

      {:ok, %OAuth2.Response{body: keys} } = Ueberauth.Strategy.Github.OAuth.get(token, "/users/#{username}/keys")

      create_user_with_keys(%{
        name: auth.info.name,
        email: auth.info.email,
        nick: username,
        avatar_url: auth.info.urls.avatar_url,
        token: auth.credentials.token},
        keys)
    end
  end

  @doc """
  Updates a user.

  ## Examples

  iex> update_user(user, %{field: new_value})
  {:ok, %User{}}

  iex> update_user(user, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

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
  %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    user_changeset(user, %{})
  end

  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name, :nick, :avatar_url, :token])
    |> validate_required([:email, :name, :nick, :avatar_url, :token])
    |> validate_format(:email, ~r/@/)
  end

  ### Keys ###

  def list_keys do
    Repo.all(Key)
  end

  def get_user_by_key(key) do
    case Repo.get_by(Key, key: key) do
      nil -> nil
      key -> get_user!(key.user_id)
    end
  end

  defp key_changeset(%Key{} = key, attrs) do
    key
    |> cast(attrs, [:key])
    |> validate_required([:key])
  end
end
