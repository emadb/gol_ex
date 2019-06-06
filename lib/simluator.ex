defmodule Simulator do

  def infinite_grow(ticks) do
    GolEx.World.create_cell({117, 111})
    GolEx.World.create_cell({117, 112})
    GolEx.World.create_cell({118, 112})
    GolEx.World.create_cell({117, 113})

    GolEx.World.create_cell({115, 112})
    GolEx.World.create_cell({115, 113})
    GolEx.World.create_cell({115, 114})

    GolEx.World.create_cell({113, 115})
    GolEx.World.create_cell({113, 116})

    GolEx.World.create_cell({111, 116})

    for i <- 0..ticks do
      IO.inspect i, label: ">"
      GolEx.God.tick
    end

    GolEx.CellRegistry.get_all_cells()
  end

  def start_simulation_toad() do
    GolEx.World.create_cell({2, 4})
    GolEx.World.create_cell({3, 4})
    GolEx.World.create_cell({4, 4})

    GolEx.World.create_cell({3, 3})
    GolEx.World.create_cell({4, 3})
    GolEx.World.create_cell({5, 3})

    Enum.each(1..100, fn _ -> GolEx.God.tick end)

    GolEx.CellRegistry.get_all_cells()
  end

  def start_simulation_glider() do
    GolEx.World.create_cell({2, 1})
    GolEx.World.create_cell({3, 2})
    GolEx.World.create_cell({1, 3})
    GolEx.World.create_cell({2, 3})
    GolEx.World.create_cell({3, 3})

    Enum.each(1..100, fn _ -> GolEx.God.tick end)

    GolEx.CellRegistry.get_all_cells()
  end

  def start_simulation_random(cells, cycles) do

    1..cells
      |> Enum.map(fn _ -> { Enum.random(1..100), Enum.random(1..100) } end)
      |> Enum.uniq
      |> Enum.map(fn cell -> GolEx.World.create_cell(cell) end)

    IO.inspect Enum.count(GolEx.CellRegistry.get_all_cells()), label: "Tick 0"

    1..cycles
      |> Enum.map(fn t ->
        GolEx.God.tick()
        IO.inspect Enum.count(GolEx.CellRegistry.get_all_cells()), label: "Tick #{t}"
      end)

  end
end
