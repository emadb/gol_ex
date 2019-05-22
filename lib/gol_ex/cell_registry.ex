defmodule GolEx.CellRegistry do
  use Agent

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def get_pid(cell) do
    Agent.get(__MODULE__, fn state -> Map.get(state, cell) end)
  end

  def alive?(cell) do
    Agent.get(__MODULE__, fn state -> Map.has_key?(state, cell) end)
  end

  def register(cell, pid) do
    Agent.update(__MODULE__, fn state ->
      Map.update(state, cell, pid, fn _ -> pid end)
    end)
  end

  def unregister(cell) do
    Agent.update(__MODULE__, fn state -> Map.delete(state, cell) end)
  end

  def unregister_all() do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end

  def get_all_cells() do
    Agent.get(__MODULE__, fn state -> Map.keys(state) end)
  end

  def get_all_pids() do
    Agent.get(__MODULE__, fn state -> Map.values(state) end)
  end
end

