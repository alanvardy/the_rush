defmodule TheRushWeb.Live.PlayerStatisticsTable do
  use Phoenix.LiveView
  @moduledoc "LiveView for adding equipment consumables to equipment"

  alias Phoenix.LiveView.{Rendered, Socket}
  alias TheRush.PlayerStatistics

  @spec mount(:not_mounted_at_router, any, Socket.t()) :: {:ok, Socket.t()}
  def mount(:not_mounted_at_router, %{"record_quantity" => quantity}, socket) do
    query =
      PlayerStatistics.new_query(quantity)
      |> PlayerStatistics.get()

    {:ok, assign(socket, query: query)}
  end

  @spec render(map) :: Rendered.t()
  def render(assigns), do: TheRushWeb.PageView.render("_table.html", assigns)

  @doc "Sort a column when user clicks sort, reverses direction of sort if column already sorted"
  def handle_event("sort", %{"column" => column}, %{assigns: %{query: query}} = socket) do
    query =
      query
      |> PlayerStatistics.change_sort(column)
      |> PlayerStatistics.get()

    {:noreply, assign(socket, query: query)}
  end

  @doc "Search players when typing into search field while maintaining sort"
  def handle_event(
        "search",
        %{"search" => %{"search" => search}},
        %{assigns: %{query: query}} = socket
      ) do
    query =
      query
      |> PlayerStatistics.change_search(search)
      |> PlayerStatistics.get()

    {:noreply, assign(socket, query: query)}
  end
end
