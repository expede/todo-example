defmodule Todo.API.UserController do
  alias Todo.User
  use Todo.Web, :controller

  def index(conn, _params) do
    users =
      User
      |> Repo.all()
      |> IO.inspect()
      |> Repo.preload([[lists: :items], :completed_items])

    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", user: Repo.get!(User, id))
  end

  def create(conn, params) do
    user =
      User
      |> User.changeset(params)
      |> Repo.insert!()

    conn
    |> put_status(:created)
    |> render("show.json", user: user)
  end

  def update(conn, %{"id" => id} = params) do
    user =
      User
      |> Repo.get!(id)
      |> User.changeset(params)
      |> Repo.update!()

    render(conn, "show.json", user: user)
  end

  def delete(conn, %{"id" => id}) do
    user =
      User
      |> Repo.get!(id)
      |> Repo.delete!()

    conn
    |> put_status(204)
    |> halt()
  end
end
