defmodule Structure.Generators.Option do
  use ExUnitProperties
  alias Structure.Option

  def some(:numeric) do
    StreamData.integer()
    |> StreamData.bind(fn int ->
      int
      |> Option.some()
      |> StreamData.constant()
    end)
  end

  def some(_), do: some()

  def some() do
    StreamData.term()
    |> StreamData.bind(fn t ->
      t
      |> Option.some()
      |> StreamData.constant()
    end)
  end

  def none() do
    Option.none()
    |> StreamData.constant()
  end

  def option(kind \\ nil) do
    StreamData.one_of([some(kind), none()])
  end
end
