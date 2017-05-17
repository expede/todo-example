defmodule Todo.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string, null: false

      add :list_id, references(:lists), null: false
      add :completer_id, references(:users), null: true

      timestamps()
    end
  end
end
