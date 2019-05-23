defmodule GolEx.World do
  use DynamicSupervisor

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def create_cell(pos) do
    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__, {GolEx.Cell, pos})
    GolEx.CellRegistry.register(pos, pid)
    {:ok, pid}
  end

  def kill(cell) do
    pid = GolEx.CellRegistry.get_pid(cell)
    GolEx.CellRegistry.unregister(cell)
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end

end
