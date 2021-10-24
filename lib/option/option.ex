defmodule Structure.Option do
  use Structure.Type
  alias __MODULE__
  alias Structure.Result

  Type.type(None, [])
  Type.type(Some, [:value])

  @doc """
  An empty result.

  ## Example:

      iex> Option.none()
      %Option{inner: %None{}}
  """
  def none(), do: %Option{inner: %None{}}

  @doc """
  An non-empty result.

  ## Example:

  iex> Option.some(1)
  %Option{inner: %Some{value: 1}}
  """
  def some(value), do: %Option{inner: %Some{value: value}}

  @doc """
  Tests whether a Option contains Some value.

  ## Examples:

      iex> Option.some(1)
      ...> |> Option.some?()
      true

      iex> Option.none()
      ...> |> Option.some?()
      false
  """
  def some?(%Option{inner: %Some{}}), do: true
  def some?(%Option{inner: %None{}}), do: false

  @doc """
  Tests whether a Option is None.

  ## Examples:

  iex> Option.some(1)
  ...> |> Option.none?()
  false

  iex> Option.none()
  ...> |> Option.none?()
  true
  """
  def none?(%Option{inner: %Some{}}), do: false
  def none?(%Option{inner: %None{}}), do: true

  @doc """
  Returns an Some value or a provided default.

  ## Examples:

  iex> x = Option.some(1)
  ...> Option.unwrap_or(x, 5)
  1

  iex> x = Option.none()
  ...> Option.unwrap_or(x, 5)
  5
  """
  def unwrap_or(%Option{inner: %Some{value: value}}, _default), do: value
  def unwrap_or(%Option{inner: %None{}}, default), do: default

  @doc """
  Returns an Some value or calculates a value from a function.

  ## Examples:

  iex> x = Option.some(1)
  ...> Option.unwrap_or_else(x, fn -> 5 end)
  1

  iex> x = Option.none()
  ...> Option.unwrap_or_else(x, fn -> 5 end)
  5
  """
  def unwrap_or_else(%Option{inner: %Some{value: value}}, default) when is_function(default) do
    value
  end

  def unwrap_or_else(%Option{inner: %None{}}, default) when is_function(default) do
    default.()
  end

  @doc """
  Converts arbitrarily nested Options into the innermost value.

  ## Examples:

  iex> Option.some(1)
  ...> |> Option.some()
  ...> |> Option.flatten()
  %Option{inner: %Some{value: 1}}

  iex> Option.some(1)
  ...> |> Option.some()
  ...> |> Option.some()
  ...> |> Option.some()
  ...> |> Option.some()
  ...> |> Option.some()
  ...> |> Option.flatten()
  %Option{inner: %Some{value: 1}}

  iex> Option.none()
  ...> |> Option.some()
  ...> |> Option.flatten()
  %Option{inner: %None{}}
  """
  def flatten(%Option{inner: %Some{value: %Option{} = inner}}), do: flatten(inner)
  def flatten(%Option{inner: %Option{} = inner}), do: flatten(inner)
  def flatten(%Option{inner: %Some{}} = option), do: option
  def flatten(%Option{inner: %None{}} = option), do: option

  @doc """
  Converts a Option into a Result.
  Option.Some values convert into Result.Ok.
  Option.None values convert to Result.Err using an error provided as the second argument.

  ## Examples:

  iex> Option.some(1)
  ...> |> Option.to_result(:bad_argument)
  %Result{inner: %Ok{value: 1}}

  iex> Option.none()
  ...> |> Option.to_result(:bad_argument)
  %Result{inner: %Err{error: :bad_argument}}
  """
  def to_result(%Option{inner: %Some{value: value}}, _error), do: Result.ok(value)
  def to_result(%Option{inner: %None{}}, error), do: Result.error(error)

  defimpl String.Chars do
    def to_string(%Option{inner: %Some{value: value}}), do: "%Option::Some { #{value} }"
    def to_string(%Option{inner: %None{}}), do: "%Option::None {}"
  end

  defimpl Structure.Protocol.Functor do
    @doc """
    Map a function over an optional value.

    ## Examples:

    iex> Option.some(1) |> Functor.map(fn x -> x * 10 end)
    %Option{inner: %Some{value: 10}}

    iex> Option.none() |> Functor.map(fn x -> x * 10 end)
    %Option{inner: %None{}}
    """
    def map(%Option{inner: %Some{value: v}}, f) when is_function(f) do
      Option.some(f.(v))
    end

    def map(%Option{inner: %None{}} = option, f) when is_function(f) do
      option
    end
  end
end
