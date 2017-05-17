defmodule Todo.API.ListController do
  alias Todo.List
  use Todo.Web, :controller

  def index(conn, _params) do
    lists =
      List
      |> Repo.all()
      |> Repo.preload([:users, :items])

    render(conn, "index.json", lists: lists)
  end

  def show(conn, %{"id" => id}) do
    list =
      List
      |> Repo.get!(id)
      |> Repo.preload([:users, :items])

    render(conn, "show.json", list: list)
  end

  def create(conn, params) do
    list =
      List
      |> List.changeset(params)
      |> Repo.insert!()
      |> Repo.preload([:users, :items])

    conn
    |> put_status(:created)
    |> render("show.json", list: list)
  end

  def update(conn, %{"id" => id} = params) do
    list =
      List
      |> Repo.get!(id)
      |> List.changeset(params)
      |> Repo.update!()
      |> Repo.preload([:users, :items])

    render(conn, "show.json", list: list)
  end

  def delete(conn, %{"id" => id}) do
    List
    |> Repo.get!(id)
    |> Repo.delete!()

    send_resp(conn, 204, "")
  end
end
