defmodule TheRushWeb.PageViewTest do
  use TheRushWeb.ConnCase, async: true
  alias TheRushWeb.PageView

  describe "build_sort/2" do
    test "builds an ascending sort link" do
      sort_link =
        PageView.build_sort("column_name", {"column_name", :asc})
        |> Phoenix.HTML.safe_to_string()

      assert sort_link =~ "eb-icon-chevron-up"
    end

    test "builds an descending sort link" do
      sort_link =
        PageView.build_sort("column_name", {"column_name", :desc})
        |> Phoenix.HTML.safe_to_string()

      assert sort_link =~ "eb-icon-chevron-down"
    end

    test "builds a sort link without chevrons when different column" do
      sort_link =
        PageView.build_sort("column_name", {"different_column", :desc})
        |> Phoenix.HTML.safe_to_string()

      refute sort_link =~ "eb-icon-chevron-up"
      refute sort_link =~ "eb-icon-chevron-down"
    end
  end
end
