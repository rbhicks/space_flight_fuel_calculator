defmodule SpaceFlightFuelCalculator do
  def calculate(spacecraft_weight, flights) do
    flights
    |> Enum.reverse()
    |> Enum.reduce(0, fn {flight_directive, acceleration_due_to_gravity}, total_fuel_weight ->
      next_fuel_weight =
        get_fuel_weight(
          spacecraft_weight + total_fuel_weight,
          flight_directive,
          acceleration_due_to_gravity
        )

      total_fuel_weight +
        calculate_for_fuel_weight(
          flight_directive,
          acceleration_due_to_gravity,
          0,
          next_fuel_weight
        )
    end)
  end

  def calculate_for_fuel_weight(
        flight_directive,
        acceleration_due_to_gravity,
        total_fuel_weight,
        last_fuel_weight
      )
      when last_fuel_weight > 0 do
    next_fuel_weight =
      get_fuel_weight(last_fuel_weight, flight_directive, acceleration_due_to_gravity)

    calculate_for_fuel_weight(
      flight_directive,
      acceleration_due_to_gravity,
      total_fuel_weight + last_fuel_weight,
      next_fuel_weight
    )
  end

  def calculate_for_fuel_weight(
        _flight_directive,
        _acceleration_due_to_gravity,
        total_fuel_weight,
        last_fuel_weight
      )
      when last_fuel_weight <= 0 do
    total_fuel_weight
  end

  defp get_fuel_weight(weight, flight_directive, acceleration_due_to_gravity) do
    (weight * acceleration_due_to_gravity * get_flight_directive_multiplier(flight_directive) -
       get_flight_directive_minuend(flight_directive))
    |> trunc
  end

  def get_flight_directive_multiplier(:launch), do: 0.042
  def get_flight_directive_multiplier(:land), do: 0.033
  def get_flight_directive_minuend(:launch), do: 33
  def get_flight_directive_minuend(:land), do: 42
end
