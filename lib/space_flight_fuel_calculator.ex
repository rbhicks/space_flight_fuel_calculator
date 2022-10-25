defmodule SpaceFlightFuelCalculator do
  @moduledoc """
  Functions for calculating the fuel weight for space flights.
  There is a single enternal entry point, calculate/2. The
  functions for making the calculations, calculate_for_fuel_weight/4,
  are tail recursive and behave similarly to Enum.reduce.
  This method is preferred over Enum.reduce for clarity.

  As private functions can't have @doc strings, there are
  explanatory comments in front of the primary functions.
  """

  @doc """
  This is the main external entry point. It validates
  that the mission makes sense and then starts the
  fuel calculation process.
  """
  def calculate(spacecraft_weight, flights) do
    if validate_mission(flights) do
      do_calculate(spacecraft_weight, flights)
    else
      nil
    end
  end

  # This is main internal entry point that takes params as
  # defined in the test description. Since we want a total
  # for 1 to some number of flights, we use Enum.reduce. The
  # most intersting, and needed, part is the call to Enum.reverse.
  # This is critical to perform the weight calculations
  # correctly since for multiple flights fuel is burned.
  # This means that to launch after a landing the weight
  # calculation can't include the weight of the fuel that
  # was used to launch and land at that destination. As
  # such, we have to calculate the flights backwards.
  # This way the weight calculations can start with the
  # spacecraft weight and the weight of the fuel for the
  # last flight, then we simply add the weights from flights
  # that came previously. This keeps the calculation simple
  # is that all that needs to be done is addition.
  defp do_calculate(spacecraft_weight, flights) do
    flights
    |> Enum.reverse()
    |> Enum.reduce(0, fn {flight_directive, acceleration_due_to_gravity}, total_fuel_weight ->
      current_fuel_weight =
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
          current_fuel_weight
        )
    end)
  end

  # These are tail recursive functions that calculate the
  # fuel weight for a single flight. The functios are called
  # based on the algorithm described in the test documentation;
  # i.e., fuel is repeatedly calculated based on current weight
  # and the weight of the fuel until the fuel weight is either
  # 0 or negative. This is based on the incoming parameter
  # 'last_fuel_weight'. This is done so that pattern matching
  # can be used instead of internal conditionals to check
  # when the fuel weight is 0 or negative. N.B., we only have
  # function heads for the two expected cases, i.e., positive
  # or 0 or negative 'last_fuel_weight'. It shouldn't be
  # possible for another situation to arise. If so, it's
  # truly exceptional and will fail loudly in accordance with
  # the elixir practice of "assertive code".
  defp calculate_for_fuel_weight(
         flight_directive,
         acceleration_due_to_gravity,
         total_fuel_weight,
         last_fuel_weight
       )
       when last_fuel_weight > 0 do
    current_fuel_weight =
      get_fuel_weight(last_fuel_weight, flight_directive, acceleration_due_to_gravity)

    calculate_for_fuel_weight(
      flight_directive,
      acceleration_due_to_gravity,
      total_fuel_weight + last_fuel_weight,
      current_fuel_weight
    )
  end

  defp calculate_for_fuel_weight(
         _flight_directive,
         _acceleration_due_to_gravity,
         total_fuel_weight,
         last_fuel_weight
       )
       when last_fuel_weight <= 0 do
    total_fuel_weight
  end

  # This function exists to break out the actual fuel
  # calculation so it doesn't have to be repeated.

  # It calls:
  # 'get_flight_directive_multiplier/1'
  # 'get_flight_directive_minuend/1'

  # In order to have a single calculation for both launch and
  # landing. The called functions abstract the calculation
  # constants.
  defp get_fuel_weight(weight, flight_directive, acceleration_due_to_gravity) do
    (weight * acceleration_due_to_gravity * get_flight_directive_multiplier(flight_directive) -
       get_flight_directive_minuend(flight_directive))
    |> trunc
  end

  defp get_flight_directive_multiplier(:launch), do: 0.042
  defp get_flight_directive_multiplier(:land), do: 0.033
  defp get_flight_directive_minuend(:launch), do: 33
  defp get_flight_directive_minuend(:land), do: 42

  # We need to verify that missions make sense. If
  # they don't the fuel calculation won't make sense
  # either. Single flight missions are defined as
  # always being fine. However, multiple flight
  # missions need to alternate between landings
  # and launches. Also, if a landing is followed
  # by a launch, the gravity must be the same.
  # Lastly, a multiple flight mission must begin
  # with a launch.
  defp validate_mission([_head | []]), do: true

  defp validate_mission([{:launch, _} | _tail_flights] = flights) do
    {_, _, result} =
      Enum.reduce_while(flights, {nil, nil, true}, fn {flight_directive, gravity},
                                                      {last_flight_directive, last_gravity, _} ->
        if valid_mission?(last_flight_directive, flight_directive, gravity, last_gravity) do
          {:cont, {flight_directive, gravity, true}}
        else
          {:halt, {flight_directive, gravity, false}}
        end
      end)

    result
  end

  defp validate_mission([{:land, _} | _tail_flights]), do: false

  defp valid_mission?(last_flight_directive, last_flight_directive, _gravity, _last_gravity),
    do: false

  defp valid_mission?(:land, :launch, gravity, last_gravity) when gravity != last_gravity,
    do: false

  defp valid_mission?(_last_flight_directive, _flight_directive, _gravity, _last_gravity),
    do: true
end
