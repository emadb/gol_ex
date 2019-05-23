defmodule CellRegistryTest do
  use ExUnit.Case

  setup do
    on_exit fn ->
      GolEx.CellRegistry.unregister_all()
    end
    :ok
  end

  test "Can register a cell" do
    GolEx.CellRegistry.register({1, 3}, "foo_1_3")
    pid = GolEx.CellRegistry.get_pid({1, 3})
    assert pid == "foo_1_3"
  end

  test "Can update the pid to a cell" do
    GolEx.CellRegistry.register({2, 3}, "foo_2_3")
    GolEx.CellRegistry.register({2, 3}, "foo_2_3_bis")
    pid = GolEx.CellRegistry.get_pid({2, 3})
    assert pid == "foo_2_3_bis"
  end

  test "Can unregister a cell" do
    GolEx.CellRegistry.register({2, 3}, "foo_2_3")
    GolEx.CellRegistry.unregister({2, 3})

    pid = GolEx.CellRegistry.get_pid({2, 3})
    assert pid == nil
  end

  test "Get all pids" do
    GolEx.CellRegistry.register({2, 3}, "foo_2_3")
    GolEx.CellRegistry.register({3, 3}, "foo_2_3")
    GolEx.CellRegistry.register({4, 3}, "foo_2_3")
    assert Enum.count(GolEx.CellRegistry.get_all_pids()) == 3
  end

  test "Get all cells" do
    GolEx.CellRegistry.register({2, 3}, "foo_2_3")
    GolEx.CellRegistry.register({3, 3}, "foo_2_3")
    assert Enum.count(GolEx.CellRegistry.get_all_pids()) == 2
  end

  test "Alive. It is alive" do
    GolEx.CellRegistry.register({7, 9}, "foo")
    assert GolEx.CellRegistry.alive?({7, 9}) == true
  end

  test "Alive. It is NOT alive" do
    assert GolEx.CellRegistry.alive?({8, 98}) == false
  end
end
