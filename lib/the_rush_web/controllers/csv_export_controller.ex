defmodule TheRushWeb.CsvExportController do
  use TheRushWeb, :controller

  alias TheRush.PlayerStatistics

  @spec create(Plug.Conn.t(), any) :: Plug.Conn.t()
  def create(conn, %{"csv_export" => %{"serialized_pid" => serialized_pid}}) do
    query = PlayerStatistics.find_query(serialized_pid)
    PlayerStatistics.export_csv(conn, query)
  end
end
