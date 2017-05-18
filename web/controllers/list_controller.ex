defmodule Todo.ListController do
  alias Todo.List
  use Todo.Web, :controller

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html", lists: Repo.all(List), conn: conn)
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    list =
      List
      |> Repo.get!(id)
      |> Repo.preload([:users, [items: :list]])

    render(conn, "show.html", list: list, conn: conn)
  end

  @spec new(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def new(conn, _params), do: render(conn, "new.html", changeset: List.changeset(%List{}))

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"list" => list_params}) do
    List
    |> struct()
    |> List.changeset(list_params)
    |> Repo.insert()
    |> case do
         {:ok, %{name: name} = list} ->
           conn
           |> put_flash(:info, "#{name} created!")
           |> redirect(to: list_path(conn, :show, list))

         {:error, changeset} ->
           conn
           |> put_status(422)
           |> put_flash(:error, "Problem creating list!")
           |> render("new.html", conn: conn, changeset: changeset)
       end
  end

  @spec edit(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    list = Repo.get!(List, id)
    render(conn, "edit.html", changeset: List.changeset(list), list: list, conn: conn)
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "list" => list_params}) do
    List
    |> Repo.get!(id)
    |> Repo.preload([:items, :users])
    |> List.changeset(list_params)
    |> Repo.update()
    |> case do
         {:ok, %{name: name} = list} ->
           conn
           |> put_flash(:info, "#{name} updated!")
           |> redirect(to: list_path(conn, :show, list))

         {:error, changeset} ->
           conn
           |> put_status(422)
           |> put_flash(:error, "Problem updating list!")
           |> render("new.html", conn: conn, changeset: changeset)
       end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    List
    |> Repo.get!(id)
    |> Repo.delete!()

    redirect(conn, to: list_path(conn, :index))
  end

  # @spec find_by_name(Ecto.Query.t(), String.t()) :: Ecto.Query.t()
  # def find_by_name(query, name), do: Ecto.Query.where(query, [u], ilike(u.name, ^"%#{name}%"))
end
