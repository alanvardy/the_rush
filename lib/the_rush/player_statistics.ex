defmodule TheRush.PlayerStatistics do
  @moduledoc "Handles getting and sorting NFL player statistical data"

  alias TheRush.PlayerStatistics.Sort

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
    @data
    |> build_map(opts)
    |> Sort.run()
  end

  defp build_map(data, opts) do
    %{
      data: data,
      sort: Keyword.get(opts, :sort)
    }
  end
end
