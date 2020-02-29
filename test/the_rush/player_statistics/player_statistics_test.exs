defmodule TheRush.PlayerStatistics.SortTest do
  @moduledoc false
  use TheRushWeb.ConnCase, async: true

  alias TheRush.PlayerStatistics.Sort

  @data [
    %{"field1" => 456, "field2" => "hij", "field3" => :apple},
    %{"field1" => 123, "field2" => "def", "field3" => :banana},
    %{"field1" => 789, "field2" => "abc", "field3" => :carrot}
  ]

  describe "run/1" do
    test "just returns the data when no sort is defined" do
      assert Sort.run(%{data: @data}) == @data
      assert Sort.run(%{data: @data, sort: nil}) == @data
      assert Sort.run(%{data: @data, sort: :complete_nonsense}) == @data
    end

    test "can sort descending" do
      assert Sort.run(%{data: @data, sort: {"field1", :desc}}) == [
               %{"field1" => 123, "field2" => "def", "field3" => :banana},
               %{"field1" => 456, "field2" => "hij", "field3" => :apple},
               %{"field1" => 789, "field2" => "abc", "field3" => :carrot}
             ]

      assert Sort.run(%{data: @data, sort: {"field2", :desc}}) == [
               %{"field1" => 789, "field2" => "abc", "field3" => :carrot},
               %{"field1" => 123, "field2" => "def", "field3" => :banana},
               %{"field1" => 456, "field2" => "hij", "field3" => :apple}
             ]
    end
  end

  test "can sort ascending" do
    assert Sort.run(%{data: @data, sort: {"field1", :asc}}) == [
             %{"field1" => 789, "field2" => "abc", "field3" => :carrot},
             %{"field1" => 456, "field2" => "hij", "field3" => :apple},
             %{"field1" => 123, "field2" => "def", "field3" => :banana}
           ]

    assert Sort.run(%{data: @data, sort: {"field3", :asc}}) == [
             %{"field1" => 789, "field2" => "abc", "field3" => :carrot},
             %{"field1" => 123, "field2" => "def", "field3" => :banana},
             %{"field1" => 456, "field2" => "hij", "field3" => :apple}
           ]
  end
end
