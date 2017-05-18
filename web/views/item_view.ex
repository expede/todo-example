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
end
