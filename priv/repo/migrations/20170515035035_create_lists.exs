defmodule Todo.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :name,  :string, null: false
      add :notes, :string, null: true

      timestamps()
    end
  end
end
