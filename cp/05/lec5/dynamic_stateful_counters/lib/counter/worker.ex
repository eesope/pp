defmodule Counter.Worker do
  use GenServer
  @store  Counter.Store

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via(name))
  end

  def inc(name, amt \\ 1) do
    GenServer.cast(via(name), {:inc, amt})
  end

  def value(name) do
    GenServer.call(via(name), :value)
  end

  defp via(name) do
    {:via, Registry, {Counter.Registry, {__MODULE__, name}}}
  end

  def init(name) do
    # ETS 테이블(@store)에서 이 워커의 상태를 찾고
    # ETS에서 {name, v} 형태의 튜플이 있으면 v를, 없으면 0을 기본값으로 사용

    value =
      case :ets.lookup(@store, name) do
        [{^name, v}] -> v
        _ -> 0
      end
    {:ok, {name, value}}
  end

  def handle_cast({:inc, amt}, {name, value}) do
    {:noreply, {name, value + amt}}
  end

  def handle_call(:value, _from, {_, value} = state) do
    {:reply, value, state}
  end

  def terminate(_reason, state) do
    :ets.insert(@store, state)
  end
end
