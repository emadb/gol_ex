defmodule CellTest do
  use ExUnit.Case

  test "Any live cell with fewer than two live neighbours dies, as if caused by underpopulation." do
    {:ok, pid} = GolEx.World.create_cell({53, 54})
    GolEx.World.tick
    assert Process.alive?(pid) == false
  end

  test "Any live cell with more than three live neighbours dies, as if by overcrowding." do
    {:ok, pid} = GolEx.World.create_cell({63, 64})

    GolEx.World.create_cell({62, 64})
    GolEx.World.create_cell({62, 63})
    GolEx.World.create_cell({63, 65})
    GolEx.World.create_cell({63, 63})

    GolEx.World.tick
    assert Process.alive?(pid) == false
  end

  test "Any live cell with two live neighbours lives on to the next generation." do
    {:ok, pid} = GolEx.World.create_cell({73, 74})

    GolEx.World.create_cell({72, 74})
    GolEx.World.create_cell({72, 73})

    GolEx.World.tick
    assert Process.alive?(pid) == true
  end

  test "Any live cell with three live neighbours lives on to the next generation." do
    {:ok, pid} = GolEx.World.create_cell({83, 84})

    GolEx.World.create_cell({82, 84})
    GolEx.World.create_cell({82, 83})
    GolEx.World.create_cell({83, 85})

    GolEx.World.tick
    assert Process.alive?(pid) == true
  end

  test "Any dead cell with exactly three live neighbours becomes a live cell." do

    GolEx.World.create_cell({92, 94})
    GolEx.World.create_cell({92, 93})
    GolEx.World.create_cell({93, 95})

    GolEx.World.tick

    pid = GolEx.CellRegistry.get_pid({93, 94})

    assert Process.alive?(pid) == true
  end

end
