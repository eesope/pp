defmodule Counter.WorkerSupervisor do
  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_worker(name) do
    # 동적으로 새로운 워커를 시작하는 API 함수
    # 전달받은 name을 인자로 하여 {Counter.Worker, name} 형식의 자식 사양을 DynamicSupervisor에 전달

    DynamicSupervisor.start_child(__MODULE__, {Counter.Worker, name})
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one, max_children: 100)
  end
end
