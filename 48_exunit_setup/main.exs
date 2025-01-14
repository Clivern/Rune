# ExUnit Setup
#
# setup runs before each test and its return value is the test context.
# describe groups tests. assert_raise checks that a function raises. async:
# true runs a test case in parallel with other async cases.
#
# Run: elixir 48_exunit_setup/main.exs

ExUnit.start(autorun: false, seed: 0)

defmodule AccountTest do
  use ExUnit.Case, async: true

  setup do
    %{balance: 100}
  end

  describe "withdraw" do
    test "subtracts the amount", %{balance: balance} do
      assert balance - 40 == 60
    end

    test "raises when the amount is negative" do
      assert_raise ArgumentError, fn ->
        raise ArgumentError, "negative"
      end
    end
  end
end

%{failures: 0, total: 2} = ExUnit.run()
IO.puts("2 tests, 0 failures")
