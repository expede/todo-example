defmodule Todo.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships, primary_key: false) do
      add :user_id, references(:users), null: false
      add :list_id, references(:lists), null: false

      # Note: no timestamps
    end
  end
end
