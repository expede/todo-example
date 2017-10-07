defmodule TodoWeb.API.ItemView do
  alias __MODULE__
  use TodoWeb, :view

  def render("index.json", %{items: items}) do
    %{data: render_many(items, ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, ItemView, "item.json")}
  end

  def render("item.json", %{item: item} = params) do
    list =
      case item.list do
        %Todo.List{} = list -> render_one(list, TodoWeb.API.ListView, "list.json")
        _ -> nil
      end

    completer =
      case item.completer do
        %Todo.User{} = user -> render_one(user, TodoWeb.API.UserView, "user.json")
        _ -> nil
      end

    %{
      id: item.id,
      name: item.name,
      complete: not is_nil(item.completer_id),
      completer: completer,
      completer_id: item.completer_id,
      list: list,
      list_id: item.list_id
    }
  end
end
