defmodule TheRush.PlayerStatisticsTest do
  @moduledoc false
  use TheRushWeb.ConnCase, async: true

  alias TheRush.PlayerStatistics
  alias TheRush.PlayerStatistics.{Search, Sort}

  @data [
          %{"Player" => "Donald Duck", "field1" => 123, "Team" => "def", "field3" => :banana},
          %{"Player" => "Goofy", "field1" => 456, "Team" => "hij", "field3" => :apple},
          %{"Player" => "Porky Pig", "field1" => 789, "Team" => "abc", "field3" => :carrot}
        ]
        |> Search.build_search_fields()
        |> Sort.build_sort_fields()
        |> Sort.presort()

  @query PlayerStatistics.new_query(:default)
         |> Map.put(:data, @data)
         |> Map.put(:searched_data, @data)

  @large_data (for num <- 1..51 do
                 %{"Player" => "player#{num}"}
               end)
              |> Search.build_search_fields()
              |> Sort.build_sort_fields()
              |> Sort.presort()

  @large_query PlayerStatistics.new_query(:default)
               |> Map.put(:data, @large_data)
               |> Map.put(:searched_data, @large_data)

  describe "change_sort/2" do
    test "Sorts Players descending the first time" do
      expected_data = [
        %{"Player" => "Porky Pig", "field1" => 789, "Team" => "abc", "field3" => :carrot},
        %{"Player" => "Goofy", "field1" => 456, "Team" => "hij", "field3" => :apple},
        %{"Player" => "Donald Duck", "field1" => 123, "Team" => "def", "field3" => :banana}
      ]

      result =
        @query
        |> PlayerStatistics.change_sort("Player")
        |> PlayerStatistics.get()
        |> Map.get(:paginated_data)
        |> filter()

      assert result == expected_data
    end

    test "sorts letters ascending the first time if in an alphanumeric field" do
      expected_data = [
        %{"Player" => "Porky Pig", "field1" => 789, "Team" => "abc", "field3" => :carrot},
        %{"Player" => "Donald Duck", "field1" => 123, "Team" => "def", "field3" => :banana},
        %{"Player" => "Goofy", "field1" => 456, "Team" => "hij", "field3" => :apple}
      ]

      result =
        @query
        |> PlayerStatistics.change_sort("Team")
        |> PlayerStatistics.get()
        |> Map.get(:paginated_data)
        |> filter()

      assert result == expected_data
    end

    test "sorts numbers descending the first time" do
      expected_data = [
        %{"Player" => "Porky Pig", "field1" => 789, "Team" => "abc", "field3" => :carrot},
        %{"Player" => "Goofy", "field1" => 456, "Team" => "hij", "field3" => :apple},
        %{"Player" => "Donald Duck", "field1" => 123, "Team" => "def", "field3" => :banana}
      ]

      result =
        @query
        |> PlayerStatistics.change_sort("field1")
        |> PlayerStatistics.get()
        |> Map.get(:paginated_data)
        |> filter()

      assert result == expected_data
    end

    test "sorts numbers ascending the second time" do
      expected_data = [
        %{"Player" => "Donald Duck", "field1" => 123, "Team" => "def", "field3" => :banana},
        %{"Player" => "Goofy", "field1" => 456, "Team" => "hij", "field3" => :apple},
        %{"Player" => "Porky Pig", "field1" => 789, "Team" => "abc", "field3" => :carrot}
      ]

      result =
        @query
        |> PlayerStatistics.change_sort("field1")
        |> PlayerStatistics.get()
        |> PlayerStatistics.change_sort("field1")
        |> PlayerStatistics.get()
        |> Map.get(:paginated_data)
        |> filter()

      assert result == expected_data
    end
  end

  describe "change_search/2" do
    test "returns all the rows when an empty string is searched" do
      expected_data = [
        %{"Player" => "Donald Duck", "field1" => 123, "Team" => "def", "field3" => :banana},
        %{"Player" => "Goofy", "field1" => 456, "Team" => "hij", "field3" => :apple},
        %{"Player" => "Porky Pig", "field1" => 789, "Team" => "abc", "field3" => :carrot}
      ]

      result =
        @query
        |> PlayerStatistics.change_search("")
        |> PlayerStatistics.get()
        |> Map.get(:paginated_data)
        |> filter()

      assert result == expected_data
    end

    test "is idempotent" do
      expected_data = [
        %{"Player" => "Donald Duck", "field1" => 123, "Team" => "def", "field3" => :banana},
        %{"Player" => "Goofy", "field1" => 456, "Team" => "hij", "field3" => :apple},
        %{"Player" => "Porky Pig", "field1" => 789, "Team" => "abc", "field3" => :carrot}
      ]

      result =
        @query
        |> PlayerStatistics.change_search("")
        |> PlayerStatistics.get()
        |> PlayerStatistics.get()
        |> PlayerStatistics.get()
        |> Map.get(:paginated_data)
        |> filter()

      assert result == expected_data
    end

    test "search is case insensitive" do
      expected_data = [
        %{"Player" => "Donald Duck", "field1" => 123, "Team" => "def", "field3" => :banana}
      ]

      result =
        @query
        |> PlayerStatistics.change_search("duc")
        |> PlayerStatistics.get()
        |> Map.get(:paginated_data)
        |> filter()

      assert result == expected_data
    end

    test "search ignores spaces" do
      expected_data = [
        %{"Player" => "Porky Pig", "field1" => 789, "Team" => "abc", "field3" => :carrot}
      ]

      result =
        @query
        |> PlayerStatistics.change_search("kypi g")
        |> PlayerStatistics.get()
        |> Map.get(:paginated_data)
        |> filter()

      assert result == expected_data
    end
  end

  describe "change_page/2" do
    test "shows the first page by default" do
      result =
        @large_query
        |> PlayerStatistics.get()
        |> Map.get(:paginated_data)
        |> filter()

      assert Enum.count(result) == 50
    end

    test "can get the second page" do
      result =
        @large_query
        |> PlayerStatistics.change_page("2")
        |> PlayerStatistics.get()
        |> Map.get(:paginated_data)
        |> filter()

      assert Enum.count(result) == 1
    end
  end

  defp filter(data) when is_list(data) do
    Enum.map(data, &filter/1)
  end

  @calculated_rows ["Lng_sort", "Yds_sort", "player_search"]

  defp filter(row) when is_map(row) do
    row
    |> Enum.reject(fn {k, _v} -> k in @calculated_rows end)
    |> Enum.into(%{})
  end
end
