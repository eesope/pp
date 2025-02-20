defmodule Lab4a.Macros do

  defmacro __before_compile__(env) do
    #env to use quoted value
    lines = Module.get_attribute(env.module, :lines) || []

    # take key and value to make function dynamically
    for {k, v} <- lines do
      quote do
        def unquote(k)(), do: unquote(v)
      end
    end
  end
end

defmodule Lab4a do
  @before_compile Lab4a.Macros

  # read file -> parse line -> kv list [h: 1.008, ...]
  @lines File.stream!("./atomic-weights.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.filter(&(&1 != ""))  # delete empty line
  |> Stream.map(fn line ->
    [_num, symbol, _name, weight] = String.split(line, ~r/\s+/, trim: true)
    {String.to_atom(String.downcase(symbol)), String.to_float(weight)}
    end)
  |> Enum.to_list()
  # @lines => AST
end
