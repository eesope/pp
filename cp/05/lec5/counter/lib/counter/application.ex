defmodule Counter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Counter.Worker.start_link(arg)
      {Counter.Store, "counter.db"}, #{child process, first argument}
      Supervisor.child_spec({Counter.Worker, W1}, id: :worker_1), # 각 프로세스에 id 지정
      Supervisor.child_spec({Counter.Worker, W2}, id: :worker_2)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Counter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

# Counter.Application 모듈은 애플리케이션 시작 시 실행되는 콜백 함수 start/2를 구현합니다.
# children 리스트에는 세 개의 자식이 있습니다:
# Counter.Store – 파일 "counter.db"를 사용하여 저장소 서버를 시작합니다.
# Counter.Worker – 첫 번째 워커를 {Counter.Worker, W1} 인자로 시작하며, Supervisor는 이 워커에 대해 :worker_1이라는 id를 부여합니다.
# Counter.Worker – 두 번째 워커를 {Counter.Worker, W2} 인자로 시작하며, id는 :worker_2입니다.
# Supervisor 옵션으로 :one_for_one 전략을 사용하여, 자식 프로세스가 개별적으로 재시작되도록 합니다.
