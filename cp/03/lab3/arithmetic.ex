defmodule Arithmetic.Worker do
  use GenServer

  # client; no communication with
  def start(_) do
    GenServer.start(__MODULE__, :no_state)
  end

  # server (implementation)
  @impl true
  def init(:no_state) do
    {:ok, :no_state}
  end

  @impl true
  def handle_call({:square, x}, from, :no_state) do
    result = {x * x, self()}
    # GenServer.cast(s_pid, {:result, from, result})
    {:reply, result, :no_state}
  end

  @impl true
  def handle_call({:sqrt, x}, from, :no_state) do
    Process.sleep(4000)
    result = if x >= 0, do: :math.sqrt(x), else: :error
    # GenServer.cast(s_pid, {:result, from, result} )
    {:reply, {result, self()}, :no_state}
  end
end

# ----------------------------------------------------------- #

defmodule Arithmetic.Server do
  use GenServer
  # registered && doesn't wait worker to finish

  # client
  def start(n \\ 1) do  # n == # of workers
    GenServer.start(__MODULE__, n, name: __MODULE__)
  end

  # Picked worker will do the task; answer
  def square(x) do
    GenServer.call(__MODULE__, {:square, x})
    IO.puts("Result: # from #{self()}")

  end
  def sqrt(x) do
    GenServer.call(__MODULE__, {:sqrt, x})
  end

  # server callbacks
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


  # pick worker -> one handle call do both job
  @impl true
  def handle_call({request, x}, _from, state = %{workers: workers, next: index, count: n}) do
    w_pid = Enum.at(workers, index)  # pick worker
    request_res = "#{request} task is assigned to #{w_pid}"
    case request do
        :square ->
              # {:reply, GenServer.call(w_pid, {:square, x}), %{state | next: rem(index + 1, n)}}
              {:reply, request_res, %{state | next: rem(index + 1, n)}}

        :sqrt ->
              # {:reply, GenServer.call(w_pid, {:sqrt, x}), %{state | next: rem(index + 1, n)}}
              {:reply, request_res, %{state | next: rem(index + 1, n)}}

    end
  end

  @impl true
  def handle_cast({:result, w_pid, result}, state) do
    IO.puts("Result: #{result} from #{inspect(w_pid)}")
    {:noreply, state}
  end

end
