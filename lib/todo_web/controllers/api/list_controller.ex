defmodule TodoWb.API.ListController do
  alias TodoWeb.Lists.List
  use TodoWeb, :controller

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    lists =
      List
      |> Repo.all()
      |> Repo.preload([:users, :items])

    render(conn, "index.json", lists: lists)
  end

  @spec user_lists(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def user_lists(conn, %{"user_id" => user_string_id}) do
    {user_id, ""} = Integer.parse(user_string_id)

    selector =
      from list in List,
        join:   membership in "memberships",
          on:   list.id == membership.list_id,
        where:  membership.user_id == ^user_id,
        select: list

    lists =
      selector
      |> Ecto.Query.preload(:users)
      |> Repo.all()

    render(conn, "index.json", lists: lists)
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    list =
      List
      |> Repo.get!(id)
      |> Repo.preload([:users, :items])

    render(conn, "show.json", list: list)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"data" => params}) do
    list =
      List
      |> List.changeset(params)
      |> Repo.insert!()
      |> Repo.preload([:users, :items])

    conn
    |> put_status(:created)
    |> render("show.json", list: list)
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "data" => changes}) do
    list =
      List
      |> Repo.get!(id)
      |> List.changeset(changes)
      |> Repo.update!()
      |> Repo.preload([:users, :items])

    render(conn, "show.json", list: list)
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    List
    |> Repo.get!(id)
    |> Repo.delete!()

    send_resp(conn, 204, "")
  end
end
