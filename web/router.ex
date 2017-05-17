defmodule Todo.Router do
  use Todo.Web, :router

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

  scope "/", Todo do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Todo.API do
    pipe_through :api

    resources "/users", UserController do
      get "/completed", ItemController, :completed
      resources "/lists", ListController
    end

    resources "/lists", ListController do
      resources "/items", ItemController, only: [:index, :show]
    end

    resources "/items", ItemController
  end
end
