defmodule SshChat.Repo.Migrations.CreateSshChat.Auth.User do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :nick, :string
      add :token, :string

      timestamps()
    end
    create unique_index(:users, [:token])
  end
end
