defmodule GolEx.Cell do
  use GenServer

  def init(_) do
    {:ok, %{age: 0}}
  end

  def start_link(pos) do
    {:ok, pid} = GenServer.start_link(__MODULE__, pos, name: {:global, pos})
    GolEx.CellRegistry.register(pos, pid)
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

  def get_age(pos) do
    pid = GolEx.CellRegistry.get_pid(pos)
    GenServer.call(pid, :get_age)
  end

  def handle_call(:alive, _, state) do
    {:reply, {:ok, true}, state}
  end

  def handle_call(:tick, _, state) do
    {:reply, :ok, %{age: state.age + 1}}
  end

  def handle_call(:get_age, _, state) do
    {:reply, {:ok, state.age}, state}
  end

end
