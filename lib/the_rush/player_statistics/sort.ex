defmodule TheRush.PlayerStatistics.Sort do
  @moduledoc "For sorting information by a particular column"
  alias TheRush.PlayerStatistics.Query

  @doc "For sorting data list on initial load"
  @spec presort([map]) :: [map]
  def presort(data) do
    Enum.sort(data, &(&1["Player"] <= &2["Player"]))
  end

  @doc """
    Trigger a new sort next execute, which means the data will also
    need to be repaginated. Reset to first page.
  """
  @spec change(Query.t(), {String.t(), :asc | :desc}) :: Query.t()
  def change(%Query{sort: {col, direction}} = query, column) do
    sort =
      if col == column do
        {column, reverse(direction)}
      else
        {column, :desc}
      end

    %Query{query | sort: sort, sorted_data: nil, paginated_data: nil, page: 1}
  end

  @doc "Run the sort if previously triggered"
  @spec execute(Query.t()) :: Query.t()
  def execute(%Query{searched_data: searched_data, sort: {col, :desc}, sorted_data: nil} = query) do
    %Query{query | sorted_data: Enum.sort(searched_data, &(&1[col] <= &2[col]))}
  end

  def execute(%Query{searched_data: searched_data, sort: {col, :asc}, sorted_data: nil} = query) do
    %Query{query | sorted_data: Enum.sort(searched_data, &(&1[col] >= &2[col]))}
  end

  # Pass through if no sorting needed
  def execute(%Query{} = query), do: query

  defp reverse(:asc), do: :desc
  defp reverse(:desc), do: :asc
end
