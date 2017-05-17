defmodule Todo.API.UserController do
  alias Todo.User
  use Todo.Web, :controller

  def index(conn, _params), do: render(conn, "index.json", users: Repo.all(User))

  def show(conn, %{"id" => id}) do
    user =
      User
      |> Repo.get!(id)
      |> Repo.preload([:lists, :completed_items])

    render(conn, "show.json", user: user)
  end

  def create(conn, %{"data" => params}) do
    user =
      User
      |> User.changeset(params)
      |> Repo.insert!()
      |> Repo.preload([:lists, :completed_items])

    conn
    |> put_status(:created)
    |> render("show.json", user: user)
  end

  def update(conn, %{"id" => id, "data" => changes}) do
    user =
      User
      |> Repo.get!(id)
      |> User.changeset(changes)
      |> Repo.update!()

    render(conn, "show.json", user: user)
  end

  def delete(conn, %{"id" => id}) do
    user =
      User
      |> Repo.get!(id)
      |> Repo.delete!()

    send_resp(conn, 204, "")
  end
end
