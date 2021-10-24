defmodule Structure.Result do
  @moduledoc """
  A structure for a computation that may result in a value or an error.
  """
  use Structure.Type
  alias __MODULE__
  alias Structure.Option

  Type.type(Ok, [:value])
  Type.type(Err, [:error])

  @doc """
  Creates a Result with a value.

  ## Example:

  iex> Result.ok(1)
  %Result{inner: %Ok{value: 1}}
  """
  def ok(value), do: %Result{inner: %Ok{value: value}}

  @doc """
  Creates a Result containing an error.

  iex> Result.error(:bad_argument)
  %Result{inner: %Err{error: :bad_argument}}
  """
  def error(error), do: %Result{inner: %Err{error: error}}

  @doc """
  Tests whether a Result contains a value.

  ## Examples:

      iex> Result.ok(1)
      ...> |> Result.ok?()
      true

      iex> Result.error(:bad_argument)
      ...> |> Result.ok?()
      false
  """
  def ok?(%Result{inner: %Ok{}}), do: true
  def ok?(%Result{inner: %Err{}}), do: false

  @doc """
  Tests whether a Result contains an error.

  ## Examples:

  iex> Result.ok(1)
  ...> |> Result.error?()
  false

  iex> Result.error(:bad_argument)
  ...> |> Result.error?()
  true
  """
  def error?(%Result{inner: %Ok{}}), do: false
  def error?(%Result{inner: %Err{}}), do: true

  @doc """
  Returns an Ok value or a provided default.

  ## Examples:

  iex> x = Result.ok(1)
  ...> Result.unwrap_or(x, 5)
  1

  iex> x = Result.error(:bad_argument)
  ...> Result.unwrap_or(x, 5)
  5
  """
  def unwrap_or(%Result{inner: %Ok{value: value}}, _default), do: value
  def unwrap_or(%Result{inner: %Err{}}, default), do: default

  @doc """
  Returns an Ok value or calculates a value from a function.

  ## Examples:

  iex> x = Result.ok(1)
  ...> Result.unwrap_or_else(x, fn -> 5 end)
  1

  iex> x = Result.error(:bad_argument)
  ...> Result.unwrap_or_else(x, fn -> 5 end)
  5
  """
  def unwrap_or_else(%Result{inner: %Ok{value: value}}, default) when is_function(default) do
    value
  end

  def unwrap_or_else(%Result{inner: %Err{}}, default) when is_function(default) do
    default.()
  end

  @doc """
  Converts arbitrarily nested Results into the innermost value.

  ## Examples:

  iex> Result.ok(1)
  ...> |> Result.ok()
  ...> |> Result.flatten()
  %Result{inner: %Ok{value: 1}}

  iex> Result.ok(1)
  ...> |> Result.ok()
  ...> |> Result.ok()
  ...> |> Result.ok()
  ...> |> Result.ok()
  ...> |> Result.ok()
  ...> |> Result.flatten()
  %Result{inner: %Ok{value: 1}}

  iex> Result.error(:bad_argument)
  ...> |> Result.ok()
  ...> |> Result.flatten()
  %Result{inner: %Err{error: :bad_argument}}
  """
  def flatten(%Result{inner: %Ok{value: %Result{} = inner}}), do: flatten(inner)
  def flatten(%Result{inner: %Result{} = inner}), do: flatten(inner)
  def flatten(%Result{inner: %Ok{}} = result), do: result
  def flatten(%Result{inner: %Err{}} = result), do: result

  @doc """
  Converts a Result into an Option.
  Result.Ok values convert Option.Some; Result.Err values convert to Option.None.
  Note that in the error case, this is lossy; the error value is dropped.

  ## Examples:

  iex> Result.ok(1)
  ...> |> Result.to_option()
  %Option{inner: %Some{value: 1}}

  iex> Result.error(:bad_argument)
  ...> |> Result.to_option()
  %Option{inner: %None{}}
  """
  def to_option(%Result{inner: %Ok{value: value}}), do: Option.some(value)
  def to_option(%Result{inner: %Err{}}), do: Option.none()

  defimpl String.Chars do
    def to_string(%Result{inner: %Ok{value: value}}), do: "%Result::Ok { #{value} }"
    def to_string(%Result{inner: %Err{error: error}}), do: "%Result::Error { #{error} }"
  end

  defimpl Structure.Protocol.Functor do
    @doc """
    Map a function over a Result.

    ## Examples:

    iex> Result.ok(1) |> Functor.map(fn x -> x * 10 end)
    %Result{inner: %Ok{value: 10}}

    iex> Result.error(:bad_argument) |> Functor.map(fn x -> x * 10 end)
    %Result{inner: %Err{error: :bad_argument}}
    """
    def map(%Result{inner: %Ok{value: v}}, f) when is_function(f) do
      Result.ok(f.(v))
    end

    def map(%Result{inner: %Err{}} = result, f) when is_function(f) do
      result
    end
  end
end
