defmodule TheRush.PlayerStatistics.Request do
  @moduledoc "For requesting data from a mythical API"
  alias TheRush.PlayerStatistics.{Query, Search, Sort}

  @default "json/rushing.json"
           |> File.read!()
           |> Jason.decode!()
           |> Search.build_search_fields()
           |> Sort.presort()

  @ten_thousand Enum.reduce(1..31, [], fn _, acc -> @default ++ acc end) |> Sort.presort()

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

  @doc "Creates a new query struct with default values"
  @spec new(:default | :ten_thousand) :: Query.t()
  def new(quantity) do
    data =
      case quantity do
        :default -> @default
        :ten_thousand -> @ten_thousand
      end

    %Query{
      data: data,
      searched_data: nil,
      sorted_data: nil,
      paginated_data: nil,
      search: "",
      per_page: 50,
      sort: {"Player", :desc},
      page: 1,
      fields: @fields
    }
  end
end
