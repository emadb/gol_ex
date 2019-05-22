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
    {max_x, max_y} = GolEx.CellRegistry.get_all_cells()
    |> Enum.reduce({0, 0}, fn {x, y}, {mx, my} ->
      tick_cell({x, y})
      max_x = if x > mx, do: x, else: mx
      max_y = if y > my, do: y, else: my
      {max_x, max_y}
    end)
    evaluate_dead_cells({max_x, max_y})
  end

  defp evaluate_dead_cells({mx, my}) do
    (for i <- 0..mx, j <- 0..my, do:  {i, j})
    |> Enum.reject(fn {i, j} -> GolEx.CellRegistry.alive?({i, j}) end)
    |> Enum.map(fn c -> tick_dead_cell(c) end)

  end

  defp tick_dead_cell({93, 94}) do
    neighbours = (for i <- 93-1..93+1, j <- 94-1..94+1, do:  {i, j})
    |> Enum.reject(fn {i, j} -> i == 93 && j == 94 end)
    |> Enum.map(fn c ->
      IO.inspect {c, GolEx.CellRegistry.alive?(c)}, label: "Alive"
      if GolEx.CellRegistry.alive?(c), do: 1, else: 0
    end)
    |> Enum.sum

    IO.inspect neighbours, label: "9394"

    evaluate_nolife({93, 94}, neighbours)
  end

  defp tick_dead_cell({x, y}) do
    neighbours = (for i <- x-1..x+1, j <- y-1..y+1, do:  {i, j})
    |> Enum.reject(fn {i, j} -> i == x && j == y end)
    |> Enum.map(fn c ->
      if GolEx.CellRegistry.alive?(c), do: 1, else: 0
    end)
    |> Enum.sum

    evaluate_nolife({x, y}, neighbours)
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

  defp evaluate_nolife({x, y}, neighbours) when neighbours == 3 do
    create_cell({x, y})
  end

  defp evaluate_nolife(_, _neighbours) do

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
