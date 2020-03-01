defmodule TheRushWeb.PageControllerTest do
  use TheRushWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "The Rush"
  end

  test "GET /ten_thousand", %{conn: conn} do
    conn = get(conn, "/ten_thousand")
    assert html_response(conn, 200) =~ "The Rush"
  end
end
