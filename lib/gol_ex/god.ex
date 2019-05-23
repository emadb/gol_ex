defmodule GolEx.God do
  use GenServer

  def init(_args) do
    {:ok, %{tick: 0}}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def tick() do
    GenServer.call(__MODULE__, :tick)
  end

  def handle_call(:tick, _from, state) do
    cells = GolEx.CellRegistry.get_all_cells()

    {max_x, max_y} = get_world_edges(cells)

    live_cells_result = evaluate_live_cells(cells)
    dead_cells_result = evaluate_dead_cells({max_x + 1, max_y + 1})

    kill_cells(live_cells_result ++ dead_cells_result)
    create_cells(live_cells_result ++ dead_cells_result)

    new_state = %{tick: state.tick + 1}
    {:reply, :ok, new_state}
  end

  defp kill_cells(cells) do
    cells
      |> Enum.reject(fn {status, _} -> status != :kill end)
      |> Enum.map(fn {:kill, cell} -> GolEx.World.kill(cell) end)
  end

  defp create_cells(cells) do
    cells
      |> Enum.reject(fn {status, _} -> status != :create end)
      |> Enum.map(fn {:create, cell} -> GolEx.World.create_cell(cell) end)
  end

  defp get_world_edges(cells) do
    cells
    |> Enum.reduce({0, 0}, fn {x, y}, {mx, my} ->
        {(if x > mx, do: x, else: mx), (if y > my, do: y, else: my)}
      end)
  end

  defp evaluate_live_cells(cells) do
    Enum.map(cells, &tick_live_cell/1)
  end

  defp count_neighbours({x, y}) do
    (for i <- x-1..x+1, j <- y-1..y+1, do:  {i, j})
      |> Enum.reject(fn {i, j} -> {i, j} == {x, y} end)
      |> Enum.count(&GolEx.CellRegistry.alive?/1)
  end

  defp tick_live_cell(cell) do
    neighbours = count_neighbours(cell)
    tick_live_cell(cell, neighbours)
  end

  defp evaluate_dead_cells({mx, my}) do
    (for i <- 0..mx, j <- 0..my, do:  {i, j})
      |> Enum.reject(&GolEx.CellRegistry.alive?/1)
      |> Enum.map(&tick_dead_cell/1)
  end

  defp tick_dead_cell(cell) do
    neighbours = count_neighbours(cell)
    tick_dead_cell(cell, neighbours)
  end

  defp tick_live_cell(cell, neighbours) when neighbours == 3, do: {:live, cell}
  defp tick_live_cell(cell, neighbours) when neighbours == 2, do: {:live, cell}
  defp tick_live_cell(cell, neighbours) when neighbours < 2, do: {:kill, cell}
  defp tick_live_cell(cell, neighbours) when neighbours > 3, do: {:kill, cell}

  defp tick_dead_cell(cell, neighbours) when neighbours == 3, do: {:create, cell}
  defp tick_dead_cell(cell, _neighbours), do: {:dead, cell}

end
