defmodule GolEx.Cell do
  use GenServer

  def init(pos) do
    Process.flag(:trap_exit, true)
    {:ok, %{age: 0, position: pos, next_tick: :live}}
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

  def apply_tick(pos) do
    pid = GolEx.CellRegistry.get_pid(pos)
    GenServer.call(pid, :apply_tick)
  end

  def get_age(pos) do
    pid = GolEx.CellRegistry.get_pid(pos)
    GenServer.call(pid, :get_age)
  end

  def handle_call(:alive, _, state) do
    {:reply, {:ok, true}, state}
  end

  def handle_call(:tick, _, state) do
    neighbours = GolEx.Utils.count_neighbours(state.position)
    next_tick = tick_live_cell(neighbours)

    {:reply, :ok, %{state | age: state.age + 1, next_tick: next_tick}}
  end

  def handle_call(:apply_tick, _, %{next_tick: :live} = state) do
    {:reply, :ok, state}
  end

  def handle_call(:apply_tick, _, %{next_tick: :kill} = state) do
    {:stop, :normal, :self_killed, state}
  end

  def handle_call(:get_age, _, state) do
    {:reply, {:ok, state.age}, state}
  end

  def terminate(_reason, state) do
    GolEx.CellRegistry.unregister(state.position)
    state
  end

  defp tick_live_cell(neighbours) when neighbours == 3 or neighbours == 2, do: :live
  defp tick_live_cell(neighbours) when neighbours < 2, do: :kill
  defp tick_live_cell(neighbours) when neighbours > 3, do: :kill

end
