defmodule Todo.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string, null: false

      add :list_id, references(:lists), null: false
      add :completer_id, references(:users), null: true

      timestamps()
    end

    create unique_index(:items, [:name, :list_id], name: :unique_name_within_list)
  end
end
