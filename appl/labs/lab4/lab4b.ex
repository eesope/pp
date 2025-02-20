defmodule Lab4b do

  @lines File.stream!("./atomic-weights.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.filter(&(&1 != ""))  # delete empty line
  |> Stream.map(fn line ->
    [_num, symbol, _name, weight] = String.split(line, ~r/\s+/, trim: true)
    {symbol, String.to_float(weight)}
    end)
  |> Enum.to_list()

  # atomic _weight ("He") returns 4.003
  for {symbol, weight} <- @lines do
    def atomic_weight(unquote(symbol)), do: unquote(weight)
  end

  # atomic _weight ("abc") returns -1
  def atomic_weight(_), do: -1
end
