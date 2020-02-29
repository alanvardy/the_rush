defmodule TheRush.PlayerStatistics do

  @type player_data :: [map]
  @data "json/rushing.json"
        |> File.read!()
        |> Jason.decode!()
        |> Enum.sort(&(&1["Player"] <= &2["Player"]))

  @fields [
    {"Player", "Name"},
    {"Team", "Team"},
    {"Pos", "Position"},
    {"Att/G", "Average Attempts / Game"},
    {"Att", "Attempts"},
    {"Yds", "Total Rushing Yards"},
    {"Avg", "Average Yards Per Attempt"},
    {"Yds/G", "Yards Per Game"},
    {"TD", "Total Touchdowns"},
    {"Lng", "Longest (T = Touchdown)"},
    {"1st", "First Downs"},
    {"1st%", "First Down Percentage"},
    {"20+", "20+ Yards Each"},
    {"40+", "40+ Yards Each"},
    {"FUM", "Fumbles"}
  ]

  @spec get_fields :: [{String.t(), String.t()}]
  def get_fields do
    @fields
  end

  @spec get_data :: player_data
  @spec get_data(keyword) :: player_data
  def get_data(opts \\ []) do
    sort = Keyword.get(opts, :sort)

    @data
    |> maybe_sort(sort)
  end

  @spec maybe_sort(player_data, any) :: player_data
  defp maybe_sort(data, {col, :desc}), do: Enum.sort(data, &(&1[col] <= &2[col]))
  defp maybe_sort(data, {col, :asc}), do: Enum.sort(data, &(&1[col] >= &2[col]))
  defp maybe_sort(data, _), do: data
end
