defmodule Server do
  use GenServer

  # client
  def start() do
    GenServer.start(__MODULE__, :generate_new_deck)
  end

  def new(pid) do
    GenServer.cast(pid, :new)
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

  def shuffle(pid) do
    GenServer.cast(pid, :shuffle)
  end

  def count(pid) do
    GenServer.call(pid, :count)
  end

  def deal(pid, n \\ 1) do
    GenServer.call(pid, {:deal, n})
  end

  # server callbacks
  @impl true
  def init(:generate_new_deck) do
    deck = generate_deck()
    {:ok, deck}
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
  def handle_call({:deal, n}, _from, deck) do
    cond do
      n <= 0 ->
        {{:error, "Please request at least 1 card."}, deck}
      n > length(deck) ->
        {:reply, {:error, "Not enough cards to deal."}, deck}
      true ->
        {cards, left_deck} = Enum.split(deck, n)
        {:reply, {:ok, cards}, left_deck}
    end
  end
end
