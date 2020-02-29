defmodule TheRush.PlayerStatistics.Sort do
  @moduledoc "For sorting information by a particular column"

  def presort(statistics) do
    %{data: statistics, sort: {"Player", :desc}}
    |> run()
    |> Map.get(:data)
  end

  @spec run(map) :: map
  def run(%{sort: nil} = struct), do: struct

  def run(%{data: data, sort: {col, :desc}} = struct) do
    %{struct | data: Enum.sort(data, &(&1[col] <= &2[col]))}
  end

  def run(%{data: data, sort: {col, :asc}} = struct) do
    %{struct | data: Enum.sort(data, &(&1[col] >= &2[col]))}
  end

  def run(%{data: data}), do: data
end
