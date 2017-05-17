defmodule Todo.API.ListView do
  alias __MODULE__
  use Todo.Web, :view

  def render("index.json", %{lists: lists}) do
    %{data: render_many(lists, ListView, "simple_list.json")}
  end

  def render("show.json", %{list: list}) do
    %{data: render_one(list, ListView, "list.json")}
  end

  def render("list.json", %{list: list}) do
    %{
      name: list.name,
      users: render_many(list.users, Todo.API.UserView, "user.json"),
      items: render_many(list.items, Todo.API.ItemView, "item.json")
    }
  end

  def render("simple_list.json", %{list: list}) do
    %{
      name: list.name,
      user_ids: Enum.map(list.users, fn user -> user.id end),
      item_ids: Enum.map(list.items, fn item -> item.id end)
    }
  end
end
