# ExUnit
#
# ExUnit is Elixir's test framework. assert fails the test when its expression
# is falsy, or when a match on the left does not fit the right. refute fails
# when the expression is truthy. This script starts ExUnit itself so it can run
# without mix.
#
# Run: elixir 45_exunit/main.exs

ExUnit.start(autorun: false, seed: 0)

defmodule Rune.MathTest do
  use ExUnit.Case, async: false

  test "adds" do
    assert 1 + 1 == 2
  end

  test "matches a tagged tuple" do
    assert {:ok, 3} = {:ok, 1 + 2}
  end

  test "refutes a wrong sum" do
    refute 2 + 2 == 5
  end
end

%{failures: 0, total: 3} = ExUnit.run()
IO.puts("3 tests, 0 failures")
