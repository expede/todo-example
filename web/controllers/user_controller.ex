defmodule Todo.UserController do
  alias Todo.{List, User, Item}
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
    user = Repo.one!(from user in User, where: user.id == ^id, preload: [:lists, :completed_items])

    all_lists = Repo.all(from list in List, select: {list.name, list.id})
    all_items = Repo.all(from item in Item, select: {item.name, item.id})

    render(
      conn,
      "edit.html",
      conn: conn,
      user: user,
      changeset: User.changeset(user),
      all_lists: all_lists,
      all_items: all_items,
      joined_list_ids:    Enum.map(user.lists, fn list -> list.id end),
      completed_item_ids: Enum.map(user.completed_items, fn item -> item.id end)
    )
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.one!(from user in User, where: user.id == ^id, preload: [:lists, :completed_items])

    lists = Repo.all(from list in List, where: list.id in ^user_params["list_ids"])
    completed_items = Repo.all(from item in Item, where: item.id in ^user_params["completed_item_ids"])

    normalized_params =
      user_params
      |> Map.put("lists", lists)
      |> Map.put("completed_items", completed_items)

    user
    |> User.changeset(normalized_params)
    |> Repo.update()
    |> case do
         {:ok, %{name: name} = user} ->
           conn
           |> put_flash(:info, "#{name} updated!")
           |> redirect(to: user_path(conn, :show, user))

         {:error, changeset} ->
           IO.inspect changeset

           conn
           |> put_status(422)
           |> put_flash(:error, "Problem updating user!")
           |> redirect(to: user_path(conn, :show, user))
       end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    IO.puts("DELETE")
    User
    |> Repo.get!(id)
    |> Repo.delete!()

    redirect(conn, to: user_path(conn, :index))
  end
end
