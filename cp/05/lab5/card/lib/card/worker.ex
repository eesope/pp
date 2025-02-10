defmodule Card.Worker do
  use GenServer
  @store Card.Store

  # APIs
  def start_link(name) do
    IO.puts("Worker #{name} is restarting...")
    GenServer.start_link(__MODULE__, {:generate_new_deck, name}, name: via(name))
  end

  def new(name) do
    GenServer.cast(via(name), {:new, name})
    :ok
  end

  defp generate_deck() do
    faces = ["J", "Q", "K", "A"]
    numbers = 2..10 |> Enum.to_list()
    symbols = [0x2663, 0x2666, 0x2665, 0x2660]
    for order <- numbers ++ faces, symbol <- symbols do
      "#{order}#{<<symbol::utf8>>}"
    end
  end

  def shuffle(name) do
    GenServer.cast(via(name), {:shuffle, name})
  end

  def count(name) do
    GenServer.call(via(name), {:count, name})
  end

  def deal(name, n \\ 1) do
    if is_number(n) do
      GenServer.call(via(name), {:deal, n})
    else raise "You must deal at least 1 card!"
    end
  end

  defp via(name) do
    {:via, Registry, {Card.Registry, {__MODULE__, name}}}
  end


  # call backs
  @impl true
  def init(name) do
    IO.puts("Worker #{name} restarted.")

    # find this worker's state in ets table
    restored_deck =
      case :ets.lookup(@store, name) do
        [{^name, v}] -> v
        _ -> 0
      end

      this_deck =
        case restored_deck do
          nil -> generate_deck()
          deck -> deck
        end

      {:ok, {name, this_deck}}
  end

  @impl true
  def handle_call(request, _from, {_, deck} = _state) do

    case request do
      :count -> result = length(deck)
      {:result, result, deck}

      {:deal, n} when n == 0 ->
        {:reply, {:error, "You must deal at least 1 card."}, deck}

      {:deal, n} when n > length(deck) ->
        {:reply, {:error, "Not enough cards to deal."}, deck}

      {:deal, n} when n < length(deck) ->
        {cards, left_deck} = Enum.split(deck, n)
        {:reply, {:ok, cards}, left_deck}
    end
  end

  @impl true
  def handle_cast(request, {name, deck}) do

    result_deck =
      case request do
        :new ->
          generate_deck()
        :shuffle ->
          Enum.shuffle(deck)
      end

    {:noreply, {name, result_deck}}
  end

  @impl true
  def terminate(_reason, state) do
    :ets.insert(@store, state)
  end

end
