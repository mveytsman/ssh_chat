defmodule SshChat.Repo.Migrations.CreateSshChat.Auth.Key do
  use Ecto.Migration

  def change do
    create table(:auth_keys) do
      add :key, :text
      add :user_id, references(:auth_users, on_delete: :delete_all)

      timestamps()
    end

    create index(:auth_keys, [:user_id])
    create unique_index(:auth_keys, [:key])
  end
end
