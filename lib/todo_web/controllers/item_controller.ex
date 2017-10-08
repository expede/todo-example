defmodule TodoWeb.ItemController do
  alias TodoWeb.Lists.{Item, List}
  alias TodoWeb.Accounts.User

  import TodoWeb.Endpoint, only: [broadcast: 3]
  use TodoWeb, :controller
  require Logger

  # @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  # def index(conn, _params) do
  #   render(conn, "index.html", items: Repo.all(Item), conn: conn)
  # end

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
  def create(conn, %{"list_id" => list_id, "item" => item_params} = params) do
    %Item{}
    |> Item.changeset(Map.put(item_params, "list_id", list_id))
    |> Repo.insert()
    |> case do
         {:ok, %{name: name} = item} ->
           TodoWeb.EventChannel.broadcast_create(item)

           conn
           |> put_flash(:info, "#{name} created!")
           |> redirect(to: list_item_path(conn, :show, list_id, item))

         {:error, changeset} ->
           Logger.warn(inspect changeset)

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
  def edit(conn, %{"id" => id}) do
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
    changeset =
      Item
      |> Repo.get!(id)
      |> Repo.preload([:completer, :list])
      |> Item.changeset(item_params)

    changeset
    |> Repo.update()
    |> case do
         {:ok, %{name: name} = item} ->
           TodoWeb.EventChannel.broadcast_update(changeset)

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
    |> Repo.delete()
    |> case do
         {:ok, deleted} ->
           TodoWeb.EventChannel.broadcast_destroy(deleted)
           redirect(conn, to: list_path(conn, :show, deleted.list_id))

         {:error, survivor} ->
           conn
           |> put_status(422)
           |> put_flash(:error, "Problem deleting item!")
           |> render("show.html", conn: conn, item: Repo.preload(survivor, [:list, :users]))
       end
  end
end
