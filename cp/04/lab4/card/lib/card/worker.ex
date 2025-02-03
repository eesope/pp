defmodule Card.Worker do
  use GenServer

  # client
  def start_link(_arg) do
    GenServer.start_link(__MODULE__, :generate_new_deck, name: __MODULE__)
  end

  def new() do
    GenServer.cast(__MODULE__, :new)
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

  def shuffle() do
    GenServer.cast(__MODULE__, :shuffle)
  end

  def count() do
    GenServer.call(__MODULE__, :count)
  end

  def deal(n \\ 1) do
    GenServer.call(__MODULE__, {:deal, n})
  end

  # server callbacks
  @impl true
  # def init(:generate_new_deck) do
  #   IO.puts("Worker started a new deck.")
  #   {:ok, generate_deck()}
  # end
  def init(arg) do
    IO.puts("Worker restored.")
    restored_deck = Card.Store.get()

    this_deck =
      case restored_deck do
        nil -> generate_deck()
        deck -> deck
      end

    {:ok, this_deck}
  end

  @impl true
  def handle_cast(:new, _deck) do
    new_deck = generate_deck()
    {:noreply, new_deck}
  end

  @impl true
  def handle_cast(:shuffle, deck) do
    shuffled_deck = Enum.shuffle(deck)
    {:noreply, shuffled_deck}
  end

  @impl true
  def handle_call(:count, _from, deck) do
    {:reply, length(deck), deck}
  end

  @impl true
  def handle_call({:deal, n}, _from, _deck) when not is_integer(n), do: raise "Deal must be a positive number!"
  def handle_call({:deal, n}, _from, deck) do
    cond do
      n <= 0 ->
        {:reply, {:error, "Please request at least 1 card."}, deck}
      n > length(deck) ->
        {:reply, {:error, "Not enough cards to deal."}, deck}
      true ->
        {cards, left_deck} = Enum.split(deck, n)
        {:reply, {:ok, cards}, left_deck}
    end
  end

  @impl true
  def terminate(_reason, deck) do  # when supervisor terminates
    Card.Store.put(deck)
    :ok
  end
end
