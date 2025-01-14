# Ecto Changesets
#
# A changeset casts untrusted fields into a schema and records validation
# errors. This example uses no database. valid? is false when an error was
# added. traverse_errors turns the error tuples into strings.
#
# Run: mix run 73_ecto/main.exs

defmodule Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field(:name, :string)
    field(:age, :integer)
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :age])
    |> validate_required([:name])
    |> validate_number(:age, greater_than: 0, message: "must be greater than 0")
  end
end

defmodule Demo do
  def run do
    good = Account.changeset(%Account{}, %{name: "ada", age: 36})
    bad = Account.changeset(%Account{}, %{age: 0})

    IO.inspect(good.valid?)
    IO.inspect(Ecto.Changeset.traverse_errors(bad, fn {msg, _opts} -> msg end))
  end
end

Demo.run()
