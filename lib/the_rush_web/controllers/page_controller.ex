defmodule TheRushWeb.PageController do
  use TheRushWeb, :controller

  @spec default(Plug.Conn.t(), any) :: Plug.Conn.t()
  def default(conn, _params) do
    render(conn, "index.html", record_quantity: :default)
  end

  @spec ten_thousand(Plug.Conn.t(), any) :: Plug.Conn.t()
  def ten_thousand(conn, _params) do
    render(conn, "index.html", record_quantity: :ten_thousand)
  end
end
