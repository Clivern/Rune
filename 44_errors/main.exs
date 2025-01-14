# Errors
#
# Most failures are ordinary values, usually {:ok, value} or {:error, reason}.
# Raise is for something the caller cannot reasonably handle, such as a broken
# assumption. rescue catches a raised exception.
#
# Run: elixir 44_errors/main.exs

defmodule Account do
  def withdraw(balance, amount)
      when is_integer(amount) and amount > 0 and amount <= balance do
    {:ok, balance - amount}
  end

  def withdraw(_balance, _amount), do: {:error, :invalid}

  def withdraw!(balance, amount) do
    case withdraw(balance, amount) do
      {:ok, left} -> left
      {:error, reason} -> raise ArgumentError, "withdraw failed: #{reason}"
    end
  end
end

IO.inspect(Account.withdraw(100, 40))
IO.inspect(Account.withdraw(100, 140))

try do
  Account.withdraw!(100, 140)
rescue
  error in ArgumentError -> IO.puts(Exception.message(error))
end
