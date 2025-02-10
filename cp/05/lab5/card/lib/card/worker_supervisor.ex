defmodule Card.WorkerSupervisor do
  use DynamicSupervisor

  def start_link(_) do
    IO.puts("Linking new worker...")
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_worker(name) do
    DynamicSupervisor.start_child(__MODULE__, {Card.Worker, name})
  end

  def init(:ok) do
    # dynamic doesn't need max_children
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
