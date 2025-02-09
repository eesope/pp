defmodule Arithmetic.Worker do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, :no_state)
  end

  @impl true
  def init(:no_state) do
    {:ok, :no_state}
  end

  @impl true
  def handle_call({:square, x}, _from, :no_state) do

    if is_number(x) do
      result = x * x
      reply = "Result: #{result}   @worker: #{inspect(self())}"

      {:reply, reply, :no_state}
    else raise "Invalid argument: not a number."
    end

  end

  @impl true
  def handle_call({:sqrt, x}, _from, :no_state) do
    Process.sleep(4000)

    if is_number(x) do
      result = if x >= 0, do: :math.sqrt(x), else: :error
      reply = "Result: #{result} @worker: #{inspect(self())}"

      {:reply, reply, :no_state}
    else raise "Invalid argument: not a number."
    end
  end
end

# ----------------------------------------------------------- #
# work divisor && monitor
defmodule Arithmetic.Server do
  use GenServer

  def start(n \\ 1) do  # n == # of workers
    GenServer.start(__MODULE__, n, name: __MODULE__)
  end

  # Picked worker carry out the task
  def square(x) do
    {:ok, {:square, worker}} = GenServer.call(__MODULE__, {:square, x})
    GenServer.call(worker, {:square, x})
  end

  def sqrt(x) do
    {:ok, {:sqrt, worker}} = GenServer.call(__MODULE__, {:sqrt, x})
    GenServer.call(worker, {:sqrt, x})
  end

  # server callbacks
  @impl true
  def init(n) do
    # to handle exit signal
    Process.flag(:trap_exit, true)

    # Distribute tasks in round-robin fashion
    workers = 1..n |> Enum.map(fn _ ->
      {:ok, pid} = Arithmetic.Worker.start_link()
      IO.puts("Worker: #{inspect(pid)}")
      pid
    end)

    # count workers
    state = %{workers: workers, next: 0, count: n}
    {:ok, state}
  end

  # pick the worker for each job
  @impl true
  def handle_call({request, _x}, _from, state = %{workers: workers, next: index, count: n}) do
    w_pid = Enum.at(workers, index)
    w_set = {:ok, {request, w_pid}}
    {:reply, w_set, %{state | next: rem(index + 1, n)}}
  end

  # when worker exit(terminate) -> take EXIT msg from linked process
  @impl true
  def handle_info({:EXIT, died_pid, reason}, state = %{workers: workers, count: _n}) do

    IO.puts(
      "------------------------------------\n
      Worker #{inspect(died_pid)} died. \n
      Reason: #{inspect(reason)} \n
      Replacing with a new worker...\n")

    {:ok, new_pid} = Arithmetic.Worker.start_link()

    IO.puts("
      New worker: #{inspect(new_pid)}
------------------------------------")
    # update to new worker pid
    new_workers = Enum.map(workers, fn worker_pid ->
      if worker_pid == died_pid, do: new_pid, else: worker_pid
    end)

    {:noreply, %{state | workers: new_workers}}
  end
end
