defmodule TheRush.MockGenServer do
  @moduledoc "A genserver for mocking functionality around serialized pids"
  use GenServer

  alias TheRush.PlayerStatistics
  alias TheRush.PlayerStatistics.Query

  # Client API

  @spec start_link(Query.t()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(query) do
    GenServer.start_link(__MODULE__, [query: query], name: __MODULE__)
  end

  @spec get_serialized_pid :: String.t()
  def get_serialized_pid do
    GenServer.call(__MODULE__, :get_serialized_pid)
  end

  # Server API

  @impl true
  @spec init(keyword) :: {:ok, %{query: Query.t()}}
  def init(opts) do
    {:ok, %{query: Keyword.fetch!(opts, :query)}}
  end

  @impl true
  def handle_call(:get_serialized_pid, _from, state) do
    {:reply, PlayerStatistics.find_serialized_pid(), state}
  end

  @impl true
  def handle_call(:get_query, _from, %{query: query} = state) do
    {:reply, query, state}
  end
end
