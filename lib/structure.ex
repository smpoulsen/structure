defmodule Structure do
  @moduledoc """
  Utility functions.
  """

  @doc """
  Identity function returns its argument.

  ## Examples:

      iex> Structure.identity(5)
      5

      iex> Structure.identity([1, 2, 3])
      [1, 2, 3]

      iex> Structure.identity(:a)
      :a
  """
  def identity(x), do: x

  @doc """
  Alias for Structure.identity/1

  ## Examples:

  iex> Structure.id(5)
  5

  iex> Structure.id([1, 2, 3])
  [1, 2, 3]

  iex> Structure.id(:a)
  :a
  """
  def id(x), do: x
end
