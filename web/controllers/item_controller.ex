defmodule Todo.ItemController do
  alias Todo.{Item, User, List}
  use Todo.Web, :controller

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html", items: Repo.all(Item), conn: conn)
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    item =
      Item
      |> Repo.get!(id)
      |> Repo.preload([:completer, :list])

    render(conn, "show.html", item: item, list: item.list, completer: item.completer, conn: conn)
  end

  @spec new(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def new(conn, %{"list_id" => list_id}) do
    render(
      conn,
      "new.html",
      conn: conn,
      list: Repo.get!(List, list_id),
      changeset: Item.changeset(%Item{})
    )
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"list_id" => list_id, "item" => item_params}) do
    %Item{}
    |> Item.changeset(item_params)
    |> Repo.insert()
    |> case do
         {:ok, %{name: name} = item} ->
           conn
           |> put_flash(:info, "#{name} created!")
           |> redirect(to: item_path(conn, :show, item))

         {:error, changeset} ->
           conn
           |> put_status(422)
           |> put_flash(:error, "Problem creating item!")
           |> render(
             "new.html",
             conn: conn,
             list: Repo.get!(List, list_id),
             changeset: changeset
           )
       end
  end

  @spec edit(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def edit(conn, %{"id" => id, "list_id" => list_id}) do
    users = Repo.all(User)

    item =
      Item
      |> Repo.get!(id)
      |> Repo.preload([:completer, :list])

    render(
      conn,
      "edit.html",
      changeset: Item.changeset(item),
      users: users,
      item: item,
      list: item.list,
      completer: item.completer,
      conn: conn
    )
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "item" => item_params}) do
    Item
    |> Repo.get!(id)
    |> Repo.preload([:completer, :list])
    |> Item.changeset(item_params)
    |> Repo.update()
    |> case do
         {:ok, %{name: name} = item} ->
           conn
           |> put_flash(:info, "#{name} updated!")
           |> redirect(to: list_item_path(conn, :show, item.list, item))

         {:error, changeset} ->
           conn
           |> put_status(422)
           |> put_flash(:error, "Problem updating item!")
           |> render("new.html", conn: conn, changeset: changeset)
       end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    Item
    |> Repo.get!(id)
    |> Repo.delete!()

    redirect(conn, to: item_path(conn, :index))
  end
end
