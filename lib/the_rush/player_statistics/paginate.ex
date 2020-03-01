defmodule TheRush.PlayerStatistics.Paginate do
  @moduledoc "For paginating queries"

  alias TheRush.PlayerStatistics.Query
  use Phoenix.HTML

  @doc "Change the page, don't need to trigger pagination because pagination runs every time"
  @spec change(Query.t(), String.t()) :: Query.t()
  def change(query, page) do
    %Query{query | page: String.to_integer(page)}
  end

  @spec execute(Query.t()) :: Query.t()
  def execute(%Query{sorted_data: sorted_data, per_page: per_page, page: page} = query) do
    start_index = (page - 1) * per_page
    end_index = page * per_page

    paginated_data = Enum.slice(sorted_data, start_index..end_index)
    %Query{query | paginated_data: paginated_data}
  end

  @doc "Builds the pagination selector with page numbers, next and back etc."
  @spec build(map) :: {:safe, iolist}
  def build(%Query{page: page} = query) do
    pages = page_count(query)

    ([paginate_button("Previous", page, pages)] ++
       numbered_buttons(page, pages) ++
       [paginate_button("Next", page, pages)])
    |> contag(:ul, class: "pagination pagination-sm")
    |> contag(:nav, class: "mt-1 mt-xl-0")
  end

  # Handle the case where there is only a single page, just gives us some disabled buttons
  @spec numbered_buttons(integer, integer) :: [{:safe, iolist}]
  defp numbered_buttons(_page, 0) do
    [paginate_button(1, 1, 1)]
  end

  defp numbered_buttons(page, pages) do
    pages
    |> filter_pages(page)
    |> Enum.map(fn x -> paginate_button(x, page, pages) end)
  end

  # A partial page is still a page.
  defp page_count(%Query{count: count, per_page: per_page}) do
    if rem(count, per_page) > 0 do
      div(count, per_page) + 1
    else
      div(count, per_page)
    end
  end

  @spec paginate_button(String.t() | integer, integer, integer) :: {:safe, iolist}
  defp paginate_button("Next", page, pages) when page == pages do
    contag("Next", :a, class: "page-link text-center mt-1", tabindex: "-1")
    |> contag(:li, class: "page-item disabled")
  end

  defp paginate_button("Previous", 1, _pages) do
    contag("Previous", :a, class: "page-link text-center mt-1", tabindex: "-1")
    |> contag(:li, class: "page-item disabled")
  end

  defp paginate_button("....", _page, _pages) do
    contag("....", :a, class: "page-link text-center mt-1 pagination-width", tabindex: "-1")
    |> contag(:li, class: "page-item disabled")
  end

  defp paginate_button("Next", page, _pages) do
    contag("Next", :a,
      class: "page-link text-center mt-1",
      style: "cursor: pointer",
      "phx-click": "change_page",
      "phx-value-page": page + 1
    )
    |> contag(:li, class: "exz-pagination-li")
  end

  defp paginate_button("Previous", page, _pages) do
    contag("Previous", :a,
      class: "page-link text-center mt-1",
      style: "cursor: pointer",
      "phx-click": "change_page",
      "phx-value-page": page - 1
    )
    |> contag(:li, class: "exz-pagination-li")
  end

  defp paginate_button(same, same, _pages) do
    contag(same, :a, class: "page-link text-center mt-1 pagination-width")
    |> contag(:li, class: "page-item active")
  end

  defp paginate_button(label, _page, _pages) do
    contag(label, :a,
      class: "page-link text-center mt-1 pagination-width",
      style: "cursor: pointer",
      "phx-click": "change_page",
      "phx-value-page": label
    )
    |> contag(:li, class: "page-item")
  end

  @doc "Selects the page buttons we need for pagination"
  @spec filter_pages(integer, integer) :: [String.t() | Integer]
  def filter_pages(pages, _page) when pages <= 7, do: 1..pages

  def filter_pages(pages, page) when page in [1, 2, 3, pages - 2, pages - 1, pages] do
    [1, 2, 3, "....", pages - 2, pages - 1, pages]
  end

  def filter_pages(pages, page) do
    [1, "...."] ++ [page - 1, page, page + 1] ++ ["....", pages]
  end

  # Used everywhere to make it easier to pipe HTML chunks into each other
  @spec contag(any(), atom, keyword) :: {:safe, iolist}
  defp contag(body, tag, opts), do: content_tag(tag, body, opts)
end
