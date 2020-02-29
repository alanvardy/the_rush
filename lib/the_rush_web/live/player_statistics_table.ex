defmodule TheRushWeb.Live.PlayerStatisticsTable do
  use Phoenix.LiveView
  @moduledoc "LiveView for adding equipment consumables to equipment"

  alias Phoenix.LiveView.Socket
  alias TheRush.PlayerStatistics

  @spec mount(:not_mounted_at_router, any, Socket.t()) :: {:ok, Socket.t()}
  def mount(:not_mounted_at_router, _, socket) do
    assigns = [
      statistics: PlayerStatistics.get_data(),
      fields: PlayerStatistics.get_fields(),
      sort: {"Player", :desc}
    ]

    {:ok, assign(socket, assigns)}
  end

  @spec render(map) :: Phoenix.LiveView.Rendered.t()
  def render(assigns), do: TheRushWeb.PageView.render("_table.html", assigns)

  @doc "Sort a column when user clicks sort, reverses direction of sort if column already sorted"
  def handle_event("sort", %{"column" => column}, socket) do
    %{assigns: %{sort: {sorted_column, direction}}} = socket

    sort =
      if sorted_column == column do
        {column, reverse(direction)}
      else
        {column, :desc}
      end

    assigns = [
      statistics: PlayerStatistics.get_data(sort: sort),
      sort: sort
    ]

    {:noreply, assign(socket, assigns)}
  end

  defp reverse(:asc), do: :desc
  defp reverse(:desc), do: :asc
end
