defmodule TheRush.PlayerStatistics.Query do
  @moduledoc "The struct holding all the state around player statistics"

  @enforce_keys [:data, :search, :page, :sort, :per_page, :fields]

  defstruct [
    # The original list of data
    :data,
    # Data after it has been searched
    :searched_data,
    # Data after it has been searched and sorted
    :sorted_data,
    # Data after it has been searched, sorted, and paginated
    :paginated_data,
    # How many records exist after being searched
    :count,
    # The current search query
    :search,
    # Column sorted and direction, default is {"Player", :desc}
    :sort,
    # Which page is currently being viewed
    :page,
    # How many records shown per page
    :per_page,
    # List of field keys and labels, i.e. {"Pos", "Position"}
    :fields
  ]

  @type t :: %__MODULE__{
          data: [map],
          searched_data: [map] | nil,
          sorted_data: [map] | nil,
          paginated_data: [map] | nil,
          count: non_neg_integer | nil,
          search: String.t(),
          sort: {String.t(), :asc | :desc},
          page: non_neg_integer,
          per_page: non_neg_integer,
          fields: [{String.t(), String.t()}]
        }
end
