defmodule GolEx.Cell do
  use GenServer

  def init(_) do
    {:ok, []}
  end

  def start_link({x, y}) do
    {:ok, pid} = GenServer.start_link(__MODULE__, {x, y}, name: {:global, {x, y}})
    GolEx.CellRegistry.register({x, y}, pid)
    {:ok, pid}
  end

  def alive?(pos) do
    pid = GolEx.CellRegistry.get_pid(pos)
    GenServer.call(pid, :alive)
  end

  def tick(pos) do
    pid = GolEx.CellRegistry.get_pid(pos)
    GenServer.call(pid, :tick)
  end

  def handle_call(:alive, _, state) do
    {:reply, :ok, state}
  end

  def handle_call(:tick, _, {x, y}) do
    {:reply, :ok, {x, y}}
  end
end
