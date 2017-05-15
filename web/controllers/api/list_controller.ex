defmodule Todo.API.ListController do
  alias Todo.List
  use Todo.Web, :controller

  def index(conn, _params) do
    render(conn, "index.json", users: Repo.all(List))
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", user: Repo.get!(List, id))
  end

  def create(conn, params) do
    user =
      List
      |> List.changeset(params)
      |> Repo.insert!()

    conn
    |> put_status(:created)
    |> render("show.json", user: user)
  end

  def update(conn, %{"id" => id} = params) do
    user =
      List
      |> Repo.get!(id)
      |> List.changeset(params)
      |> Repo.update!()

    render(conn, "show.json", user: user)
  end

  def delete(conn, %{"id" => id}) do
    user =
      List
      |> Repo.get!(id)
      |> Repo.delete!()

    conn
    |> put_status(204)
    |> halt()
  end
end
