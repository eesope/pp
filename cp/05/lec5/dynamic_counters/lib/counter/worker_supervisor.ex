defmodule Counter.WorkerSupervisor do
  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_worker(name) do
    DynamicSupervisor.start_child(__MODULE__, {Counter.Worker, name})
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one, max_children: 100)
  end
end

# 동적 워커를 시작하고 관리
# 외부에서 start_worker/1 함수를 호출하면, 새로운 카운터 워커를 시작

