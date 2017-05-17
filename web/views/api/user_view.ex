defmodule Todo.API.UserView do
  @moduledoc "JSON render functions for `User`s"

  alias __MODULE__
  use Todo.Web, :view

  @spec render(String.t(), map()) :: map()
  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    lists =
      case user.lists do
        lists when is_list(lists) -> render_many(lists, Todo.API.ListView, "list.json")
        _ -> nil
      end

    items =
      case user.completed_items do
        items when is_list(items) -> render_many(items, Todo.API.ItemView, "item.json")
        _ -> nil
      end

    %{
      id: user.id,
      name: user.name,
      lists: lists,
      completed_items: items
    }
  end
end
