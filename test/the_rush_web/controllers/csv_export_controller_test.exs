defmodule TheRushWeb.CsvExportControllerTest do
  use TheRushWeb.ConnCase

  alias TheRush.{MockGenServer, PlayerStatistics}
  alias TheRush.PlayerStatistics.{Search, Sort}

  @data [
          %{"Player" => "Donald Duck"},
          %{"Player" => "Goofy"},
          %{"Player" => "Porky Pig"}
        ]
        |> Search.build_search_fields()
        |> Sort.build_sort_fields()
        |> Sort.presort()

  @query PlayerStatistics.new_query(:default)
         |> Map.put(:data, @data)
         |> Map.put(:searched_data, @data)
         |> PlayerStatistics.get()

  test "can export a csv file", %{conn: conn} do
    {:ok, _pid} = MockGenServer.start_link(@query)
    serialized_pid = MockGenServer.get_serialized_pid()

    params = %{csv_export: %{serialized_pid: serialized_pid}}
    conn = post(conn, Routes.csv_export_path(conn, :create), params)

    assert response(conn, 200) =~ "\uFEFFName,Team,Position,Rushing Attempts"
    assert response(conn, 200) =~ "Donald Duck"
    assert response_content_type(conn, :csv)
  end
end
