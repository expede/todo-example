defmodule Todo.List do
  @moduledoc """
  Models a list of items

  Backed by Ecto

      User >---< List ---< Item

  """

  use Todo.Web, :model

  @type t :: %Todo.List{
    id: non_neg_integer(),
    name: String.t(),
    notes: String.t(),

    users: [Todo.User.t()],
    items: [Todo.Item.t()],

    inserted_at: Ecto.DateTime.t(),
    updated_at: Ecto.DateTime.t()
  }

  schema "lists" do
    # ==========
    # Attributes
    # ==========

    field :name,  :string
    field :notes, :string

    timestamps()

    # ============
    # Associations
    # ============

    has_many :items, Todo.Item,
      on_replace: :delete,
      on_delete:  :delete_all

    many_to_many :users, Todo.User,
      join_through: "memberships",
      on_replace:   :delete
  end

  @allowed_fields ~W(name notes)
  @required_fields ~W(name)a

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(list, params \\ %{}) do
    IO.inspect(params)
    list
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:users, Map.get(params, "users", []))
    |> put_assoc(:items, Map.get(params, "items", []))
  end
end
