defmodule TheRush.PlayerStatistics do
  @moduledoc "Handles getting and sorting NFL player statistical data"

  alias TheRush.PlayerStatistics.{Paginate, Query, Request, Search, Sort}

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
end
