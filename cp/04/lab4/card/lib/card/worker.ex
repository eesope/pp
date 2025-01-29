defmodule Card.Worker do
  use GenServer

  # client
  def start_link(n \\ 0) do
    GenServer.start_link(__MODULE__, n, name: __MODULE__)
  end

  def new() do
    send(__MODULE__, {:new, generate_deck()})
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

  def shuffle() do  #request only, no need to reply
    send(__MODULE__, :shuffle)
  end

  def count() do
    send(__MODULE__, {:count, self()})
    receive do
      count -> count
    end
  end

  def deal(n \\ 1) do
    send(__MODULE__, {:deal, n, self()})  #giving cards
    receive do
      {:ok, cards} -> {:ok, cards}
      {:error, reason} -> {:error, reason}
    end
  end

  # server loop
  defp loop(deck) do
    receive do
      {:new, new_deck} ->
        loop(new_deck)

      :shuffle ->
        shuffled_deck = Enum.shuffle(deck)
        loop(shuffled_deck)

      {:count, from} ->
        send(from, length(deck))
        loop(deck)

      {:deal, n, from} ->
        cond do
          n <= 0 ->
            send(from, {:error, "Please request at least 1 card."})
            loop(deck)

          n > length(deck)->
            send(from, {:error, "Not enough cards to deal."})
            loop(deck)

          true ->
            {cards, left_deck} = Enum.split(deck, n)
            send(from, {:ok, cards})
            loop(left_deck)
        end
      _ -> loop(deck)
    end
  end
end
