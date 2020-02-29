defmodule TheRushWeb.PageView do
  use TheRushWeb, :view

  alias ExEffectiveBootstrap.Icons

  @doc "Make a sort button and show a chevron if column is sorted, takes the current column and the sort variable"
  @spec build_sort(any, any) :: {:safe, iolist}
  def build_sort(col, {col, :desc}) do
    content_tag(:span, ["sort", Icons.icon("chevron-down")], class: "text-muted")
  end

  def build_sort(col, {col, :asc}) do
    content_tag(:span, ["sort", Icons.icon("chevron-up")], class: "text-muted")
  end

  def build_sort(_, _) do
    content_tag(:span, "sort", class: "text-muted mr-2")
  end

  @doc "Color the cell if it is in a sorted column, takes the current column and the sort variable"
  @spec cell_class(String.t(), any) :: String.t()
  def cell_class(column, {column, _}), do: "table-active"
  def cell_class(_, _), do: ""
end
