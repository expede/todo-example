defmodule TodoWeb.API.UserController do
  alias Todo.Accounts.User
  use TodoWeb, :controller

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params), do: render(conn, "index.json", users: Repo.all(User))

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    user =
      User
      |> Repo.get!(id)
      |> Repo.preload([:lists, :completed_items])

    render(conn, "show.json", user: user)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
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

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "data" => changes}) do
    user =
      User
      |> Repo.get!(id)
      |> User.changeset(changes)
      |> Repo.update!()

    render(conn, "show.json", user: user)
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    user =
      User
      |> Repo.get!(id)
      |> Repo.delete!()

    send_resp(conn, 204, "")
  end
end
