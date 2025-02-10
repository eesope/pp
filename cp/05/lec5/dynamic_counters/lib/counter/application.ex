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
    opts = [strategy: :one_for_one, name: Counter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

# Counter.Application은 OTP 애플리케이션의 시작점
# children 리스트에는 두 자식이 포함
# 첫 번째 자식은 Registry로, 워커들이 등록될 때 이름으로 접근할 수 있도록 고유 키를 사용
# 두 번째 자식은 Counter.WorkerSupervisor로, 동적 방식으로 카운터 워커들을 관리
# Supervisor 옵션으로 :one_for_one 전략을 사용하여, 개별 자식이 종료되었을 때 그 자식만 재시작되도록
