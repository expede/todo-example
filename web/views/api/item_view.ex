defmodule Todo.API.ItemView do
  alias __MODULE__
  use Todo.Web, :view

  def render("index.json", %{items: items}) do
    %{data: render_many(items, ItemView, "simple_item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{
      name: item.name,
      list: render_one(item.list, Todo.API.ListView, "list.json"),
      completer: render_one(item.completer, Todo.API.UserView, "user.json")
    }
  end

  def render("simple_item.json", %{item: item}) do
    %{
      name: item.name,
      list_id: item.list_id,
      completer_id: item.completer_id,
      complete: not is_nil(item.completer_id)
    }
  end
end
