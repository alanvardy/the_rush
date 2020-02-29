defmodule TheRush.PlayerStatistics.Search do
  @moduledoc "For filtering player statistics by name"

  @doc "The main search function, "
  @spec run(map) :: map
  def run(%{search: search} = struct) when search in ["", nil], do: struct

  def run(%{data: data, search: search} = struct) do
    data = Enum.filter(data, fn row -> String.contains?(row["player_search"], search) end)

    %{struct | data: data}
  end

  def run(struct), do: struct

  @letters ~r/[a-zA-Z]/

  @doc "Takes a string and makes it only lowercase letters for search purposes"
  @spec sanitize(String.t()) :: String.t()
  def sanitize(string) do
    @letters
    |> Regex.scan(string)
    |> Enum.join()
    |> String.downcase()
  end

  @doc "Puts a new sanitized field on statistics for search purposes"
  @spec build_search_fields([map]) :: [map]
  def build_search_fields(statistics) do
    Enum.map(statistics, &Map.put(&1, "player_search", sanitize(&1["Player"])))
  end
end
