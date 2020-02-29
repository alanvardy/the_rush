defmodule TheRush.PlayerStatistics.Search do
  @moduledoc "For filtering player statistics by name"

  @spec run(map) :: map
  def run(%{search: search} = struct) when search in ["", nil], do: struct

  def run(%{data: data, search: search} = struct) do
    data = Enum.filter(data, fn row -> String.contains?(row["player_search"], search) end)

    %{struct | data: data}
  end

  def run(struct), do: struct

  @letters ~r/[a-zA-Z]/

  @spec sanitize(String.t()) :: String.t()
  def sanitize(string) do
    @letters
    |> Regex.scan(string)
    |> Enum.join()
    |> String.downcase()
  end

  def build_search_fields(statistics) do
    Enum.map(statistics, &Map.put(&1, "player_search", sanitize(&1["Player"])))
  end
end
