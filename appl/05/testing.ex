defmodule Testing do
  defmacro check(predicate) do
    name = Macro.to_string(predicate)
    quote do
      IO.write(unquote(name) <> ": ")
      if unquote(predicate), do: IO.puts("passed"), else: IO.puts("FAILED")
    end
  end

  defmacro test(name, block) do
    name = "test_" <> name
    fn_name = String.to_atom(name)
    quote do
      @tests [unquote(fn_name) | @tests]
      def unquote(fn_name)() do 
        IO.puts(unquote(name))
        unquote(block)
      end
    end
  end

  defmacro __using__(_opt) do
    quote do
      import unquote(__MODULE__)
      @tests []
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run() do
        Enum.each(Enum.reverse(@tests), fn f ->
          apply(__MODULE__, f, []) end)
      end
    end
  end
end

defmodule Testing.Examples do
  use Testing
  
  test "equality" do
    check(1 + 1 == 2)
    check(1 + 2 == 2)
  end

  test "less_than" do
    check(1 < 2)
  end
end

