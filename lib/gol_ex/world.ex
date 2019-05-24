defmodule GolEx.World do
  use DynamicSupervisor

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def create_cell(pos) do
    # worker(Stackgen, [], [id: unique_name, restart: :transient])
    DynamicSupervisor.start_child(__MODULE__, %{
      id: pos,
      start: {GolEx.Cell, :start_link, [pos]},
      restart: :transient
    })
  end

  # def kill(cell) do
  #   pid = GolEx.CellRegistry.get_pid(cell)
  #   DynamicSupervisor.terminate_child(__MODULE__, pid)
  # end

end
