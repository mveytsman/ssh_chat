defmodule SshChat.Web.Router do
  use SshChat.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug Ueberauth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SshChat.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/auth", SshChat.Web do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", SshChat.Web do
  #   pipe_through :api
  # end
end
