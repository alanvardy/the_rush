defmodule TheRush.PlayerStatistics.Paginate do
  @moduledoc "For paginating queries"

  alias TheRush.PlayerStatistics.Query

  @spec execute(Query.t()) :: Query.t()
  def execute(%Query{sorted_data: sorted_data, per_page: per_page, page: page} = query) do
    start_index = (page - 1) * per_page
    end_index = page * per_page

    paginated_data = Enum.slice(sorted_data, start_index..end_index)
    %Query{query | paginated_data: paginated_data}
  end
end
