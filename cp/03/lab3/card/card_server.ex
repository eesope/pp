defmodule CardServer do

  def start() do
    Process.register(spawn(fn -> new() end), __MODULE__)
  end

  defp new() do
    faces = ["J", "Q", "K", "A"]
    numbers = 2..10 |> Enum.to_list()
    symbols = [0x2663, 0x2666, 0x2665, 0x2660]
    new_deck =
      for order <- numbers ++ faces, symbol <- symbols do
        "#{order}#{<<symbol::utf8>>}"
      end
    loop(new_deck)
  end

  def shuffle() do
    send(__MODULE__, :shuffle)  #request only, no need to reply
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

  defp loop(deck) do
    receive do
      {:shuffle} ->
        loop(Enum.shuffle(deck))
      {:count, from} ->
        send(from, length(deck))
        loop(deck)
      {:deal, n, from} ->
        cond do
          n <= 0 ->
            send(from, {:error, "Please request at least 1 card."})
            loop(deck)

          length(deck) < n ->
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
