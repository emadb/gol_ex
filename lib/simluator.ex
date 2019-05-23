defmodule Simulator do

  def start_simulation_toad() do
    GolEx.World.create_cell({2, 4})
    GolEx.World.create_cell({3, 4})
    GolEx.World.create_cell({4, 4})

    GolEx.World.create_cell({3, 3})
    GolEx.World.create_cell({4, 3})
    GolEx.World.create_cell({5, 3})

    GolEx.God.tick()
    GolEx.God.tick()
    GolEx.God.tick()
    GolEx.God.tick()
    GolEx.God.tick()
    GolEx.God.tick()
    GolEx.God.tick()
    GolEx.God.tick()

    GolEx.CellRegistry.get_all_cells()
  end

  def start_simulation_glider() do
    GolEx.World.create_cell({2, 1})
    GolEx.World.create_cell({3, 2})
    GolEx.World.create_cell({1, 3})
    GolEx.World.create_cell({2, 3})
    GolEx.World.create_cell({3, 3})

    GolEx.God.tick()
    GolEx.God.tick()
    GolEx.God.tick()
    GolEx.God.tick()
    GolEx.God.tick()
    GolEx.God.tick()
    GolEx.God.tick()
    GolEx.God.tick()

    GolEx.CellRegistry.get_all_cells()
  end

  def start_simulation_random() do

    1..1000
      |> Enum.map(fn _ -> { Enum.random(1..100), Enum.random(1..100) } end)
      |> Enum.uniq
      |> Enum.map(fn cell -> GolEx.World.create_cell(cell) end)

    IO.inspect Enum.count(GolEx.CellRegistry.get_all_cells()), label: "Tick 0"

    1..1000
      |> Enum.map(fn t ->
        GolEx.God.tick()
        IO.inspect Enum.count(GolEx.CellRegistry.get_all_cells()), label: "Tick #{t}"
      end)

  end
end
