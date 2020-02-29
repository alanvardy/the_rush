defmodule TheRush.PlayerStatistics do
  alias TheRushWeb.Router.Helpers, as: Routes
  alias TheRushWeb.Endpoint

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

  @spec get_data :: [map]
  def get_data do
    @data
  end

  @spec get_fields :: [{String.t(), String.t()}]
  def get_fields do
    @fields
  end

  @spec get_field_columns :: [String.t()]
  def get_field_columns do
    Enum.map(@fields, fn field -> elem(field, 0) end)
  end

  @spec get_field_labels :: [String.t()]
  def get_field_labels do
    Enum.map(@fields, fn field -> elem(field, 1) end)
  end
end
