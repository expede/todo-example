defmodule Todo.ListController do
  alias Todo.{List, User, Item}
  use Todo.Web, :controller

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html", lists: Repo.all(List), conn: conn)
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    list =
      List
      |> Repo.get!(id)
      |> Repo.preload([:users, [items: :list]])

    render(conn, "show.html", list: list, conn: conn)
  end

  @spec new(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def new(conn, _params), do: render(conn, "new.html", changeset: List.changeset(%List{}))

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"list" => list_params}) do
    List
    |> struct()
    |> List.changeset(list_params)
    |> Repo.insert()
    |> case do
         {:ok, %{name: name} = list} ->
           Todo.EventChannel.broadcast_create(list)

           conn
           |> put_flash(:info, "#{name} created!")
           |> redirect(to: list_path(conn, :show, list))

         {:error, changeset} ->
           conn
           |> put_status(422)
           |> put_flash(:error, "Problem creating list!")
           |> render("new.html", conn: conn, changeset: changeset)
       end
  end

  @spec edit(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    list = Repo.one!(from list in List, where: list.id == ^id, preload: [:items, :users])
    all_users  = Repo.all(from user in User, select: {user.name, user.id})
    list_items = Enum.map(list.items, fn item -> {item.name, item.id} end)

    render(
      conn,
      "edit.html",
      changeset: List.changeset(list),
      conn: conn,
      list: list,
      all_users: all_users,
      member_ids: Enum.map(list.users, fn list -> list.id end),
      list_items: list_items,
      list_item_ids: Enum.map(list.items, fn item -> item.id end)
    )
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Repo.one!(from list in List, where: list.id == ^id, preload: [:items, :users])

    item_ids = Map.get(list_params, "item_ids", [])
    items    = Repo.all(from item in Item, where: item.id in ^item_ids)

    member_ids = Map.get(list_params, "user_ids", [])
    members    = Repo.all(from member in User, where: member.id in ^member_ids)

    normalized_params =
      list_params
      |> Map.put("items", items)
      |> Map.put("users", members)

    changeset = List.changeset(list, normalized_params)

    changeset
    |> Repo.update()
    |> case do
         {:ok, %{name: name} = list} ->
           Todo.EventChannel.broadcast_update(changeset)

           conn
           |> put_flash(:info, "#{name} updated!")
           |> redirect(to: list_path(conn, :show, list))

         {:error, changeset} ->
           conn
           |> put_status(422)
           |> put_flash(:error, "Problem updating list!")
           |> render("edit.html", conn: conn, changeset: changeset)
       end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    List
    |> Repo.get!(id)
    |> Repo.delete()
    |> case do
         {:ok, deleted} ->
           Todo.EventChannel.broadcast_destroy(deleted)
           redirect(conn, to: list_path(conn, :index))

         {:error, survivor} ->
           conn
           |> put_status(422)
           |> put_flash(:error, "Problem deleting list!")
           |> render("show.html", conn: conn, list: Repo.preload(survivor, [:items, :members]))
       end
  end
end
