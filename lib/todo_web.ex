defmodule TodoWeb do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use TodoWeb.Web, :controller
      use TodoWeb.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: TodoWeb

      alias Todo.Accounts.User
      alias Todo.Lists.{List, Item}

      alias Todo.Repo
      import Ecto
      import Ecto.Query

      import TodoWeb.Router.Helpers
      import TodoWeb.Gettext
    end
  end

  def view do
    quote do
      alias Todo.Accounts.User
      alias Todo.Lists.{List, Item}

      use Phoenix.View,
        root: "lib/todo_web/templates",
        namespace: TodoWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [
        get_csrf_token: 0,
        get_flash: 2,
        view_module: 1,
        action_name: 1,
        controller_module: 1
      ]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import TodoWeb.Router.Helpers
      import TodoWeb.ErrorHelpers
      import TodoWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Todo.Repo
      import Ecto
      import Ecto.Query
      import TodoWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
