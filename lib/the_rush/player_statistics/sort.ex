defmodule TheRush.PlayerStatistics.Sort do
  @moduledoc "For sorting information by a particular column"

  @spec run(map) :: [map]
  def run(%{data: data, sort: {col, :desc}}), do: Enum.sort(data, &(&1[col] <= &2[col]))
  def run(%{data: data, sort: {col, :asc}}), do: Enum.sort(data, &(&1[col] >= &2[col]))
  def run(%{data: data}), do: data
end
