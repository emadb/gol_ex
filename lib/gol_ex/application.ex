defmodule GolEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Supervisor.child_spec({Registry, [keys: :unique, name: GolEx.DefaultRegistry]}, id: :cell_registry),
      {GolEx.CellRegistry, %{}},
      Supervisor.child_spec({GolEx.World, []}, id: World),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GolEx.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
