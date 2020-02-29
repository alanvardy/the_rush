defmodule TheRushWeb.Live.PlayerStatisticsTable do
  use Phoenix.LiveView
  @moduledoc "LiveView for adding equipment consumables to equipment"

  alias Phoenix.LiveView.Socket
  alias TheRush.PlayerStatistics

  @spec mount(:not_mounted_at_router, any, Socket.t()) :: {:ok, Socket.t()}
  def mount(:not_mounted_at_router, _, socket) do
    assigns = [
      statistics: PlayerStatistics.get_data(),
      field_labels: PlayerStatistics.get_field_labels(),
      field_columns: PlayerStatistics.get_field_columns()
    ]

    {:ok, assign(socket, assigns)}
  end

  @spec render(map) :: Phoenix.LiveView.Rendered.t()
  def render(assigns), do: TheRushWeb.PageView.render("_table.html", assigns)
end
