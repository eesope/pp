defmodule Counter.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Counter.Worker.start_link(arg)
      # {Counter.Worker, arg}
      Counter.WorkerSupervisor
    ]
    :ets.new(Counter.Store, [:named_table, :public])
    opts = [strategy: :one_for_one, name: Counter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
