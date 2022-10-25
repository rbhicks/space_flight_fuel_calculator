defmodule SpaceFlightFuelCalculatorTest do
  @moduledoc """
  The first test function is for a single flight. It
  was put into place to test the base fuel calculation
  algorithm. The subsequent tests are taken from the
  test description.
  """

  use ExUnit.Case

  test "land Apollo 11 CSM on Earth" do
    "Landing the Apollo 11 CSM on Earth should use 13,447 kg of fuel..." |> IO.puts()

    assert SpaceFlightFuelCalculator.calculate(28801, [{:land, 9.807}]) == 13447
  end

  test "Apollo 11" do
    "Apollo 11 mission should use 51,898 kg of fuel..." |> IO.puts()

    assert SpaceFlightFuelCalculator.calculate(28801, [
             {:launch, 9.807},
             {:land, 1.62},
             {:launch, 1.62},
             {:land, 9.807}
           ]) == 51898
  end

  test "Mission on Mars" do
    "Mission to Mars should use 33,388 kg of fuel..." |> IO.puts()

    assert SpaceFlightFuelCalculator.calculate(14606, [
             {:launch, 9.807},
             {:land, 3.711},
             {:launch, 3.711},
             {:land, 9.807}
           ]) == 33388
  end

  test "Passenger ship" do
    "Passenger ship mission should use 212,161 kg of fuel..." |> IO.puts()

    assert SpaceFlightFuelCalculator.calculate(75432, [
             {:launch, 9.807},
             {:land, 1.62},
             {:launch, 1.62},
             {:land, 3.711},
             {:launch, 3.711},
             {:land, 9.807}
           ]) == 212_161
  end
end
