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
    evaluate_live_cells(cells)

    {max_x, max_y} = GolEx.Utils.get_world_edges(cells)
    dead_cells = evaluate_dead_cells({max_x + 1, max_y + 1})

    apply_tick(cells)
    create_new_cells(dead_cells)

    new_state = %{tick: state.tick + 1}
    {:reply, :ok, new_state}
  end

  defp apply_tick(cells) do
    Enum.map(cells, &GolEx.Cell.apply_tick/1)
  end

  defp create_new_cells(cells) do
    cells
      |> Enum.reject(fn {status, _} -> status != :create end)
      |> Enum.map(fn {:create, cell} -> GolEx.World.create_cell(cell) end)
  end

  defp evaluate_live_cells(cells) do
    Enum.map(cells, &GolEx.Cell.tick/1)
  end

  defp evaluate_dead_cells({mx, my}) do
    (for i <- 0..mx, j <- 0..my, do:  {i, j})
      |> Enum.reject(&GolEx.CellRegistry.alive?/1)
      |> Enum.map(&tick_dead_cell/1)
  end

  defp tick_dead_cell(cell) do
    neighbours = GolEx.Utils.count_neighbours(cell)
    next_status(cell, neighbours)
  end

  defp next_status(cell, neighbours) when neighbours == 3, do: {:create, cell}
  defp next_status(cell, _neighbours), do: {:dead, cell}

end
