defmodule Todo.API.ItemController do
  alias Todo.Item
  use Todo.Web, :controller

  def index(conn, _params) do
    render(conn, "index.json", items: Repo.all(Item))
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", item: Repo.get!(Item, id))
  end

  def create(conn, params) do
    item =
      Item
      |> Item.changeset(params)
      |> Repo.insert!()

    conn
    |> put_status(:created)
    |> render("show.json", item: item)
  end

  def update(conn, %{"id" => id} = params) do
    item =
      Item
      |> Repo.get!(id)
      |> Item.changeset(params)
      |> Repo.update!()

    render(conn, "show.json", item: item)
  end

  def delete(conn, %{"id" => id}) do
    Item
    |> Repo.get!(id)
    |> Repo.delete!()

    conn
    |> put_status(204)
    |> halt()
  end
end
