# SpaceFlightFuelCalculator

Hello Elixerator folks!

This was a cool test. I like how it appears simple at first, but then when multiple flights are taken into account it's necessary to either pass a lot of information to account for the previous burned fuel or, much simpler, reverse the order of the flights and simply add them up.

For the fuel calculation, I opted for a tail recursive implementation that behaves similar to Enum.reduce. A larger description is in the moduledoc.

Given that this was titled as a Backend test and that the description of the application was in terms of input parameters, I didn't put together a front end. Instead, I made four tests. This first test is to check the base calculation algorithm, i.e., for a single flight and the other three tests are taken from the examples in the test description. As such, all that's necessary to do is clone this repo, go into the directory and run `mix test`. To avoid dependencies that aren't really needed in this case I didn't use any other test deps that make tests more verbose. Instead, I added a small description output to each test. Since the tests are asynchronous this means that the order of the descriptions can change on each run. In a larger project I'd probably address this, but here it seems better to keep things simple.

Thanks!

