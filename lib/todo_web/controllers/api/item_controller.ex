defmodule TodoWeb.API.ItemController do
  alias TodoWeb.Lists.Item

  use TodoWeb, :controller

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    items =
      Item
      |> Repo.all()
      |> Repo.preload([:list, :completer])

    render(conn, "index.json", items: items)
  end

  @spec completed_for_user(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def completed_for_user(conn, %{"user_id" => user_string_id}) do
    {user_id, ""} = Integer.parse(user_string_id)
    items = Repo.all(from item in Item, where: item.completer_id == ^user_id)

    render(conn, "index.json", items: items)
  end

  @spec list_items(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def list_items(conn, %{"list_id" => list_string_id}) do
    {list_id, ""} = Integer.parse(list_string_id)
    items = Repo.all(from item in Item, where: item.list_id == ^list_id)

    render(conn, "index.json", items: items)
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    render(conn, "show.json", item: Repo.get!(Item, id))
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"data" => params}) do
    item =
      Item
      |> Item.changeset(params)
      |> Repo.insert!()

    conn
    |> put_status(:created)
    |> render("show.json", item: item)
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "data" => changes}) do
    item =
      Item
      |> Repo.get!(id)
      |> Item.changeset(changes)
      |> Repo.update!()

    render(conn, "show.json", item: item)
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    Item
    |> Repo.get!(id)
    |> Repo.delete!()

    send_resp(conn, 204, "")
  end
end
