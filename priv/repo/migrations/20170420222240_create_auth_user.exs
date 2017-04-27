defmodule SshChat.Repo.Migrations.CreateSshChat.Auth.User do
  use Ecto.Migration

  def change do
    create table(:auth_users) do
      add :name, :string
      add :email, :string
      add :nick, :string
      add :avatar_url, :string
      add :token, :string

      timestamps()
    end
    create unique_index(:auth_users, [:token])
  end
end
