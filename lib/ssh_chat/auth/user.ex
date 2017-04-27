defmodule SshChat.Auth.User do
  use Ecto.Schema
  alias SshChat.Auth.Key

  schema "auth_users" do
    field :email, :string
    field :name, :string
    field :nick, :string
    field :avatar_url, :string
    field :token, :string

    has_many :keys, Key

    timestamps()
  end
end
