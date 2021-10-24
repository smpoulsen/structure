defprotocol Structure.Protocol.Functor do
  @fallback_to_any true

  @doc """
  Map a function over a structure.
  """
  def map(value, function)
end

defimpl Structure.Protocol.Functor, for: List do
  @doc """
  Applies a function to the elements of a list.

  ## Examples:

      iex> Functor.map([1, 2, 3], fn x -> x * x end)
      [1, 4, 9]
  """
  def map(l, f), do: Enum.map(l, f)
end

defimpl Structure.Protocol.Functor, for: Map do
  @doc """
  Applies a function to the values in a map.

  ## Examples:

  iex> Functor.map(%{a: 1, b: 2, c: 3}, fn x -> x * x end)
  %{a: 1, b: 4, c: 9}
  """
  def map(m, f) do
    m
    |> Enum.map(fn {k, v} -> {k, f.(v)} end)
    |> Enum.into(%{})
  end
end

defimpl Structure.Protocol.Functor, for: Any do
  @doc """
  Attempts to fall back to the Enum.map implementation for a structure.

  ## Examples:

  iex> Functor.map([{:a, 1}, {:b, 2}, {:c, 3}], fn {k, v} -> {k, v * v} end)
  [{:a, 1}, {:b, 4}, {:c, 9}]
  """
  def map(l, f), do: Enum.map(l, f)
end
