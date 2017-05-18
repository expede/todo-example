defmodule Todo.UserController do
  alias Todo.{List, User}
  use Todo.Web, :controller

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html", users: Repo.all(User), conn: conn)
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    user =
      User
      |> Repo.get!(id)
      |> Repo.preload([:lists, [completed_items: :list]])

    render(conn, "show.html", user: user, completed_items: user.completed_items, conn: conn)
  end

  @spec new(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def new(conn, _params), do: render(conn, "new.html", changeset: User.changeset(%User{}))

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"user" => user_params}) do
    User
    |> struct()
    |> User.changeset(user_params)
    |> Repo.insert()
    |> case do
         {:ok, %{name: name} = user} ->
           conn
           |> put_flash(:info, "#{name} created!")
           |> redirect(to: user_path(conn, :show, user))

         {:error, changeset} ->
           conn
           |> put_status(422)
           |> put_flash(:error, "Problem creating user!")
           |> render("new.html", conn: conn, changeset: changeset)
       end
  end

  @spec edit(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    user =
      User
      |> Repo.get!(id)
      |> Repo.preload([:lists])

    list_ids = Enum.map(user.lists, fn list -> list.id end)
    all_lists = Repo.all(List)

    memberships =
      Enum.reduce(all_lists, [], fn(list, acc) ->
        [{list, Enum.member?(list_ids, list.id)} | acc]
      end)

    render(
      conn,
      "edit.html",
      changeset: User.changeset(user),
      user: user,
      checkbox_memberships: memberships,
      conn: conn
    )
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "user" => user_params}) do
    User
    |> Repo.get!(id)
    |> Repo.preload([:lists, :completed_items])
    |> User.changeset(user_params)
    |> Repo.update()
    |> case do
         {:ok, %{name: name} = user} ->
           conn
           |> put_flash(:info, "#{name} updated!")
           |> redirect(to: user_path(conn, :show, user))

         {:error, changeset} ->
           conn
           |> put_status(422)
           |> put_flash(:error, "Problem updating user!")
           |> render("new.html", conn: conn, changeset: changeset)
       end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    User
    |> Repo.get!(id)
    |> Repo.delete!()

    redirect(conn, to: user_path(conn, :index))
  end

  # @spec find_by_name(Ecto.Query.t(), String.t()) :: Ecto.Query.t()
  # def find_by_name(query, name), do: Ecto.Query.where(query, [u], ilike(u.name, ^"%#{name}%"))
end
