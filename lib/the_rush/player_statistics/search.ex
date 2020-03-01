defmodule TheRush.PlayerStatistics.Search do
  @moduledoc "For filtering player statistics by name"
  alias TheRush.PlayerStatistics.Query

  @doc "Trigger a new search, which means that data will need to be searched, sorted, and paginated"
  @spec change(Query.t(), String.t()) :: Query.t()
  def change(query, search) do
    %Query{
      query
      | search: sanitize(search),
        searched_data: nil,
        sorted_data: nil,
        paginated_data: nil,
        page: 1,
        count: nil
    }
  end

  @doc """
  Execute the search if previously triggered, also need to reset
    - record count
    - page count
    - reset to first page
  """
  @spec execute(Query.t()) :: Query.t()
  # When searched_data is nil, execute the search
  def execute(%Query{data: data, search: search, searched_data: nil} = query) do
    searched_data =
      if search == "" do
        data
      else
        Enum.filter(data, fn row -> String.contains?(row["player_search"], search) end)
      end

    count = Enum.count(searched_data)

    %Query{query | searched_data: searched_data, count: count, page: 1}
  end

  # No search required
  def execute(%Query{} = query) do
    query
  end

  @letters ~r/[a-zA-Z]/

  @doc "Takes a string and makes it only lowercase letters for search purposes"
  @spec sanitize(String.t()) :: String.t()
  def sanitize(string) do
    @letters
    |> Regex.scan(string)
    |> Enum.join()
    |> String.downcase()
  end

  @doc "Puts a new sanitized field on the data for search purposes"
  @spec build_search_fields([map]) :: [map]
  def build_search_fields(data) do
    Enum.map(data, &Map.put(&1, "player_search", sanitize(&1["Player"])))
  end
end
