defmodule Structure.OptionTest do
  use ExUnit.Case
  use Structure.Generators

  alias Structure.Option
  alias Structure.Option.None
  alias Structure.Option.Some
  alias Structure.Protocol.Functor
  alias Structure.Result
  alias Structure.Result.Ok
  alias Structure.Result.Err
  doctest Option
  doctest Functor.Structure.Option

  property "Identity law: returns value for any Option" do
    check all(value <- Generators.option()) do
      assert Structure.identity(value) == value
      assert Structure.id(value) == value
    end
  end

  property "Functor law: map identity doesn't change structure" do
    check all(value <- Generators.option()) do
      assert Functor.map(value, &Structure.id/1) == value
    end
  end

  property "Functor law: mapping composed function is the same as mapping components individually" do
    check all(value <- Generators.option(:numeric)) do
      f = fn x -> x * x end
      composed = Functor.map(value, fn x -> f.(Structure.identity(x)) end)

      individual =
        value
        |> Functor.map(f)
        |> Functor.map(&Structure.identity/1)

      assert composed == individual
    end
  end
end
