# Files
#
# File reads and writes bytes. The functions without a bang return {:ok, value}
# or {:error, reason}. The bang versions raise. Path joins and splits paths
# without touching the disk.
#
# Run: elixir 34_files/main.exs

dir = System.tmp_dir!()
path = Path.join(dir, "rune-files-example.txt")

File.write!(path, "hello file\n")
{:ok, body} = File.read(path)
IO.puts(String.trim(body))

IO.puts(File.exists?(path))
IO.puts(Path.extname(path))
IO.puts(Path.basename(path))

File.rm!(path)
IO.puts(File.exists?(path))
