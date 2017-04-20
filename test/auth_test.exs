defmodule SshChat.AuthTest do
  use SshChat.DataCase

  alias SshChat.Auth
  alias SshChat.Auth.User

  @create_attrs %{email: "some@email", name: "some name", nick: "some nick", token: "some token"}
  @update_attrs %{email: "someupdated@email", name: "some updated name", nick: "some updated nick", token: "some updated token"}
  @invalid_attrs %{email: nil, name: nil, nick: nil, token: nil}

  def fixture(:user, attrs \\ @create_attrs) do
    {:ok, user} = Auth.create_user(attrs)
    user
  end

  test "list_users/1 returns all users" do
    user = fixture(:user)
    assert Auth.list_users() == [user]
  end

  test "get_user! returns the user with given id" do
    user = fixture(:user)
    assert Auth.get_user!(user.id) == user
  end

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user} = Auth.create_user(@create_attrs)
    assert user.email == "some@email"
    assert user.name == "some name"
    assert user.nick == "some nick"
    assert user.token == "some token"
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
  end

  test "update_user/2 with valid data updates the user" do
    user = fixture(:user)
    assert {:ok, user} = Auth.update_user(user, @update_attrs)
    assert %User{} = user
    assert user.email == "someupdated@email"
    assert user.name == "some updated name"
    assert user.nick == "some updated nick"
    assert user.token == "some updated token"
  end

  test "update_user/2 with invalid data returns error changeset" do
    user = fixture(:user)
    assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
    assert user == Auth.get_user!(user.id)
  end

  test "delete_user/1 deletes the user" do
    user = fixture(:user)
    assert {:ok, %User{}} = Auth.delete_user(user)
    assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
  end

  test "change_user/1 returns a user changeset" do
    user = fixture(:user)
    assert %Ecto.Changeset{} = Auth.change_user(user)
  end
end
