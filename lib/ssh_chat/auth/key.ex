defmodule SshChat.Auth.Key do
  use Ecto.Schema
  alias SshChat.Auth.User
  schema "auth_keys" do
    field :key, :string
    belongs_to :user, User

    timestamps()
  end
end
