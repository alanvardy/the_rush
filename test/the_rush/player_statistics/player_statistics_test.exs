defmodule TheRush.PlayerStatistics.SortTest do
  @moduledoc false
  use TheRushWeb.ConnCase, async: true

  alias TheRush.PlayerStatistics.Sort

  @struct %{
    data: [
      %{"field1" => 123, "field2" => "def", "field3" => :banana},
      %{"field1" => 456, "field2" => "hij", "field3" => :apple},
      %{"field1" => 789, "field2" => "abc", "field3" => :carrot}
    ],
    sort: {"field1", :desc},
    search: ""
  }

  describe "run/1" do
    test "just returns the data when no sort is defined" do
      assert Sort.run(@struct) == @struct
    end

    test "can sort descending" do
      sort = {"field2", :desc}
      input = %{@struct | sort: sort}

      output = %{
        sort: sort,
        search: "",
        data: [
          %{"field1" => 789, "field2" => "abc", "field3" => :carrot},
          %{"field1" => 123, "field2" => "def", "field3" => :banana},
          %{"field1" => 456, "field2" => "hij", "field3" => :apple}
        ]
      }

      assert Sort.run(input) == output
    end

    test "can sort descending again" do
      sort = {"field3", :desc}
      input = %{@struct | sort: sort}

      output = %{
        sort: sort,
        search: "",
        data: [
          %{"field1" => 456, "field2" => "hij", "field3" => :apple},
          %{"field1" => 123, "field2" => "def", "field3" => :banana},
          %{"field1" => 789, "field2" => "abc", "field3" => :carrot}
        ]
      }

      assert Sort.run(input) == output
    end

    test "can sort ascending" do
      sort = {"field1", :asc}
      input = %{@struct | sort: sort}

      output = %{
        sort: sort,
        search: "",
        data: [
          %{"field1" => 789, "field2" => "abc", "field3" => :carrot},
          %{"field1" => 456, "field2" => "hij", "field3" => :apple},
          %{"field1" => 123, "field2" => "def", "field3" => :banana}
        ]
      }

      assert Sort.run(input) == output
    end

    test "can sort ascending again" do
      sort = {"field2", :asc}
      input = %{@struct | sort: sort}

      output = %{
        sort: sort,
        search: "",
        data: [
          %{"field1" => 456, "field2" => "hij", "field3" => :apple},
          %{"field1" => 123, "field2" => "def", "field3" => :banana},
          %{"field1" => 789, "field2" => "abc", "field3" => :carrot}
        ]
      }

      assert Sort.run(input) == output
    end
  end
end
