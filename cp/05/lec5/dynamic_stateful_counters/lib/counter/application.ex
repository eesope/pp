defmodule Counter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Counter.Worker.start_link(arg)
      # {Counter.Worker, arg}
      {Registry, name: Counter.Registry, keys: :unique},
      Counter.WorkerSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options

    # ETS 테이블 생성: Counter.Store라는 이름의 테이블을 public하게 생성
    # 이 테이블은 워커의 상태(예: 카운터 값)를 저장하는 데 사용
    :ets.new(Counter.Store, [:named_table, :public])

    # Supervisor 옵션: :one_for_one 전략을 사용하여, 자식 중 하나가 죽으면 그 자식만 재시작
    opts = [strategy: :one_for_one, name: Counter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

# 애플리케이션 시작 (Counter.Application)
# Supervisor는 두 자식 프로세스를 시작합니다.
# Registry: 워커들이 고유하게 등록될 수 있도록 설정합니다.
# Counter.WorkerSupervisor: 동적으로 워커들을 관리합니다.
# ETS 테이블(Counter.Store)를 생성하여 워커의 상태를 저장할 준비를 합니다.
# Supervisor는 :one_for_one 전략을 사용합니다.

# 워커 시작 (Counter.WorkerSupervisor를 통해)
# 동적 워커들이 생성될 때, 각 워커는 Counter.Worker.start_link(name)를 호출합니다.
# 각 워커는 Registry를 통해 고유 이름으로 등록되고, 초기 상태는 ETS에서 복원하거나 기본값 0으로 설정됩니다.
# 워커의 PID는 Registry를 통해 접근 가능하며, 이를 이용해 개별 워커에 메시지를 전달할 수 있습니다.

# 워커 조작
# 외부 클라이언트(또는 상위 모듈)는 Counter.Worker.inc(name, amt) 또는 Counter.Worker.value(name) 등의 API를 호출하여 워커의 상태를 변경하거나 조회합니다.
# 각 워커는 내부적으로 GenServer의 handle_cast/2와 handle_call/3 콜백을 사용하여 메시지를 처리합니다.

# 상태 보존
# 워커가 종료될 때, terminate/2 콜백이 호출되어 ETS 테이블에 상태를 저장합니다.
# 이렇게 하면, 워커가 재시작될 때 ETS에서 이전 상태를 읽어와 복원할 수 있으므로, stateful (상태를 유지하는) 동작을 보장합니다.
