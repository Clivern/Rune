# Copyright 2022 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Rune.Pipe do
  def add_one(nums) do
    Enum.map(nums, fn x -> x + 1 end)
  end

  def inc(x) do
    x + 1
  end

  def dec(x) do
    x - 1
  end

  def add_two(nums) do
    nums
    |> add_one
    |> add_one
  end

  def add_three(nums) do
    nums
    |> add_one
    |> add_one
    |> add_one
  end

  def add_four(nums) do
    nums
    |> add_one
    |> add_one
    |> add_one
    |> add_one
  end

  def test() do
    x = 4
    # 5
    IO.puts(x |> inc |> inc |> dec)

    IO.puts(inspect(add_two([1, 2, 3])))
    IO.puts(inspect(add_three([1, 2, 3])))
    IO.puts(inspect(add_four([1, 2, 3])))
  end
end
