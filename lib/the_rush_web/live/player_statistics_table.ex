defmodule TheRushWeb.Live.PlayerStatisticsTable do
  use Phoenix.LiveView
  @moduledoc "LiveView for adding equipment consumables to equipment"

  alias Phoenix.LiveView.Socket
  alias TheRush.PlayerStatistics

  @spec mount(:not_mounted_at_router, any, Socket.t()) :: {:ok, Socket.t()}
  def mount(:not_mounted_at_router, _, socket) do
    search = ""
    sort = {"Player", :desc}
    statistics = PlayerStatistics.get_data(%{search: search, sort: sort})
    count = Enum.count(statistics)

    assigns = [
      statistics: statistics,
      fields: PlayerStatistics.get_fields(),
      sort: sort,
      search: search,
      count: count
    ]

    {:ok, assign(socket, assigns)}
  end

  @spec render(map) :: Phoenix.LiveView.Rendered.t()
  def render(assigns), do: TheRushWeb.PageView.render("_table.html", assigns)

  @doc "Sort a column when user clicks sort, reverses direction of sort if column already sorted"
  def handle_event("sort", %{"column" => column}, socket) do
    %{assigns: %{sort: {sorted_column, direction}, search: search}} = socket

    sort =
      if sorted_column == column do
        {column, reverse(direction)}
      else
        {column, :desc}
      end

    assigns = [
      statistics: PlayerStatistics.get_data(%{sort: sort, search: search}),
      sort: sort
    ]

    {:noreply, assign(socket, assigns)}
  end

  @doc "Search players when typing into search field while maintaining sort"
  def handle_event("search", %{"search" => %{"search" => search}}, socket) do
    %{assigns: %{sort: sort}} = socket

    search = PlayerStatistics.sanitize_search(search)
    statistics = PlayerStatistics.get_data(%{sort: sort, search: search})
    count = Enum.count(statistics)

    assigns = [
      statistics: statistics,
      search: search,
      count: count
    ]

    {:noreply, assign(socket, assigns)}
  end

  defp reverse(:asc), do: :desc
  defp reverse(:desc), do: :asc
end
