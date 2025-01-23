defmodule Primes do

  #(a) Sieve of Eratosthenes
  defp sieve([], _, acc), do: Enum.reverse(acc)
  defp sieve([h | t], limit, acc) when h <= limit do
    filtered = Enum.filter(t, fn x -> rem(x, h) != 0 end)
    sieve(filtered, limit, acc)
  end
  defp sieve([h | t], _limit, acc) do
    Enum.reverse(acc) ++ [h | t]
  end

  def primes(n) when n < 2 do [] end
  def primes(n) do
    limit = :math.sqrt(n) |> floor()
    2..n
    |> Enum.to_list()
    |> sieve(limit, [])
  end

  #(b) Permutations of one another
  def largest_prime_group() do
    primes(999_999)
    |> Enum.filter(&(String.length(Integer.to_string(&1)) > 5))
    |> Enum.group_by(&(Integer.to_string(&1) |> String.graphemes() |> Enum.sort())) # Group by sorted digits
    |> Enum.map(fn {_key, group} -> group end)
    |> Enum.max_by(&length/1)
    |> length()
  end

end

IO.puts("-------------------------------------------------------------------------")
IO.puts("The largest set of 6-digit primes that are permutations of one another:")
IO.inspect Primes.largest_prime_group()
IO.puts("Calculation finished.")
IO.puts("-------------------------------------------------------------------------")
``
