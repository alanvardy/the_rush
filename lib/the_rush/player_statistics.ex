defmodule TheRush.PlayerStatistics do
  @moduledoc "Handles getting and sorting NFL player statistical data"

  alias TheRush.PlayerStatistics.{Search, Sort}

  @data "json/rushing.json"
        |> File.read!()
        |> Jason.decode!()
        |> Search.build_search_fields()
        |> Sort.presort()

  @fields [
    {"Player", "Name"},
    {"Team", "Team"},
    {"Pos", "Position"},
    {"Att/G", ["Rushing Attempts / Game Avg"]},
    {"Att", "Rushing Attempts"},
    {"Yds", "Total Rushing Yards"},
    {"Avg", "Average Yards Per Attempt"},
    {"Yds/G", "Rushing Yards Per Game"},
    {"TD", "Total Rushing Touchdowns"},
    {"Lng", "Longest Rush (T = Touchdown)"},
    {"1st", "Rushing First Downs"},
    {"1st%", "Rushing First Down %"},
    {"20+", "Rushing 20+ Yards Each"},
    {"40+", "Rushing 40+ Yards Each"},
    {"FUM", "Rushing Fumbles"}
  ]

  @spec get_fields :: [{String.t(), String.t()}]
  def get_fields do
    @fields
  end

  @spec get_data(%{search: String.t(), sort: {String.t(), :asc | :desc}}) :: [map]
  def get_data(%{search: search, sort: sort}) do
    %{data: @data, search: search, sort: sort}
    |> Search.run()
    |> Sort.run()
    |> Map.get(:data)
  end

  defdelegate sanitize_search(string), to: Search, as: :sanitize
end
