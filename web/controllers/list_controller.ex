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

    all_users = Repo.all(from user in User, select: {user.name, user.id})
    list_items =

    render(
      conn,
      "edit.html",
      changeset: List.changeset(list),
      conn: conn,
      list: list,
      all_users: all_users,
      member_ids: Enum.map(list.users, fn list -> list.id end),
      list_items: Enum.map(list.items, fn item -> {item.name, item.id} end),
      list_item_ids: Enum.map(list.items, fn item -> item.id end)
    )
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Repo.one!(from list in List, where: list.id == ^id, preload: [:items, :users])

    items   = Repo.all(from item in Item, where: item.id in ^list_params["item_ids"])
    members = Repo.all(from member in User, where: member.id in ^list_params["user_ids"])

    normalized_params =
      list_params
      |> Map.put("items", items)
      |> Map.put("users", members)

    list
    |> List.changeset(normalized_params)
    |> Repo.update()
    |> case do
         {:ok, %{name: name} = list} ->
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
    |> Repo.delete!()

    redirect(conn, to: list_path(conn, :index))
  end
end