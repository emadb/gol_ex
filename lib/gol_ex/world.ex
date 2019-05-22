defmodule GolEx.World do
  use DynamicSupervisor

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def create_cell(pos) do
    DynamicSupervisor.start_child(__MODULE__, {GolEx.Cell, pos})
  end

  def kill(cell) do
    pid = GolEx.CellRegistry.get_pid(cell)
    DynamicSupervisor.terminate_child(__MODULE__, pid)
    GolEx.CellRegistry.unregister(cell)
  end

  def tick do
    GolEx.CellRegistry.get_all_cells()
    |> Enum.map(fn c -> tick_cell(c) end)
  end

  defp tick_cell({x, y}) do
    neighbours = (for i <- x-1..x+1, j <- y-1..y+1, do:  {i, j})
    |> Enum.reject(fn {i, j} -> i == x && j == y end)
    |> Enum.map(fn c ->
      if GolEx.CellRegistry.alive?(c), do: 1, else: 0
    end)
    |> Enum.sum

    evaluate_life({x, y}, neighbours)
  end

  defp evaluate_life({x, y}, neighbours) when neighbours < 2 do
    kill({x, y})
  end

  defp evaluate_life({x, y}, neighbours) when neighbours > 2 do
    kill({x, y})
  end

  defp evaluate_life({x, y}, _neighbours) do
    IO.puts "#{x}, #{y} can live"
  end
end
