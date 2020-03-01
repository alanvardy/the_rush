defmodule TheRushWeb.Router do
  use TheRushWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", TheRushWeb do
    pipe_through :browser

    get "/", PageController, :default
    get "/ten_thousand", PageController, :ten_thousand
    resources "/csv_export", CsvExportController, only: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TheRushWeb do
  #   pipe_through :api
  # end
end
