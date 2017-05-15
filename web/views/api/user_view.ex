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
      lists: render_many(user.lists, Todo.API.ListView, "user.json"),
      completed_items: render_many(user.items, Todo.API.ItemView, "user.json")
    }
  end
end
