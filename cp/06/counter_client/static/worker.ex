defmodule Counter.Worker do
  @name {:global, __MODULE__}
  # :global은 Erlang/Elixir에서 제공하는 전역 프로세스 레지스트리
  # 여러 노드에 걸쳐 프로세스를 고유하게 등록할 수 있게 해줍니다.
  # __MODULE__은 현재 모듈(Counter.Worker)의 이름

  # 이 프로세스는 전역 이름 {:global, Counter.Worker}로 등록
  # 결과적으로, 분산 시스템에서 어느 노드에서든 Counter.Worker라는 이름으로 접근 가능

  def start_link(n \\ 0) do
    GenServer.start_link(__MODULE__, n, name: @name)
  end

  def inc(amt \\ 1)  do
    GenServer.cast(@name, {:inc, amt})
  end

  def dec(amt \\ 1) do
    GenServer.cast(@name, {:dec, amt})
  end

  def value() do
    GenServer.call(@name, :value)
  end
end

# 분산 환경에서 특정 이름(여기서는 Counter.Worker)으로 프로세스를 전역 등록하여,
# 여러 노드 간에 동일한 프로세스에 접근하거나,
# 분산 시스템의 한 부분으로 쉽게 통합할 수 있도록 하는 샘플 코드
