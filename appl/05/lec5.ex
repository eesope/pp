defmodule Lec5 do
  def if_fun(predicate, do_block, else_block) do
    cond do
      predicate -> do_block
      true -> else_block
    end
  end

  defmacro inspect(x) do
    IO.inspect(x)
  end

  defmacro if_macro(predicate, do_block, else_block) do
    quote do
      cond do
        unquote(predicate) -> unquote(do_block)
        true -> unquote(else_block)
      end
    end
  end

  defmacro if(predicate, do: do_block, else: else_block) do
    quote do
      cond do
        unquote(predicate) -> unquote(do_block)
        true -> unquote(else_block)
      end
    end
  end

  defmacro if(predicate, do: do_block) do
    quote do
      cond do
        unquote(predicate) -> unquote(do_block)
        true -> nil
      end
    end
  end

  defmacro while(predicate, do: block) do
    quote do
      try do
        for _ <- Stream.cycle([:ok]) do
          if unquote(predicate), do: unquote(block), else: throw :break
        end
      catch :throw, :break -> 
        :ok
      end
    end
  end

  def break(), do: throw :break

  defmacro context() do
    IO.puts("macro: #{__MODULE__}")
    quote do
      IO.puts("caller: #{__MODULE__}")
      def f() do
        IO.puts("macro: #{unquote(__MODULE__)}")
        IO.puts("caller: #{__MODULE__}")
      end
    end
  end

  defmacro add_vars() do
    quote do
      x = -1
      var!(y) = -2
    end
  end

  defmacro say(msg) do
    name = String.to_atom("say_" <> msg)
    quote do
      def unquote(name)(), do: IO.puts(unquote(msg))
    end
  end 

  defmacro make_fn(name, do: block) do
    name = String.to_atom(name)
    quote do
      def unquote(name)(), do: unquote(block)
    end
  end

  defmacro make_kv_fn(kv) do
    for {k, v} <- kv do
      quote do
        def unquote(k)(), do: unquote(v)
      end
    end
  end
end

defmodule Lec5.Examples do
  require Lec5
  IO.puts("hello")
  Lec5.context()

  IO.puts("before add_vars")
  x = 1
  y = 2
  IO.puts(x)
  IO.puts(y)
  Lec5.add_vars()
  IO.puts("after add_vars")
  IO.puts(x)
  IO.puts(y)

  Lec5.say("hello")
  Lec5.say("goodbye")

  Lec5.make_fn "greet" do (IO.puts("hi")) end

  Lec5.make_kv_fn(homer: 55, bart: 25, monty: 99)
end

defmodule Lec5b do
  # unquote fragment
  for {k, v} <- [homer: 55, bart: 25] do
    def unquote(k)(), do: unquote(v)
  end
end
