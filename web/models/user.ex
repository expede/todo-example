defmodule Todo.User do
  @moduledoc "A human user of the system. Model is backed by an Ecto store"

  use Todo.Web, :model

  @type t :: %Todo.User{
    id: non_neg_integer(),
    name: String.t(),

    completed_items: [Todo.Item.t()],
    lists: [Todo.List.t()],

    inserted_at: Ecto.DateTime.t(),
    updated_at: Ecto.DateTime.t()
  }

  schema "users" do
    # ==========
    # Attributes
    # ==========

    field :name, :string

    timestamps()

    # ============
    # Associations
    # ============

    has_many :completed_items, Todo.Item,
      foreign_key: :completer_id,
      on_delete: :nilify_all

    many_to_many :lists, Todo.List,
      join_through: "memberships",
      on_replace: :delete,
      on_delete:  :delete_all
  end

  @allowed_fields ~W(name)
  @required_fields ~W(name)a

  @doc ~S"""
  Create a changeset for inserting or updating a `User`

  ## Examples

      ...> params = %{"name" => "brooke", "lists" => [%{"name" => "hi", "id" => 1}]}
      ...>
      ...> %Todo.User{}
      ...> |> Todo.User.changeset(params)
      ...> |> Todo.Repo.insert()
      {:ok, %Todo.User{...}]

  """
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(user, params) do
    user
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:lists)
    |> cast_assoc(:completed_items)
  end
end
