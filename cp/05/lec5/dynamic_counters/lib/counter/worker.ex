defmodule Counter.Worker do
  use GenServer

  def start_link(name) do
    # GenServer를 시작할 때 초기 상태로 0을 사용하고, via/1 함수를 통해 Registry에 등록합니다.
    GenServer.start_link(__MODULE__, 0, name: via(name))
  end

  def inc(name, amt \\ 1) do
    GenServer.cast(via(name), {:inc, amt})
  end

  def value(name) do
    GenServer.call(via(name), :value)
  end

  defp via(name) do
    # helper: 주어진 name과 함께, Registry를 통해 해당 워커 프로세스를 고유하게 식별할 수 있는 튜플을 생성
    # 이렇게 하면, Registry에서 {Counter.Worker, name} 키로 프로세스를 찾을 수 있습니다.
    {:via, Registry, {Counter.Registry, {__MODULE__, name}}}
  end

  @impl true
  def init(arg) do
    {:ok, arg}
  end

  @impl true
  def handle_cast({:inc, amt}, state) do
    {:noreply, state + amt}
  end

  @impl true
  def handle_call(:value, _from, state) do
    {:reply, state, state}
  end
end
