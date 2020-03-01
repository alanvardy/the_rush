defmodule TheRushWeb.CsvExportController do
  use TheRushWeb, :controller

  alias TheRush.PlayerStatistics.Csv

  @spec create(Plug.Conn.t(), any) :: Plug.Conn.t()
  def create(conn, %{"csv_export" => %{"serialized_pid" => serialized_pid}}) do
    query = Csv.get_query(serialized_pid)
    Csv.export(conn, query)
  end
end
