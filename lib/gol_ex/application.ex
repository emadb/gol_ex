defmodule GolEx.Application do
  use Application

  def start(_type, _args) do
    children = [
      {GolEx.CellRegistry, %{}},
      {GolEx.God, []},
      Supervisor.child_spec({GolEx.World, []}, id: World),
    ]

    opts = [strategy: :one_for_one, name: GolEx.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
