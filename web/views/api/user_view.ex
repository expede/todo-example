defmodule Todo.API.UserView do
  alias __MODULE__
  use Todo.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      name: user.name,
      lists: render_many(user.lists, Todo.API.ListView, "simple_list.json"),
      completed_items: render_many(user.completed_items, Todo.API.ItemView, "simple_item.json")
    }
  end

  def render("simple_user.json", %{user: user}) do
    %{
      name: user.name,
      list_ids: Enum.map(user.lists, fn list -> list.id end),
      completed_item_ids: Enum.map(user.completed_items, fn item -> item.id end)
    }
  end
end
