defmodule Card.Worker do
  use GenServer
  @store Card.Store

  # APIs
  def start_link(name) do
    IO.puts("Worker #{name} is restarting...")
    GenServer.start_link(__MODULE__, name, name: via(name))
  end

  def new(name), do: GenServer.cast(via(name), :new)

  def shuffle(name), do: GenServer.cast(via(name), :shuffle)

  def count(name), do: GenServer.call(via(name), :count)

  def deal(name, n \\ 1) when is_integer(n) do
    GenServer.call(via(name), {:deal, n})
  end
  def deal(_name, _n) do
    raise ArgumentError, "You must at least deal 1 card."
  end

  # private helper function
  defp via(name), do: {:via, Registry, {Card.Registry, {__MODULE__, name}}}

  defp generate_deck() do
    faces = ["J", "Q", "K", "A"]
    numbers = 2..10 |> Enum.to_list()
    symbols = [0x2663, 0x2666, 0x2665, 0x2660]
    for order <- numbers ++ faces, symbol <- symbols do
      "#{order}#{<<symbol::utf8>>}"
    end
  end


  # call backs
  @impl true
  def init(name) do
    IO.puts("Worker #{name} restarted.")

    # find this worker's state in ets table
    deck =
      case :ets.lookup(Card.store, name) do
        [{^name, saved_deck}] -> saved_deck
        [] -> generate_deck()
      end

      {:ok, {name, deck}}
  end

  @impl true
  def handle_call(request, _from, {name, deck} = _state) do

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
  def terminate(_reason, {name, deck}) do
    :ets.insert(Card.Store, {name, deck})
    :ok
  end

end
