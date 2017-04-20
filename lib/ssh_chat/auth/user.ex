defmodule SshChat.Auth.User do
  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :name, :string
    field :nick, :string
    field :token, :string

    timestamps()
  end
end
