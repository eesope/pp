defmodule Counter.Worker do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def inc(name, amt \\ 1)  do
    GenServer.cast(name, {:inc, amt})
  end

  def dec(name, amt \\ 1) do
    GenServer.cast(name, {:dec, amt})
  end

  def value(name) do
    GenServer.call(name, :value)
  end

  @impl true
  def init(name) do
    {:ok, {name, Counter.Store.get(name)}}
  end

  @impl true
  def handle_cast({:inc, amt}, {name, state}) do
    {:noreply, {name, state + amt}}
  end

  @impl true
  def handle_cast({:dec, amt}, {name, state}) do
    {:noreply, {name, state - amt}}
  end

  @impl true
  def handle_call(:value, _from, {_, value} = state) do
    {:reply, value, state}
  end

#  @impl true
#  def handle_info(:reset, _state) do
#    {:noreply, 0}
#  end

  @impl true
  def terminate(_reason, {name, state}) do
    Counter.Store.put(name, state)
  end
end


# 이 모듈은 각 카운터 워커를 나타내며, GenServer를 사용하여 개별 워커의 상태(카운터 값)를 관리합니다.
# start_link/1은 워커를 시작할 때, 전달받은 name을 초기 인자로 사용하며, 동시에 워커 프로세스를 등록된 이름으로 시작합니다.
# 예를 들어, W1이나 W2라는 이름을 전달하여 각 워커를 구분합니다.
# inc/2, dec/2, value/1은 외부에서 워커의 상태를 조작하거나 조회할 수 있는 클라이언트 API 함수입니다.
# 이때 각 함수는 호출 시, 워커의 이름(등록된 PID 대신 사용)을 인자로 받아 메시지를 보냅니다.
# init/1에서는 초기 상태를 튜플 {name, Counter.Store.get(name)}으로 설정합니다.
# Counter.Store.get(name)를 통해, 저장소에 저장된 이전 카운터 값을 가져오고, 없으면 기본값(저장소의 get 함수에서 기본 0을 반환하도록 구현되어 있음)이 사용됩니다.
# handle_cast/2에서는 증가(:inc)와 감소(:dec) 메시지를 받아 상태를 갱신합니다.
# handle_call/3에서는 :value 요청에 대해 현재 카운터 값을 응답합니다.
# terminate/2에서는 워커가 종료될 때, 현재 상태를 저장소에 기록합니다.
