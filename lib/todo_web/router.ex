defmodule TodoWeb.Router do
  use TodoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TodoWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController do
      get "/lists", ListController, :user_lists
    end

    resources "/lists", ListController do
      resources "/items", ItemController
    end
  end

  # Other scopes may use custom stacks.
  scope "/api", TodoWeb.API do
    pipe_through :api

    resources "/users", UserController do
      get "/lists",     ListController, :user_lists
      get "/completed", ItemController, :completed_for_user
    end

    resources "/lists", ListController do
      get "/items", ItemController, :list_items
    end

    resources "/items", ItemController
  end
end
