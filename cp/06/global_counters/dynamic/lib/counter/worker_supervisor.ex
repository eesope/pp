defmodule Counter.WorkerSupervisor do
  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: {:global, __MODULE__})
  end

  def start_worker(name) do
    DynamicSupervisor.start_child({:global, __MODULE__}, {Counter.Worker, name})
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one, max_children: 100)
  end
end

