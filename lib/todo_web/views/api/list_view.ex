defmodule TodoWeb.API.ListView do
  alias __MODULE__
  use TodoWeb, :view

  def render("index.json", %{lists: lists}) do
    %{data: render_many(lists, ListView, "list.json")}
  end

  def render("show.json", %{list: list}) do
    %{data: render_one(list, ListView, "list.json")}
  end

  def render("list.json", %{list: list}) do
    users =
      case list.users do
        users when is_list(users) -> render_many(users, TodoWeb.API.UserView, "user.json")
        _ -> nil
      end

    items =
      case list.items do
        items when is_list(items) -> render_many(items, TodoWeb.API.ItemView, "item.json")
        _ -> nil
      end

    %{
      id: list.id,
      name: list.name,
      users: users,
      items: items
    }
  end
end
