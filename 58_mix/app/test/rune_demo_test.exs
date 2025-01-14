defmodule RuneDemoTest do
  use ExUnit.Case, async: true

  test "reads both config files" do
    assert RuneDemo.greeting() == "hello"
    assert RuneDemo.from_runtime() == "yes"
  end
end
