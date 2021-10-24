defmodule Structure.ResultTest do
  use ExUnit.Case
  use Structure.Generators

  alias Structure.Result
  alias Structure.Result.Ok
  alias Structure.Result.Err
  alias Structure.Protocol.Functor
  alias Structure.Option
  alias Structure.Option.Some
  alias Structure.Option.None
  doctest Result
  doctest Functor.Structure.Result

  property "Identity law: returns value for any Result" do
    check all(value <- Generators.result()) do
      assert Structure.identity(value) == value
      assert Structure.id(value) == value
    end
  end

  property "Functor law: map identity doesn't change structure" do
    check all(value <- Generators.result()) do
      assert Functor.map(value, &Structure.id/1) == value
    end
  end

  property "Functor law: mapping composed function is the same as mapping components individually" do
    check all(value <- Generators.result(:numeric)) do
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
