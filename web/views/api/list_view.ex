defmodule Todo.API.ListView do
  alias __MODULE__
  use Todo.Web, :view

  def render("index.json", %{lists: lists}) do
    %{data: render_many(lists, ListView, "list.json")}
  end

  def render("show.json", %{list: list}) do
    %{data: render_one(list, ListView, "list.json")}
  end

  def render("item.json", %{list: list}) do
    %{
      name: list.name,
      users: render_many(list.users, Todo.API.UserView, "user.json"),
      items: render_many(list.items, Todo.API.ItemView, "item.json")
    }
  end
end
