defmodule Todo.ItemController do
  alias Todo.Item
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
  def new(conn, _params), do: render(conn, "new.html", changeset: Item.changeset(%Item{}))

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"item" => item_params}) do
    Item
    |> struct()
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
           |> render("new.html", conn: conn, changeset: changeset)
       end
  end

  @spec edit(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    render(conn, "edit.html", changeset: Item.changeset(item), item: item, conn: conn)
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "item" => item_params}) do
    Item
    |> Repo.get!(id)
    |> Repo.preload([:items, :users])
    |> Item.changeset(item_params)
    |> Repo.update()
    |> case do
         {:ok, %{name: name} = item} ->
           conn
           |> put_flash(:info, "#{name} updated!")
           |> redirect(to: item_path(conn, :show, item))

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
