defmodule TheRush.PlayerStatistics.Find do
  @moduledoc "For handling moving the query across boundaries"
  alias TheRush.PlayerStatistics.Query

  @doc """
  Get the pid of the current process (a genserver) and serialize
  so it can be passed through a controller action
  """
  @spec serialized_pid :: binary
  def serialized_pid do
    self()
    |> :erlang.term_to_binary()
    |> Base.url_encode64()
  end

  @doc """
  Take a serialized pid, decode it and then use the resulting pid
  to obtain the query struct from a genserver. Used to pass complex
  datatypes between a liveview and a controller.
  """

  @spec query(binary) :: Query.t()
  def query(serialized_pid) do
    pid =
      serialized_pid
      |> Base.url_decode64!()
      |> :erlang.binary_to_term()

    GenServer.call(pid, :get_query)
  end
end
