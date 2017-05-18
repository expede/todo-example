defmodule Todo.ListView do
  @moduledoc "HTML view helpers for `List`s"

  use Todo.Web, :view

  @spec delete_confirmation(String.t()) :: String.t()
  def delete_confirmation(name) do
    """
    if(!confirm('Are you sure you want to delete the list \"#{name}\"?')) {
      return false;
    }
    """
  end

  @spec name_placeholder(User.t()) :: String.t()
  def name_placeholder(%{name: username}) when is_bitstring(username), do: username
  def name_placeholder(_), do: "List name"

  @spec notes_placeholder(User.t()) :: String.t()
  def notes_placeholder(%{notes: usernotes}) when is_bitstring(usernotes), do: usernotes
  def notes_placeholder(_), do: "Notes"

  @spec datetime(NaiveDateTime.t()) :: String.t()
  def datetime(datetime), do: Timex.format!(datetime, "%F %T", :strftime)
end
