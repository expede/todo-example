defmodule Todo.API.ItemController do
  alias Todo.Item
  use Todo.Web, :controller

  def index(conn, _params) do
    render(conn, "index.json", users: Repo.all(Item))
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", user: Repo.get!(Item, id))
  end

  def create(conn, params) do
    user =
      Item
      |> Item.changeset(params)
      |> Repo.insert!()

    conn
    |> put_status(:created)
    |> render("show.json", user: user)
  end

  def update(conn, %{"id" => id} = params) do
    user =
      Item
      |> Repo.get!(id)
      |> Item.changeset(params)
      |> Repo.update!()

    render(conn, "show.json", user: user)
  end

  def delete(conn, %{"id" => id}) do
    user =
      Item
      |> Repo.get!(id)
      |> Repo.delete!()

    conn
    |> put_status(204)
    |> halt()
  end
end
