defmodule TheRushWeb.PageView do
  use TheRushWeb, :view

  alias ExEffectiveBootstrap.Icons

  @doc "Make a sort button and show a chevron if column is sorted"
  @spec build_sort(any, any) :: {:safe, iolist} | String.t()
  def build_sort(col, {col, :desc}) do
    content_tag(:span, ["sort", Icons.icon("chevron-down")], [])
  end

  def build_sort(col, {col, :asc}) do
    content_tag(:span, ["sort", Icons.icon("chevron-up")], [])
  end

  def build_sort(_, _) do
    "sort  "
  end
end
