defmodule Todo.ItemView do
  @moduledoc "HTML view helpers for `Item`s"

  use Todo.Web, :view

  @spec delete_confirmation(String.t()) :: String.t()
  def delete_confirmation(name) do
    """
    if(!confirm('Are you sure you want to delete the item \"#{name}\"?')) {
      return false;
    }
    """
  end

  @spec name_placeholder(User.t()) :: String.t()
  def name_placeholder(%{name: name}) when is_bitstring(name), do: name
  def name_placeholder(_), do: "Item name"

  @spec image_url_placeholder(User.t()) :: String.t()
  def image_url_placeholder(%{image_url: image_url}) when is_bitstring(image_url), do: image_url
  def image_url_placeholder(_), do: "Image URL"

  @spec user_options([Todo.User.t()]) :: keyword()
  def user_options(users), do: Enum.map(users, fn %{id: id, name: name} -> {name, id} end)

  @spec datetime(NaiveDateTime.t()) :: String.t()
  def datetime(datetime), do: Timex.format!(datetime, "%F %T", :strftime)
end
