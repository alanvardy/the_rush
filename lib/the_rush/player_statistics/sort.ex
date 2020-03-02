defmodule TheRush.PlayerStatistics.Sort do
  @moduledoc "For sorting information by a particular column"
  alias TheRush.PlayerStatistics.Query

  @doc "For sorting data list on initial load"
  @spec presort([map]) :: [map]
  def presort(data) do
    Enum.sort(data, &(&1["Player"] >= &2["Player"]))
  end

  # Alphanumeric columns
  @alpha_columns ["Player", "Team", "Pos"]

  # Columns that have digits mixed with other characters need to have them extracted
  @mixed_columns ["Lng", "Yds"]

  def mixed_columns, do: @mixed_columns

  @doc """
    Trigger a new sort next execute, which means the data will also
    need to be repaginated. Reset to first page.
    Alphanumeric fields are sorted ascending to start
    Numerical fields are sorted descending to start
  """
  @spec change(Query.t(), {String.t(), :asc | :desc}) :: Query.t()
  def change(%Query{sort: {col, direction}} = query, column) do
    sort =
      case {column, col} do
        {same, same} -> {col, reverse(direction)}
        {column, _} when column in @alpha_columns -> {column, :asc}
        {column, _} -> {column, :desc}
      end

    %Query{query | sort: sort, sorted_data: nil, paginated_data: nil, page: 1}
  end

  @doc "Run the sort if previously triggered"
  @spec execute(Query.t()) :: Query.t()
  def execute(%Query{sorted_data: nil} = query) do
    %Query{searched_data: searched_data, sort: {col, dir}} = query

    sort_fn =
      case {col, dir} do
        {col, :asc} when col in @mixed_columns -> &(&1["#{col}_sort"] <= &2["#{col}_sort"])
        {col, :desc} when col in @mixed_columns -> &(&1["#{col}_sort"] >= &2["#{col}_sort"])
        {col, :asc} -> &(&1[col] <= &2[col])
        {col, :desc} -> &(&1[col] >= &2[col])
      end

    %Query{query | sorted_data: Enum.sort(searched_data, sort_fn)}
  end

  # Pass through if no sorting needed
  def execute(%Query{} = query), do: query

  defp reverse(:asc), do: :desc
  defp reverse(:desc), do: :asc

  @doc """
  Puts a new processed sort field with the suffix _sort in the data for search
  purposes, takes data and a list of the columns that need to be processed
  """
  @spec build_sort_fields([map], [String.t()]) :: [map]
  def build_sort_fields(data, columns \\ @mixed_columns)
  def build_sort_fields(data, []), do: data

  def build_sort_fields(data, [column | tail]) do
    data
    |> Enum.map(&Map.put(&1, "#{column}_sort", extract_integer(&1, column)))
    |> build_sort_fields(tail)
  end

  # Pull an integer out of the string, return 0 if no success
  defp extract_integer(row, column) do
    with lng <- row[column],
         {:string, string} <- is_string?(lng),
         {:ok, match} <- get_digits(string) do
      String.to_integer(match)
    else
      {:number, number} -> number
      {:error, :no_match} -> 0
    end
  end

  defp is_string?(string) when is_binary(string), do: {:string, string}
  defp is_string?(number), do: {:number, number}

  defp get_digits(string) do
    case Regex.scan(~r/\d/, string) do
      [] -> {:error, :no_match}
      list -> {:ok, Enum.join(list)}
    end
  end
end
