defmodule TheRush.PlayerStatistics.SortTest do
  @moduledoc false
  use TheRushWeb.ConnCase, async: true

  alias TheRush.PlayerStatistics.{Request, Sort}

  @data [
    %{"field1" => 123, "field2" => "def", "field3" => :banana},
    %{"field1" => 456, "field2" => "hij", "field3" => :apple},
    %{"field1" => 789, "field2" => "abc", "field3" => :carrot}
  ]
  @query Request.new(:default)
         |> Map.put(:data, @data)
         |> Map.put(:searched_data, @data)

  describe "run/1" do
    test "can sort descending" do
      expected_data = [
        %{"field1" => 789, "field2" => "abc", "field3" => :carrot},
        %{"field1" => 123, "field2" => "def", "field3" => :banana},
        %{"field1" => 456, "field2" => "hij", "field3" => :apple}
      ]

      result =
        @query
        |> Sort.change("field2")
        |> Sort.execute()
        |> Map.get(:sorted_data)

      assert result == expected_data
    end

    test "can sort descending again" do
      expected_data = [
        %{"field1" => 456, "field2" => "hij", "field3" => :apple},
        %{"field1" => 123, "field2" => "def", "field3" => :banana},
        %{"field1" => 789, "field2" => "abc", "field3" => :carrot}
      ]

      result =
        @query
        |> Sort.change("field3")
        |> Sort.execute()
        |> Map.get(:sorted_data)

      assert result == expected_data
    end

    test "can sort ascending" do
      expected_data = [
        %{"field1" => 789, "field2" => "abc", "field3" => :carrot},
        %{"field1" => 456, "field2" => "hij", "field3" => :apple},
        %{"field1" => 123, "field2" => "def", "field3" => :banana}
      ]

      result =
        @query
        |> Sort.change("field1")
        |> Sort.execute()
        |> Sort.change("field1")
        |> Sort.execute()
        |> Map.get(:sorted_data)

      assert result == expected_data
    end

    test "can sort ascending again" do
      expected_data = [
        %{"field1" => 456, "field2" => "hij", "field3" => :apple},
        %{"field1" => 123, "field2" => "def", "field3" => :banana},
        %{"field1" => 789, "field2" => "abc", "field3" => :carrot}
      ]

      result =
        @query
        |> Sort.change("field2")
        |> Sort.execute()
        |> Sort.change("field2")
        |> Sort.execute()
        |> Map.get(:sorted_data)

      assert result == expected_data
    end
  end
end
