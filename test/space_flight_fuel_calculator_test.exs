defmodule SpaceFlightFuelCalculatorTest do
  use ExUnit.Case

  test "land Apollo 11 CSM on Earth" do
    assert SpaceFlightFuelCalculator.calculate(28801, [{:land, 9.807}]) == 13447
  end

  test "Apollo 11" do
    assert SpaceFlightFuelCalculator.calculate(28801, [
             {:launch, 9.807},
             {:land, 1.62},
             {:launch, 1.62},
             {:land, 9.807}
           ]) == 51898
  end

  test "Mission on Mars" do
    assert SpaceFlightFuelCalculator.calculate(14606, [
             {:launch, 9.807},
             {:land, 3.711},
             {:launch, 3.711},
             {:land, 9.807}
           ]) == 33388
  end

  test "Passenger ship" do
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
