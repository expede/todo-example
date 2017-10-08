defmodule Todo.Accounts.User do
  @moduledoc """
  A human user of the system

  Backed by Ecto

      Completed Items >--- User >---< List

  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %Todo.Accounts.User{
    id: non_neg_integer(),

    name: String.t(),
    avatar_url: String.t(),

    completed_items: [Todo.Lists.Item.t()],
    lists: [Todo.Lists.List.t()],

    inserted_at: Ecto.DateTime.t(),
    updated_at: Ecto.DateTime.t()
  }

  schema "users" do
    # ==========
    # Attributes
    # ==========

    field :name,       :string
    field :avatar_url, :string

    timestamps()

    # ============
    # Associations
    # ============

    has_many :completed_items, Todo.Lists.Item,
      foreign_key: :completer_id,
      on_replace: :nilify,
      on_delete:  :nilify_all

    many_to_many :lists, Todo.Lists.List,
      join_through: "memberships",
      on_replace: :delete,
      on_delete:  :delete_all
  end

  @allowed_fields ~W(name avatar_url)
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
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 1, max: 256)
    |> put_assoc(:lists, Map.get(params, "lists", []))
    |> put_assoc(:completed_items, Map.get(params, "completed_items", []))
  end
end
