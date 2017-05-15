defmodule Todo.API.ItemView do
  use Todo.Web, :view

  def render("index.json", %{items: items}) do
    %{data: render_many(items, Todo.ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, Todo.ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{
      name: item.name,
      list: render_one(item.list, Todo.ListView, "list.json"),
      completer: render_one(item.completer, Todo.UserView, "user.json")
    }
  end
end
