defmodule TheRush.PlayerStatistics do
  @moduledoc "Handles getting and sorting NFL player statistical data"

  alias TheRush.PlayerStatistics.{Csv, Find, Paginate, Query, Request, Search, Sort}

  @doc """
  Runs a query through search, sort and paginate, rerunning each as needed.
  If one runs then the others after need to alter the query as well

  i.e. if Sort alters the query, then paginate needs to as well.
  """
  @spec get(Query.t()) :: Query.t()
  def get(query) do
    query
    |> Search.execute()
    |> Sort.execute()
    |> Paginate.execute()
  end

  defdelegate new_query(quantity), to: Request, as: :new
  defdelegate change_search(query, column), to: Search, as: :change
  defdelegate change_sort(query, column), to: Sort, as: :change
  defdelegate change_page(query, column), to: Paginate, as: :change

  defdelegate find_serialized_pid(), to: Find, as: :serialized_pid
  defdelegate find_query(serialized_pid), to: Find, as: :query
  defdelegate export_csv(conn, query), to: Csv, as: :export
end
