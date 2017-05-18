defmodule Todo.UserView do
  @moduledoc "HTML view helpers for `User`s"

  alias Todo.User
  use Todo.Web, :view

  @spec delete_confirmation(String.t()) :: String.t()
  def delete_confirmation(name) do
    """
    if(!confirm('Are you sure you want to delete #{name}?')) {
      return false;
    }
    """
  end

  @spec name_placeholder(User.t()) :: String.t()
  def name_placeholder(%{name: username}) when is_bitstring(username), do: username
  def name_placeholder(_), do: "User name"

  @spec avatar_url_placeholder(User.t()) :: String.t()
  def avatar_url_placeholder(%{avatar_url: avatar_url}) when is_bitstring(avatar_url), do: avatar_url
  def avatar_url_placeholder(_), do: "Avatar URL"

  @spec datetime(NaiveDateTime.t()) :: String.t()
  def datetime(datetime), do: Timex.format!(datetime, "%F %T", :strftime)
end
