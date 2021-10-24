defmodule Structure.Generators do
  alias Structure.Generators.Option
  alias Structure.Generators.Result

  defmacro __using__(_args) do
    quote do
      use ExUnitProperties
      alias Structure.Generators
    end
  end

  def result(kind \\ nil), do: Result.result(kind)

  def option(kind \\ nil), do: Option.option(kind)
end
