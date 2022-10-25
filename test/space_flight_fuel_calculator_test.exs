defmodule SpaceFlightFuelCalculatorTest do
  use ExUnit.Case

  test "land Apollo 11 CSM on Earth" do
    assert SpaceFlightFuelCalculator.calculate(28801, [{:land, 9.807}]) == 13447
  end
end
