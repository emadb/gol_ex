defmodule GolEx.God do
  use GenServer

  def init(_args) do
    {:ok, %{tick: 0, to_kill: [], to_create: []}}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def tick() do
    GenServer.call(__MODULE__, :tick)
  end

  def handle_call(:tick, _from, state) do
    {max_x, max_y} = get_world_edges()

    live_cells_result = evaluate_live_cells(GolEx.CellRegistry.get_all_cells())
    dead_cells_result = evaluate_dead_cells({max_x + 1, max_y + 1})

    kill_cells(live_cells_result ++ dead_cells_result)
    create_cells(live_cells_result ++ dead_cells_result)

    new_state = %{tick: state.tick + 1, to_kill: [], to_create: []}
    {:reply, :ok, new_state}
  end

  defp kill_cells(cells) do
    cells
      |> Enum.reject(fn {status, _} -> status != :kill end)
      |> Enum.map(fn {:kill, cell} ->
        GolEx.World.kill(cell)
      end)
  end

  defp create_cells(cells) do
    cells
      |> Enum.reject(fn {status, _} -> status != :create end)
      |> Enum.map(fn {:create, cell} ->
        GolEx.World.create_cell(cell)
      end)
  end

  defp get_world_edges() do
    GolEx.CellRegistry.get_all_cells()
      |> Enum.reduce({0, 0}, fn {x, y}, {mx, my} ->
        max_x = if x > mx, do: x, else: mx
        max_y = if y > my, do: y, else: my
        {max_x, max_y}
      end)
  end

  defp evaluate_live_cells(cells) do
    Enum.map(cells, fn c -> tick_cell(c) end)
  end

  defp count_neighbours({x, y}) do
    (for i <- x-1..x+1, j <- y-1..y+1, do:  {i, j})
      |> Enum.reject(fn {i, j} -> i == x && j == y end)
      |> Enum.map(fn c ->
        if GolEx.CellRegistry.alive?(c), do: 1, else: 0
      end)
      |> Enum.sum
  end

  defp tick_cell({83, 84} = {x, y}) do
    neighbours = count_neighbours({x, y})
    evaluate_live_cell({x, y}, neighbours)
  end

  defp tick_cell({x, y}) do
    neighbours = count_neighbours({x, y})
    evaluate_live_cell({x, y}, neighbours)
  end


  defp evaluate_dead_cells({mx, my}) do
    (for i <- 0..mx, j <- 0..my, do:  {i, j})
      |> Enum.reject(fn {i, j} -> GolEx.CellRegistry.alive?({i, j}) end)
      |> Enum.map(fn c -> tick_dead_cell(c) end)
  end

  defp tick_dead_cell({x, y}) do
    neighbours = count_neighbours({x, y})
    evaluate_dead_cell({x, y}, neighbours)
  end

  defp evaluate_live_cell({x, y}, neighbours) when neighbours == 3, do: {:live, {x, y}}
  defp evaluate_live_cell({x, y}, neighbours) when neighbours == 2, do: {:live, {x, y}}
  defp evaluate_live_cell({x, y}, neighbours) when neighbours < 2, do: {:kill, {x, y}}
  defp evaluate_live_cell({x, y}, neighbours) when neighbours > 3, do: {:kill, {x, y}}

  defp evaluate_dead_cell({x, y}, neighbours) when neighbours == 3, do: {:create, {x, y}}
  defp evaluate_dead_cell({x, y}, _neighbours), do: {:dead, {x, y}}

end
