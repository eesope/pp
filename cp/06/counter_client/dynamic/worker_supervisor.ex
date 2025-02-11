defmodule Counter.WorkerSupervisor do
  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: {:global, __MODULE__})
  end

  def start_worker(name) do
    child_spec = %{
      id: Counter.Worker,
      start: {Counter.Worker, :start_link, [name]}
    }
    DynamicSupervisor.start_child({:global, __MODULE__}, child_spec)
  end
end


# Supervisor 시작:
# Counter.WorkerSupervisor.start_link/1 호출 시,
# DynamicSupervisor가 전역 이름 { :global, Counter.WorkerSupervisor }로 시작

# 워커 생성:
# Counter.WorkerSupervisor.start_worker("some_name")를 호출하면,
# child_spec에 따라 Counter.Worker.start_link("some_name")가 호출되어 새로운 GenServer 워커가 시작
# 이 워커는 via("some_name")를 통해 전역 등록

# 워커 호출:
# 클라이언트는 Counter.Worker.inc("some_name", amt)나 Counter.Worker.value("some_name")와 같이,
# 전역 이름({:via, :global, {Counter.Worker, "some_name"}})으로 등록된 프로세스에 메시지를 보내서 카운터 값을 조작하거나 조회

# 이 client 구조는 분산 환경에서도 동일한 이름으로 워커를 접근할 수 있게 해주며,
# 동적 supervisor를 통해 필요에 따라 워커 프로세스를 생성하고 관리할 수 있도록 설계
