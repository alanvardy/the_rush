defmodule TheRushWeb.PageController do
  use TheRushWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
