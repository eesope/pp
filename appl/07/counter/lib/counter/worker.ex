# registered counter worker
defmodule Counter.Worker do
  use GenServer

  # client API
  def start_link(value \\ 0) do
    GenServer.start_link(__MODULE__, value, name: __MODULE__)
  end

  def dec(amt \\ 1) do
    GenServer.cast(__MODULE__, {:dec, amt})
  end

  def inc(amt \\ 1) do
    GenServer.cast(__MODULE__, {:inc, amt})
  end

  def value() do
    GenServer.call(__MODULE__, :value)
  end

  # implementation/callbacks
  @impl true
  def init(value) do
    {:ok, value}
  end

  @impl true
  def handle_cast({:dec, amt}, value) do
    {:noreply, value - amt}
  end

  @impl true
  def handle_cast({:inc, amt}, value) do
    {:noreply, value + amt}
  end

  @impl true
  def handle_call(:value, _from, value) do
    {:reply, value, value}
  end

  @impl true
  def terminate(_reason, _value) do
    IO.puts("terminating")
  end
end
