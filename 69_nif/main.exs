# NIFs
#
# A NIF is a function implemented in C and loaded into the VM. erl_nif.h comes
# with the Erlang installation. The name in ERL_NIF_INIT must be the module
# atom, which for Rune.Nif is Elixir.Rune.Nif. load_nif takes the path without
# the .so suffix.
#
# Run: elixir 69_nif/main.exs

dir = Path.dirname(__ENV__.file)
include = Path.join(to_string(:code.root_dir()), "usr/include")
source = Path.join(dir, "nif.c")
library = Path.join(dir, "nif.so")

args = ["-fPIC", "-shared", "-I", include, "-o", library]

args =
  if match?({:unix, :darwin}, :os.type()) do
    args ++ ["-undefined", "dynamic_lookup"]
  else
    args
  end

{output, 0} = System.cmd("cc", args ++ [source], stderr_to_stdout: true)
if output != "", do: IO.write(output)

defmodule Rune.Nif do
  @on_load :load_nif

  def load_nif do
    path = Path.join(Path.dirname(__ENV__.file), "nif")
    :erlang.load_nif(String.to_charlist(path), 0)
  end

  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
end

IO.inspect(Rune.Nif.add(20, 22))
