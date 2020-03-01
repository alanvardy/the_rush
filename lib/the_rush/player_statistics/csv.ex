defmodule TheRush.PlayerStatistics.Csv do
  alias Phoenix.Controller

  alias TheRush.PlayerStatistics.Query

  @spec get_serialized_pid :: binary
  def get_serialized_pid do
    self()
    |> :erlang.term_to_binary()
    |> Base.url_encode64()
  end

  @spec get_query(binary) :: Query.t()
  def get_query(serialized_pid) do
    pid =
      serialized_pid
      |> Base.url_decode64!()
      |> :erlang.binary_to_term()

    GenServer.call(pid, :get_query)
  end

  @doc "Sends a CSV binary"
  @spec export(Plug.Conn.t(), Query.t()) :: Plug.Conn.t()
  def export(conn, %Query{fields: fields, sorted_data: sorted_data}) do
    data =
      sorted_data
      |> Enum.map(fn row -> build_row(fields, row) end)
      |> List.insert_at(0, build_headers(fields))
      |> CSV.encode()
      |> Enum.join("")

    date = Date.utc_today()

    Controller.send_download(
      conn,
      {:binary, "\uFEFF" <> data},
      content_type: "application/csv",
      filename: "#{date}_player_rushing_statistics.csv"
    )
  end

  @spec build_headers([{String.t(), String.t()}]) :: [String.t()]
  defp build_headers(fields) do
    IO.inspect(fields)
    Enum.map(fields, fn {_k, v} -> pretty_print(v) end)
  end

  @spec build_row([{String.t(), String.t()}], map) :: [String.t()]
  defp build_row(fields, row) do
    Enum.map(fields, fn {k, _v} -> build_field(row, k) end)
  end

  @spec build_field(map, String.t()) :: String.t()
  defp build_field(item, key) do
    item
    |> Map.get(key)
    |> pretty_print()
    |> filter()
  end

  defp pretty_print(nil), do: ""

  defp pretty_print(integer) when is_integer(integer) do
    Integer.to_string(integer)
  end

  defp pretty_print(float) when is_float(float) do
    Float.to_string(float)
  end

  defp pretty_print(string) when is_binary(string), do: String.replace(string, ",", "")
  defp filter(text), do: String.replace(text, ",", "")
end
