defmodule Arithmetic.Worker do
  use GenServer

  # client
  def start(_) do
    GenServer.start(__MODULE__, :no_state)
  end

  def square(pid, x) do
    GenServer.call(pid, {:square, x})
  end

  def sqrt(pid, x) do
    GenServer.call(pid, {:sqrt, x})
  end

  # server (implementation)
  @impl true
  def init(:no_state) do
    {:ok, :no_state}
  end

  # no wait
  @impl true
  def handle_cast({:square, x, from}, :no_state) do
    send(from, {:result, self(), x * x})
    {:noreply, :no_state}
  end

  @impl true
  def handle_cast({:sqrt, x, from}, :no_state) do
    Process.sleep(4000)
    result = if x >= 0, do: :math.sqrt(x), else: :error
    send(from, {:result, self(), result})
    {:noreply, :no_state}
  end
end

defmodule Arithmetic.Server do
  use GenServer

  # client
  def start(n \\ 1) do
    GenServer.start(__MODULE__, n, name: __MODULE__)
  end

  def square(x) do
    GenServer.cast(__MODULE__, {:square, x})
  end

  def sqrt(x) do
    GenServer.cast(__MODULE__, {:sqrt, x})
  end

  # server
  @impl true
  def init(n) do
    # Distribute tasks in round-robin fashion
    workers = 1..n |> Enum.map(fn _ ->
      {:ok, pid} = Arithmetic.Worker.start(:no_args)
      IO.puts("Worker: #{inspect(pid)}")
      pid
    end)

    # count workers
    state = %{workers: workers, next: 0, count: n}
    {:ok, state}
  end

  # no wait for worker to finish
  @impl true
  def handle_cast({:square, x}, state = %{workers: workers, next: index, count: n}) do
    worker_pid = Enum.at(workers, index)  # current worker
    GenServer.cast(worker_pid, {:square, x, self()})
    next_index = rem(index + 1, n)  # to set next worker
    {:noreply, %{state | next: next_index}}
  end

  @impl true
  def handle_cast({:sqrt, x}, state = %{workers: workers, next: index, count: n}) do
    worker_pid = Enum.at(workers, index)  # current worker
    GenServer.cast(worker_pid, {:sqrt, x, self()})
    next_index = rem(index + 1, n)  # to set next worker
    {:noreply, %{state | next: next_index}}
  end

  @impl true
  def handle_info({:result, worker_pid, result}, state) do
    IO.puts("Result: #{result} from #{inspect(worker_pid)}")
    {:noreply, state}
  end
end
