defmodule GolEx.Utils do
  def get_world_edges(cells) do
    {max_x, _} = Enum.max_by(cells, fn {x, _} -> x end, fn -> {0, 0} end)
    {_, max_y} = Enum.max_by(cells, fn {_, y} -> y end, fn -> {0, 0} end)

    {min_x, _} = Enum.min_by(cells, fn {x, _} -> x end, fn -> {0, 0} end)
    {_, min_y} = Enum.min_by(cells, fn {_, y} -> y end, fn -> {0, 0} end)

    {{min_x, min_y}, {max_x, max_y}}
  end

  def count_neighbours({x, y}) do
    (for i <- x-1..x+1, j <- y-1..y+1, do:  {i, j})
      |> Enum.reject(fn {i, j} -> {i, j} == {x, y} end)
      |> Enum.count(&GolEx.CellRegistry.alive?/1)
  end

end
