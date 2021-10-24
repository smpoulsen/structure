defprotocol Structure.Protocol.Applicative do
  @fallback_to_any true

  @doc """
  Lift a value into an Applicative context.
  """
  def pure(context, value)

  @doc """
  Apply a function in an Applicative context to an Applicative value.
  """
  def apply(value, function)
end

defimpl Structure.Protocol.Applicative, for: List do
  @doc """
  Lifts a value into a List.

  ## Examples:

      iex> Applicative.pure([], 5)
      [5]

      iex> Applicative.pure([], [:a])
      [[:a]]
  """
  def pure([], x), do: [x]

  @doc """
  Applies a list of functions to a list of arguments.

  ## Examples:

      iex> [1, 2, 3]
      ...> |> Applicative.apply([
      ...>      fn x -> x + 1 end,
      ...>      fn x -> x * x end
      ...> ])
      [2, 3, 4, 1, 4, 9]
  """
  def apply(vals, fns) do
    for f <- fns,
        v <- vals do
      f.(v)
    end
  end
end

# defimpl Structure.Protocol.Applicative, for: Map do
#   @doc """
#   Applies a function to the values in a map.

#   ## Examples:

#   iex> Applicative.map(%{a: 1, b: 2, c: 3}, fn x -> x * x end)
#   %{a: 1, b: 4, c: 9}
#   """
#   def map(m, f) do
#     m
#     |> Enum.map(fn {k, v} -> {k, f.(v)} end)
#     |> Enum.into(%{})
#   end
# end
