defmodule Structure.Generators.Result do
  use ExUnitProperties
  alias Structure.Result

  def ok(:numeric) do
    StreamData.integer()
    |> StreamData.bind(fn int ->
      int
      |> Result.ok()
      |> StreamData.constant()
    end)
  end

  def ok(_), do: ok()

  def ok() do
    StreamData.term()
    |> StreamData.bind(fn t ->
      t
      |> Result.ok()
      |> StreamData.constant()
    end)
  end

  def error() do
    StreamData.atom(:alphanumeric)
    |> StreamData.bind(fn e ->
      e
      |> Result.error()
      |> StreamData.constant()
    end)
  end

  def result(kind \\ nil) do
    StreamData.one_of([ok(kind), error()])
  end
end
