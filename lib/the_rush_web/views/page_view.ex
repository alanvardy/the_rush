defmodule TheRushWeb.PageView do
  use TheRushWeb, :view

  alias ExEffectiveBootstrap.Icons

  def build_sort(col, {col, :desc}) do
    content_tag(:span, ["sort", Icons.icon("chevron-down")], [])
  end

  def build_sort(col, {col, :asc}) do
    content_tag(:span, ["sort", Icons.icon("chevron-up")], [])
  end

  def build_sort(_, _) do
    "sort"
  end
end
