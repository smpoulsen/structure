defmodule Structure.Type do
  defmacro __using__(_opts) do
    quote do
      require Structure.Type
      alias Structure.Type

      defstruct [:inner]

      def unwrap!(%__MODULE__{inner: val}), do: val
    end
  end

  defmacro type(name, attrs \\ []) do
    fields = [{:__meta__, :"Structure.Type.type"} | List.wrap(attrs)]

    quote do
      defmodule unquote(name) do
        defstruct unquote(fields)
      end
    end
  end

  defmacro sum(name, variants) do
    fields = [{:__meta__, :"Structure.Type.sum"}, {:variants, List.wrap(variants)}]

    quote do
      defmodule unquote(name) do
        defstruct unquote(fields)
      end
    end
  end
end
