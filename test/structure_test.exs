defmodule StructureTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest Structure

  property "Identity law: returns input for any input" do
    check all(value <- StreamData.term()) do
      assert Structure.identity(value) == value
      assert Structure.id(value) == value
    end
  end
end
