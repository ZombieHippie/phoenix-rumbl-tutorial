defmodule Rumbl.Router do
  use Rumbl.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Rumbl.Auth, repo: Rumbl.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Rumbl do
    pipe_through :browser # Use the default browser stack

    resources "/groups", GroupController, only: [:index, :new, :create]
    resources "/watch", WatchController, only: [:show]
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/oauth", OAuthController, only: [:show]
    resources "/sessions", SessionController, only: [:new, :create, :delete, :fb_oauth]
    get "/", PageController, :index
  end

  scope "/manage", Rumbl do
    pipe_through [:browser, :authenticate_user]

    resources "/videos", VideoController
  end
  # Other scopes may use custom stacks.
  # scope "/api", Rumbl do
  #   pipe_through :api
  # end
end
